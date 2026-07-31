# Analyzer Warning Classification

Baseline measured on the current branch:
- 55 analyzer issues reported
- 0 errors
- full test suite passes

## Must Fix Before Beta
- None of the remaining analyzer issues are blocking release by themselves.
- The app is functionally stable enough for external beta if the release notes call out the technical debt below.

## Acceptable Technical Debt
- Deprecated `background` theme access in `lib/app_theme.dart`
- `withOpacity` usage in `lib/settings_screen.dart`
- `use_build_context_synchronously` warnings in `lib/settings_screen.dart`
- `depend_on_referenced_packages` for `clock` in `lib/app_lock_wrapper.dart`
- `unnecessary_import` warnings in `default_accounts.dart`, `default_categories.dart`, `sync_service.dart`
- `use_super_parameters` and `annotate_overrides` warnings in `lib/app_database.dart`
- `unnecessary_underscores` warnings in a few widgets/screens
- `constant_identifier_names` warnings for currency constants in `settings_providers.dart`
- `no_leading_underscores_for_local_identifiers` warnings in a few tests
- `unused_local_variable` warnings in `test/cloud_sync_test.dart`

## Post-Beta Cleanup
- The remaining analyzer debt is mostly legacy style and API modernization.
- The cloud-sync test warnings should be cleaned after beta if cloud sync remains out of scope.
- The remaining UI warnings can be tackled piecemeal in touched files without changing behavior.

## Release View
- Treat the analyzer backlog as documented debt, not a beta blocker.
- Do not broaden the release scope just to force warning count reduction.
- Keep the beta release focused on risk communication and workflow validation.
