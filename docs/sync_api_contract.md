# Sync API Contract

## Purpose

This document defines the backend contract for making wallet sync production-ready.

The app already has a local sync scaffold. This contract turns that scaffold into a real multi-device sync target.

## Scope

The sync API is wallet-scoped.

One request syncs one active wallet at a time.

## Endpoints

### `POST /sync`

Push local changes and fetch remote changes for the active wallet.

### `GET /sync/health`

Return backend readiness and API version information.

## Authentication

The request should use a bearer token:

```http
Authorization: Bearer <token>
```

The backend should also identify the device so it can support conflict auditing later.

Recommended headers:

- `X-Device-Id`
- `X-Client-Version`
- `X-Sync-Api-Version`

## Request body

```json
{
  "syncApiVersion": 1,
  "walletId": 12,
  "deviceId": "device-uuid",
  "lastSyncTime": 1718760000000,
  "changes": {
    "accounts": [],
    "categories": [],
    "transactions": [],
    "budgets": [],
    "recurring_transactions": [],
    "loans": [],
    "peer_debts": [],
    "wallets": [],
    "wallet_members": [],
    "wallet_invitations": [],
    "wallet_activities": [],
    "wallet_notifications": [],
    "wallet_notification_preferences": [],
    "wallet_goals": [],
    "wallet_goal_contributions": [],
    "wallet_allowances": [],
    "wallet_allowance_payments": [],
    "wallet_goal_schedules": [],
    "wallet_bills": [],
    "wallet_expense_splits": [],
    "wallet_settlements": []
  },
  "deletions": [
    {
      "uuid": "record-uuid",
      "tableName": "transactions",
      "deletedAt": 1718760000000
    }
  ]
}
```

## Response body

```json
{
  "syncApiVersion": 1,
  "serverTime": 1718761234567,
  "changes": {
    "accounts": [],
    "categories": [],
    "transactions": [],
    "budgets": [],
    "recurring_transactions": [],
    "loans": [],
    "peer_debts": [],
    "wallets": [],
    "wallet_members": [],
    "wallet_invitations": [],
    "wallet_activities": [],
    "wallet_notifications": [],
    "wallet_notification_preferences": [],
    "wallet_goals": [],
    "wallet_goal_contributions": [],
    "wallet_allowances": [],
    "wallet_allowance_payments": [],
    "wallet_goal_schedules": [],
    "wallet_bills": [],
    "wallet_expense_splits": [],
    "wallet_settlements": []
  },
  "deletions": [],
  "conflicts": [],
  "warnings": []
}
```

## Record identity

Every synced record should have:

- a stable `uuid`
- a `walletId`
- an `updatedAt` timestamp

Records that are wallet-global, such as wallets themselves, still need stable UUIDs.

## Conflict policy

Use last-write-wins by `updatedAt` for the first version.

Rules:

- newer `updatedAt` wins
- if timestamps tie, the server should prefer the higher `deviceId` lexicographically or the newest server version stamp
- deletes should win over older updates
- membership and invitation state changes should be server-authoritative once a response has been committed

## Sync ordering

The backend should apply data in dependency order:

1. wallets
2. accounts and categories
3. wallet membership and invitations
4. activity and notifications
5. transactions and budgets
6. recurring data, goals, allowances, bills, splits, settlements
7. deletions

## Exclusions for v1

The first production backend can omit:

- real-time push
- offline queue replay from the server
- per-field merge resolution
- binary attachments
- analytics

## Backend responsibilities

- validate auth
- validate wallet access
- merge changes safely
- return only wallet-scoped data
- reject records that do not belong to the active wallet
- preserve server timestamps and conflict audit data

## Client responsibilities

- send only the active wallet payload
- keep local IDs mapped to UUIDs
- retry on transient transport errors
- treat sync as an incremental merge, not a full overwrite

