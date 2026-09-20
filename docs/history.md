# History

## Current product shape

This app started as a single-user expense tracker with:

- local transactions, categories, budgets, accounts, recurring transactions
- Drift/SQLite persistence
- dashboard summaries and trend reporting
- security features such as PIN lock and biometrics
- sync scaffolding

## Recent direction changes

The workstream has shifted toward:

- reducing startup cost
- adding SMS-based transaction import on Android
- preparing the data model for collaboration
- preserving local-first behavior

## Wallet scoping milestone

The current architecture now includes:

- a default Personal Wallet
- wallet and wallet-member schema foundation
- wallet-scoped transactions, budgets, accounts, recurring transactions, loans, and peer debts
- a current wallet context backed by local preferences
- a wallet selector foundation in settings
- wallet-isolation tests for core transaction and budget flows
- migration validation coverage for wallet-owned table defaults

## Collaboration foundation milestone

The collaboration foundation now includes:

- wallet member roles for owner, admin, member, and viewer
- transaction audit fields for created-by and updated-by attribution
- a wallet activity table and DAO for member/activity history
- repository logging for transaction create and update events
- member management UI for listing, role editing, and removal
- wallet activity feed surfaced in the dashboard shell
- characterization tests for member lookup, transaction ownership, and activity feed generation

## Invitation preparation milestone

The invite-ready collaboration layer now includes:

- wallet invitation schema and lifecycle states for pending, accepted, revoked, and expired
- invitation repository scaffolding without transport or cloud dependencies
- local invitation exchange codes and QR export
- invitation acceptance flow that creates wallet membership locally
- activity hooks for member changes, budget changes, and wallet rename events
- permission checks centralized behind a collaboration permission service
- member contribution summaries on the dashboard
- prominent active-wallet indicator in the dashboard shell

## Architectural intent

The current direction is not to replace the app with a server-first product. The intent is:

- keep local data working
- layer collaboration on top
- allow one user, family users, and small-team users to share the same core model
- enforce wallet boundaries as the primary isolation layer

## Collaboration hardening milestone

This pass tightened the collaboration baseline before invite transport or cloud sync:

- wallet-aware screens were audited for switching behavior and active-wallet visibility
- wallet isolation tests were expanded for activity feeds, member summaries, invitations, and collaboration reads
- role permissions were exercised for invalid operations across viewer, member, admin, and owner
- historical migrations from v4 through v8 were validated against the current schema
- write-path attribution coverage was checked for walletId, createdBy, and updatedBy fields
- analyzer warnings remain, but the core collaboration flow is still behaviorally stable

## Shared family wallet features milestone

## Children allowance milestone

The allowance layer now adds:

- wallet-native allowance rows for member-specific weekly, monthly, and custom schedules
- allowance payment tracking with local payment history
- wallet activity events for allowance create, update, suspend, resume, and payment actions
- allowance management and allowance detail screens in the settings flow
- allowance summary providers for dashboard and child spending views
- characterization tests for allowance CRUD, payment recording, summaries, permissions, and activity logging

## Family commitments milestone

The commitment layer now adds:

- recurring goal contribution schedules tied to wallet goals
- wallet bills for local bill tracking and payment status
- wallet activity events for schedule and bill lifecycle changes
- family commitment dashboard summaries for goals, contributions, upcoming bills, and overdue bills
- commitment management surfaces in the settings flow
- characterization tests for schedules, bill CRUD, bill summaries, permissions, and activity logging

## Family automation milestone

The local automation layer now adds:

- a wallet-scoped recurrence service for allowances, goal schedules, and bills
- forecast providers for goal completion, allowance timing, bill status, and cashflow projection
- a family automation dashboard surface for future commitments
- characterization tests for recurrence calculations and projection summaries

## Expense splitting milestone

The collaboration layer now adds:

- wallet-native expense splits for equal, percentage, and fixed-amount sharing
- wallet settlements between members with local balance adjustment support
- member balance calculations derived from split and settlement state
- balance and settlement views in the settings flow
- characterization tests for split math, settlement math, permissions, and balance calculation

## Split expense management milestone

The split workflow now has:

- a split expense screen for creating, editing, and deleting wallet-native splits
- a split detail view for participants, amounts owed, settled amounts, and activity history
- a settlement entry screen for recording local settlements
- settlement history surfaced from the wallet activity layer
- audit hooks for split and settlement create/update/delete actions
- characterization tests for split UI visibility and settlement entry access

## Shared notifications and action center milestone

The local notification layer now adds:

- wallet-scoped notifications for bill, goal, allowance, settlement, invitation, and activity events
- a notification preference table for wallet-level reminder toggles
- a local notification generation service for in-process reminder rules
- an action center screen with unread, upcoming, and dismissed sections
- an attention-needed dashboard widget for overdue and pending work
- characterization tests for notification generation, dismissal, and action-center rendering

## Quality and intelligence milestone

The current quality pass strengthens the local-first platform with:

- forecast history and trend providers derived from existing local forecast data
- an attention widget plus spending insight summaries for more actionable dashboards
- richer SMS parsing heuristics with merchant extraction, duplicate detection, category hints, and confidence scoring
- test coverage for forecast history, SMS parsing, and notification surfaces

## Production readiness and v1 release milestone

The release hardening pass now focuses on stabilization instead of new domains:

- end-to-end workflow coverage for wallet creation, invitations, budgets, goals, allowances, bills, splits, settlements, and notifications
- a release checklist covering testing, migration validation, backups, and Android/SMS permission review
- documentation of the forecast persistence tradeoff, keeping forecast history derived for now
- incremental analyzer cleanup in touched files while the broader warning backlog remains tracked

This milestone added the first wallet-native family finance features without introducing cloud or server dependencies:

- wallet-level budgets remain isolated and now log create, update, and delete activity
- wallet goals were added with local contributions and progress tracking
- dashboard summaries now surface family budget and family financial aggregates from wallet-scoped data
- goal and budget permissions were extended for owner, admin, member, and viewer behavior
- widget coverage now reflects the shared budget and shared goal experience

## Public beta stabilization milestone

The public beta pass is now focused on user feedback and friction reduction:

- a local feedback entry table now captures bug reports, improvement ideas, and SMS parsing issues
- feedback is wallet-scoped and stored entirely on-device
- SMS import now records accepted, rejected, and duplicate metrics per wallet
- the feedback screen surfaces SMS quality metrics and recent feedback history
- the settings flow links to the beta feedback screen
- analyzer cleanup is still incremental; older warnings remain but no new cloud or server dependency was added
- the release checklist now exists for migration validation, Android permissions, backup review, and SMS review

## Real user beta validation milestone

The beta validation pass is now making local usage visible:

- a beta metrics dashboard summarizes wallet creations, invite acceptances, SMS imports, budgets, goals, splits, and settlements
- local friction signals are captured for abandoned invite flows, abandoned SMS imports, and failed split or settlement creation paths
- feedback is now categorized for bug, UX issue, feature request, and SMS accuracy review
- SMS accuracy reporting now shows accepted, rejected, duplicate, and confidence-oriented quality signals
- the dashboard now surfaces the beta metrics summary alongside the existing local-first widgets
- the current focus is measuring real usage before any new architectural investment

## Beta feedback triage and UX refinement milestone

This pass is using beta data to sharpen the local UX without adding new domains:

- feedback review now groups bug, UX issue, feature request, and SMS accuracy reports into a wallet-scoped dashboard summary
- workflow friction is tracked from existing local signals for invites, SMS imports, splits, and settlements
- the dashboard now exposes recent feedback trends so the highest-friction workflows are easier to spot
- the dashboard density audit found the current home surface is still crowded with summary cards, so the next improvement should be consolidation rather than more widgets
- the first-time-user audit highlights wallet creation, invite acceptance, and SMS setup as the main onboarding friction points
- the current work stays local-first and keeps wallet boundaries unchanged

## Onboarding and dashboard simplification milestone

This pass reduces first-run friction and trims the dashboard surface:

- the dashboard now defaults to account summary, recent transactions, attention needed, and upcoming commitments
- secondary summaries are pushed behind an explicit "View more" control instead of being stacked by default
- the dashboard now includes a wallet-first onboarding banner that explains the wallet boundary in plain language
- SMS import now starts with an introduction card that explains the permission, privacy model, and review-first flow
- empty states for budgets, goals, allowances, settlements, and notifications now tell the user what to do next
- the current UX emphasis is reducing setup friction before adding any new feature area

## Guided onboarding completion milestone

The guided onboarding pass adds a local-first funnel for the remaining high-friction steps:

- a guided wallet creation screen explains what a wallet is, why it exists, and how personal and shared wallets differ
- wallet creation now records local onboarding progress through wallet activity events
- invitation creation and acceptance now record start and completion markers so the funnel can be measured locally
- SMS setup now records start and completion markers around the existing review-first import flow
- the current goal is to make the first run self-explanatory without introducing cloud or schema changes

## Closed beta observation dashboard milestone

The beta review layer now has a single local surface:

- the beta observation dashboard combines onboarding, wallet activity, SMS quality, workflow friction, and feedback summaries
- the health score is derived locally from onboarding completion, SMS acceptance, and friction events
- the observation screen is wallet-scoped and uses the existing beta telemetry providers
- feedback categories are still limited by the current schema, so feature-request reporting is mapped to the existing improvement bucket
- the goal is faster beta triage without adding analytics SDKs or cloud reporting

## Public beta launch readiness milestone

The release pass is now focused on beta distribution and risk documentation:

- settings and onboarding paths explain permissions, SMS review, and backup/export behavior more explicitly
- the public beta checklist documents install, upgrade, migration, onboarding, SMS, notification, and backup validation
- crash recovery coverage now includes the missing-wallet case in addition to the existing malformed invite and SMS parse safeguards
- the analyzer backlog is being classified for beta rather than chased indiscriminately
- the current release goal is documented stability, not new product surface area

## Beta feedback resolution milestone

This pass narrows the highest-friction beta paths without changing architecture:

- the first-wallet flow now explains wallet boundaries, personal versus shared usage, and the next step after creation
- invite acceptance now explains invalid or expired codes more clearly and shows the granted role and status before acceptance
- SMS setup now gives a stronger review-first explanation and shows rejected and duplicate counts up front
- backup and export settings now explain the local backup and restore flow in plainer language
- the top beta friction points remain wallet creation, invite acceptance, SMS setup, dashboard density, and malformed or invalid recovery paths

## Closed beta bug bash milestone

The beta bug bash tightened the highest-impact user-facing edges:

- malformed invitation payloads now fail cleanly instead of surfacing parser noise
- malformed SMS bodies are rejected explicitly by the SMS parser
- the invite screen now gives clearer invalid-code feedback and clearer success state after acceptance
- the beta dashboard continues to act as a local review surface rather than a second analytics stack
- the remaining issues are mostly release-debt warnings, not beta-blocking product bugs

## Analyzer cleanup milestone

The debt-reduction pass is now focused on reducing the warning backlog without changing behavior:

- analyzer baseline is 114 warnings with zero errors
- current measured warning count is 52 with zero errors
- the cleanup pass removed unused imports, dead code, stale TODOs, obsolete helpers, several deprecated form/color APIs, and deprecated sharing calls
- the remaining warnings are concentrated in a few style issues, older test helpers, and a small amount of legacy UI/API debt
- the cleanup plan is documented in `docs/analyzer_cleanup_plan.md`

## Release debt reduction sprint

The release-debt pass keeps behavior intact and trims release-facing noise:

- unused imports were removed from the default account/category helpers and sync service
- the settings screen now uses the modern color accessor for the divider border
- malformed invitation payloads now resolve cleanly to `null`
- malformed SMS bodies are rejected explicitly by the parser
- the current remaining warnings are mostly style debt, async-context warnings, and legacy test helpers

## Family finance management UI milestone

This pass tightened the repository/UI boundary and added dedicated local management surfaces:

- UI-facing view models now sit between the widgets and Drift-backed repositories
- wallet goals can be listed, edited, archived, deleted, and contributed to from local screens
- shared budgets can be listed, edited, and deleted from local screens
- budget activity is visible as a dedicated detail screen
- the settings screen now links to the new wallet-goal and shared-budget management screens
- the full test suite remains green after the UI boundary refactor
- keep migration behavior explicit and testable

## Budget wallet isolation milestone (P0-1)

The wallet architecture hardening pass now establishes proper budget wallet ownership:

- added `walletId` foreign-key column to `budgets` Drift schema referencing `wallets(id)` with `ON DELETE CASCADE`
- incremented database `schemaVersion` from 6 to 7 with migration logic assigning legacy budget records to default wallet (`walletId = 1`)
- updated `BudgetDao` with wallet-scoped watch (`watchBudgetsWithCategory`), fetch (`getBudgetsForWallet`), update (`updateBudget(walletId, ...)`), and delete (`deleteBudget(id, walletId)`) queries
- updated `BudgetRepositoryImpl` to pass active `walletId` to DAO operations and prevent cross-wallet budget mutations
- updated budget providers (`familyBudgetSummaryProvider`, `budgetViewModelsProvider`) to query wallet-scoped budgets
- updated sync service (`sync_service.dart`) to scope local budget payload reads and remote budget companion writes to `walletId`
- added automated test suite `test/budget_wallet_isolation_test.dart` covering wallet ownership, isolation reads, cross-wallet update/delete guards, wallet switching, legacy migration defaults, and FK cascade deletion

## Transaction wallet isolation milestone (P0-2)

The wallet architecture hardening pass now establishes complete transaction wallet isolation across DAO, repository, and provider boundaries:

- updated `TransactionDao` with wallet-scoped read, watch (`watchTransactionsInMonth`, `watchRecentTransactions`, `watchAllTransactions`), aggregation (`getMonthlySummaryTotals`, `getMonthlyExpensesForLastNMonths`), and lookup (`getTransactionById`, `getTransactionWithDetailsById`) queries
- implemented cross-wallet mutation and lookup protection guards in `TransactionDao` (`UPDATE ... WHERE id = ? AND wallet_id = ?`, `DELETE FROM ... WHERE id = ? AND wallet_id = ?`, `SELECT ... WHERE id = ? AND wallet_id = ?`)
- updated `TransactionRepositoryImpl` to pass active `walletId` to all DAO operations and expose `getTransactionById`
- updated `AccountDao` and `AccountRepositoryImpl` to compute transaction counts and balances isolated by `walletId`
- updated `dashboard_providers.dart` (`familyBudgetSummaryProvider`, `budgetViewModelsProvider`, `familyFinancialSummaryProvider`) to pass `walletId` to `getMonthlySummaryTotals`
- added comprehensive automated test suite `test/transaction_wallet_isolation_test.dart` covering transaction wallet ownership, read isolation, recent transaction isolation, monthly summary isolation, date-range isolation, category trend isolation, cross-wallet update protection, cross-wallet delete protection, transaction-by-ID lookup protection, wallet switching, dashboard/summary isolation, multiple transaction isolation, recurring transaction ownership, SMS/import ownership, and regression testing for formerly unsafe global queries

## Wallet deletion cleanup milestone (P0-3)

The wallet deletion cleanup pass ensures `WalletDao.deleteWallet()` is deterministic, transactional, and complete across all wallet-owned records:

- conducted a complete SQLite table inventory audit across all 29 database tables registered in `AppDatabase`
- corrected table name mismatches in `deleteWallet()` (`wallet_notifications`, `wallet_bills`, `feedback_entries`, `wallet_notification_preferences`, `wallet_goal_contributions`, `unrecognized_sms_entries`)
- added dependency-ordered explicit subquery deletion for indirect child tables (`wallet_allowance_payments`, `wallet_goal_schedules`, `wallet_expense_split_members`, `attachments`, `recurring_transactions`) before parent entities/accounts
- wrapped `deleteWallet()` inside an atomic Drift database transaction (`transaction(() async { ... })`) to ensure zero partial deletion states
- verified that global reference tables (`categories`, `deleted_records`) remain intact during wallet deletion
## Last-owner protection milestone (P0-4)

The last-owner protection pass enforces the fundamental wallet ownership invariant (`COUNT(owners) >= 1`):

- added `countActiveOwners(walletId)` query to `WalletDao` to accurately count active `WalletRole.owner` members
- implemented atomic pre-mutation guards in `WalletDao.updateMember`, `WalletDao.deactivateMember`, and `WalletDao.deleteMember` that throw `LastOwnerException` if a demotion or removal operation would leave a wallet with zero active owners
- updated `WalletMembersScreen` UI layer to catch `LastOwnerException` gracefully and present explanatory SnackBar messages to the user
- verified that multi-owner wallets permit valid demotions/deactivations down to 1 owner, and non-owner member operations remain unaffected
- verified that invitation acceptance adds members without reducing owner count or invalidating existing owners
- added automated test suite `test/wallet_last_owner_test.dart` containing 14 tests covering wallet creation ownership, multiple owner demotions/deactivations, last-owner removal rejection, last-owner demotion rejection, non-owner demotions/removals, cross-wallet isolation, owner-count accuracy, invitation acceptance interactions, sequential demotions, and atomic transaction failure rollback without partial mutations

## Service/repository RBAC milestone (P0-5)

The wallet authorization pass enforces RBAC below the UI layer at the service/repository/DAO boundary:

- audited `WalletPermissionService` and existing role definitions (`OWNER`, `ADMIN`, `MEMBER`, `VIEWER`) to preserve product permission semantics
- added `WalletPermissionDeniedException` and `checkPermission` helper method in `WalletDao` to evaluate actor permissions against the target `walletId`
- added RBAC permission checks below the UI in `WalletDao` for `updateMember` (`canChangeRoles`), `deactivateMember` (`canRemoveMembers`), `deleteMember` (`canRemoveMembers`), and `deleteWallet` (`canDeleteWallet`)
- updated `BudgetRepositoryImpl` to enforce `canManageBudgets` on budget creation, modification, and deletion
- updated `TransactionRepositoryImpl` to enforce `canAddTransactions` on transaction creation, modification, and deletion
- updated `WalletInvitationRepositoryImpl` to enforce `canManageMembers` on invitation creation
- preserved P0-4 last-owner protection underneath the RBAC layer so that even authorized `OWNER` operations cannot demote or remove the final active owner
- added comprehensive automated test suite `test/wallet_rbac_test.dart` containing 16 tests covering role-based permissions (`OWNER`, `ADMIN`, `MEMBER`, `VIEWER`), missing membership rejection, inactive membership rejection, cross-wallet authorization isolation, member role change & removal protection, invitation management protection, budget & transaction repository RBAC enforcement, P0-4 last-owner protection coexistence, and non-partial mutation failure atomicity

## Active-wallet validation & startup integrity milestone (P0-6)

The active wallet validation pass completes the P0 wallet architecture hardening workstream:

- established active wallet invariant enforcing wallet existence in SQLite, active wallet state, and active member lookup (`isActive == true`)
- added `isWalletValid`, `getAccessibleWallets`, and `validateActiveWallet` to `WalletDao` to provide a single, unified validation boundary for active wallet selection and restoration
- added `InvalidActiveWalletException` for invalid wallet selection attempts
- updated `CurrentWalletIdNotifier` in Riverpod settings providers to validate stored wallet IDs upon app startup, revalidate upon wallet deletion or member deactivation, and reject invalid wallet switches
- eliminated all production hardcoded fallbacks to `walletId = 1` across `Budget` entity constructors, settings screens, and provider defaults
- integrated active wallet validation with P0-3 wallet deletion so deleting an active wallet automatically revalidates and selects the next accessible valid wallet or transitions to a safe no-wallet state (`state = 0`)
- added comprehensive automated test suite `test/active_wallet_validation_test.dart` containing 15 tests covering valid wallet acceptance, non-existent wallet rejection, missing/inactive membership rejection, startup validation/restoration, cross-user wallet isolation, valid/invalid wallet switching, wallet deletion revalidation, and accessible wallet listing

## Why this matters

Without a wallet abstraction, collaboration features tend to spread across the entire schema and become hard to maintain. The wallet layer is the right boundary for:

- shared budgets
- member roles
- approvals
- settlement
- family or shared contexts
- wallet activity history
- invitation lifecycle management

## Account wallet isolation & RBAC milestone (P1-1)

The wallet architecture hardening pass now establishes complete account wallet isolation and RBAC authorization across DAO, repository, and provider boundaries:

- updated `WalletPermissionService` with `canManageAccounts` (OWNER/ADMIN allowed, MEMBER/VIEWER denied) and `canViewAccounts` permission definitions
- updated `AccountDao` methods (`watchAllAccounts`, `insertAccount`, `updateAccount`, `deleteAccount`, `getAccountById`) to accept target `walletId` and enforce atomic `WHERE id = ? AND wallet_id = ?` predicates directly in SQLite
- updated `AccountRepositoryImpl` to pass active `walletId` to all DAO operations and enforce `_walletDao.checkPermission` (`canManageAccounts`) for write operations (`addAccount`, `updateAccount`, `deleteAccount`)
- updated `accountRepositoryProvider` in `lib/core/providers/repository_providers.dart` to inject `walletDaoProvider`
- added comprehensive automated test suite `test/account_wallet_isolation_test.dart` containing 9 tests covering wallet-scoped reads, lookup isolation, cross-wallet update/delete rejection, RBAC authorization, missing/inactive membership rejection, explicit walletId/accountId mismatch rejection, and cascade deletion

## Goals, Bills & Allowances wallet isolation & RBAC milestone (P1-2)

The wallet architecture hardening pass now establishes complete wallet isolation and RBAC authorization across DAO, repository, and provider boundaries for Goals, Bills, and Allowances:

- updated `WalletPermissionService` with `canViewGoals`, `canViewBills`, `canViewAllowances` helper methods alongside existing `canManageGoals`, `canContributeToGoals`, `canManageBillsAndSchedules`, `canMarkBillsPaid`, and `canManageAllowances` permission definitions
- implemented `GoalDao`, `BillDao`, and `AllowanceDao` in `AppDatabase` with atomic `WHERE id = ? AND wallet_id = ?` SQLite predicates (and parent subqueries for child tables `WalletGoalContributions`, `WalletGoalSchedules`, `WalletAllowancePayments`)
- created `GoalRepositoryImpl`, `BillRepositoryImpl`, and `AllowanceRepositoryImpl` enforcing `_walletDao.checkPermission` before propagating `walletId` to DAOs
- registered `goalRepositoryProvider`, `billRepositoryProvider`, and `allowanceRepositoryProvider` in `lib/core/providers/repository_providers.dart`
- updated providers in `dashboard_providers.dart` (`walletGoalsProvider`, `allowanceViewModelsProvider`, `allowancePaymentViewModelsProvider`, `allowanceSpendingSummaryProvider`, `billViewModelsProvider`, `goalScheduleViewModelsProvider`) and UI screens (`wallet_goals_screen.dart`, `allowance_management_screen.dart`) to route mutations and reads through the secured repository/DAO boundary
- added comprehensive automated test suite `test/deferred_domains_wallet_isolation_test.dart` containing 23 tests covering read isolation, lookup isolation, cross-wallet update/delete rejection, RBAC authorization, missing/inactive membership rejection, explicit walletId mismatch rejection, failure atomicity, active-wallet switching, and cascade deletion

## Sync Service RBAC & wallet isolation milestone (P1-3)

The sync authorization pass closes the remaining authorization boundary in `sync_service.dart`:

- updated `WalletPermissionService` with `canSynchronizeWallet` (OWNER, ADMIN, MEMBER allowed; VIEWER, missing membership, and inactive membership denied)
- updated `SyncNotifier` in `sync_service.dart` with `_validateSyncAuthorization` to verify target wallet validity (`isWalletValid`) and actor permission (`canSynchronizeWallet`) before payload creation and incoming sync application
- updated `_buildSyncPayload` and `performSync` to accept target `walletId` and `actorAccountId` without trusting untrusted payload `walletId` values
- updated all sync table upsert helpers (`_upsertWalletMember`, `_upsertWalletInvitation`, `_upsertWalletNotification`, `_upsertWalletNotificationPreference`, `_upsertWalletGoal`, `_upsertWalletGoalContribution`, `_upsertWalletAllowance`, `_upsertWalletAllowancePayment`, `_upsertWalletGoalSchedule`, `_upsertWalletBill`, `_upsertWalletExpenseSplit`, `_upsertWalletSettlement`, `_upsertWallet`) to validate target `walletId` matching and parent entity ownership
- enforced cross-wallet entity hijack protection for incoming remote change records (`accounts`, `transactions`, `budgets`, `loans`, `peer_debts`) and remote deletions, preventing payload records from mutating entities in other wallets
- preserved atomic Drift database transaction behavior (`db.transaction`), ensuring any authorization or target validation error triggers full rollback
- added comprehensive automated test suite `test/sync_wallet_rbac_test.dart` containing 14 tests covering role-based sync permissions, target wallet validation, payload hijack attacks, child entity cross-wallet protection, mid-session membership deactivation, and failure atomicity

## Recurring Transactions wallet isolation & RBAC milestone (P2-1)

The recurring transaction hardening pass closes wallet-isolation vulnerabilities in the recurring transaction implementation:

- added `walletId` column to `recurring_transactions` table with FK to `wallets.id` ON DELETE CASCADE (schema v8 migration)
- added deterministic migration backfill: existing records assigned to wallet of their referenced account (`recurring_transactions.account_id → accounts.id → accounts.wallet_id`); orphaned records (unresolvable wallet) fail the migration clearly rather than silently assigning to wallet 1
- added `walletId` field to `RecurringTransaction` domain model following Budget/Transaction conventions
- updated `RecurringTransactionMapper` to preserve `walletId` in DB→Domain and support explicit wallet override in Domain→Companion
- updated `RecurringTransactionDao` with wallet-scoped operations: `watchAllWithDetails(walletId)`, `getActiveTemplatesWithDetails(walletId)`, `getById(id, walletId)`, `deleteTemplate(id, walletId)`, `updateTemplate(..., walletId)`, `insertTemplate(..., walletId)` — all using atomic `WHERE id = ? AND wallet_id = ?` predicates
- updated `RecurringTransactionRepositoryImpl` with `WalletDao` injection and RBAC enforcement (`canManageRecurringTransactions`: OWNER/ADMIN/MEMBER allowed, VIEWER denied; missing/inactive membership denied)
- added `hasActiveMemberWithPermission` wallet-level permission check to `WalletDao`
- added account-wallet validation: `recurring.walletId == account.walletId` enforced before create/update; cross-wallet account references rejected
- updated `ProcessRecurringTransactions` use case to preserve `walletId` in generated domain objects
- updated wallet deletion cleanup to delete recurring transactions through direct `wallet_id` ownership (not via `account_id IN (...)`)
- hardened Sync Service: outgoing filters by `walletId` and serializes it; incoming validates `remoteWalletId == walletId` and checks existing record ownership (UUID hijack protection); deletion verifies wallet ownership before deleting
- added comprehensive automated test suite `test/recurring_transaction_wallet_isolation_test.dart` containing 40 tests covering read isolation, RBAC, mutations, account ownership, cross-wallet attacks, generation security, active-wallet behavior, deletion cleanup, sync security, and migration

## Splits & Settlements wallet isolation & RBAC milestone (P2-2)

The splits/settlements/peer-debts hardening pass closes wallet-isolation vulnerabilities in the expense-splitting, settlement, and peer-debt data layer:

- hardened `peer_debts.wallet_id`: removed unsafe `DEFAULT 1` and added FK constraint to `wallets(id) ON DELETE CASCADE` (schema v8 → v9 migration). The migration backfills `wallet_id` deterministically from the linked transaction's wallet (`peer_debts.transaction_id → transactions.id → transactions.wallet_id`); orphaned records (unresolvable wallet ownership) fail the migration clearly with a descriptive error listing orphan UUIDs, never silently assigning to wallet 1
- added `uuid` columns to `wallet_expense_splits` and `wallet_settlements` tables (schema v9 migration) so they participate in UUID-based sync deletion. Existing rows backfilled with deterministic UUIDs
- added `canManageDebts(WalletRole?)` to `WalletPermissionService` (OWNER, ADMIN allowed; MEMBER and VIEWER denied) following existing permission naming conventions
- extended `WalletDao` with wallet-scoped, RBAC-enforced operations for splits, split members, settlements, and peer debts:
  - `watchSplitsForWallet(walletId)`, `getSplitsForWallet(walletId)`, `getSplitById(id, walletId)`, `insertSplit(..., walletId, actorAccountId)`, `updateSplit(..., walletId, actorAccountId)`, `deleteSplit(id, walletId, actorAccountId)`
  - `watchSplitMembersForWallet(walletId)`, `getSplitMembersForSplit(splitId, walletId)`, `insertSplitMember(..., walletId, actorAccountId)`, `updateSplitMember(..., walletId, actorAccountId)`, `deleteSplitMember(id, walletId, actorAccountId)`
  - `watchSettlementsForWallet(walletId)`, `getSettlementsForWallet(walletId)`, `getSettlementById(id, walletId)`, `insertSettlement(..., walletId, actorAccountId)`, `updateSettlement(..., walletId, actorAccountId)`, `deleteSettlement(id, walletId, actorAccountId)`
  - `getPeerDebtsForWallet(walletId)`, `getPeerDebtById(id, walletId)`, `insertPeerDebt(..., walletId, actorAccountId)`, `updatePeerDebt(..., walletId, actorAccountId)`, `deletePeerDebt(id, walletId, actorAccountId)`
- all mutations enforce atomic `WHERE id = ? AND wallet_id = ?` SQLite predicates; updates/deletes on cross-wallet records return 0 rows / false
- cross-wallet reference validation: split creation verifies `transactionId` belongs to target wallet and `paidByMemberId` belongs to target wallet; settlement creation verifies `payerMemberId` and `receiverMemberId` belong to target wallet; peer debt creation verifies `transactionId` belongs to target wallet; split member creation verifies parent split belongs to target wallet AND referenced member belongs to target wallet
- RBAC enforcement at the DAO boundary: `insertSplit` uses `canCreateSplits` (OWNER/ADMIN/MEMBER allowed, VIEWER denied); `updateSplit`, `deleteSplit`, `insertSettlement`, `updateSettlement`, `deleteSettlement` use `canManageSettlements` (OWNER/ADMIN allowed, MEMBER/VIEWER denied); `insertPeerDebt`/`updatePeerDebt`/`deletePeerDebt` use `canManageDebts` (OWNER/ADMIN allowed, MEMBER/VIEWER denied)
- fixed dashboard `splitExpenseViewModelsProvider` global read: split members are now fetched via `WHERE splitId IN (wallet splits)` subquery rather than a global table read
- sync deletion handling: added `wallet_expense_splits` and `wallet_settlements` deletion handlers with wallet ownership validation (`target.walletId == walletId` check before delete). Split members are handled via parent-split FK cascade deletion
- sync incoming validation: existing `_upsertWalletExpenseSplit` and `_upsertWalletSettlement` helpers already enforce `item.walletId == targetWalletId` and existing-record wallet ownership; no changes needed
- preserved atomic Drift database transaction behavior (`db.transaction`); any authorization or cross-wallet validation error triggers full rollback
- updated `debts_loans_screen.dart` presentation file to pass `walletId` from `currentWalletIdProvider` to `PeerDebtsCompanion.insert` (required after walletId became a non-nullable required field)
- added comprehensive automated test suite `test/splits_settlements_wallet_isolation_test.dart` containing 38 tests covering read isolation (3), mutation isolation (6), RBAC (13), cross-wallet reference attacks (5), split member attacks (4), wallet deletion integrity (1), migration safety (2), and transaction interaction (4)
- added `test/sync_deletion_wallet_isolation_test.dart` containing 6 tests covering outgoing split/settlement/PeerDebt wallet filtering and remote deletion wallet ownership validation
- added `test/peer_debt_migration_test.dart` containing 2 tests validating the schema v9 fresh-DB state requires `walletId` (no unsafe default)

## Activity Audit Trail wallet isolation & RBAC milestone (P2-3)

The audit trail hardening pass establishes a first-class, wallet-safe activity audit trail:

- added `WalletActivities` Drift table (schema v9 → v10) with `walletId` FK to `wallets.id` ON DELETE CASCADE, `actorAccountId` FK to `accounts.id` ON DELETE SET NULL, `actorMemberId` FK to `wallet_members.id` ON DELETE SET NULL, `uuid`, `action`, `entityType`, `entityId`, `entityUuid`, `details`, `metadata` (JSON), `source`, and `createdAt`
- added `WalletDao` wallet-scoped activity operations: `insertActivity(companion, walletId, {actorAccountId})`, `getActivityForWallet(walletId, {limit, offset, actorAccountId, action, entityType})`, `watchActivityForWallet(walletId, {...})` — all using atomic `WHERE walletId = ?` predicates; no update/delete methods exposed (append-only)
- implemented `logOnboardingActivity`, `logWalletCreated`, `logRoleChanged`, `logMemberRemoved`, `logMemberAdded`, and `logInvitationActivity` (replacing empty stubs)
- added `WalletPermissionService.canCreateActivity` (OWNER/ADMIN/MEMBER allowed, VIEWER denied) and `canViewAllActivity` (OWNER/ADMIN); retained `canViewActivity` (any active member)
- cross-wallet activity isolation: events are strictly wallet-scoped; a caller cannot create or read events for another wallet; actor identity must resolve to the target wallet
- append-only enforcement at the DAO layer by omitting update/delete methods for `wallet_activities`; events cannot be modified or deleted through the public API
- wallet deletion now cascades `wallet_activities` cleanup (added `wallet_activities` to `deleteWallet` direct tables)
- connected outgoing sync query to the real `wallet_activities` table (wallet-scoped read); there is no incoming `_upsertWalletActivity` handler, so audit events are effectively local-only and cannot be injected via sync
- added `test/activity_audit_trail_test.dart` containing 12 tests covering actor RBAC, cross-wallet create/read isolation, wallet-scoped ID queries, append-only behavior, action filtering, wallet-deletion cascade, and log helper methods

## Audit Event Wiring & Atomicity (P2-3A)

Wired audit event creation into the highest-value business mutation paths with atomic guarantees:

- **Transaction**: `addTransaction`, `updateTransaction`, `deleteTransaction` in `TransactionRepositoryImpl` — each wrapped in a Drift transaction; audit event inserted after business mutation, atomically committed or rolled back
- **Account**: `addAccount`, `updateAccount`, `deleteAccount` in `AccountRepositoryImpl` — atomic audit + mutation with `actorAccountId` support
- **Budget**: `addBudget`, `updateBudget`, `deleteBudget` in `BudgetRepositoryImpl` — atomic audit + mutation
- **Recurring Transaction**: `add`, `update`, `delete` in `RecurringTransactionRepositoryImpl` — atomic audit + mutation
- **Split**: `insertSplit`, `updateSplit`, `deleteSplit` in `WalletDao` — already atomic (P2-2+P2-3)
- **Settlement**: `insertSettlement`, `updateSettlement`, `deleteSettlement` in `WalletDao` — already atomic
- **PeerDebt**: `insertPeerDebt`, `updatePeerDebt`, `deletePeerDebt` in `WalletDao` — already atomic
- **Membership**: `insertMember`, `deactivateMember`, `deleteMember`, `updateMember` in `WalletDao` — already atomic with `MEMBER_ADDED`, `MEMBER_DEACTIVATED`, `MEMBER_REMOVED`, `MEMBER_ROLE_CHANGED` events
- **Invitation**: `_setStatus` in `WalletInvitationRepositoryImpl` — wrapped in Drift transaction for atomic invitation status change + member creation + audit events
- **Recurring Generation**: `ProcessRecurringTransactions` now passes `source: 'recurring'` to `addTransactionUseCase`, producing `RECURRING_GENERATED` events with `actorAccountId: null` (background operation)

### Source Classification
- `source = 'user'` for normal UI/business mutations
- `source = 'recurring'` for recurring transaction generation
- Actor identity suppressed (`null`) for non-user sources

### Audit Events Generated
`TRANSACTION_CREATED`, `TRANSACTION_UPDATED`, `TRANSACTION_DELETED`, `RECURRING_GENERATED`, `ACCOUNT_CREATED`, `ACCOUNT_UPDATED`, `ACCOUNT_DELETED`, `BUDGET_CREATED`, `BUDGET_UPDATED`, `BUDGET_DELETED`, `RECURRING_TRANSACTION_CREATED`, `RECURRING_TRANSACTION_UPDATED`, `RECURRING_TRANSACTION_DELETED`, `SPLIT_CREATED`, `SPLIT_UPDATED`, `SPLIT_DELETED`, `SETTLEMENT_CREATED`, `SETTLEMENT_UPDATED`, `SETTLEMENT_DELETED`, `PEER_DEBT_CREATED`, `PEER_DEBT_UPDATED`, `PEER_DEBT_DELETED`, `MEMBER_ADDED`, `MEMBER_REMOVED`, `MEMBER_DEACTIVATED`, `MEMBER_ROLE_CHANGED`, `INVITATION_ACCEPTED`, `INVITATION_REVOKED`, `INVITATION_EXPIRED`

### Sensitive Data
Audit events store only entity references (`entityType`, `entityId`, `entityUuid`) and optional human-readable `details`. No financial values (amounts, balances, notes) or PII are stored in audit metadata.

### Fixes
- fixed `updateMember` variable scoping bug: `existing` member reference was scoped inside `if (memberId != null)` block but referenced outside it (line 287)
- added `BudgetDao.getBudgetById` method to support audit event UUID retrieval
- updated mock files (`budget_rollover_test.mocks.dart`, `get_monthly_summary_test.mocks.dart`) to include `source` parameter on `addTransaction` mock

- added `test/audit_event_wiring_test.dart` containing 18 tests covering account/budget/transaction/split/settlement/PeerDebt/membership audit events, wallet isolation, recurring generation source classification, and sensitive data protection

## Invitation Security & Wallet Isolation (P2-5)

- **P2-5 Invitation Security & Wallet Isolation Hardening:**
    - Implemented secure `token` generation (UUIDv4) and validation for wallet invitations.
    - Enforced explicit atomic state transitions and identity validation (`accountId` matching) in the DAO layer.
    - Removed authorization bypasses in status updates and ensured audit logs are bound directly to the `actorAccountId`.
    - Isolated cross-wallet scanning vectors in invitation resolution.
    - Fixed legacy test suite to comply with stricter RBAC checks and token requirements.
- **P2-5 Invitation Security & Wallet Isolation Audit:** Performed a read-only security audit of the wallet invitation system. Identified vulnerabilities regarding lack of cryptographic tokens, authorization bypass, invitation replay, and cross-wallet manipulation. Produced a detailed implementation plan.

## SMS Import Wallet Isolation & Security Hardening (P2-4)

Implemented comprehensive wallet isolation, RBAC, audit attribution, privacy protection, and stable wallet context for the SMS import feature:

- **DAO Hardening & Ownership Predicates (`SmsParsingDao`)**:
  - `markSmsResolved(int id, {required int authorizedWalletId})`: Enforces `WHERE id = ? AND wallet_id = ?`
  - `deleteUnrecognizedSms(int id, {required int authorizedWalletId})`: Enforces `WHERE id = ? AND wallet_id = ?`
  - `insertUnrecognizedSms(companion, {authorizedWalletId})`: Validates `companion.walletId == authorizedWalletId`
  - `insertMerchantMapping(mapping, {required authorizedWalletId, actorAccountId})`: Enforces target wallet equality and RBAC via `WalletDao.checkPermission(canManageMerchantMappings)`
  - `updateMerchantMapping(mapping, {required authorizedWalletId, actorAccountId})`: Enforces RBAC check and strict conditional update (`WHERE id = ? AND wallet_id = ?`)
  - `deleteMerchantMapping(id, {required authorizedWalletId, actorAccountId})`: Enforces RBAC check and conditional deletion (`WHERE id = ? AND wallet_id = ?`)
- **Merchant Mapping RBAC**:
  - `canManageMerchantMappings`: OWNER and ADMIN allowed; MEMBER, VIEWER, inactive members, and non-members denied
- **SMS Audit Attribution (`source = 'import'`)**:
  - SMS-derived transactions specify `source: 'import'`, generating `TRANSACTION_CREATED` audit events with `actorAccountId: null` (suppressing false user attribution per P2-3A convention)
- **SMS Privacy Protection**:
  - Raw SMS message bodies (including OTPs, balances, account numbers, and phone numbers) are stripped from transaction notes
  - Transaction notes format: `[SMS] Merchant Name` (or `[AI] Merchant Name`)
  - Verified that raw SMS text is absent from audit metadata and outgoing sync payloads
  - `unrecognized_sms_entries` and `sms_import_metrics` remain strictly device-local and excluded from sync
- **Stable Wallet Context**:
  - Captured `currentWalletIdProvider` once per import operation in `SmsImportScreen`
  - Added pre-operation wallet validation (`WalletDao.isWalletValid`); fail cleanly if context is invalid
- **Test Suite**:
  - Added `test/sms_wallet_isolation_test.dart` containing 35 dedicated unit and security integration tests covering SMS isolation, merchant mapping RBAC/isolation, import wallet ownership, audit attribution, privacy invariants, failure atomicity, and Security Attacks 1 through 8
