import 'package:flutter/material.dart';

/// Asks the user where to move records that would otherwise block a delete.
///
/// Call this only when [affectedCount] > 0 and [candidates] is not empty; the
/// callers in the account and category screens fall back to a plain
/// confirmation or a "cannot delete" message otherwise.
///
/// Returns the chosen target, or `null` when the user cancels. The dialog does
/// not perform the move itself — the caller owns the reassign-and-delete call
/// so it can report how many records moved.
Future<T?> showReassignDeleteDialog<T>({
  required BuildContext context,
  required String title,
  required String sourceName,
  required int affectedCount,
  required String recordNoun,
  required List<T> candidates,
  required String Function(T value) labelOf,
  String Function(T value)? subtitleOf,
  String? warning,
}) {
  T? selected = candidates.isEmpty ? null : candidates.first;

  return showDialog<T>(
    context: context,
    builder: (dialogContext) {
      final colorScheme = Theme.of(dialogContext).colorScheme;
      final countLabel = affectedCount == 1 ? '1 $recordNoun' : '$affectedCount ${recordNoun}s';

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"$sourceName" is still used by $countLabel. '
                    'Choose where to move ${affectedCount == 1 ? 'it' : 'them'} before deleting.',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Move to',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 280),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: candidates.length,
                      itemBuilder: (context, index) {
                        final candidate = candidates[index];
                        final isSelected = selected == candidate;
                        final subtitle = subtitleOf?.call(candidate);
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          selected: isSelected,
                          title: Text(labelOf(candidate)),
                          subtitle: (subtitle == null || subtitle.isEmpty)
                              ? null
                              : Text(subtitle),
                          trailing: isSelected
                              ? Icon(Icons.check_circle, color: colorScheme.primary)
                              : null,
                          onTap: () => setState(() => selected = candidate),
                        );
                      },
                    ),
                  ),
                  if (warning != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      warning,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: selected == null
                    ? null
                    : () => Navigator.of(dialogContext).pop(selected),
                child: Text(
                  'Move and delete',
                  style: TextStyle(color: colorScheme.error),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
