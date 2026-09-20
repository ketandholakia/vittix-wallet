# Release Backlog - consolidated

Status of every item below was checked against the code in this repo (not from
memory). "Verified" = the claim was confirmed by reading the actual source.

Effort: **S** ≈ hours, **M** ≈ 1-3 days, **L** ≈ 1-2 weeks+.

---

## Part A - Must-have before a public release

| # | Item | Verified state in code | Effort | Depends on |
|---|------|------------------------|--------|------------|
| A1 | **Backup & restore** | ✅ **Done.** VACUUM INTO snapshots; optional AES-256-GCM container (PBKDF2-HMAC-SHA256, passphrase in secure storage); automatic backup at app start with interval, folder choice and 5-file retention; import validates (SQLite header, integrity_check, schema version), swaps the file in and reloads providers without an app restart. | M | - |
| A2 | **Real transfers** | `transfer_form_screen.dart` does two independent `addTransaction` calls, no DB transaction; the legs are linked only by a `[Transfer]` note prefix; summaries do not exclude transfers. | M | A6 (for exactness) |
| A3 | **Data-at-rest encryption** | DB is plain `NativeDatabase`; PIN = 4 digits, **static salt in source**, 10k SHA-256 rounds, no attempt limit/lockout. | L | - |
| A4 | **Safe deletion flows** | `deleteCategory` is an unguarded DELETE (`app_database.dart:1341`). No `PRAGMA foreign_keys` **anywhere** in `lib/`, so all `cascade`/`restrict` are inert. `transactions.categoryId` is `onDelete: cascade` → naive FK enablement would erase transactions. | M | - |
| A5 | **Release infrastructure** | ✅ `INTERNET` + `allowBackup="false"` added to the main manifest. Still open: package name is `com.example.expense_tracker`, debug-keystore signing, no `dataExtractionRules`, no privacy screen, no Play SMS declaration. | S-M | - |
| A6 | **Integer money + rounding policy** | 22 `real()` columns. No rounding/remainder handling for splits at all. | L | - |
| A7 | **User identity for collaboration** | No users/profiles table. `WalletMembers.accountId` references money accounts. | L | - |
| A8 | **Sync that works, or hide it** | ✅ **Hidden.** The Settings "Cloud Sync" section is gated behind `kCloudSyncEnabled` (default `false`) in `settings_screen.dart`. Underlying state unchanged: deleted-record writes are no-ops, Nextcloud mode only GETs, wallets matched by local autoincrement ints, sync token in plain SharedPreferences, post-sync cleanup wipes every wallet's deletion log. | S (hide) / L (fix) | A1, A7 |

## Part B - Feature completion

| # | Item | Verified state in code | Effort | Depends on |
|---|------|------------------------|--------|------------|
| B1 | **Tags & attachments that work** | Both DAOs are **no-op stubs**: `TransactionTagDao.setTagsForTransaction` → `async {}`, `AttachmentDao.insertAttachment` → `async {}`. Receipt scanner OCRs but never saves the image. | M | - |
| B2 | **Excel + PDF export; CSV formula injection** | Only CSV exists. `csv_exporter.dart` `escapeCsv` quotes only on `" , \n \r` → a note starting with `=`, `+`, `-` or `@` is executed by Excel/LibreOffice. `syncfusion_flutter_pdf` is already a dependency (currently only for import parsing). | S (fix) / M (PDF+Excel) | - |
| B3 | **Credit card management** | `Account` entity has only `id, name, type, icon, color, openingBalance, isDefault, currencyCode` - no statement date, due date, credit limit, utilization or minimum due. | M | - |
| B4 | **Edit history, undo, trash** | No user-facing undo/trash. (`deletedAt` exists only in the sync `deleted_records` table.) | M | - |
| B5 | **Duplicate detection at entry** | ✅ **Done for all paths.** Shared `looksLikeDuplicate()` (`lib/core/utils/duplicate_detector.dart`) now backs manual entry and both importers; SMS/PDF skip known duplicates and report the count. | S-M | - |
| B6 | **Home-screen widget + quick-add** | `home_widget` not in `pubspec.yaml`; no quick-add tile. | M | - |
| B7 | **Search & filters: saved filters, amount/tag filters, bulk edit** | Search box, type/category/account/date/amount filters exist in `transaction_list_screen.dart`. No saved filters, no tag filter, no bulk edit/delete. | M | B1 (tag filter) |
| B8 | **Ledger sharing without an account** | Read-only share (link or PDF) not implemented. | M | B2 (PDF) |
| B9 | **Automated tests for money paths** | Started: month-boundary + CSV-amount tests added. Still uncovered: timezones, transfers, recurring drift, rounding. | M | A6 |
| B10 | **Crash reporting + diagnostics export** | No crash reporting dependency (no Sentry/Crashlytics). No redacting diagnostics export. | S-M | - |
| B11 | **Data migration safety** | No automatic pre-upgrade backup in the migration path. | S-M | A1 |
| B12 | **SMS parsing beyond SBI/HDFC/ICICI** | Only `sbi_bank_parser`, `hdfc_bank_parser`, `icici_bank_parser`. No per-sender confidence. `merchant_mappings` table exists as a start for merchant memory. | M | - |

---

## Recommended sequencing

**Wave 0 - foundations (do first)**
1. **A6 integer money + rounding policy** - every amount feature (splits, interest, budgets, reports) depends on it. Cheapest to do before those land.
2. **B9 tests for money paths** - lock in current behaviour before/while migrating.
3. **B11 migration safety** - auto-backup before any schema change.

**Wave 1 - release blockers**
4. **A5 release infra** (finish: package name, keystore, dataExtractionRules, privacy screen)
5. **A1 backup/restore** (replaces sync for v1)
6. **A8 hide sync** (small; the "Simulate Cloud Sync" dev toggle is load-bearing for testing - decide)
7. **A4 safe deletion** (reassign-or-block + FK enablement)

**Wave 2 - correctness & core UX**
8. **A2 real transfers**
9. **B2 CSV formula-injection fix** (quick win) → then PDF/Excel export
10. **B4 undo/trash**, **B5 duplicate detection everywhere**
11. **B1 tags & attachments** (incl. persisting the scanned receipt image)

**Wave 3 - differentiators**
12. **A3 encryption**, **A7 users/profiles**
13. **B3 credit cards**, **B7 saved filters/bulk ops**, **B8 sharing**, **B6 widget/quick-add**, **B12 SMS parsers**, **B10 crash reporting**

---

## Quick wins available immediately
- **B2 CSV formula-injection fix** - ✅ done.
- **A8 hide sync** - ✅ done (flag-gated).
- **B5 duplicate-detection parity** - ✅ done (shared detector).

## Already done this session
- Month-range off-by-one (half-open `[firstDay, nextMonthStart)`) across summary/list/dashboard - with tests.
- CSV amount parsing (Indian/Western/European grouping, comma decimals, currency prefixes) - with tests.
- CSV export formula-injection neutralisation (`escapeCsvField`) - with tests.
- Duplicate detection shared across manual/SMS/PDF entry (`looksLikeDuplicate`) - with tests.
- Cloud Sync UI hidden behind a feature flag (A8).
- `INTERNET` + `allowBackup="false"` in the main Android manifest.
- Working backup + validated restore (core/services/backup_service.dart, A1) - with tests.
- Encrypted + automatic backups and restart-free restore (A1) - with 11 tests.
- Full suite 325 pass / 1 pre-existing failure.
