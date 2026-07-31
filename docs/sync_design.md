# Sync Design

## Current scope

The app has a local-first sync scaffold that operates on the currently selected wallet.

It supports two modes:

- `Simulate Cloud Sync` stores a server state blob in local shared preferences
- real sync posts JSON to the configured `syncUrl`

## What is synchronized today

The sync payload currently includes:

- accounts
- categories
- transactions
- budgets
- recurring transactions
- loans
- peer debts

The payload is always scoped to the active wallet.

## What the current implementation does well

- preserves a local-first workflow
- keeps wallet data isolated during sync
- uses UUIDs for most core records
- applies last-write-wins behavior based on `updatedAt`
- supports deletion replay through `deletedRecords`

## Known limitations

- there is no bundled production backend
- simulated sync is only local state stored in preferences
- wallet membership, invitations, activity, notifications, and preferences are not yet fully synced
- the sync model does not yet define device identity or server-side conflict policy
- cross-device collaboration remains a scaffold, not a finished cloud feature

## Expected next step

To make sync production-ready, the project still needs:

- a real backend API contract
- auth and device identity
- stable server identifiers for collaboration tables
- conflict resolution rules for member/invite state
- coverage for wallet metadata and collaboration entities

