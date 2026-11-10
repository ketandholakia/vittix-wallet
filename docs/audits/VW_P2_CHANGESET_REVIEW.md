# VW P2 change-set review

- **Date:** 2026-11-10
- **Repository:** `vittix-wallet`
- **Branch / HEAD:** `master` / `7b671fa` (`fix(android): use AGP 9 addStaticManifestFile for no-SMS overlay`)
- **Working tree:** 277 modified files (1684 insertions, 1064 deletions), 5 untracked paths, nothing staged
- **Scope:** P2-15, P2-16, P2-17, P2-18 and the release-plan/history documentation, reviewed as one change set

This report separates what was **executed** from what was **read**. No Flutter, Dart, Java or
Android SDK is installed on the review machine, so nothing that requires those toolchains was run.
Every claim below is tagged `EXECUTED`, `STATIC` (read or grep), or `NOT RUN`.

---

## 1. Overall review result

**PASS WITH BLOCKERS.**

The combined change set is coherent, the defects found in static review were fixed, and the parts
that can be validated without a Dart toolchain pass. It cannot be called complete because three
things genuinely require a Flutter SDK that is not installed: lockfile regeneration, static
analysis/formatting, and test execution.

| Area | Result | Basis |
| --- | --- | --- |
| Combined diff review | PASS | `EXECUTED` (git) + `STATIC` |
| Defects found during review | PASS — fixed | `EXECUTED` (edits) |
| Whitespace / line endings (`git diff --check`) | PASS | `EXECUTED` — clean |
| CI workflow YAML + shell syntax | PASS | `EXECUTED` — parses, all `run:` blocks pass `bash -n` |
| CI enforcement-gate logic | PASS | `EXECUTED` — 4 simulated scenarios correct |
| `flutter analyze` / `dart format` | **NOT RUN — BLOCKED BY ENVIRONMENT** | no Dart SDK |
| `flutter test` (451 expected) | **NOT RUN — BLOCKED BY ENVIRONMENT** | no Flutter SDK |
| `pubspec.lock` regeneration | **BLOCKED** | no Flutter SDK; not hand-edited |
| Commits 1, 3, 4 (rename / safe deletion / CI+docs) | CREATED | `EXECUTED` — see §8 execution note |
| Commit 2 (dependency cleanup) | **HELD** | pending lockfile regeneration; created last |

---

## 2. Review of the five changes

### 2.1 P2-15 — package rename to `vittix_wallet`

**Result: PASS (static).**

- `pubspec.yaml` line 1 is `name: vittix_wallet` (`EXECUTED` read).
- 272 modified `.dart` files: 261 are import/export path swaps only, 1
  (`budget_list_item.dart`) is an import swap plus LF normalisation, and 10 contain other edits
  (`EXECUTED` per-file diff classification).
- Zero `package:expense_tracker/` imports remain under `lib/`, `test/`, `integration_test/`
  (`EXECUTED` grep over the tree excluding `.git`, `build`, `.dart_tool`).
- Remaining `expense_tracker` strings are historical (CHANGELOG, `docs/history.md`,
  `docs/release-plan.md`), native desktop shells, and two generated `test/*.mocks.dart` header
  comments. See §3 D-14 and §10.
- No runtime storage identifier changed: the database file is still
  `const String kDatabaseFileName = 'db.sqlite'` and that line is untouched
  (`EXECUTED` read + `git diff --name-only`).
- Android identity is unchanged and correct: `namespace = "com.vittix.wallet"`,
  `applicationId = "com.vittix.wallet"` (`EXECUTED` read).
- The onboarding alias is renamed consistently: `dashboard_screen.dart` imports the screen
  `as guided_onboarding_alias` and uses `guided_onboarding_alias.GuidedOnboardingScreen()`; the
  old `expense_tracker_guided_onboarding` alias is gone (`EXECUTED` grep).
- `pubspec.yaml` version (`1.0.0+1`) and SDK constraint (`^3.12.0`) are unchanged.

### 2.2 P2-16 — removal of four unused dependencies

**Result: PASS (static) with a BLOCKER on the lockfile.**

- `alfred`, `go_router`, `permission_handler` and `flex_color_scheme` are removed from
  `pubspec.yaml` (`EXECUTED` diff).
- No import or symbol reference survives (`EXECUTED` grep for `FlexThemeData`, `FlexColorScheme`,
  `GoRouter`, `GoRoute`, `context.go(`, `Permission.`, `Alfred` — all 0 in `lib/`, `test/`,
  `integration_test/`).
- Remaining constraints are untouched and internally consistent; no version conflict can be
  inferred statically.
- **`pubspec.lock` still lists all four packages.** It is deliberately not hand-edited. This is a
  real blocker: the lockfile must come from a real `flutter pub get` (§6).

### 2.3 P2-17 — CI validation workflow

**Result: PASS (static + logic simulation).**

`.github/workflows/ci.yml` was rewritten during review; the final version has 12 steps:

`checkout` → `set up Flutter (pinned)` → `toolchain versions` → `flutter pub get` →
`lockfile drift` → `build_runner build` → `codegen drift` → `dart format` → `flutter analyze` →
`flutter test` → `summary` → `enforcement gate`.

Verified (`EXECUTED`):

- YAML parses; `env` is `{FLUTTER_VERSION: 3.44.0, REPORT_ONLY: 'true'}`; 12 steps.
- All 10 `run:` blocks pass `bash -n` after substituting `${{ }}` expressions (`ALL_OK`).
- Gate logic, executed as a standalone script against the real gate body:

| Scenario | Expected exit | Actual | Result |
| --- | --- | --- | --- |
| `REPORT_ONLY=true`, one failure | 0 | 0 | OK |
| `REPORT_ONLY=false`, one failure | 1 | 1 | OK |
| `REPORT_ONLY=false`, all pass | 0 | 0 | OK |
| `REPORT_ONLY=false`, a step skipped | 1 | 1 | OK |

Design properties confirmed by reading the file (`STATIC`):

- Flutter is pinned by version, not the floating `stable` channel. **The pinned value is
  provisional** — see §9 R-1.
- Generation runs before analysis, so the analyzer sees freshly generated code.
- Codegen drift uses `git status --porcelain -- '*.g.dart'`, which catches modified, deleted and
  **newly created** files. The previous `git diff --quiet` form missed untracked output.
- Report-only mode is one switch (`REPORT_ONLY`), not scattered `continue-on-error` flags. Steps
  keep `continue-on-error: true` so every check still runs, and the final gate is the only place
  that decides pass/fail.
- The summary maps outcomes to PASS / FAIL / NOT RUN (skipped or cancelled) and prints the active
  mode, so a report-only run cannot look like a green build.
- `permissions: contents: read`; no secrets, no credentials.
- `integration_test/` is excluded and documented as requiring a device/emulator.
- Failure masking is not possible in enforcing mode: the gate treats anything other than
  `success` as a failure.

### 2.4 P2-18 — safe category and account deletion

**Result: PASS (static). Tests NOT RUN.**

Implementation reviewed:

| Symbol | Location | Verdict |
| --- | --- | --- |
| `countTransactionsForCategory` | `category_repository_impl.dart` | Includes the whole subtree via `_subtreeIds`; delegates to `countTransactionsForCategories`. |
| `reassignAndDeleteCategory` | `category_repository_impl.dart` | Rejects source/descendant targets, **and non-existent targets**; moves then deletes inside one `database.transaction`. |
| `_subtreeIds` | `category_repository_impl.dart` | Iterative BFS with a `seen` set, so arbitrary nesting works and a corrupt self-reference cannot loop forever. |
| `deleteCategory` | `category_repository_impl.dart` | Now deletes the subtree explicitly, deepest first (`ids.reversed`), inside a transaction. |
| `reassignAndDeleteAccount` | `account_repository_impl.dart` | Rejects self-target; enforces `canManageAccounts`; rejects a target outside the active wallet (`StateError`); moves + deletes + audit event in one transaction. |
| `showReassignDeleteDialog` | `core/presentation/reassign_delete_dialog.dart` | Generic `T`, returns `null` on cancel; performs no database work. |
| `CategoryScreen._confirmDelete` | `category_screen.dart` | Computes subtree, offers candidates excluding the subtree, discloses cross-wallet effect, reports moved count. |
| `AccountScreen._confirmDelete` | `account_screen.dart` | Offers reassignment, falls back to a message when no other account exists. |

Atomicity and ordering (`STATIC`): both composite operations obtain the transaction from the DAO's
`attachedDatabase` and perform move + delete + audit inside it. Deleting deepest-first keeps the
operation correct if foreign keys are ever enabled.

Symbol/signature verification performed because compilation is impossible (`EXECUTED` grep):

- `TransactionDao` has `reassignTransactionsForCategories`, `countTransactionsForCategories`,
  `reassignTransactionsForAccount`.
- `CategoryDao` has `deleteCategories`, `getAllCategories`, `getCategoryById`.
- `AccountDao` has `getAccountById(int, [int?])`, `deleteAccount(int, [int?])`,
  `countTransactionsForAccount(int, [int?])` — matching the call sites.
- `AccountRepository` and `CategoryRepository` each have exactly one implementation, and no test
  mock implements them, so adding abstract methods cannot break another class.
- `repository_providers.dart` exposes `CategoryRepository` through
  `lib/domain/repositories/category_repository.dart`, which is an `export` of the same features
  interface — the new methods are visible to the screens.
- `AccountScreen` passes `accounts` (a `List<AccountWithBalance>` from
  `StreamBuilder<List<AccountWithBalance>>`) to the new `List<AccountWithBalance> allAccounts`
  parameter; the dialog's optional `subtitleOf`/`warning` match both call sites.
- `Value` and `WalletsCompanion` used by the new test are reachable from its existing imports
  (`drift/native.dart`, `app_database.dart`).

Test coverage added (`STATIC`): seven tests in `test/category_account_reassign_test.dart`, group
`reassign-and-delete`:

1. count includes subcategory transactions;
2. reassign+delete moves the whole subtree and leaves no orphans;
3. invalid target rejected (subtree member **and** non-existent id) with no mutation;
4. `deleteCategory` removes subcategories without foreign keys;
5. account reassign moves history then deletes the account;
6. account self-target rejected with no mutation;
7. cross-wallet target rejected with `StateError` and no mutation.

Cancellation safety: the dialog returns `null` and both screens return before touching the
repository, so cancelling performs no database work (`STATIC`). Empty cases: `deleteCategories`
returns 0 for an empty id list; both screens short-circuit when no candidate exists.

### 2.5 Documentation

**Result: PASS after correction.**

`CHANGELOG.md`, `docs/release-plan.md`, `docs/roadmap.md` and `docs/history.md` now distinguish
implemented changes from static review results, tests written vs. executed, environment blockers,
and deferred schema work. Inaccuracies found and fixed are listed in §3 (D-11, D-12, D-13).

---

## 3. Defects found and fixes applied

| ID | Defect | Severity | Fix |
| --- | --- | --- | --- |
| D-01 | CI used the floating `stable` channel, so dependency resolution and Drift output were not reproducible. | High | Pinned `FLUTTER_VERSION` in `ci.yml`; documented how to correct it against `.metadata`. |
| D-02 | Codegen drift check used `git diff --quiet -- '*.g.dart'` and silently ignored **newly generated** files. | High | Replaced with `git status --porcelain -- '*.g.dart'`. |
| D-03 | Code generation ran *after* analysis, so the analyzer validated stale generated code. | High | Reordered: generate, then drift-check, then format/analyze/test. |
| D-04 | `continue-on-error` was applied per step with no aggregation, so failures could pass unnoticed and later steps ran misleadingly. | High | Single `REPORT_ONLY` switch + final "Enforcement gate" that fails on any non-`success` outcome. |
| D-05 | Job summary could not distinguish PASS, FAIL and NOT RUN. | Medium | Added `status()` mapping and a mode banner. |
| D-06 | No formatting check, so drift in formatting was invisible. | Medium | Added `dart format --output=none --set-exit-if-changed .` (report-only). |
| D-07 | No lockfile drift check, so a stale `pubspec.lock` could pass. | Medium | Added a lockfile drift step. |
| D-08 | Workflow had no explicit permissions block. | Low | Added `permissions: contents: read`. |
| D-09 | `reassignAndDeleteCategory` accepted a non-existent target id, which would move every transaction onto a missing category and orphan the history. | High | Added existence guard (`ArgumentError`) and extended the invalid-target test to cover it. |
| D-10 | The category delete dialog did not disclose that categories are shared across wallets, so a delete moves transactions in every wallet. | Medium | Dialog now states this explicitly. |
| D-11 | `CHANGELOG.md` claimed CI resolves dependencies from `pubspec.yaml` and implied the stale lockfile was harmless. | Medium | Corrected; the stale lockfile is declared a blocker. |
| D-12 | `CHANGELOG.md`/`release-plan.md` described validation as if performed. | Medium | Rewritten to separate static results from unexecuted checks. |
| D-13 | `docs/roadmap.md` presented "0 analyzer issues / 444 passing" as a current fact. | Medium | Clarified as a historical baseline. |
| D-14 | Native desktop artefacts still use `expense_tracker`, and Linux declares `APPLICATION_ID "com.example.expense_tracker"`. | Low (out of scope) | Documented as deferred; not renamed without the relevant toolchains. |
| D-15 | `budget_list_item.dart` was the only Dart file committed with CRLF, making the four renamed imports show as trailing whitespace and guaranteeing a format-gate failure on Linux. | High | Normalised to LF (BOM status preserved as absent). Whole-file diff in commit 1. |
| D-16 | `docs/history.md` ended with a stray blank line (`git diff --check` failure). | Low | Trimmed to a single trailing newline. |
| D-17 | Missing Flutter/Dart/Android setup documentation. | Medium | Added `docs/development/DEVELOPMENT_ENVIRONMENT.md`. |

After the fixes, `git diff --check` is clean (`EXECUTED`).

---

## 4. Test inventory

| Item | Count | Status |
| --- | --- | --- |
| Historical baseline (from `docs/roadmap.md`, not re-verified) | 444 | Historical claim |
| New tests added by P2-18 | 7 | Written, `NOT RUN` |
| **Expected total** | **451** | **`NOT RUN`** |

Actual execution: **zero tests were run.** There is no Flutter or Dart SDK on this machine, so
`flutter test` could not be invoked. Nothing in this change set may be described as passing until a
CI run or a local `flutter test` is recorded. The seven new tests use in-memory Drift databases and
assert on transaction/category/account row counts, which is the right shape for the behaviour, but
that is a static judgement, not evidence of execution.

---

## 5. Flutter / Dart environment status

`EXECUTED` probes on 2026-11-10:

| Tool | Result |
| --- | --- |
| Git | `2.56.0.windows.4` (available) |
| Flutter | NOT FOUND |
| Dart | NOT FOUND |
| `java` / `javac` | NOT FOUND |
| `adb` / `sdkmanager` / `avdmanager` / `emulator` | NOT FOUND |
| Gradle (standalone) | NOT FOUND (wrapper present in repo) |

| Variable | Value |
| --- | --- |
| `JAVA_HOME` | unset |
| `ANDROID_HOME` | unset |
| `ANDROID_SDK_ROOT` | unset |
| `FLUTTER_ROOT` | unset |
| `PUB_CACHE` | unset |
| `GRADLE_USER_HOME` | unset |

`PATH` contains no Flutter, Dart, Android, Java or Gradle entry. **Runtime validation is
BLOCKED BY ENVIRONMENT.** Setup instructions, including the JDK 17 choice derived from the
repository's Gradle 9.1.0 / AGP 9.0.1 / `VERSION_17` / `jvmTarget = JVM_17` / `compileSdk = 36`,
are in `docs/development/DEVELOPMENT_ENVIRONMENT.md`. No software was installed and no
machine-wide setting was changed.

---

## 6. Lockfile status

**Stale and deliberately untouched.** `pubspec.lock` still contains `alfred`, `go_router`,
`permission_handler` and `flex_color_scheme` entries. It was not hand-edited and no resolution was
fabricated. Consequences:

- Commit 2 is **incomplete** until a real `flutter pub get` regenerates the lockfile on a machine
  with the pinned SDK.
- The new CI "Lockfile drift" step will report a change on the first run, which is the intended
  behaviour and is visible in the report-only summary.
- Until the lockfile is regenerated, a local `flutter pub get` may resolve transitive versions
  differently from the committed lockfile.

---

## 7. CI workflow review summary

| Step | Purpose | Report-only? | Notes |
| --- | --- | --- | --- |
| Set up Flutter | Pinned SDK | n/a | `subosito/flutter-action@v2`, `flutter-version` + `channel: stable` |
| Toolchain versions | Records actual SDK | Yes | `flutter --version`, `dart --version` |
| Install dependencies | Resolves packages | Yes | `flutter pub get` |
| Lockfile drift | Detects stale lockfile | Yes | Fails if `pubspec.lock` changes |
| Generate Drift code | Fresh generated code | Yes | `build_runner build --delete-conflicting-outputs` |
| Codegen drift | Detects modified/deleted/untracked `*.g.dart` | Yes | `git status --porcelain` |
| Format | Style gate | Yes | `dart format --set-exit-if-changed` |
| Analyze | Static analysis | Yes | `flutter analyze --no-fatal-infos` |
| Test | Unit + widget | Yes | `flutter test --reporter expanded` |
| Summary | PASS/FAIL/NOT RUN table | Always | Written to `$GITHUB_STEP_SUMMARY` |
| Enforcement gate | Decides job result | Always | Only switch is `REPORT_ONLY` |

`NOT RUN in this environment`: the workflow has never executed on GitHub Actions. It is validated
only by YAML parsing, `bash -n`, and gate simulation.

Integration tests (`integration_test/`) are excluded from CI and documented as requiring a device
or emulator.

---

## 8. Four proposed commit boundaries

Messages are fixed by the task. Commit 1 had to be complete enough to compile on
its own, which is why **seven files are split at hunk level**.

**Execution note (2026-11-10).** Commits were created in the order 1 → 3 → 4,
with commit 2 held because the lockfile cannot be regenerated without a Flutter
SDK. Commit 2 is therefore appended **last**, after `flutter pub get` produces
the lockfile. Created in this session:

- `22a2a84` — commit 1: 273 files (263 whole Dart + import-only hunks of the 7
  split files + `README.md` + `pubspec.yaml` `name:` hunk + CHANGELOG P2-15).
- `9cb39d3` — commit 3: 11 files (2 DAO files, the new dialog, the logic hunks
  of the 7 split files, CHANGELOG P2-18).
- commit 4 — this document and the CI/docs set.

Every staged set was verified with `git diff --cached` and
`git diff --cached --check` (clean) before committing; no `git add .`, no
amend, no history rewrite.

### Commit 1 — `refactor: rename package to vittix_wallet`

Content: every rename-only change, so the tree still compiles with no new API in use.

- **Whole files (263 `.dart` files):**

```
integration_test/backup_cipher_test.dart
integration_test/backup_smoke_test.dart
lib/calendar/subscription_calendar_screen.dart
lib/core/database/app_database.dart
lib/core/database/database_encryption.dart
lib/core/database/database_provider.dart
lib/core/database/default_categories.dart
lib/core/domain/attention_needed_widget.dart
lib/core/domain/bill_dashboard_widget.dart
lib/core/domain/forecast_history_widget.dart
lib/core/presentation/app_drawer.dart
lib/core/presentation/main_screen.dart
lib/core/providers/database_provider.dart
lib/core/providers/notification_provider.dart
lib/core/providers/repository_providers.dart
lib/core/providers/usecase_providers.dart
lib/core/services/auto_backup.dart
lib/core/services/backup_service.dart
lib/core/services/database_recovery_service.dart
lib/core/services/notification_service.dart
lib/core/utils/csv_exporter.dart
lib/core/utils/csv_importer.dart
lib/core/utils/duplicate_detector.dart
lib/data/local/app_database.dart
lib/data/local/mappers/budget_mapper.dart
lib/data/local/mappers/category_mapper.dart
lib/data/local/mappers/transaction_mapper.dart
lib/data/repositories/budget_repository_impl.dart
lib/data/repositories/category_repository_impl.dart
lib/data/repositories/recurring_transaction_repository_impl.dart
lib/data/repositories/transaction_repository_impl.dart
lib/domain/entities/account.dart
lib/domain/entities/budget.dart
lib/domain/entities/category.dart
lib/domain/entities/monthly_report.dart
lib/domain/entities/recurring_transaction.dart
lib/domain/entities/transaction.dart
lib/domain/entities/trend_data_point.dart
lib/domain/repositories/budget_repository.dart
lib/domain/repositories/category_repository.dart
lib/domain/repositories/recurring_transaction_repository.dart
lib/domain/repositories/transaction_repository.dart
lib/domain/usecases/budget/add_budget.dart
lib/domain/usecases/budget/check_budget_thresholds.dart
lib/domain/usecases/budget/delete_budget.dart
lib/domain/usecases/budget/get_budget_status.dart
lib/domain/usecases/budget/update_budget.dart
lib/domain/usecases/category/add_category.dart
lib/domain/usecases/category/delete_category.dart
lib/domain/usecases/category/update_category.dart
lib/domain/usecases/category/watch_all_categories.dart
lib/domain/usecases/recurring/add_recurring.dart
lib/domain/usecases/recurring/delete_recurring.dart
lib/domain/usecases/recurring/process_recurring_transactions.dart
lib/domain/usecases/recurring/watch_all_recurring.dart
lib/domain/usecases/summary/get_monthly_summary.dart
lib/domain/usecases/summary/get_trend_report.dart
lib/domain/usecases/transaction/add_transaction.dart
lib/domain/usecases/transaction/delete_transaction.dart
lib/domain/usecases/transaction/update_transaction.dart
lib/domain/usecases/transaction/watch_recent_transactions.dart
lib/features/accounts/data/account_mapper.dart
lib/features/accounts/data/tables/accounts_table.dart
lib/features/accounts/domain/account.dart
lib/features/accounts/domain/default_accounts.dart
lib/features/accounts/domain/usecases/add_account.dart
lib/features/accounts/domain/usecases/delete_account.dart
lib/features/accounts/domain/usecases/update_account.dart
lib/features/accounts/domain/usecases/watch_accounts_with_balance.dart
lib/features/accounts/domain/usecases/watch_all_accounts.dart
lib/features/accounts/presentation/account_form_dialog.dart
lib/features/accounts/presentation/account_report_screen.dart
lib/features/accounts/presentation/accounts_overview_widget.dart
lib/features/bills/data/bill_repository_impl.dart
lib/features/bills/data/tables/bills_table.dart
lib/features/budgets/data/budget_mapper.dart
lib/features/budgets/data/budget_repository.dart
lib/features/budgets/data/budget_repository_impl.dart
lib/features/budgets/data/tables/budgets_table.dart
lib/features/budgets/domain/budget.dart
lib/features/budgets/domain/usecases/add_budget.dart
lib/features/budgets/domain/usecases/check_budget_thresholds.dart
lib/features/budgets/domain/usecases/delete_budget.dart
lib/features/budgets/domain/usecases/get_budget_status.dart
lib/features/budgets/domain/usecases/update_budget.dart
lib/features/budgets/presentation/budget_activity_detail_screen.dart
lib/features/budgets/presentation/budget_form_dialog.dart
lib/features/budgets/presentation/budget_list_item.dart
lib/features/budgets/presentation/budget_overview_widget.dart
lib/features/budgets/presentation/budget_screen.dart
lib/features/budgets/presentation/shared_budgets_screen.dart
lib/features/categories/data/category_mapper.dart
lib/features/categories/domain/usecases/add_category.dart
lib/features/categories/domain/usecases/delete_category.dart
lib/features/categories/domain/usecases/update_category.dart
lib/features/categories/domain/usecases/watch_all_categories.dart
lib/features/categories/presentation/category_form_dialog.dart
lib/features/categories/presentation/category_report_screen.dart
lib/features/dashboard/data/tables/notifications_table.dart
lib/features/dashboard/data/tables/wallet_activities_table.dart
lib/features/dashboard/presentation/dashboard_header.dart
lib/features/dashboard/presentation/dashboard_providers.dart
lib/features/dashboard/presentation/dashboard_screen.dart
lib/features/debts/data/debts_dao.dart
lib/features/debts/data/tables/loans_table.dart
lib/features/debts/data/tables/peer_debts_table.dart
lib/features/debts/presentation/debts_loans_screen.dart
lib/features/debts/presentation/debts_overview_widget.dart
lib/features/debts/presentation/settlement_entry_screen.dart
lib/features/debts/presentation/settlement_history_screen.dart
lib/features/debts/presentation/split_expense_screen.dart
lib/features/family/data/allowance_repository_impl.dart
lib/features/family/data/family_automation_service.dart
lib/features/family/data/family_settlement_service.dart
lib/features/family/data/tables/allowance_payments_table.dart
lib/features/family/data/tables/allowances_table.dart
lib/features/family/data/tables/settlements_table.dart
lib/features/family/data/tables/wallet_invitations_table.dart
lib/features/family/data/tables/wallet_members_table.dart
lib/features/family/data/wallet_invitation_repository.dart
lib/features/family/data/wallet_invitation_service.dart
lib/features/family/domain/family_automation_dashboard.dart
lib/features/family/domain/wallet_activity_feed.dart
lib/features/family/domain/wallet_permissions.dart
lib/features/family/presentation/allowance_detail_screen.dart
lib/features/family/presentation/allowance_management_screen.dart
lib/features/family/presentation/family_commitments_screen.dart
lib/features/family/presentation/family_financial_summary_widget.dart
lib/features/family/presentation/family_goal_summary_widget.dart
lib/features/family/presentation/member_balances_widget.dart
lib/features/family/presentation/wallet_goals_screen.dart
lib/features/family/presentation/wallet_invitation_screen.dart
lib/features/family/presentation/wallet_member_summary_widget.dart
lib/features/family/presentation/wallet_members_screen.dart
lib/features/goals/data/goal_repository_impl.dart
lib/features/goals/data/tables/goal_contributions_table.dart
lib/features/goals/data/tables/goal_schedules_table.dart
lib/features/goals/data/tables/goals_table.dart
lib/features/notifications/data/notification_center_service.dart
lib/features/notifications/data/notification_provider.dart
lib/features/notifications/data/notification_service.dart
lib/features/recurring/data/recurring_transaction_mapper.dart
lib/features/recurring/data/recurring_transaction_repository.dart
lib/features/recurring/data/recurring_transaction_repository_impl.dart
lib/features/recurring/domain/recurring_transaction.dart
lib/features/recurring/domain/usecases/add_recurring.dart
lib/features/recurring/domain/usecases/delete_recurring.dart
lib/features/recurring/domain/usecases/process_recurring_transactions.dart
lib/features/recurring/domain/usecases/watch_all_recurring.dart
lib/features/recurring/presentation/add_recurring_transaction_screen.dart
lib/features/recurring/presentation/recurring_transactions_screen.dart
lib/features/reports/domain/monthly_report.dart
lib/features/reports/domain/usecases/get_monthly_summary.dart
lib/features/reports/domain/usecases/get_trend_report.dart
lib/features/reports/presentation/reports_screen.dart
lib/features/reports/presentation/spending_heatmap_screen.dart
lib/features/reports/presentation/spending_insights_summary_widget.dart
lib/features/reports/presentation/spending_insights_widget.dart
lib/features/reports/presentation/spending_pie_chart.dart
lib/features/reports/presentation/spending_streak_widget.dart
lib/features/reports/presentation/trend_report_screen.dart
lib/features/security/data/pin_attempt_limiter.dart
lib/features/security/data/pin_hasher.dart
lib/features/security/presentation/app_lock_wrapper.dart
lib/features/security/presentation/database_recovery_screen.dart
lib/features/security/presentation/lock_screen.dart
lib/features/security/presentation/security_providers.dart
lib/features/settings/data/tables/feedback_table.dart
lib/features/settings/data/tables/notification_preferences_table.dart
lib/features/settings/presentation/auto_backup_screen.dart
lib/features/settings/presentation/beta_metrics_widget.dart
lib/features/settings/presentation/beta_observation_dashboard_screen.dart
lib/features/settings/presentation/guided_onboarding_screen.dart
lib/features/settings/presentation/settings_providers.dart
lib/features/settings/presentation/settings_screen.dart
lib/features/sync/data/sync_service.dart
lib/features/transactions/data/tables/attachments_table.dart
lib/features/transactions/data/tables/expense_split_members_table.dart
lib/features/transactions/data/tables/expense_splits_table.dart
lib/features/transactions/data/tables/merchant_mappings_table.dart
lib/features/transactions/data/tables/payees_table.dart
lib/features/transactions/data/tables/recurring_transactions_table.dart
lib/features/transactions/data/tables/sms_import_metrics_table.dart
lib/features/transactions/data/tables/tags_table.dart
lib/features/transactions/data/tables/transactions_table.dart
lib/features/transactions/data/tables/unrecognized_sms_table.dart
lib/features/transactions/data/transaction_mapper.dart
lib/features/transactions/data/transaction_repository_impl.dart
lib/features/transactions/domain/transaction.dart
lib/features/transactions/domain/transaction_repository.dart
lib/features/transactions/domain/usecases/add_transaction.dart
lib/features/transactions/domain/usecases/add_transfer.dart
lib/features/transactions/domain/usecases/delete_transaction.dart
lib/features/transactions/domain/usecases/update_transaction.dart
lib/features/transactions/domain/usecases/watch_recent_transactions.dart
lib/features/transactions/presentation/add_transaction_screen.dart
lib/features/transactions/presentation/quick_add_widget.dart
lib/features/transactions/presentation/recent_transactions_list.dart
lib/features/transactions/presentation/transaction_list_item.dart
lib/features/transactions/presentation/transaction_list_screen.dart
lib/features/transactions/presentation/transfer_form_screen.dart
lib/features/users/presentation/user_providers.dart
lib/llm/llm_service.dart
lib/main.dart
lib/pdf/parsers/gpay_pdf_parser.dart
lib/pdf/parsers/pdf_statement_parser.dart
lib/pdf/parsers/phonepe_pdf_parser.dart
lib/pdf/pdf_import_screen.dart
lib/pdf/pdf_transaction_candidate.dart
lib/presentation/screens/dashboard/customize_dashboard_screen.dart
lib/receipt/receipt_scanner_screen.dart
lib/shared/theme/colors.dart
lib/shared/theme/typography.dart
lib/sms/data/sms_import_metrics_dao.dart
lib/sms/data/sms_parsing_dao.dart
lib/sms/merchant_mappings_screen.dart
lib/sms/parsers/bank_sms_parser.dart
lib/sms/parsers/hdfc_bank_parser.dart
lib/sms/parsers/icici_bank_parser.dart
lib/sms/parsers/sbi_bank_parser.dart
lib/sms/sms_import_screen.dart
lib/sms/sms_transaction_parser.dart
lib/sms/unrecognized_sms_screen.dart
test/account_wallet_isolation_test.dart
test/active_wallet_validation_test.dart
test/activity_audit_trail_test.dart
test/audit_actor_identity_test.dart
test/audit_event_wiring_test.dart
test/backup_restore_test.dart
test/budget_rollover_test.dart
test/budget_rollover_test.mocks.dart
test/budget_wallet_isolation_test.dart
test/cloud_sync_test.dart
test/csv_amount_parse_test.dart
test/csv_export_test.dart
test/database_encryption_test.dart
test/debts_loans_test.dart
test/deferred_domains_wallet_isolation_test.dart
test/duplicate_detector_test.dart
test/get_monthly_summary_test.dart
test/get_monthly_summary_test.mocks.dart
test/money_migration_test.dart
test/money_test.dart
test/month_boundary_test.dart
test/peer_debt_migration_test.dart
test/pin_hashing_test.dart
test/recurring_transaction_wallet_isolation_test.dart
test/sms_wallet_isolation_test.dart
test/splits_settlements_wallet_isolation_test.dart
test/sync_deletion_wallet_isolation_test.dart
test/sync_merge_test.dart
test/sync_security_test.dart
test/sync_wallet_rbac_test.dart
test/transaction_dao_test.dart
test/transaction_wallet_isolation_test.dart
test/transfer_atomicity_test.dart
test/user_dao_test.dart
test/user_provider_test.dart
test/wallet_actor_identity_test.dart
test/wallet_deletion_test.dart
test/wallet_invitation_security_test.dart
test/wallet_last_owner_test.dart
test/wallet_rbac_test.dart
```

- **`README.md`** — package name line only.
- **`pubspec.yaml`** — the `name:` hunk only.
- **`CHANGELOG.md`** — the P2-15 section only.
- **Seven split files** — take *only* the import-path hunks:

| File | Commit 1 takes | Commit 3 takes |
| --- | --- | --- |
| `lib/features/accounts/data/account_repository_impl.dart` | `@@ -1,7 +1,7 @@` (4 import swaps) | `@@ -85,6 +85,48 @@` (method) |
| `lib/features/accounts/domain/account_repository.dart` | `@@ -1,4 +1,4 @@` (1 import swap) | `@@ -8,4 +8,12 @@` (interface method) |
| `lib/features/accounts/presentation/account_screen.dart` | `@@ -1,9 +1,10 @@` **minus** the new `reassign_delete_dialog` import (6 swaps only) | the new import + `@@ -36…`, `@@ -44…`, `@@ -155…` |
| `lib/features/categories/data/category_repository.dart` | `@@ -1,4 +1,4 @@` (1 import swap) | `@@ -6,4 +6,16 @@` (interface methods) |
| `lib/features/categories/data/category_repository_impl.dart` | `@@ -1,7 +1,7 @@` (4 import swaps) | `@@ -16,8 +16,90 @@` (impl) |
| `lib/features/categories/presentation/category_screen.dart` | `@@ -1,7 +1,9 @@` **minus** the new `repository_providers` and `reassign_delete_dialog` imports (4 swaps only) | the 2 new imports + `@@ -30…`, `@@ -168…` |
| `test/category_account_reassign_test.dart` | `@@ -1,7 +1,9 @@` **minus** the 2 new impl imports (2 swaps only) | the 2 new imports + `@@ -114,4 +116,120 @@` |

`lib/features/dashboard/presentation/dashboard_screen.dart` is **whole-file in commit 1**: its only
non-import change is the onboarding alias rename, which belongs to this commit.

Staging method: `git add` the 263 whole files explicitly, then `git add -p` (with manual hunk
editing where a new import shares a hunk with renamed imports) for the seven split files, then
`git add -p` for `pubspec.yaml`, `README.md` and `CHANGELOG.md`.

### Commit 2 — `chore: remove unused dependencies`

- `pubspec.yaml` — the four removed dependency lines only.
- `CHANGELOG.md` — the P2-16 section only.
- **`pubspec.lock` — OMITTED (BLOCKED).** Do not hand-edit it and do not fabricate a resolution.

Commit 2 is therefore incomplete. It should not be declared final until `flutter pub get` runs and
the regenerated lockfile is added.

### Commit 3 — `fix: implement safe category and account deletion`

- **Whole files:** `lib/core/database/daos/category_dao.dart`,
  `lib/core/database/daos/transaction_dao.dart` (both contain only additions; no import changes,
  so neither needs splitting).
- **New file:** `lib/core/presentation/reassign_delete_dialog.dart`.
- **Logic hunks** of the seven split files listed in commit 1, including the new imports that only
  the new code needs.
- `CHANGELOG.md` — the P2-18 section only.

Staging note: with commit 2 held, the index for commit 3 contains the CHANGELOG
sections **P2-15 and P2-18 only** (P2-16 and P2-17 are still absent). Commit 4
inserts P2-17 between them; the deferred commit 2 later inserts P2-16 between
P2-15 and P2-17, restoring the intended final file order.

### Commit 4 — `ci: add Flutter validation workflow`

- `.github/workflows/ci.yml` (new).
- `docs/release-plan.md` (new).
- `docs/development/DEVELOPMENT_ENVIRONMENT.md` (new).
- `docs/audits/VW_P2_CHANGESET_REVIEW.md` (this report, new).
- `docs/roadmap.md` (whole file).
- `docs/history.md` (whole file — one combined P2-15…P2-18 section).
- `CHANGELOG.md` — the P2-17 section only.

### Verification before each commit

1. `git diff --cached --stat` and `git diff --cached -- <file>` for every staged path.
2. Confirm no file is staged twice in different commits unintentionally.
3. Confirm commit 1 has no reference to symbols/imports introduced in commit 3.
4. `git diff --check` clean.
5. No `git add .`, no `--amend`, no destructive commands, no push.

---

## 9. Remaining risks

| ID | Risk | Impact | Mitigation |
| --- | --- | --- | --- |
| R-1 | `FLUTTER_VERSION: "3.44.0"` is provisional. `.metadata` pins revision `559ffa3f75e7402d65a8def9c28389a9b2e6fe42` but not a marketing version. | CI may install the wrong SDK, changing Drift output and dependency resolution. | On a provisioned machine check out the exact revision, read `flutter --version`, and replace the value. Keep CI report-only until then. |
| R-2 | `pubspec.lock` is stale (four removed packages). | Commit 2 incomplete; first CI run reports lockfile drift. | Regenerate with a real `flutter pub get` and commit the result. |
| R-3 | `dart format` was never run. Several new lines exceed 80 columns (e.g. `Future<int> reassignAndDeleteCategory(int fromCategoryId, int toCategoryId) async {`). | The new format gate will very likely fail on the first run. | Run `dart format` locally or accept the first report-only run and fix. |
| R-4 | Analyzer was never run. Static signature checks passed but type inference in the large screen hunks (`accounts`, `candidates`, generic `T`) is unverified. | Possible compile error. | Run `flutter analyze` before enforcing CI. |
| R-5 | The 451-test suite was never executed, including the seven new tests. | Regressions in subtree deletion would go unnoticed. | Run `flutter test` and record the count. |
| R-6 | Category deletion is global across wallets (`categories` has no `walletId`). | Deleting a category moves transactions in every wallet. | Disclosed in the dialog; schema fix deferred (§10). |
| R-7 | `PRAGMA foreign_keys` is never enabled, so integrity depends on application code. | A future code path that deletes without the subtree helper would orphan rows. | Subtree deletion is explicit and tested; enabling FKs is a separate migration. |
| R-8 | Desktop shell artefacts still say `expense_tracker`; Linux still declares `com.example.expense_tracker`. | Cosmetic/identity inconsistency on desktop builds. | Documented; deferred until those toolchains exist. |
| R-9 | `pubspec.yaml` requires `sdk: ^3.12.0`; the actual Dart version bundled with the pinned Flutter is unknown. | `pub get` fails if the SDK is older. | Confirm with `flutter --version` before enforcing CI. |
| R-10 | Drift codegen was not re-run; DAO methods are hand-written and require no new generated code, but `build_runner` may still rewrite `.g.dart`. | First CI codegen-drift step may report changes. | Expected; review and commit genuine generated output with the schema change that causes it. |

---

## 10. Deferred architecture / schema tasks

Explicitly **not** done in this change set:

1. **Wallet-scoped categories.** `Categories` has no `walletId`; making it wallet-scoped requires a
   schema migration and data backfill. Tracked in `docs/release-plan.md`.
2. **Enable SQLite foreign keys.** Requires a migration plus an orphan-data audit; the subtree
   helpers are written so they stay correct if FKs are later enabled.
3. **Rename desktop shell artefacts** (Windows `CMakeLists.txt`/`main.cpp`/`Runner.rc`, Linux
   `CMakeLists.txt`/`my_application.cc`, macOS `AppInfo.xcconfig`/pbxproj/schemes) and fix the
   Linux `com.example.expense_tracker` `APPLICATION_ID`. Needs those toolchains.
4. **Regenerate the two generated `test/*.mocks.dart` header comments** that still mention
   `expense_tracker` (they are build output).
5. **`tools/generate_brand_assets.py`** still hardcodes an absolute `D:\ketan\...\expense_tracker`
   path.
6. **CI enforcement flip.** Set `REPORT_ONLY` to `"false"` once R-1…R-5 are resolved.
7. Out of scope by instruction: `performSync` refactor, portable backup, financial calculations,
   encryption behaviour, database schema changes, removal of `lib/data/**` and `lib/domain/**`
   re-export shims.

---

## 11. Exact next actions for the developer

1. Install the toolchain per `docs/development/DEVELOPMENT_ENVIRONMENT.md` (needs approval; no
   software was installed here).
2. Check out Flutter at revision `559ffa3f75e7402d65a8def9c28389a9b2e6fe42`, run
   `flutter --version`, and replace the provisional `FLUTTER_VERSION` in
   `.github/workflows/ci.yml`.
3. Run `flutter pub get` and commit the regenerated `pubspec.lock` into the dependency-cleanup
   commit. Do not edit it by hand.
4. Run `dart run build_runner build --delete-conflicting-outputs` and review `git status --short`
   for `*.g.dart` changes.
5. Run `dart format --output=none --set-exit-if-changed .`; if it rewrites files, commit the
   formatting separately or fold it into the relevant commit.
6. Run `flutter analyze` and fix any real error in the P2-18 hunks (not unrelated baseline issues).
7. Run `flutter test` and confirm **451** tests, recording the exact command and result.
8. Build the Android debug APK to validate the toolchain.
9. Commit 2 was deliberately deferred. After `flutter pub get` regenerates
   `pubspec.lock`, stage the four removed dependency lines and the CHANGELOG
   P2-16 section, verify the staged diff, and create
   `chore: remove unused dependencies` as the final commit. Push only with
   separate approval.
10. Flip `REPORT_ONLY` to `"false"` after the first green run and update `docs/release-plan.md`.

Until steps 2–7 are done, this change set must be reported as **PASS WITH BLOCKERS**, never as
validated or released.
