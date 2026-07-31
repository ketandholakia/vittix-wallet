# Sync Status

## Short answer

Wallet sync is **not complete** yet.

## What exists now

- a local sync scaffold
- simulated server mode for development
- HTTP POST support for a configured backend URL
- wallet-scoped payloads for the main expense data
- local backup and restore in Settings

## What is still missing

- a real production backend
- server-side authentication
- stable multi-device merge rules
- full collaboration entity sync
- live device-to-device propagation

## Practical guidance

Use backup and restore if you need a reliable way to move a wallet between devices today.

Treat the sync screen as an unfinished feature until a backend is introduced and the collaboration tables are fully covered.

