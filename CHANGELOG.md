# Changelog

All notable changes to Vittix Wallet are recorded here, one entry per task.

## P0-1 — Android signing and identity

- Removed the debug `signingConfig` from the `release` build type.
- Release builds now read the keystore from `android/key.properties`
  (`storeFile`, `storePassword`, `keyAlias`, `keyPassword`) and fail with a
  clear Gradle message when it is missing or incomplete. Added
  `android/key.properties.example`; `android/key.properties` is gitignored.
- Renamed the Android `applicationId`/`namespace` and Kotlin package from
  `com.example.expense_tracker` to `com.vittix.wallet`, moved the Kotlin
  sources, and renamed the SMS capture `MethodChannel` to
  `com.vittix.wallet/sms_capture` (Dart side updated).
- Enabled `minifyEnabled` + `shrinkResources` for release with keep rules for
  ML Kit, SQLCipher artefacts, sqflite and application components.

## P0-2 — Database encryption fails closed

- `DatabaseEncryption.resolveOpenPlan` now decides how the database opens and
  refuses to open an encrypted file as plaintext: it throws
  `DatabaseKeyUnavailableException` when the keystore is unavailable or the
  stored key does not pass an integrity check. The file is never overwritten.
- Plaintext is only used when key creation itself failed; the plan then carries
  a warning string. A plaintext database that cannot be encrypted in place is
  refused rather than opened unencrypted.
- `_openConnection` uses the memoized plan; `databaseOpenPlanProvider` /
  `databaseEncryptionWarningProvider` expose the outcome to the UI.
- Added `DatabaseRecoveryScreen` (retry, restore-from-backup via
  `DatabaseRecoveryService`) shown instead of the app when unlocking fails, and
  a persistent warning banner while running unencrypted.
- Added tests for every resolution branch using a fake secure store.
