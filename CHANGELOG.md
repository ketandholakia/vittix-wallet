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
