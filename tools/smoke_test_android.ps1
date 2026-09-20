<#
.SYNOPSIS
    Android virtual-device smoke test runner for the Vittix Wallet Flutter app.

.DESCRIPTION
    Preflight -> boot AVD -> build debug APK -> install -> launch -> verify ->
    screenshot -> crash scan. Produces a timestamped log and screenshot under
    build/reports/smoke/ so a smoke run leaves real evidence.

    Requires a working hypervisor (Intel VT-x / AMD-V enabled in firmware plus
    the Android Emulator hypervisor driver `aehd`, or Windows Hypervisor
    Platform). The script fails fast with remediation steps if not available.

.EXAMPLE
    pwsh -File tools/smoke_test_android.ps1
    pwsh -File tools/smoke_test_android.ps1 -SkipUnitTests -KeepEmulatorRunning
#>
[CmdletBinding()]
param(
    [string]$AvdName        = 'Medium_Phone',
    [string]$AppId          = 'com.example.expense_tracker',
    [string]$Activity       = 'com.example.expense_tracker.MainActivity',
    [int]   $BootTimeoutSec = 300,
    [string]$ReportDir      = '',
    [switch]$SkipUnitTests,
    [switch]$SkipBuild,
    [switch]$KeepEmulatorRunning
)

$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------- paths / log
$Sdk = if ($env:ANDROID_HOME) { $env:ANDROID_HOME }
elseif ($env:ANDROID_SDK_ROOT) { $env:ANDROID_SDK_ROOT }
else { 'C:\Users\Admin\AppData\Local\Android\sdk' }

$EmulatorExe = Join-Path $Sdk 'emulator\emulator.exe'
$AdbExe      = Join-Path $Sdk 'platform-tools\adb.exe'

$ProjectRoot = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
if (-not $ReportDir) { $ReportDir = Join-Path $ProjectRoot 'build\reports\smoke' }
New-Item -ItemType Directory -Force -Path $ReportDir | Out-Null

$Stamp = '{0:yyyyMMdd-HHmmss}' -f (Get-Date)
$LogFile = Join-Path $ReportDir "smoke-$Stamp.log"
$ShotFile = Join-Path $ReportDir "smoke-$Stamp.png"

$script:Failures = @()
function Write-Log {
    param([string]$Message, [string]$Level = 'INFO')
    $line = '[{0:HH:mm:ss}] [{1}] {2}' -f (Get-Date), $Level, $Message
    switch ($Level) {
        'ERROR' { Write-Host $line -ForegroundColor Red }
        'WARN'  { Write-Host $line -ForegroundColor Yellow }
        'OK'    { Write-Host $line -ForegroundColor Green }
        default { Write-Host $line }
    }
    Add-Content -Path $LogFile -Value $line
}

function Add-Failure { param([string]$m) $script:Failures += $m; Write-Log $m 'ERROR' }

function Assert-Tool {
    param([string]$Path, [string]$Hint)
    if (-not (Test-Path $Path)) {
        throw "Required tool not found: $Path`n$Hint"
    }
}

Write-Log "Smoke run started. Log: $LogFile"
Write-Log "SDK: $Sdk"
Assert-Tool $EmulatorExe 'Install Android SDK emulator via sdkmanager: "sdkmanager emulator"'
Assert-Tool $AdbExe      'Install Android platform-tools via sdkmanager: "sdkmanager platform-tools"'

# ------------------------------------------------------------- preflight: accel
function Get-HypervisorState {
    $hvPresent = $false
    try { $hvPresent = [bool](Get-CimInstance Win32_ComputerSystem -EA Stop).HypervisorPresent } catch { }

    $fwEnabled = $null
    try { $fwEnabled = (Get-CimInstance Win32_Processor -EA Stop).VirtualizationFirmwareEnabled } catch { }

    $aehd = Get-Service -Name 'aehd' -EA SilentlyContinue

    [pscustomobject]@{
        HypervisorPresent = $hvPresent
        FirmwareVTx       = $fwEnabled
        AehdPresent       = [bool]$aehd
        AehdStatus        = if ($aehd) { $aehd.Status } else { $null }
    }
}

$hv = Get-HypervisorState
Write-Log ("Hypervisor: present={0} firmwareVTx={1} aehd={2}/{3}" -f $hv.HypervisorPresent, $hv.FirmwareVTx, $hv.AehdPresent, $hv.AehdStatus)

if (-not $hv.HypervisorPresent) {
    if ($hv.AehdPresent -and $hv.AehdStatus -ne 'Running') {
        Write-Log 'AEHD driver is stopped; attempting to start it...' 'WARN'
        sc.exe start aehd | Out-Null
        Start-Sleep -Seconds 2
        $hv = Get-HypervisorState
        Write-Log ("AEHD after start: {0}" -f $hv.AehdStatus)
    }
    if (-not $hv.HypervisorPresent -and $hv.AehdStatus -ne 'Running') {
        Write-Log '' 
        Write-Log '=== EMULATOR CANNOT START: no CPU virtualization available ===' 'ERROR'
        Write-Log 'The x86_64 system image requires hardware acceleration.' 'ERROR'
        if ($hv.FirmwareVTx -eq $false) {
            Write-Log 'Root cause: Intel VT-x / AMD-V is DISABLED IN FIRMWARE (BIOS/UEFI).' 'ERROR'
            Write-Log 'This cannot be fixed from the OS. Remediation:'
            Write-Log '  1. Reboot and enter BIOS/UEFI (commonly F2, F10, Del, or Esc at boot).'
            Write-Log '  2. Enable "Intel Virtualization Technology" / "Intel VT-x" (or AMD SVM).'
            Write-Log '  3. Save and exit, boot Windows, then start the driver:  sc.exe start aehd'
            Write-Log '  4. Re-run this script.'
        } else {
            Write-Log 'Firmware virtualization looks enabled but the driver is not running. Try:'
            Write-Log '  - sc.exe start aehd   (Android Emulator hypervisor driver)'
            Write-Log '  - or enable Windows Hypervisor Platform:'
            Write-Log '    Enable-WindowsOptionalFeature -Online -FeatureName HypervisorPlatform -All'
            Write-Log '  - reinstall AEHD via: sdkmanager "extras;google;Android_Emulator_Hypervisor_Driver"'
        }
        Write-Log ("Full log: {0}" -f $LogFile)
        exit 2
    }
}
Write-Log 'CPU virtualization available.' 'OK'

# ------------------------------------------------------- emulator boot helpers
function Get-ConnectedSerial {
    $lines = & $AdbExe devices 2>$null | Select-Object -Skip 1
    foreach ($l in $lines) {
        if ($l -match '^(?<serial>\S+)\s+(?<state>device|offline|unauthorized)$') {
            if ($Matches.state -eq 'device' -and $Matches.serial -notlike 'windows*' -and $Matches.serial -notlike 'chrome*') {
                return $Matches.serial
            }
        }
    }
    return $null
}

function Wait-ForBoot {
    param([string]$Serial, [int]$TimeoutSec)
    $deadline = (Get-Date).AddSeconds($TimeoutSec)
    Write-Log "Waiting for boot_completed on $Serial (timeout ${TimeoutSec}s)..."
    while ((Get-Date) -lt $deadline) {
        $done = (& $AdbExe -s $Serial shell getprop sys.boot_completed 2>$null) -join ''
        if ($done.Trim() -eq '1') {
            # boot animation fully stopped
            $anim = (& $AdbExe -s $Serial shell getprop init.svc.bootanim 2>$null) -join ''
            if ($anim.Trim() -eq 'stopped') { return $true }
        }
        Start-Sleep -Seconds 5
    }
    return $false
}

$serial = Get-ConnectedSerial
if ($serial) {
    Write-Log "Emulator already running: $serial" 'OK'
} else {
    Write-Log "Launching AVD '$AvdName'..."
    Start-Process -FilePath $EmulatorExe `
        -ArgumentList @('-avd', $AvdName, '-no-boot-anim', '-no-snapshot-load', '-gpu', 'auto') `
        -WindowStyle Minimized

    & $AdbExe start-server | Out-Null
    $deadline = (Get-Date).AddSeconds($BootTimeoutSec)
    while (-not $serial -and (Get-Date) -lt $deadline) {
        Start-Sleep -Seconds 5
        $serial = Get-ConnectedSerial
    }
    if (-not $serial) {
        Add-Failure "No emulator device appeared within ${BootTimeoutSec}s."
        Write-Log ("Full log: {0}" -f $LogFile)
        exit 3
    }
    Write-Log "Device connected: $serial" 'OK'
}

if (-not (Wait-ForBoot -Serial $serial -TimeoutSec $BootTimeoutSec)) {
    Add-Failure "Emulator did not finish booting within ${BootTimeoutSec}s."
    Write-Log ("Full log: {0}" -f $LogFile)
    exit 3
}
Write-Log 'Emulator boot completed.' 'OK'
& $AdbExe -s $serial shell input keyevent 82 | Out-Null   # dismiss keyguard

# ------------------------------------------------------------------ unit tests
Push-Location $ProjectRoot
try {
    if (-not $SkipUnitTests) {
        Write-Log 'Running flutter test...'
        & flutter test 2>&1 | Tee-Object -FilePath $LogFile -Append | Out-Null
        if ($LASTEXITCODE -ne 0) { Add-Failure 'flutter test reported failures.' }
        else { Write-Log 'flutter test passed.' 'OK' }
    }

    if (-not $SkipBuild) {
        Write-Log 'Building debug APK...'
        & flutter build apk --debug 2>&1 | Tee-Object -FilePath $LogFile -Append | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Add-Failure 'flutter build apk --debug failed.'
            Write-Log ("Full log: {0}" -f $LogFile)
            exit 4
        }
        Write-Log 'APK build succeeded.' 'OK'
    }
}
finally {
    Pop-Location
}

$apk = Join-Path $ProjectRoot 'build\app\outputs\flutter-apk\app-debug.apk'
Assert-Tool $apk 'Run without -SkipBuild first, or build the APK manually.'

# ------------------------------------------------------------ install + launch
Write-Log "Installing $apk ..."
$installOut = & $AdbExe -s $serial install -r -t $apk 2>&1
$installOut | Tee-Object -FilePath $LogFile -Append | Out-Null
if ($LASTEXITCODE -ne 0) {
    Add-Failure 'adb install failed.'
} elseif (($installOut -join "`n") -match 'Success') {
    Write-Log 'APK installed successfully.' 'OK'
}

& $AdbExe -s $serial logcat -c | Out-Null

Write-Log "Launching $AppId/$Activity ..."
& $AdbExe -s $serial shell am start -W -n "$AppId/$Activity" 2>&1 |
    Tee-Object -FilePath $LogFile -Append | Out-Null

Start-Sleep -Seconds 12   # let first frame render

# -------------------------------------------------------------------- verify
$pidOut = (& $AdbExe -s $serial shell pidof $AppId 2>$null) -join ''
if ($pidOut.Trim()) {
    Write-Log "App process alive (pid $(($pidOut -join '').Trim()))." 'OK'
} else {
    Add-Failure 'App process is not running after launch.'
}

$crashes = & $AdbExe -s $serial logcat -d -b crash 2>$null |
    Select-String -Pattern 'FATAL EXCEPTION|beginning of crash' -SimpleMatch
if ($crashes) {
    Add-Failure 'Crash detected in logcat crash buffer:'
    $crashes | ForEach-Object { Write-Log ("  $_") 'ERROR' }
} else {
    Write-Log 'No crash-buffer entries.' 'OK'
}

$anr = & $AdbExe -s $serial logcat -d 2>$null | Select-String -Pattern 'ANR in', 'Application Not Responding' -SimpleMatch
if ($anr) { Add-Failure 'ANR detected in logcat.' } else { Write-Log 'No ANR detected.' 'OK' }

# ------------------------------------------------------------------ screenshot
& $AdbExe -s $serial shell screencap -p /sdcard/smoke.png | Out-Null
& $AdbExe -s $serial pull /sdcard/smoke.png $ShotFile 2>&1 | Out-Null
if (Test-Path $ShotFile) { Write-Log "Screenshot saved: $ShotFile" 'OK' }
else { Add-Failure 'Screenshot capture failed.' }

# -------------------------------------------------------------------- summary
Write-Log ''
if ($script:Failures.Count -eq 0) {
    Write-Log '=== SMOKE TEST PASSED ===' 'OK'
    $code = 0
} else {
    Write-Log ("=== SMOKE TEST FAILED ({0} issue(s)) ===" -f $script:Failures.Count) 'ERROR'
    $script:Failures | ForEach-Object { Write-Log "  - $_" 'ERROR' }
    $code = 1
}
Write-Log "Log:        $LogFile"
Write-Log "Screenshot: $ShotFile"

if (-not $KeepEmulatorRunning) {
    Write-Log 'Shutting down emulator (use -KeepEmulatorRunning to keep it).'
    & $AdbExe -s $serial emu kill | Out-Null
} else {
    Write-Log "Emulator left running: $serial"
}

exit $code
