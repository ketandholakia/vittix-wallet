# Development environment

Status: **not installed on the current review machine.** Flutter, Dart, Java, the
Android SDK, Gradle, `adb` and `sdkmanager` are all absent, and `JAVA_HOME`,
`ANDROID_HOME`, `ANDROID_SDK_ROOT`, `FLUTTER_ROOT`, `PUB_CACHE` and
`GRADLE_USER_HOME` are unset. Everything in this document is therefore a set of
instructions to be executed with approval — none of it has been run here.

Until a machine is provisioned, **CI is the authoritative validation path**
(see the last section).

## Required tools

| Tool | Requirement | Why this value |
| --- | --- | --- |
| Git | Current supported release (verified here: 2.56.0.windows.4) | Clones the Flutter SDK and manages the repo. |
| Flutter SDK | **Stable channel, pinned to the revision recorded in `.metadata`**: `559ffa3f75e7402d65a8def9c28389a9b2e6fe42` | The repo does not record a marketing version. Checking out the exact revision is the only way to reproduce the SDK that generated the committed code. The `FLUTTER_VERSION` value in `.github/workflows/ci.yml` must then be set to the version that `flutter --version` prints for this revision. |
| Dart SDK | Bundled with the Flutter SDK above. `pubspec.yaml` requires `sdk: ^3.12.0`. | Never install Dart separately; a mismatched standalone Dart breaks Flutter tooling. |
| Java JDK | **JDK 17** | Derived from the repo, not assumed: `android/app/build.gradle.kts` sets `sourceCompatibility`/`targetCompatibility` to `VERSION_17` and `jvmTarget` to `JVM_17`; `android/settings.gradle.kts` pins **AGP 9.0.1**; `android/gradle/wrapper/gradle-wrapper.properties` pins **Gradle 9.1.0**. Gradle 9.x and AGP 8+ both require JDK 17 or newer, and 17 is the level the bytecode targets. |
| Android SDK | Platform **36** (`compileSdk = 36`), Platform Tools, and Build Tools 36.x | `android/app/build.gradle.kts` sets `compileSdk = 36`. `minSdk`/`targetSdk` come from `flutter.minSdkVersion`/`flutter.targetSdkVersion`, so they follow the Flutter SDK — do not hardcode them. |
| Android command-line tools | Current `cmdline-tools` release (`latest`) | Required to install SDK packages and accept licences without Android Studio. |
| Android licences | Accepted via `flutter doctor --android-licenses` | Gradle builds fail without accepted licences. |

## Optional tools

- Android Studio (convenient SDK/emulator manager; not required for CI).
- Android emulator. Needed for `integration_test/` and manual UI checks.
- Physical Android device with USB debugging. Needed for SMS import, notifications
  and exact-alarm behaviour, which cannot be exercised on an emulator.
- VS Code with the Flutter and Dart extensions, or any Flutter-compatible editor.

## Installation — Windows 11 PowerShell

These steps change user-level environment variables and install software. Run
them only with explicit approval.

### 1. Check architecture and prerequisites

```powershell
$env:PROCESSOR_ARCHITECTURE          # expect AMD64
[System.Environment]::OSVersion.Version   # expect 10.0.22621 or newer
Get-PSDrive -Name C | Select-Object Used,Free
git --version
```

Enable long paths (the Flutter SDK and Gradle caches exceed 260 characters):

```powershell
# Requires elevation; this is a machine-wide policy change.
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' `
  -Name LongPathsEnabled -Value 1
```

### 2. Install Flutter outside the repository

Do **not** clone Flutter into this project. Use a directory you control, e.g.
`C:\dev\flutter`.

```powershell
New-Item -ItemType Directory -Force C:\dev | Out-Null
git clone https://github.com/flutter/flutter.git C:\dev\flutter

# Pin to the revision recorded in .metadata instead of floating on `stable`.
git -C C:\dev\flutter checkout 559ffa3f75e7402d65a8def9c28389a9b2e6fe42

# Record the real version for .github/workflows/ci.yml.
C:\dev\flutter\bin\flutter --version
```

Take the `Flutter <version>` line from that output and set it in
`.github/workflows/ci.yml` as `FLUTTER_VERSION`, replacing the provisional
value. Do not leave the placeholder in place once CI is enforced.

### 3. Add Flutter to the user PATH

```powershell
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
[Environment]::SetEnvironmentVariable(
  'Path', "$userPath;C:\dev\flutter\bin", 'User')
```

### 4. Restart the terminal and verify

Close and reopen PowerShell, then:

```powershell
flutter --version
```

### 5. Verify Dart

Dart ships with Flutter; there is nothing separate to install.

```powershell
dart --version
```

### 6. Install the Android SDK

Either install Android Studio and use its SDK Manager, or use the command-line
tools alone:

```powershell
New-Item -ItemType Directory -Force C:\dev\android-sdk\cmdline-tools | Out-Null
# Download the current "commandlinetools-win-*-latest.zip" from
# https://developer.android.com/studio#command-line-tools-only and unzip it so
# the layout is C:\dev\android-sdk\cmdline-tools\latest\bin\sdkmanager.bat
```

Then install the packages this project needs:

```powershell
C:\dev\android-sdk\cmdline-tools\latest\bin\sdkmanager.bat `
  "platform-tools" "platforms;android-36" "build-tools;36.0.0"
```

### 7. Configure Android environment variables

```powershell
[Environment]::SetEnvironmentVariable('ANDROID_HOME', 'C:\dev\android-sdk', 'User')
[Environment]::SetEnvironmentVariable('ANDROID_SDK_ROOT', 'C:\dev\android-sdk', 'User')

$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
[Environment]::SetEnvironmentVariable('Path',
  "$userPath;C:\dev\android-sdk\platform-tools;C:\dev\android-sdk\cmdline-tools\latest\bin",
  'User')
```

Install JDK 17 (Eclipse Temurin is a reasonable choice), then:

```powershell
[Environment]::SetEnvironmentVariable('JAVA_HOME', 'C:\Program Files\Eclipse Adoptium\jdk-17<...>', 'User')
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
[Environment]::SetEnvironmentVariable('Path', "$userPath;$env:JAVA_HOME\bin", 'User')
```

Restart the terminal, then confirm `java -version` reports 17.x.

### 8. Accept Android licences

```powershell
flutter doctor --android-licenses
```

### 9. Verify the toolchain

```powershell
flutter doctor -v
```

The Android toolchain section must report the JDK, SDK and licences as resolved.
Desktop-only warnings (Visual Studio, Chrome) do not block `flutter test`.

### 10. Common Android toolchain problems

| Symptom | Cause | Fix |
| --- | --- | --- |
| `Unable to locate Android SDK` | `ANDROID_HOME` unset or stale terminal | Set the variable, then reopen the terminal. |
| `cmdline-tools component is missing` | Tools unzipped to the wrong depth | Must be `cmdline-tools\latest\bin\sdkmanager.bat`. |
| `licences not accepted` | Licences never run | `flutter doctor --android-licenses`. |
| Gradle fails with `Unsupported class file major version` | JDK newer/older than Gradle expects | Use JDK 17 and set `JAVA_HOME`; do not point Flutter at a JRE. |
| `Could not reserve enough space` / daemon OOM | Gradle heap | Raise `org.gradle.jvmargs` in `android/gradle.properties`. |
| Builds slow or hang | Defender scanning build dirs | Exclude `C:\dev`, the pub cache and `%USERPROFILE%\.gradle`. |
| Long path errors | Windows path limit | Enable `LongPathsEnabled` and keep the repo shallow. |

## Project setup commands

Run from the repository root. This order matters: generate, then validate.

```powershell
flutter clean
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
dart run build_runner build --delete-conflicting-outputs
flutter test
```

Notes:

- `flutter pub get` **must** regenerate `pubspec.lock` after the P2-16 dependency
  removal. Commit the regenerated lockfile; never hand-edit it.
- `dart run build_runner build` rewrites `*.g.dart`. Review the output with
  `git status --short` and commit any legitimate change. Generated files must be
  committed in the same commit as the schema change that produced them.
- CI mirrors this order but runs generation *before* formatting and analysis, so
  the analyzer sees freshly generated code. Locally, either order works as long
  as you re-run `flutter analyze` after generation.
- `dart format` also covers generated `*.g.dart`. If Drift output is not
  format-clean, scope the command to hand-written directories rather than
  committing generated churn.

## Android build and integration tests

Debug build:

```powershell
flutter build apk --debug
```

Run on a connected device or emulator:

```powershell
flutter devices
flutter run -d <device-id>
```

Integration tests require a device or emulator and are **not** run by CI:

```powershell
flutter test integration_test/backup_cipher_test.dart -d <device-id>
flutter test integration_test/backup_smoke_test.dart -d <device-id>
```

Optional SMS build variant (see P2-14):

```powershell
flutter build apk --debug --dart-define=SMS_IMPORT_ENABLED=false
```

## Environment verification checklist

- [ ] Flutter stable SDK installed at the `.metadata` revision.
- [ ] Dart SDK available (`dart --version`).
- [ ] JDK 17 installed and `JAVA_HOME` set.
- [ ] Android SDK platform 36 and build-tools 36.x installed.
- [ ] Android command-line tools on `PATH`.
- [ ] `flutter doctor -v` reviewed.
- [ ] Android licences accepted.
- [ ] `flutter pub get` succeeds.
- [ ] Drift generation succeeds and produces no unexpected changes.
- [ ] `dart format --output=none --set-exit-if-changed .` passes.
- [ ] `flutter analyze` passes.
- [ ] `flutter test` passes.
- [ ] Android debug build succeeds.
- [ ] `.github/workflows/ci.yml` `FLUTTER_VERSION` updated to the real version.

## CI as the authoritative path

This repository can be validated without a local SDK. `.github/workflows/ci.yml`
runs on every push and pull request and covers dependency resolution, lockfile
drift, Drift code generation and drift, formatting, analysis and the unit/widget
suite. Integration tests are the only thing it cannot cover.

CI currently starts in **report-only** mode (`REPORT_ONLY: "true"`), so a red
result is informational until the baseline is confirmed. Records of what has
actually been executed belong in `docs/audits/`; do not describe a check as
passing unless a run is linked.
