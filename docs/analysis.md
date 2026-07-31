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

- budgets remain wallet-owned and use wallet transactions for usage calculations
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
