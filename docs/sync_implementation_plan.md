# Sync Implementation Plan

## Phase 1

- keep the existing sync scaffold
- align the client payload with the new contract
- add wallet and collaboration tables to the payload format
- add API versioning fields

## Phase 2

- implement the backend `/sync` endpoint
- add auth and device identity
- store per-wallet sync cursors
- persist server-side conflict metadata

## Phase 3

- sync wallet metadata, memberships, invitations, activities, notifications, and preferences
- add explicit conflict handling for membership and invitation state
- add sync tests for wallet switching and multi-device replay

## Phase 4

- add retry, backoff, and transport error handling
- surface sync health in the UI
- document recovery guidance for users

