# Phase 4L — Required Status-Check Context Correction

Temporary verification artifact created on a disposable verification branch;
closed unmerged after evidence capture.

## Purpose

Phase 4K discovered that the branch protection configured in Phase 4J required
the status-check context `CI / Validate`, while the CI workflow
(`.github/workflows/ci.yml`, job `Validate`) publishes its check run as
`Validate`. Because no check could ever match the required context, every pull
request was blocked — including fully green ones.

## Correction (Phase 4L)

The required status check on protected branch `master` was corrected to the
app-scoped check:

- context: `Validate`
- app: GitHub Actions (`github-actions`, app id 15368, verified from live
  check-run metadata)
- strict up-to-date requirement: unchanged (enabled)

No application behavior is changed by this file or by this branch; it exists
only to verify that a clean change can now satisfy the required check and
become eligible for merging. Do not merge.
