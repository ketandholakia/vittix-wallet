/// Compile-time feature switches.
///
/// Override with `--dart-define=SMS_IMPORT_ENABLED=false` for a build that
/// ships without the SMS import feature. The Android manifest can drop the SMS
/// permissions at the same time (`-Pvittix.smsImport=false`, see the README).
const bool kSmsImportEnabled = bool.fromEnvironment(
  'SMS_IMPORT_ENABLED',
  defaultValue: true,
);
