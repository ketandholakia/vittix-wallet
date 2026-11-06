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

## P0-3 — SQLCipher backup verification and atomic restore

- Verified with a device integration test (`integration_test/backup_cipher_test.dart`)
  that `VACUUM INTO` on a SQLCipher database produces an **encrypted** snapshot
  (its first 16 bytes are not `SQLite format 3`).
- `BackupService.validate()` is now async and key-aware: it opens encrypted
  snapshots with the database key (after unwrapping a passphrase container)
  instead of requiring the plaintext SQLite header. Wrong keys/passphrases fail
  closed.
- `restore()` is atomic: materialize → validate → stage beside the live file →
  close → move old DB to `.bak` → rename staged file into place → only then
  delete old `-wal`/`-shm` → probe the new file and roll back to `.bak` if it
  cannot be opened. The previous database is kept as `.bak`.
- Settings import and the recovery service pass the live database key to
  validation/restore.
- Plaintext scratch files from encrypted snapshots are still deleted on every
  path, including failure.

## P0-4 — Sync deletions (tombstones)

- `deleted_records` now stores `wallet_id`; schema version is 17 with a
  migration that adds the column (or creates the table if an older database
  never had it).
- `AFTER DELETE` triggers now write a tombstone for every synced UUID table
  (`accounts`, `categories`, `transactions`, `budgets`,
  `recurring_transactions`, `loans`, `peer_debts`, `wallet_expense_splits`,
  `wallet_settlements`, `wallet_activities`, `wallets`) in `onCreate` and in the
  v17 migration. `insertDeletedRecord` writes a real row again.
- Sync pushes only the current wallet's tombstones (plus wallet-independent
  ones) and populates `walletId` in the payload. Cleanup deletes only the
  tombstones that were pushed, never other wallets' logs.
- Pull applies tombstones with wallet isolation: foreign tombstones are skipped,
  a newer local edit survives an older tombstone, and remote changes do not
  resurrect a row with a newer tombstone. Applied remote deletions clear the
  local trigger-generated tombstone so it is not pushed straight back.
- Re-enabled `test/cloud_sync_test.dart` and kept
  `test/sync_deletion_wallet_isolation_test.dart` green (fixed stale imports,
  wallet/member setup, and the schema-version assertion).
- Fixed `CurrentWalletIdNotifier.selectWallet` to reject an invalid wallet
  instead of "allowing selection anyway" (the pre-existing failing test).

## P0-5 — Sync transport and secrets

- `validateSyncUrl` now rejects anything but `https`. Debug builds additionally
  allow `http` for `localhost`, `127.0.0.1`, `::1`, `10.x` and `192.168.x`;
  release builds reject plain http everywhere.
- `syncToken` moved from SharedPreferences to `flutter_secure_storage` via
  `SecureStorageKeyValueStore`, with a one-time `SyncTokenMigration` that writes
  the legacy value to the keystore and deletes the old plaintext key.
- The sync payload is encrypted with the same AES-GCM container used by
  `BackupService` (`encryptBytes`/`decryptBytes`), keyed by a user-set sync
  passphrase in secure storage. Encrypted request/response bodies are detected
  with `BackupService.isEncryptedBytes`; no second crypto format was added.
- Added a "Sync Passphrase" field in the sync settings.
- Removed credentials and payloads from logs and exceptions: failures log only
  the error type, and HTTP errors no longer include response bodies.
- Added `test/sync_security_test.dart` for URL policy and token migration.

## P1-6 — Money as integer minor units (defensive migration)

- Confirmed the current schema already stores every money column as `INTEGER`
  minor units through `MoneyConverter`; the Dart-facing API intentionally keeps
  `double` major units at the boundary (so CSV/SMS/LLM/report code is unchanged).
- Added schema v18: `convertLegacyMoneyColumns` rewrites any money column whose
  declared SQLite type is still `REAL`/`DOUBLE`/`FLOAT`/`NUMERIC` (databases
  created before v13) using `ROUND(value * 100)` instead of silent truncation.
  It is idempotent and skips missing tables/columns.
- Added `test/money_migration_test.dart` seeding `0.1 + 0.2`, `1234.565`,
  negative values and an exact half, asserting `[30, 123457, -30, 1]`.
- No Dart API rewrite: backwards-compatible CSV import/export is preserved.

## P1-7 — Sync conflict resolution

- Added `sync_merge.dart`: `resolveSyncConflict` (5-minute future clock-skew
  guard, 2-second conflict window) and `mergeEntityChanges`, one generic
  last-write-wins merge driven by per-entity callbacks. The seven duplicated
  `updatedAt.isAfter(existing.updatedAt)` blocks (categories, accounts,
  transactions, budgets, recurring, loans, peer debts) now use it.
- Near-simultaneous edits keep the local row and record the remote payload in a
  new `sync_conflicts` table (schema v19) instead of dropping it silently.
  Conflicts are deduplicated per entity/uuid/timestamp.
- Tombstone filtering moved into the generic merge.
- Added `test/sync_merge_test.dart` for the decision matrix and merge outcomes.

## P1-8 — Stop swallowing errors

- Added `core/utils/app_logger.dart`, a single diagnostic sink that is a no-op
  in release builds.
- Replaced every `catch (_)` in the listed paths with specific `on` clauses:
  CSV date parsing (`FormatException`), CSV row import (Format
  `Exception`/`Exception` with row number), PDF/SMS merchant mapping
  (`FormatException`), SMS unrecognised-row insert (`SqliteException`), wallet
  revalidation (`Object` so teardown errors cannot leak), dashboard widget JSON
  (`FormatException`/`TypeError`), account currency (`ArgumentError`), backup
  probes (`FileSystemException`/`SqliteException`), backup pruning, PIN hash
  corruption, notification exact-alarm fallback (`PlatformException`) and
  category suggestions.
- `CsvImportSummary.skippedReasons` now lists row numbers and reasons; SMS/PDF
  screens already show candidate/rejected/duplicate counts. (CSV import has no
  screen wired to it, so the summary is returned to callers.)
- `AppLogger` prints stack traces as plain text (Flutter's frame parser asserts
  on test-only "asynchronous gap" markers), and release builds log nothing.

## P1-9 — PIN lockout clock and KDF hardening

- `PinAttemptLimiter` now persists a wall-clock high-water mark plus a
  process-scoped `Stopwatch` reference. Moving the device clock backwards
  cannot shorten or clear a lockout; a restart falls back to the high-water
  mark.
- `PinHasher.defaultIterations` raised from 50 000 to 210 000. PBKDF2 now runs
  in `Isolate.run` so the UI does not jank.
- Existing hashes keep verifying with their stored iteration count, and
  `needsUpgrade` now also upgrades older v2 hashes (< 210 000) on the next
  successful unlock, not just legacy v1.
- Tests: clock rollback keeps the lockout; old hashes verify and are flagged
  for upgrade.

## P2-10 — Remove duplicate files

- Deleted every one-line export shim under `lib/presentation/**` and
  `lib/core/providers/{settings,dashboard}_providers.dart`; all imports now point
  at the live `lib/features/**` / `lib/core/presentation/**` copies.
- Removed the duplicated widgets/screens: add_transaction_screen,
  transaction_list_item, recent_transactions_list, category_report_screen,
  dashboard_shimmer, shimmer_list, empty_state_widget, error_display_widget,
  dashboard_providers, settings_providers (plus budget/trend/account/report
  shims found in the same pass).
- Deleted two unreachable, non-compiling screens (`notification_action_center_screen.dart`,
  `feedback_screen.dart`) whose DAOs do not exist.
- Fixed `walletInvitationsProvider` (was a `FutureProvider` returning a
  `Stream`); it is now a `StreamProvider`. Replaced the undefined
  `appDatabaseProvider` usage with `databaseProvider`.
- `lib/data/**` and `lib/domain/**` were kept: they are an actively used
  re-export layer, not dead code.
- Analyzer now has **0 errors** (was 10).

## P2-11 — Split database and sync service

- `app_database.dart` went from ~2,600 to 347 lines:
  - one `part` file per DAO under `lib/core/database/daos/`
    (`wallet_dao.dart`, `account_dao.dart`, `transaction_dao.dart`,
    `budget_dao.dart`, `recurring_transaction_dao.dart`, `allowance_dao.dart`,
    `bill_dao.dart`, `category_dao.dart`, `goal_dao.dart`, `user_dao.dart`,
    `payee_dao.dart`, `transaction_tag_dao.dart`, `attachment_dao.dart`).
  - `lib/core/database/migrations/database_migrations.dart` holds
    `createSchema`, `upgradeSchema`, and one `migrateToVn` function per schema
    version (v2-v19).
  - Part files stay in the same Drift library, so the generated `_$…DaoMixin`
    and table fields keep working with no public API change.
- `sync_service.dart` was split into:
  - `sync_service.dart` (coordinator, payload, transport),
  - `sync_entity_upserts.dart` (per-entity upsert handlers),
  - `sync_simulated_server.dart` (local simulated server),
  - `sync_merge.dart` (generic per-entity merge adapters, from P1-7).

## P2-12 — One DI approach: Riverpod

- Removed the `get_it` dependency from `pubspec.yaml`/`pubspec.lock`.
- It was declared but never imported or used. Riverpod is the actual DI system
  (~495 `ref.watch`/`ref.read` uses across 74 files, plus `ProviderScope` in
  `main.dart` and `ProviderContainer` in tests), so keeping both was dead
  weight and an invitation to split the wiring.

## P2-13 — Tooling, startup and docs

- `analysis_options.yaml` now enables `strict-casts`, `strict-inference`,
  `strict-raw-types`, `avoid_catches_without_on_clauses`, `unawaited_futures`,
  `prefer_const_constructors` and `always_declare_return_types`.
  `flutter analyze` reports **0 issues** (was 210 before the engagement).
- Applied 162 `dart fix` changes, then fixed the remaining strict-mode issues
  manually (explicit generics for routes/dialogs/delays, typed stub collections,
  mounted guards, await/unawaited, typed catch clauses, deprecated share/PIN
  APIs, test import hides).
- `.isolated` tests: `cloud_sync` (P0-4) and `debts_loans` re-enabled,
  `widget_test` replaced with a real smoke test; the stale widget-lifecycle
  `app_lock_test` was deleted (its PIN/limiter logic is covered by
  `pin_hashing_test.dart`).
- README replaced with real setup, architecture, security model, backup/restore,
  sync, migration and SMS-permission documentation. `pubspec.yaml` has a real
  description and declares `clock` directly.
- `main.dart` no longer waits a fixed 2 seconds: startup runs after the first
  frame while the DB opens and migrates (`databaseOpenPlanProvider` + a probe
  query). Notifications, recurring processing and auto-backup each have their
  own try block and their own once-per-day gate, so one failure cannot skip the
  others or retry in a loop.

## P2-14 — Android policy

- README documents why `READ_SMS`/`RECEIVE_SMS` are needed (Play declaration
  wording), how SMS data stays on-device, and how to build without SMS.
- SMS import is now optional end to end:
  - `kSmsImportEnabled` (`--dart-define=SMS_IMPORT_ENABLED=false`) hides the
    Settings entry and short-circuits the import screen.
  - `-Pvittix.smsImport=false` (or the equivalent Gradle property) merges
    `android/app/src/noSms/AndroidManifest.xml`, removing both SMS permissions
    (including the copies contributed by `android_sms_reader`) and the
    `SmsCaptureReceiver`.
- Exact alarms: `NotificationService` checks
  `canScheduleExactNotifications()` and falls back to `inexactAllowWhileIdle`
  when exact alarms are unavailable (with the existing `PlatformException`
  fallback as a backstop). The README documents the Play policy trade-off.
