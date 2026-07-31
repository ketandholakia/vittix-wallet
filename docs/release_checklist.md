# Release Checklist

## Testing

- Run `flutter test`
- Run targeted workflow and regression tests
- Validate wallet isolation, invitation lifecycle, notification generation, settlement math, and forecast providers
- Validate that sync settings are documented as scaffold-only unless a backend is configured

## Migration validation

- Verify historical upgrades replay successfully on v4 through current schema
- Confirm default Personal Wallet creation still works for fresh installs
- Confirm existing data maps into the active wallet boundary without cross-wallet leakage

## Backup strategy

- Use the built-in database export from Settings
- Keep a recent `.db` backup before upgrading production data
- Verify import/restore on a non-production device before rollout
- Treat backup/restore as the supported cross-device transfer path until multi-device sync is completed

## Sync review

- Confirm the configured sync URL points to a real backend before enabling it for users
- Verify the backend understands the active wallet payload and conflict policy
- Confirm collaboration tables are either synchronized or explicitly excluded by design

## Android permissions review

- Review SMS permissions and policy requirements
- Confirm local notification permissions are requested only when needed
- Confirm no cloud or background transport permission is introduced for v1

## SMS permissions review

- Keep SMS import review-first
- Ensure parsing never auto-saves detected transactions
- Verify duplicate detection still suppresses repeat imports

## Release notes

- Document remaining analyzer warnings
- Document forecast persistence tradeoff
- Document known local-only limitations
