# Project Rules

Before making any changes, read and follow this file.

## Definition of Done

A task is NOT complete until all applicable items below are completed.

### 1. Source Code

* Update relevant source code.
* Preserve existing behavior unless the task explicitly changes it.
* Prefer low-risk, incremental changes.

### 2. Tests

* Add new tests for new functionality.
* Update existing tests affected by the change.
* Ensure relevant test suites pass.

### 3. Documentation

Update all affected documentation:

* `docs/history.md`
* `docs/analysis.md`
* `docs/roadmap.md`

Documentation must reflect the actual state of the codebase.

### 4. Architecture

When introducing new features:

* Document architectural decisions.
* Record migration impacts.
* Record known limitations and follow-up work.

### 5. Verification

Run applicable validation:

* `flutter analyze`
* `flutter test`
* Drift code generation, if schema changed

Document any remaining warnings or known issues.

### 6. Completion Report

Every completed task must include:

* Summary of changes
* Files modified
* Tests added or updated
* Documentation updated
* Remaining work
* Risks or follow-up items

### 7. Roadmap Discipline

When a roadmap item is completed:

* Mark it complete.
* Add the next logical implementation step.
* Keep roadmap progress current.

### 8. Database Changes

If Drift schema changes:

* Update schema version.
* Add migration logic.
* Add migration tests where appropriate.
* Document migration behavior.

### 9. Wallet Architecture Rule

All collaboration features must be implemented through wallet boundaries.

Do not introduce:

* ad hoc ownership flags
* duplicated sharing logic
* cross-wallet queries

Wallets are the primary isolation boundary for:

* transactions
* budgets
* goals
* approvals
* settlements
* collaboration

### 10. Stop Condition

If code, tests, and documentation are not all updated, the task is incomplete.

### 11. Architecture Status Updates

Whenever a milestone materially changes system architecture:

* Update `docs/history.md` with what changed.
* Update `docs/analysis.md` with the new current state.
* Update `docs/roadmap.md` by:
  * marking completed milestones,
  * identifying the current milestone,
  * identifying the next milestone.

Every completion report must include:

* Current Milestone
* Next Milestone
* Architecture Status
