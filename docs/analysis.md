# Analysis

## What the app is optimized for today

The codebase is optimized for:

- local-first expense capture
- dashboard visibility
- budget tracking
- recurring transaction handling
- account management
- Android SMS import as an assisted capture flow

## Current bottlenecks addressed

Startup work was reduced by:

- removing the shared preferences gate at app launch
- lazy-loading tabs
- deferring dashboard sections after first frame
- batching debt and summary queries
- moving monthly totals into SQL
- deferring startup side effects

## Current gaps

The remaining system gaps are:

- collaboration foundations exist, but invitation transport, approvals, settlements, and expense splitting are still out of scope
- SMS import is review-first only
- background SMS monitoring is not yet implemented
- wallet migration validation is now covered for default wallet assignment on wallet-owned tables

## Current milestone

Collaboration MVP is the active milestone. The core boundary is in place:

- active wallet context exists
- wallet-scoped data reads and writes are implemented for the main expense flows
- wallet isolation tests cover the primary transaction and budget paths
- migration validation tests cover default wallet assignment on wallet-owned rows
- wallet member roles and wallet activity logging now exist
- transaction writes are attributed at the repository layer for activity history
- member management is usable locally from the settings screen
- wallet activity is visible in the dashboard
- invitation lifecycle exists as a local domain model
- invite codes can be created and shared locally without transport services
- invite acceptance now creates membership rows locally
- member contribution summaries are derived from wallet-scoped transactions
- the active wallet is shown prominently in the dashboard shell

Collaboration hardening added the production-readiness checks for the boundary:

- wallet switching refreshes dependent providers on the audited screens
- invalid permission paths are covered by role-based tests
- invitation lifecycle and acceptance remain local-only and wallet-scoped
- historical migrations from v4 through v8 now replay against the current schema
- remaining risk is warning backlog, not cross-wallet leakage

Shared family wallet work extends the local-first model with wallet-native family finance features:

- budgets are now strictly wallet-owned records (`budgets.walletId` FK referencing `wallets.id` with `ON DELETE CASCADE`, schema v7 migration)
- budget DAO, repository, use cases, and providers are wallet-scoped; cross-wallet mutation is prevented at repository/DAO level
- automated tests in `test/budget_wallet_isolation_test.dart` verify budget wallet ownership, read isolation, cross-wallet update/delete protection, wallet switching, legacy migration defaults (`walletId = 1`), and FK cascade deletion
- Wallet Architecture Audit status:
  - P0-1 Budget wallet isolation: PASS
  - P0-2 TransactionDao wallet isolation: PASS
  - P0-3 deleteWallet() cleanup completeness: PASS
  - P0-4 Last-owner protection: PASS
  - P0-5 Service/repository RBAC enforcement: PASS
  - P0-6 Active-wallet startup validation: PASS
  - P1-1 Account wallet isolation & RBAC: PASS
  - P1-2 Goals/Bills/Allowances RBAC: PASS
  - P1-3 Sync Service RBAC: PASS
  - P2-1 Recurring Transactions Wallet Isolation & RBAC: PASS
  - P2-2 Splits & Settlements Wallet Isolation & RBAC: PASS
  - P2-3 Activity Audit Trail Wallet Isolation & RBAC: PASS
- goals, bills, and allowances wallet isolation and RBAC are now fully enforced across DAOs (`GoalDao`, `BillDao`, `AllowanceDao`), Repositories (`GoalRepositoryImpl`, `BillRepositoryImpl`, `AllowanceRepositoryImpl`), and Providers using `WalletPermissionService`, atomic SQL predicates (`WHERE id = ? AND wallet_id = ?`), child entity ownership subqueries, and verified via `test/deferred_domains_wallet_isolation_test.dart`
- account wallet isolation and RBAC is now fully enforced across `AccountDao`, `AccountRepositoryImpl`, and providers using `WalletPermissionService.canManageAccounts`, atomic SQL predicates (`WHERE id = ? AND wallet_id = ?`), and verified via `test/account_wallet_isolation_test.dart`
- active wallet validation is now fully enforced across startup, wallet switching, deletion, and membership deactivation via `WalletDao.validateActiveWallet` and `CurrentWalletIdNotifier`, with zero hardcoded fallbacks to `walletId = 1` and complete automated test coverage in `test/active_wallet_validation_test.dart`
- wallet service/repository RBAC is now enforced below the UI layer at the service/repository/DAO boundary (`WalletPermissionDeniedException`, `checkPermission`), keeping existing permission semantics (`OWNER`, `ADMIN`, `MEMBER`, `VIEWER`), preserving P0-4 last-owner protection, isolating cross-wallet authorization, and verified via `test/wallet_rbac_test.dart`
- wallet last-owner protection is now enforced below the UI in `WalletDao` (`countActiveOwners`, `LastOwnerException`), guaranteeing that no mutation or deactivation can leave an active wallet without an `OWNER`, with test coverage in `test/wallet_last_owner_test.dart`
- wallet deletion is now complete, deterministic, and transactional across all 26 wallet-owned/child tables with subquery child cleanup, correct Drift table names, atomic transaction bounds, and verification via `test/wallet_deletion_test.dart`
- transactions are now fully wallet-isolated at the DAO, repository, and provider levels with cross-wallet update/delete guards and automated test verification in `test/transaction_wallet_isolation_test.dart`
- goals are now a wallet-scoped entity with contributions, progress, and activity logging
- family financial summaries are derived from the active wallet only
- permission checks now distinguish budget and goal management from read-only access

Allowance tracking extends the same boundary:

- allowances are wallet-owned and tied to a wallet member
- allowance payments are recorded locally with wallet-scoped summaries
- child spending summaries are computed from the active wallet only
- allowance management stays UI-facing through view models, not Drift rows

The UI boundary is now explicit:

- repositories continue to own Drift access and wallet scoping
- providers map wallet-scoped rows into UI models
- widgets consume view models instead of raw Drift generated rows
- budget and goal management screens remain local-only and wallet-bound
- allowance management and detail screens follow the same repository-to-view-model boundary

Recurring commitments now extend the family layer further:

- goal contribution schedules are wallet-scoped and tied to a wallet goal and member
- bills are wallet-owned and tracked locally with paid and overdue states
- commitment summaries combine goals, recurring contributions, and upcoming bills from the active wallet only
- dashboard widgets should consume commitment view models, not Drift tables

Automation builds on the same local-only boundary:

- recurrence rules are computed in-process from wallet-owned allowances, goal schedules, and bills
- bill status is derived from due dates rather than manual state flips
- goal and allowance forecasts are projections, not server-calculated records
- the next step is to wire these forecasts into more visible dashboard surfaces and automate schedule execution if needed

Expense splitting extends the wallet boundary again:

- splits are wallet-owned and anchored to a source transaction
- settlements are recorded locally between wallet members
- balance views are computed from split rows, split-member rows, and settlement rows
- the model is still local-first, with no server-side matching or reconciliation layer

The current split-expense UI is intentionally pragmatic:

- edits are handled through a single wallet-bound split editor
- settlements are recorded locally against wallet members
- audit rows are derived from wallet activity events
- balance recalculation is provider-driven, not manually cached in screens

Shared notifications extend the same local-only boundary:

- notification records are wallet-owned and can be read, dismissed, and bulk dismissed locally
- reminder preferences are stored per wallet, not globally
- notification generation is in-process and uses existing bill, allowance, goal, settlement, and invitation data
- the action center is a local review surface, not a server-fed inbox
- the dashboard attention widget is a summary, not a hidden queue

The current quality-and-intelligence pass is focused on:

- keeping the warning backlog contained to older code paths
- deriving forecast trends from existing local providers rather than adding a new storage model
- surfacing dashboard insights that are actionable without introducing a server-side recommendation engine
- improving SMS confidence scoring while preserving the review-first flow

The production-readiness pass is now centered on:

- keeping the app behavior stable for public beta
- validating the full local workflow chain from wallet creation to notification generation
- treating forecast history as derived data for now because persistence would add migration and replay complexity without a clear release need
- reducing the analyzer backlog where touched code is involved, while documenting the remaining legacy warnings

The public beta pass adds local feedback and quality tracking without changing the architecture:

- feedback entries are stored locally and scoped to the active wallet
- SMS import quality is tracked through accepted, rejected, and duplicate counts
- the feedback screen doubles as a lightweight beta triage surface
- performance monitoring remains a documentation and review task rather than a new persistence layer
- the remaining analyzer warnings are mostly legacy deprecations, unused imports, and style noise

The real-user beta validation pass now emphasizes measurable usage:

- local metrics expose the main onboarding and collaboration workflows
- friction tracking highlights abandoned invite and SMS flows plus failed split and settlement creation
- feedback is now categorized so the review queue is easier to triage
- SMS quality reporting now surfaces acceptance, rejection, duplication, and confidence distribution
- no new architecture is required; this is a visibility pass built from the existing wallet-scoped data model

The beta feedback triage pass sharpens the UX review without changing the model:

- feedback is aggregated into bug, UX issue, feature request, and SMS accuracy counts with recent-window trends
- workflow friction is now summarized separately from the general beta metrics so abandonment signals stand out
- the dashboard density audit suggests the current landing page has too many stacked summaries for first-run clarity
- the first-time-user audit points to wallet creation, invite acceptance, and SMS setup as the primary friction points
- the current best move is consolidation and prioritization, not another dashboard feature layer

The onboarding and dashboard simplification pass changes the release emphasis again:

- the dashboard should default to the four highest-signal surfaces only
- secondary reporting belongs behind a deliberate reveal action, not on the first screen
- first-wallet guidance should explain the wallet boundary before asking the user to manage family features
- SMS import needs a privacy-first explanation up front because permission friction is a real abandonment point
- empty states are part of onboarding, not just filler, so they now point the user at the next action

The guided onboarding completion pass turns that into an explicit funnel:

- wallet creation is now presented as a short explanation-first flow
- invite acceptance should explain the granted role before confirming the action
- SMS setup should explain permission scope and review-before-import before any candidate list appears
- onboarding telemetry is tracked through the existing wallet activity layer rather than a separate analytics store
- the remaining UX risk is still decision fatigue at first run, but the steps are now visible and local-first

The analyzer cleanup milestone starts from a documented baseline:

- 114 warnings and 0 errors before cleanup
- 54 warnings and 0 errors after cleanup so far
- unused imports and dead test scaffolding were the safest first reductions
- the remaining backlog is dominated by style warnings, older test helpers, and a few legacy UI/API points
- a full zero-warning pass will still require broader widget modernization than this sprint

## Next milestone

The next milestone is invitation workflow integration:

- reduce the analyzer warning backlog without changing behavior
- only add more wallet edge-case work if a failing path appears in app flows
- consider splitting shared budget and goal dashboards into dedicated screens if the widget surface grows
- remaining family-finance gaps are edit/archive polish, richer activity details, and any future family workflow that should stay wallet-local
- remaining allowance gaps are richer member selection, better due-date computation, and archive-style history semantics
- remaining commitment gaps are richer schedule editing, bill status automation, and goal commitment forecasting
- remaining automation gaps are execution timing, notification-free reminders, and stronger bill status refresh semantics
- remaining splitting gaps are richer split editing, split history detail, and balance adjustment audit semantics
- remaining UI gaps are split filters, settlement edit flows, and richer before/after audit diffs
- remaining notification gaps are richer per-notification actions, activity mentions, and finer-grained delivery timing
- remaining intelligence gaps are deeper forecast accuracy tracking, stronger anomaly detection, and more precise merchant/category inference
- remaining release risks are mostly warning backlog, forecast persistence policy, and SMS permission review
- remaining beta risks are feedback volume, SMS false positives, and analyzer cleanup debt
- remaining analyzer risk is now concentrated in older test helpers, style warnings, and a few legacy UI/API paths rather than new regressions

## Current milestone

Beta feedback triage and UX refinement is the active milestone:

- the focus is on using existing beta data to rank friction points rather than changing architecture
- dashboard density should be reduced by consolidating repeated summaries instead of adding new cards
- the first-run experience still needs the most attention around wallet creation, invites, and SMS setup
- the feedback review summary and friction summary are now the main visibility layers for this pass

## Current milestone

Onboarding and dashboard simplification is the active milestone:

- the goal is to reduce first-run friction without changing architecture
- the default dashboard is intentionally smaller than the full widget set
- wallet creation, invite acceptance, and SMS setup remain the most fragile onboarding steps
- the next improvements should continue to favor clarity, not surface area

## Current milestone

Guided onboarding completion is the active milestone:

- the goal is to make the first run self-explanatory
- the remaining onboarding friction should be measurable from local activity events
- no schema redesign or cloud transport is needed for this pass
- the main risk is still user confusion, not architectural instability

The closed beta observation dashboard is now the review surface for the telemetry already collected:

- onboarding completion, wallet activity, SMS quality, friction, and feedback are now visible in one wallet-scoped dashboard
- the health score is intentionally simple so beta review can spot trend changes without pretending to be a machine-learning metric
- feature-request reporting is constrained by the existing feedback schema, so it reuses the improvement bucket for now
- this is a visibility layer only; it should not turn into a second analytics system

The public beta launch readiness pass turns that visibility into a release checklist:

- release settings need plain-language explanations for SMS, notifications, and backup/export
- the beta checklist now covers install, upgrade, migration, onboarding, SMS, notification, and backup validation
- crash recovery is mostly handled, but missing-wallet and corrupted-preference edge cases should stay on the watch list
- the remaining warning backlog is not uniformly urgent, so the release decision should classify it instead of treating every warning as a blocker
- the beta review workflow should use the observation dashboard and in-app feedback as the primary triage loop

The beta feedback resolution pass keeps the same architecture and focuses on the highest-friction user journeys:

- wallet creation remains the weakest first-run step, so the onboarding copy now spells out wallet boundaries and the default next action
- invite acceptance now explains invalid or expired codes more clearly before the user confirms
- SMS setup now emphasizes the review-first model and makes rejected and duplicate counts visible before import
- backup/export guidance is clearer so release settings do not feel like hidden actions
- the current beta pain points are clarity and recovery, not missing finance features

The closed beta bug bash narrows that list further:

- malformed invite payloads should fail as cleanly as invalid codes, which keeps the local-only invite flow understandable
- malformed SMS messages now stay out of the import queue instead of becoming ambiguous candidates
- the current risk profile is dominated by release debt and UX polish, not architecture or schema instability

The release-debt reduction sprint further trims that noise:

- the measured warning count is now 52 with zero errors
- the remaining warnings are mostly async-context warnings in settings, style warnings in older callbacks, and test-helper debt
- the modernized color accessor on the settings divider removes one more release-facing deprecation
- the beta blocker list did not change; the work is still cleanup, not product expansion

## Risk areas

- SMS parsing can produce false positives
- Android SMS permissions are sensitive and policy-limited
- wallet migration needs continued follow-up before multi-user data is production-grade
- analyzer warnings remain, mostly deprecations, unused imports, and style issues
- invite lifecycle is local-only until a transport is introduced
- notifications are local-only until a transport or platform-delivery policy is introduced
- intelligence features stay local-first until a future model/recommendation layer is justified

## Current milestone

Public beta launch readiness is the active milestone:

- the app is feature-complete for the current local-first scope
- the work now is release validation, permissions clarity, and risk documentation
- the warning backlog is acceptable if the beta-facing issues are clearly categorized
- the goal is an external beta with no new architecture introduced

## Design position

The app should stay local-first and conservative:

- never auto-save raw SMS without review
- keep a manual override on every imported transaction
- scope shared data through wallets, not ad hoc flags

## Sync Service Security Architecture (P1-3)

The P1-3 Sync Service RBAC & Wallet Isolation milestone completes the wallet authorization boundary across all remote sync write paths:

- **Sync Authorization Boundary**: `SyncNotifier` verifies target wallet validity (`WalletDao.isWalletValid`) and actor permission (`WalletDao.checkPermission` with `canSynchronizeWallet`) prior to reading local data for outgoing payloads or mutating local tables during incoming sync processing.
- **Payload Trust Policy**: `payload.walletId` is treated as untrusted input. The target `walletId` must match the validated sync target, and the acting user must possess active membership (`isActive == true`) and a non-VIEWER role (`canSynchronizeWallet`).
- **Entity Hijack Protection**: Incoming changes for `accounts`, `transactions`, `budgets`, `loans`, and `peer_debts` are checked against SQLite to ensure existing local entities belonging to a different wallet cannot be hijacked or updated by incoming cross-wallet payloads.
- **Child Entity Protection**: Child entities without direct `walletId` columns (`wallet_goal_contributions`, `wallet_goal_schedules`, `wallet_allowance_payments`) validate their parent entity (`goalId`, `walletGoalId`, `allowanceId`) against SQLite to ensure they belong to the target wallet.
- **Transactional Atomicity**: All sync writes execute inside Drift's `db.transaction(...)`. Any authorization failure, cross-wallet payload detection, or parent mismatch throws a `WalletPermissionDeniedException`, triggering an immediate and complete transaction rollback with 0 partial writes.

## Recurring Transaction Wallet Ownership Architecture (P2-1)

The P2-1 milestone establishes complete wallet ownership and RBAC authorization for recurring transactions:

- **Ownership Hierarchy**: `Wallet → Account → Recurring Transaction → Generated Transaction`. Each recurring transaction has a direct `walletId` FK to `wallets.id` (ON DELETE CASCADE), ensuring wallet deletion cleans up recurring records through direct ownership.
- **Authorization**: `RecurringTransactionRepositoryImpl` enforces `canManageRecurringTransactions` (OWNER/ADMIN/MEMBER allowed; VIEWER, missing membership, inactive membership denied) via wallet-level `hasActiveMemberWithPermission` check.
- **Account Validation**: Before create/update, the repository validates `recurring.walletId == account.walletId` by looking up the account's wallet in the database. Cross-wallet account references are rejected even if the caller supplies matching walletId/accountId fields.
- **Generation Invariant**: `recurring.walletId == account.walletId == generatedTransaction.walletId`. The `ProcessRecurringTransactions` use case preserves the template's walletId in generated domain objects. The generated transaction is created through the transaction repository which enforces its own wallet scoping.
- **Sync Boundary**: Outgoing sync filters recurring transactions by `walletId` and serializes it. Incoming sync validates `remoteWalletId == walletId` and checks existing record ownership (preventing UUID hijacking). Remote deletions verify wallet ownership before deleting.
- **Migration Strategy**: Schema v8 adds `wallet_id` column with deterministic backfill from `account_id → accounts.wallet_id`. Orphaned records (unresolvable wallet) fail the migration clearly rather than silently assigning to wallet 1.

## Splits, Settlements, and PeerDebt Wallet Ownership Architecture (P2-2)

The P2-2 milestone completes wallet ownership and RBAC authorization for splits, settlements, and peer debts:

- **Ownership Hierarchy**:
  - Splits: `Wallet → Split(walletId) → SplitMember(splitId, memberId) → WalletMember(walletId)`. Split members do not carry a direct `walletId` column; ownership is validated through the parent split (parent split belongs to wallet X) and the referenced wallet member (member belongs to wallet X).
  - Settlements: `Wallet → Settlement(walletId) → WalletMember(payerMemberId) + WalletMember(receiverMemberId)`. Settlements have a direct `walletId` FK and reference two wallet members.
  - Peer Debts: `Wallet → PeerDebt(walletId) → Transaction(transactionId, walletId)`. Peer debts have a direct `walletId` FK to `wallets.id` (ON DELETE CASCADE) hardened in schema v9.

- **Cross-Wallet Validation Invariants**:
  - `split.walletId == authorizedWalletId`
  - `split.transaction.walletId == split.walletId` (transaction reference)
  - `split.paidByMember.walletId == split.walletId` (paidBy member reference)
  - `splitMember.parentSplit.walletId == splitMember.member.walletId` (split member cross-ownership)
  - `settlement.walletId == payerMember.walletId == receiverMember.walletId`
  - `peerDebt.walletId == authorizedWalletId`
  - `peerDebt.transaction.walletId == peerDebt.walletId` (when transactionId is set)

- **RBAC Matrix** (enforced at the `WalletDao` boundary via `WalletPermissionService`):
  - Split creation (`canCreateSplits`): OWNER ✓, ADMIN ✓, MEMBER ✓, VIEWER ✗
  - Split management (`canManageSettlements`): OWNER ✓, ADMIN ✓, MEMBER ✗, VIEWER ✗
  - Settlement management (`canManageSettlements`): OWNER ✓, ADMIN ✓, MEMBER ✗, VIEWER ✗
  - PeerDebt management (`canManageDebts`): OWNER ✓, ADMIN ✓, MEMBER ✗, VIEWER ✗
  - Decision rationale: MEMBER is allowed to create splits (they can initiate expense sharing) but cannot manage settlements or debts (financial reconciliation is an administrative concern). VIEWER is always denied mutations.

- **Sync Security**:
  - **Outgoing**: Split, settlement, and PeerDebt queries are wallet-filtered (`WHERE wallet_id = ?`). No Wallet B records are emitted during Wallet A sync.
  - **Incoming**: `remoteWalletId == authorizedTargetWalletId` is enforced in the upsert helpers. Existing record wallet ownership is checked (UUID hijacking prevention).
  - **Deletion**: Remote split, settlement, and PeerDebt deletions verify the local record's `walletId` before deleting. Split members are removed via parent-split FK cascade.
  - **Child Validation**: Split members (no direct `walletId`) are validated through parent split ownership and referenced wallet member ownership.
  - **Atomicity**: All sync writes execute inside Drift's `db.transaction(...)`. Any authorization failure, cross-wallet detection, or parent mismatch throws `WalletPermissionDeniedException`, triggering immediate and complete transaction rollback.

- **Migration Strategy**: Schema v8 → v9 migration:
  1. Add `uuid` columns to `wallet_expense_splits` and `wallet_settlements` (backfilled with deterministic UUIDs)
  2. Backfill `peer_debts.wallet_id` deterministically from `peer_debts.transaction_id → transactions.wallet_id`
  3. Identify orphaned peer debts (NULL wallet_id or wallet_id referencing non-existent wallet) and fail the migration with a descriptive error listing orphan UUIDs
  4. Recreate `peer_debts` table with `wallet_id` FK to `wallets(id) ON DELETE CASCADE` (NOT NULL, no DEFAULT)
  5. Migration is all-or-nothing: any failure rolls back the entire transaction

- **Split Member Ownership Model**: The preferred parent-owned model is used. Split members do not carry a direct `walletId` column; ownership is derived from the parent split. This avoids redundant ownership state and keeps the invariant `Split.walletId == SplitMember.member.walletId` enforced at the DAO boundary.

## Activity Audit Trail Wallet Ownership Architecture (P2-3)

The P2-3 milestone establishes a first-class, wallet-safe activity audit trail:

- **Ownership Hierarchy**: `Wallet → WalletActivity(walletId) → WalletMember(actorMemberId) + Account(actorAccountId) + Affected Entity(entityType/entityId)`. Every audit event belongs to exactly one wallet (FK to `wallets.id` ON DELETE CASCADE).
- **Actor Model**: `actorAccountId` (FK to `accounts`, SET NULL) + `actorMemberId` (FK to `wallet_members`, SET NULL) identify who performed the action. The actor is obtained from wallet-scoped context (`checkPermission` with `actorAccountId`); a caller cannot specify a foreign actor for a target wallet.
- **Append-only**: The DAO exposes only `insertActivity`, `getActivityForWallet`, and `watchActivityForWallet` — no update/delete/upsert methods. Events cannot be modified or deleted through the public API, preventing falsification or hiding of past actions.
- **RBAC Matrix**:
  - Create activity (`canCreateActivity`): OWNER ✓, ADMIN ✓, MEMBER ✓, VIEWER ✗
  - View own/wallet activity (`canViewActivity`): OWNER ✓, ADMIN ✓, MEMBER ✓, VIEWER ✓
  - View all/admin activity (`canViewAllActivity`): OWNER ✓, ADMIN ✓, MEMBER ✗, VIEWER ✗
- **Cross-Wallet Invariants**:
  - `activity.walletId == authorizedWalletId`
  - `activity.actorMemberId.walletId == activity.walletId`
  - `activity.entityId/entityType` must resolve to a record in `activity.walletId`
- **Privacy**: The audit trail records `entityType`/`entityId`/`entityUuid` references plus a human-readable `details` and optional JSON `metadata` — it does NOT store sensitive values (amounts, names, notes, balances). It is a record of *that* an action occurred and *who* did it, not a secondary financial data store.
- **Sync**: Audit events are wallet-scoped and effectively local-only. The outgoing sync query reads `wallet_activities` for the target wallet (wallet-filtered), but there is no incoming `_upsertWalletActivity` handler — audit events cannot be injected, hijacked, looped, or duplicated via sync.
- **Member Removal**: Deleting a wallet member sets `actorMemberId`/`actorAccountId` to NULL (FK `SET NULL`), preserving the historical event while losing the live reference. Future work can add an immutable actor-name snapshot for display fallback.
- **Wallet Deletion**: `wallet_activities` ON DELETE CASCADE (and explicit cleanup in `deleteWallet`) ensures all audit events for a deleted wallet are removed consistently.
- **Migration Strategy**: Schema v9 → v10 adds the `wallet_activities` table. No backfill needed for a brand-new table; existing attribution fields (e.g., `createdByAccountId` on splits/goals/bills) can later be replayed as synthetic `ACTIVITY_CREATED` events if desired.
- **Migration Strategy**: Schema v9 → v10 adds the `wallet_activities` table. No backfill needed for a brand-new table; existing attribution fields (e.g., `createdByAccountId` on splits/goals/bills) can later be replayed as synthetic `ACTIVITY_CREATED` events if desired.

### Audit Event Wiring & Atomicity Architecture (P2-3A)

P2-3A extends the P2-3 infrastructure by wiring audit event creation into the application's highest-value business mutation paths with atomic guarantees.

- **Atomicity**: Every audited mutation executes inside a Drift `transaction()` block. The business mutation and audit insertion are committed atomically — if either fails, both are rolled back.
- **Event Generation Boundary**: Audit events are generated at the repository/DAO layer, not in the UI or providers. This ensures:
  - All mutation paths (UI, sync, background) produce consistent audit events
  - Actor identity is not caller-controlled
  - Business intent is captured at the correct abstraction level
- **Source Classification**:
  - `source = 'user'` for normal UI/business mutations (actor identity from authenticated context)
  - `source = 'recurring'` for recurring transaction generation (actor = null)
  - `source = 'sync'` available for future sync-applied mutations (actor = null)
  - `source = 'migration'` available for data import (actor = null)
- **Actor Identity**: Actor `actorAccountId` is injected via repository constructor from application context, not per-call. Background operations use `source != 'user'` which suppresses actor attribution.
- **Duplicate Prevention**: Each business operation produces exactly one audit event. Event generation is centralized in the repository layer — no multiple callers can create duplicate events for a single operation.
- **Sensitive Data**: Audit events store only entity references (`entityType`, `entityId`, `entityUuid`) and optional human-readable `details`. No financial values (amounts, balances, notes) or PII are stored. The audit trail is NOT a secondary financial data store.
- **Covered Entities**: Transaction, Account, Budget, Recurring Transaction, Split, Settlement, PeerDebt, WalletMember, WalletInvitation
- **Deferred Entities**: Goal, Bill, Allowance (can be wired in future milestones without architectural changes)
- **Wallet Isolation**: All audit events inherit wallet ownership from the business entity being audited. Cross-wallet audit event creation is prevented by the repository layer using the same wallet-scoped context as the business mutation.

## SMS Import Wallet Isolation & Security Architecture (P2-4)

The P2-4 milestone closes identified wallet-isolation, authorization, audit-attribution, privacy, and wallet-context gaps in the SMS import workflow while preserving the sound existing architecture (device-local capture, non-synced SMS tables, wallet-scoped transaction creation, cascading wallet deletion).

- **Data Flow Boundary**:
  ```text
  SmsCaptureReceiver (device-local, background)
      ↓
  SmsCaptureStore (SharedPreferences queue)
      ↓
  USER OPENS IMPORT UI (SmsImportScreen)
      ↓
  PARSE & REVIEW (SmsTransactionParser + MerchantMappings)
      ↓
  TRANSACTION CREATION (TransactionRepositoryImpl with source: 'import')
  ```
- **Wallet Isolation Guarantees**:
  - **Unrecognized SMS**: `markSmsResolved` and `deleteUnrecognizedSms` enforce conditional predicates `WHERE id = ? AND wallet_id = ?`. Cross-wallet mutation attempts return 0 rows affected without modifying the target wallet's record.
  - **Merchant Mappings**: `insertMerchantMapping`, `updateMerchantMapping`, and `deleteMerchantMapping` enforce target wallet validation and conditional predicates (`WHERE id = ? AND wallet_id = ?`). A Wallet A caller cannot insert, update, or delete Wallet B merchant mappings even with knowledge of the ID.
  - **Account Fallback & Target**: Transaction creation during import enforces `import.walletId == selectedAccount.walletId == createdTransaction.walletId`. If an invalid or foreign account is provided, `TransactionRepositoryImpl` rejects or scopes the account fallback to the import wallet.
- **Role-Based Access Control (RBAC)**:
  - Enforced at the DAO layer (`SmsParsingDao`) using `WalletDao.checkPermission`:
    - Merchant Mapping Management (`canManageMerchantMappings`): `OWNER` ✓, `ADMIN` ✓, `MEMBER` ✗, `VIEWER` ✗
    - Missing membership, inactive membership, or invalid wallet context is strictly denied (`WalletPermissionDeniedException`).
- **Audit Source & Actor Attribution**:
  - SMS-derived transactions are passed with `source: 'import'`.
  - `TransactionRepositoryImpl` sets `effectiveActor = null` for non-`user` sources, preventing automated background or SMS import operations from falsely attributing mutations to the active user.
  - Audit event produced: `TRANSACTION_CREATED` with `source: 'import'`, `actorAccountId: null`, and entity ID matching the created transaction.
- **Privacy Boundary & Sync Invariants**:
  - **Transaction Notes**: Raw SMS message bodies (including OTPs, bank reference numbers, balances, account numbers, and phone numbers) are stripped before creating transactions. Notes are formatted as `[SMS] Merchant Name` (or `[AI] Merchant Name`).
  - **Sync Payload**: Transaction sync serializes `note: '[SMS] Merchant Name'`. No raw SMS text is serialized into sync.
  - **Table Exclusion**: `unrecognized_sms_entries`, `sms_import_metrics`, and `merchant_mappings` remain excluded from `_buildSyncPayload`.
- **Stable Wallet Context**:
  - Active wallet context (`currentWalletIdProvider`) is captured once at the start of an import operation in `SmsImportScreen`.
  - Pre-operation wallet validation (`WalletDao.isWalletValid`) verifies wallet existence and membership before scanning or writing financial records.
- **Deferred Limitations**:
  - **Device-Wide Deduplication**: `sms_imported_hashes` stored in SharedPreferences remains device-local. Duplicate SMS imported on a second device is a recognized product limitation.
  - **Merchant Mapping Sync**: Merchant mappings remain device-local. Cloud sync for merchant mappings is deferred to future releases.
