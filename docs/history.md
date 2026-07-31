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

## Why this matters

Without a wallet abstraction, collaboration features tend to spread across the entire schema and become hard to maintain. The wallet layer is the right boundary for:

- shared budgets
- member roles
- approvals
- settlement
- family or business contexts
- wallet activity history
- invitation lifecycle management
