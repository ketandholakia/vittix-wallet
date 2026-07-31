# Public Beta Checklist

## Install Validation
- Fresh install completes without crashes.
- App opens to the dashboard.
- Default personal wallet is present or created locally.

## Upgrade Validation
- Existing installs open with the same wallet boundaries.
- Legacy data remains readable after upgrade.
- No cross-wallet data appears after launch.

## Migration Validation
- v4 through current migrations apply cleanly.
- Wallet-owned tables receive the correct default wallet mapping.
- Personal wallet fallback still works.

## Onboarding Validation
- Wallet creation is explanation-first and low-decision.
- Invite acceptance explains role and access before confirm.
- SMS setup explains privacy and review-before-import.

## SMS Validation
- Permission explanation is shown before inbox scanning.
- Rejected and duplicate messages remain local.
- SMS candidates are reviewed before import.

## Notification Validation
- Notification settings are visible.
- Action center opens from settings.
- Dismiss and read actions work locally.

## Backup Validation
- Export creates a local backup file.
- CSV export generates a shareable file.
- Restore flow warns before overwrite.

## Release Notes
- Known risks: analyzer warnings, SMS permission sensitivity, stale cloud-sync test warnings.
- Beta feedback should be filed through the in-app feedback screen.
- Use the beta observation dashboard to review onboarding, SMS, and friction trends.
