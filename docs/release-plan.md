# Release plan

Status: draft, 2026-11. Supersedes the ad hoc phase list in the external review
of this repository. Every factual claim below was checked against the tree at
`7b671fa`; measurements are reproduced in "Verified baseline".

This document is the plan of record for the path from the current release
hardening state to a public beta.

## Verified baseline

Checked by reading the tree, not by running the toolchain.

| Item | Measurement |
| --- | --- |
| Dart files under `lib/` | 285 |
| Generated code | `app_database.g.dart` = 26,403 lines |
| Test cases | 444 baseline; 451 after P2-18 (not executed, see below) |
| Widget tests | 1 (`test/widget_test.dart`) |
| `DateTime.now()` in `lib/` | 148 |
| `clock.now()` in `lib/` | 2 |
| `Semantics(...)` widgets | 0 |
| `.arb` files | 0 |
| `StateNotifier` references | 40 |
| `₹` literals in `lib/` | 12 |
| `MaterialPageRoute` call sites | 33 |
| `Navigator.push` call sites | 1 |
| `performSync` | starts line 371 of a 1,207-line file |
| `debts_loans_screen.dart` | 1,370 lines |
| `wallet_dao.dart` | 1,078 lines |
| `dashboard_providers.dart` | 761 lines |
| `settings_screen.dart` | 886 lines |
| `web_dashboard_ui.dart` | 892 lines, no importer |
| `package:expense_tracker` imports | 887 (before P2-15) |

**Not verified:** `flutter analyze`, `flutter test`, `dart format` and Drift
code generation. No Flutter, Dart, Java or Android SDK is installed in the
review environment (see `docs/audits/VW_P2_CHANGESET_REVIEW.md`). The roadmap's
"0 analyzer issues / 444 passing" figure is a historical baseline, not a
re-check of the current tree. Static checks that *were* run: `git diff --check`
(clean after the fixes below), YAML parse of `pubspec.yaml` and
`.github/workflows/ci.yml`, and import/symbol greps.

## Corrections to the external review

The review was accurate on almost every claim. Four points change the plan:

1. **`DateTime.now()` count is 148, not 117.** The clock refactor is larger than
   priced.
2. **The hardcoded `₹` is a parsing risk, not only a display one.** It appears in
   `gpay_pdf_parser.dart` and `phonepe_pdf_parser.dart` amount regexes. A
   currency change silently breaks statement import. Mitigation: a `Currency`
   enum with `CurrencyInfo` already exists in `settings_providers.dart`, so the
   seam is there.
3. **The clock refactor is not a Phase 1 blocker.** `test/month_boundary_test.dart`
   already covers month boundaries, so deterministic time is not a total gap.
   Demoted to Phase 2.
4. **Safe deletion is half-built, not unstarted.** `TransactionDao` already has
   wallet-scoped `reassignTransactionsForCategory` / `…ForAccount` with tests in
   `test/category_account_reassign_test.dart`. Only the UI and the atomic
   composite operations were missing. Completed as P2-18.

Additional findings made during verification:

- **`Categories` has no `walletId` column.** Categories are global, not
  wallet-scoped, unlike every other domain. This contradicts the "wallet
  isolation is consistent" assessment. It is a schema change and is not
  scheduled yet.
- **`PRAGMA foreign_keys` is never executed**, so no cascade or restrict
  constraint is enforced. Every "delete the children too" guarantee in the UI
  was therefore untrue; fixed for categories in P2-18.
- **The repository layer is duplicated behind re-export shims.**
  `lib/data/repositories/*.dart` and `lib/domain/repositories/*.dart` re-export
  `lib/features/**`. Removing the shim layer is already a roadmap item.
- **`lib/features/categories/data/category_repository.dart` duplicates the
  category repository interface** and is imported only by the dead
  `csv_importer.dart`.

## Phase 1 — Safety net (partly done)

1. CI running `flutter analyze`, `flutter test`, `dart format`, a lockfile drift
   check and a Drift codegen drift check. **Done as P2-17, report-only.**
   Making it blocking is a follow-up: set `REPORT_ONLY` to `"false"` once the
   baseline is confirmed against the pinned SDK.
2. Remove unused dependencies (`alfred`, `go_router`, `permission_handler`,
   `flex_color_scheme`). **Done as P2-16.**
3. Delete `lib/api/web_dashboard_ui.dart` or move it out of `lib/` until a real
   local server exists. It loads Chart.js from a CDN, which contradicts the
   local-first positioning.
4. Decide on `go_router`: 33 `MaterialPageRoute` sites, so adopting it is a real
   migration. Removing the dependency (P2-16) does not decide this; record a
   decision.
5. Rename the Dart package to `vittix_wallet`. **Done as P2-15.**

Exit criteria: CI is blocking, not report-only; no unused dependency remains;
`web_dashboard_ui.dart` is gone or served.

## Phase 2 — Finish what looks done but is not

1. **Tags and attachments (B1).** `TransactionTagDao.setTagsForTransaction` and
   `AttachmentDao.insertAttachment` are empty `async {}` bodies and take
   `dynamic` parameters, so they fail silently and cannot be type-checked.
   Implement both, store the scanned receipt image, add a tag filter.
2. **Safe deletion.** **Category and account paths done as P2-18.** Remaining:
   enable `PRAGMA foreign_keys` in `MigrationStrategy.beforeOpen` and verify that
   no existing delete path relies on the constraint being off.
3. **Transfers:** edit and delete both legs together from the list.
4. **Undo/trash (B4):** soft delete with a 30-day trash.
5. **Portable backup.** Highest user-facing risk: restore on another device fails
   because snapshots depend on the keystore key. Put a plaintext snapshot inside
   the passphrase container.
6. **Clock refactor:** replace `DateTime.now()` with `clock.now()` in domain, DAO
   and service code, then add timezone tests.

## Phase 3 — Maintainability

1. Split `performSync` into pull, push, apply and tombstone stages, each
   unit-tested. Do this before any further sync work.
2. Break `debts_loans_screen.dart` (1,370 lines, 13 classes) into one file per
   tab, sheet and dialog.
3. Split `wallet_dao.dart` into membership, lifecycle and invitation DAOs.
4. Migrate `StateNotifier` to `Notifier`/`AsyncNotifier` feature by feature with
   isolation tests green at each step.
5. `LlmService`: replace the polling busy-wait lock with a `Completer`/`Future`
   guard and use typed exceptions.
6. Remove the `lib/data/**` and `lib/domain/**` re-export shims, and delete the
   duplicate category repository interface.

## Phase 4 — Release readiness

1. `dataExtractionRules`, privacy screen, Play SMS declaration.
2. Opt-in crash reporting or a redacted diagnostics export (B10).
3. `intl` ARB localisation and a currency setting; replace the 12 `₹` literals,
   including both PDF parser regexes.
4. `Semantics` labels and large-text checks on the main flows.
5. Golden or widget tests for add-transaction, list and dashboard.

## Phase 5 — Features (after public beta)

1. Credit cards (B3): statement and due dates, limit, utilisation, minimum due,
   reminders.
2. Export: PDF and Excel (`syncfusion_flutter_pdf` is already a dependency), then
   read-only ledger sharing.
3. Home-screen widget and quick-add (B6).
4. More SMS parsers (B12): Axis, Kotak, PNB, with per-sender confidence.
5. Saved filters and bulk edit (B7).
6. Sync: keep hidden until there is a backend plan. The A7 identity migration is
   a prerequisite — wallets match by local autoincrement ids, which breaks across
   devices.
7. Local web dashboard: only if wanted, on a real local server, with Chart.js
   served from assets.

## Order of attack

1. Make CI blocking (Phase 1 exit).
2. Portable backup, then tags/attachments, then `PRAGMA foreign_keys`.
3. Split `performSync`, then the A7 identity migration.
4. Beta release, then credit cards, export and widget.

## Open decisions

- Portable backup container format.
- `go_router` adoption or permanent removal.
- Whether categories become wallet-scoped (schema change, affects sync).
- Whether `mediapipe_genai` 0.0.1 stays; it blocks `sqlcipher_flutter_libs`
  above 0.6.0.
