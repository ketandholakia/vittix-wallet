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
