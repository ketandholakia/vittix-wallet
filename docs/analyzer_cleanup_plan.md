# Analyzer Cleanup Plan

## Baseline

- `flutter analyze` warning count: 114
- error count: 0
- current profile: legacy deprecations, unused imports, style issues, and a small amount of test cleanup

## Current measured result

- `flutter analyze` warning count after cleanup pass: 52
- net reduction from the 114-warning baseline: 62 warnings
- `flutter test`: passing

## Warning categories

### Deprecated APIs

Most of the backlog is here:

- `Share` / `shareXFiles`
- `withOpacity`
- a small number of remaining form-field and theme APIs

These are safe to replace incrementally, but several occur in large UI files and should be handled in small batches.

### Unused imports

These are the safest wins and should be removed first.

### Dead code

The main targets are stale TODOs, obsolete helper methods, and leftover test scaffolding.

### Style issues

These are mostly underscore naming and context-usage warnings. They are low risk but spread across many UI files.

### Test issues

There are unused imports, obsolete fixtures, and a few stale locals in legacy tests.

## Remaining categories

- deprecated theme/color APIs in `app_theme.dart` and `settings_screen.dart`
- async-context warnings in `settings_screen.dart`
- style warnings from underscore-heavy callbacks across several widgets
- unused locals in legacy cloud-sync test scaffolding
- a small amount of legacy test helper naming debt

## Cleanup sequence

1. Remove unused imports and obvious dead code.
2. Remove stale TODOs and obsolete helpers in touched files.
3. Replace deprecated APIs in isolated widgets and forms.
4. Trim dead test infrastructure and duplicated helpers.
5. Re-run `flutter analyze` and only then decide whether the remaining warnings merit broader refactors.

## Current approach

- preserve behavior
- avoid schema changes
- avoid new dependencies
- keep fixes small enough to verify with the existing test suite

## Expected outcome

The warning count should materially drop after the first pass, but a full zero-warning cleanup is likely to require a broader UI modernization sweep.
