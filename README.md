# Vittix Wallet

Vittix Wallet is a local-first expense tracker for personal and shared
wallet-based finance. The on-device database is the source of truth; the app
works fully offline and can optionally synchronise through Nextcloud/WebDAV.

Package: `expense_tracker` · Flutter 3.44+ · Dart 3.12+

## Feature map

- Personal and family wallets, members, roles and invitations.
- Transactions, transfers, split expenses, settlements and peer debts.
- Budgets with rollover, goals, bills, allowances and recurring transactions.
- Reports and trends with integer-minor-unit aggregation.
- CSV import/export, SMS import (optional) and receipt/PDF scanning.
- Encrypted backups, optional passphrase containers and automatic backups.
- PIN/biometric app lock.

## Getting started

```bash
flutter pub get
flutter run --debug
```

Requirements:

- Flutter 3.44 or newer (Dart 3.12).
- Android SDK 36 (`compileSdk = 36`) and JDK 17 for Android builds.
- SQLCipher is bundled through `sqlcipher_flutter_libs`; no manual native setup
  is needed for a normal build. `lib/core/database/sqlcipher_loader.dart`
  installs the loader for Android and for the database isolate.

Generated Drift code lives in `lib/core/database/app_database.g.dart`. After
changing a Drift table or DAO run:

```bash
dart run build_runner build
```

## Project layout

```text
lib/
  core/
    database/       Drift database, DAOs, migrations, encryption
    services/       Backups, recovery, auto backup
    money/          Integer minor-unit helpers
    utils/          CSV importer/exporter, logger, duplicate detection
  features/
    <feature>/      data (tables, DAOs), domain, presentation (Riverpod)
    sync/data/      Sync coordinator, entity handlers, conflict merge
  presentation/     Shared dashboard widgets retained from the older tree
  sms/ pdf/ llm/    Optional import pipelines
test/               Unit / widget tests (flutter test)
integration_test/   On-device tests (SQLCipher, backup, notifications)
docs/               History, roadmap, architecture notes, backlog
```

Dependency injection is Riverpod only. `ProviderScope` is installed in
`main.dart`; tests use `ProviderContainer` overrides. There is no `get_it`
service locator.

## Security model

- **At rest.** The Drift database is SQLCipher-encrypted with a random 256-bit
  key generated once and stored in the platform keystore (`flutter_secure_storage`).
  The PIN is a UI gate, *not* the database key, so resetting a PIN cannot lose
  data.
- **Fail closed.** Opening a database that is already encrypted but whose key is
  missing or fails an integrity check throws `DatabaseKeyUnavailableException`;
  the app shows a recovery screen and never opens the file as plaintext or
  overwrites it. Plaintext is only used when key creation itself failed, and a
  persistent banner warns the user.
- **PIN hardening.** PBKDF2-HMAC-SHA256 with a per-PIN salt and at least 210,000
  iterations, run in an isolate. The iteration count is stored with the hash;
  legacy v1 and older v2 hashes still verify and are upgraded on the next
  successful unlock. Progressive lockout persists a wall-clock high-water mark
  plus a process-scoped monotonic reference, so setting the clock backwards
  cannot clear a lockout.
- **Transport.** Sync only accepts `https`. Debug builds also allow plain
  `http` for `localhost`/`127.0.0.1`/`::1` and `10.x`/`192.168.x`. The sync
  token and optional sync passphrase live in secure storage; the sync payload
  can be wrapped in the same AES-256-GCM container used for backups.
- **Logging.** `AppLogger` is a no-op in release builds. Tokens, passwords and
  payloads are never logged; HTTP failures log only the status, not the body.

## Backup and restore

- Snapshots use `VACUUM INTO`, which keeps the SQLCipher codec: the snapshot is
  encrypted with the database key (its first 16 bytes are *not* `SQLite format
  3`). Validation is key-aware for this reason.
- An optional passphrase wraps the snapshot in a
  `VITTIXENC1` container (PBKDF2-HMAC-SHA256 + AES-256-GCM).
- Restore is atomic: validate → stage beside the live file → move the old file
  to `.bak` → rename the staged file in → remove old `-wal`/`-shm` → probe the
  new file and roll back from `.bak` if it cannot be opened.
- Automatic backups run at most once per configured interval and keep the five
  newest files.
- **Known limitation:** raw snapshots (and the inner payload of a passphrase
  container) are encrypted with the device keystore key. Restoring after
  keystore loss or on a different device needs the same key; portable backups
  would require exporting a plaintext snapshot inside the passphrase container.

## Sync

- `features/sync/data/sync_service.dart` is the coordinator
  (`SyncNotifier`); per-entity handlers live in `sync_entity_upserts.dart`,
  simulated-server code in `sync_simulated_server.dart`, and the generic
  conflict merge in `sync_merge.dart`.
- Deletes write `deleted_records` tombstones through SQL triggers (schema v17),
  scoped by `wallet_id`. Pull applies tombstones with wallet isolation and never
  resurrects a row with a newer tombstone.
- Conflict rule: a remote edit more than 5 minutes in the future is ignored
  (clock skew); edits more than 2 seconds apart use last-write-wins; otherwise
  the local row is kept and the remote payload is recorded in `sync_conflicts`
  (schema v19) instead of being dropped.
- Cloud Sync is hidden behind `kCloudSyncEnabled` (default `false`) until the
  remaining transport gaps (Nextcloud push, wallet identity matching) are
  resolved.

## Database migrations

The schema is currently version 19. `lib/core/database/migrations/database_migrations.dart`
contains one function per version:

- v17 adds wallet-scoped deletion tombstones.
- v18 normalises legacy `REAL` money columns to exact integer minor units with
  `ROUND(value * 100)` (half away from zero). It is idempotent and skips
  missing/already-integer columns.
- v19 adds the `sync_conflicts` table.

Money is stored as integer minor units (paise/cents) via `MoneyConverter`; the
Dart public API keeps `double` major units at the boundary, so CSV/SMS/LLM
imports and exports remain backwards compatible.

## Android signing and release

Release signing is not checked in:

```bash
cp android/key.properties.example android/key.properties
# fill in storeFile, storePassword, keyAlias, keyPassword
flutter build appbundle --release
```

`android/key.properties` is gitignored. A release build fails with an
actionable Gradle message if it is missing or incomplete. Release builds enable
R8 (`minifyEnabled`) and resource shrinking, with keep rules for ML Kit,
SQLCipher and sqflite.

## SMS permissions (Play policy)

`READ_SMS` and `RECEIVE_SMS` are **optional** and only used by the SMS import
and auto-capture features:

- `RECEIVE_SMS` lets `SmsCaptureReceiver` store incoming bank/UPI messages in a
  device-local queue while the app is closed.
- `READ_SMS` lets the import screen scan existing messages when the user opts
  in.

Both are runtime-requested only when the user opens the SMS import flow, and all
capture state is device-local (`sms_capture_queue` SharedPreferences). No SMS
content is synced, and transaction notes are reduced to `[SMS] Merchant`.

**Play declaration.** SMS access is an optional feature permission, not a core
functionality: declare that `READ_SMS`/`RECEIVE_SMS` power the user-initiated
"SMS import" and auto-capture of bank/UPI transaction messages, that messages
are processed on-device only, and that users who do not use the feature are
never prompted.

**Building without SMS.** Set the Gradle property and the Dart define together:

```properties
# android/gradle.properties (or ORG_GRADLE_PROJECT_vittix.smsImport=false)
vittix.smsImport=false
```

```bash
flutter build appbundle --release --dart-define=SMS_IMPORT_ENABLED=false
```

With `vittix.smsImport=false`, Gradle merges
`android/app/src/noSms/AndroidManifest.xml`, which removes `READ_SMS`,
`RECEIVE_SMS` (including the copies declared by `android_sms_reader`) and the
`SmsCaptureReceiver`. With `SMS_IMPORT_ENABLED=false`, the Settings entry point
and the import screen are disabled. Every other feature works unchanged.

## Exact alarms

`SCHEDULE_EXACT_ALARM` is declared for daily reminders and the monthly summary.
On Android 12+ the OS may refuse exact alarms. `NotificationService` asks
`canScheduleExactNotifications()` first and schedules with
`inexactAllowWhileIdle` when exact alarms are not granted (and catches
`PlatformException` as a second fallback), so reminders still arrive within the
inexact window instead of being dropped. Play treats exact-alarm access as a
policy-sensitive permission; if the store rejects it, remove the manifest entry
and the app will stay on inexact alarms automatically.

## Testing

```bash
flutter analyze
flutter test
flutter test integration_test/backup_cipher_test.dart   # device required
```

`flutter analyze` is expected to be clean under
`strict-casts`/`strict-inference`/`strict-raw-types`.

## Documentation

- [User manual](docs/user_manual.md)
- [Project history](docs/history.md)
- [Roadmap](docs/roadmap.md)
- [Architecture analysis](docs/analysis.md)
- [Release backlog](docs/release-backlog.md)
- [Changelog](CHANGELOG.md)
