import 'package:vittix_wallet/features/categories/presentation/category_form_dialog.dart';
import 'package:vittix_wallet/core/providers/usecase_providers.dart';
import 'package:vittix_wallet/core/providers/repository_providers.dart';
import 'package:vittix_wallet/domain/entities/category.dart';
import 'package:vittix_wallet/core/presentation/empty_state_widget.dart';
import 'package:vittix_wallet/core/presentation/reassign_delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final category = await showCategoryFormDialog(context, ref);
    if (category == null || !context.mounted) return;

    await ref.read(addCategoryUseCaseProvider).call(category);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Category "${category.name}" added')),
    );
  }

  Future<void> _showEditDialog(BuildContext context, WidgetRef ref, Category category) async {
    final updated = await showCategoryFormDialog(context, ref, category: category);
    if (updated == null || !context.mounted) return;

    await ref.read(updateCategoryUseCaseProvider).call(updated);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Category "${updated.name}" updated')),
    );
  }

  /// [root] plus every descendant id, in breadth-first order.
  List<int> _subtreeIds(Category root, List<Category> all) {
    final ids = <int>[root.id];
    var frontier = <int>[root.id];
    while (frontier.isNotEmpty) {
      final next = <int>[];
      for (final candidate in all) {
        final parentId = candidate.parentId;
        if (parentId == null) continue;
        if (frontier.contains(parentId) && !ids.contains(candidate.id)) {
          ids.add(candidate.id);
          next.add(candidate.id);
        }
      }
      frontier = next;
    }
    return ids;
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Category category,
    List<Category> allCategories,
  ) async {
    final repo = ref.read(categoryRepositoryProvider);
    final txCount = await repo.countTransactionsForCategory(category.id);
    if (!context.mounted) return;

    final colorScheme = Theme.of(context).colorScheme;
    final subtreeIds = _subtreeIds(category, allCategories);

    // A category with history is deletable only if its transactions have
    // somewhere to go. Descendants are excluded: they are deleted with it.
    if (txCount > 0) {
      final candidates = allCategories
          .where((other) => !subtreeIds.contains(other.id))
          .toList(growable: false);

      if (candidates.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Cannot delete "${category.name}" — it has $txCount '
              'transaction(s) and there is no other category to move them to.',
            ),
          ),
        );
        return;
      }

      final target = await showReassignDeleteDialog<Category>(
        context: context,
        title: 'Delete Category',
        sourceName: category.name,
        affectedCount: txCount,
        recordNoun: 'transaction',
        candidates: candidates,
        labelOf: (c) => c.name,
        subtitleOf: (c) => c.parentId == null ? 'Category' : 'Subcategory',
        // Categories have no wallet column, so this delete is global. Say so
        // rather than implying it only affects the active wallet.
        warning: [
          if (category.parentId == null && subtreeIds.length > 1)
            'Its ${subtreeIds.length - 1} subcategory(ies) will also be deleted.',
          'Categories are shared across wallets, so transactions in every '
              'wallet that use this category are moved.',
          'This cannot be undone.',
        ].join(' '),
      );
      if (target == null || !context.mounted) return;

      try {
        final moved = await repo.reassignAndDeleteCategory(category.id, target.id);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              moved == 1
                  ? 'Category "${category.name}" deleted, 1 transaction moved to "${target.name}"'
                  : 'Category "${category.name}" deleted, $moved transactions moved to "${target.name}"',
            ),
          ),
        );
      } on Object catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not delete category: $error')),
        );
      }
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text(
          category.parentId == null
              ? 'Are you sure you want to delete "${category.name}"? This will also delete all its subcategories and cannot be undone.'
              : 'Are you sure you want to delete subcategory "${category.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete', style: TextStyle(color: colorScheme.error)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await ref.read(deleteCategoryUseCaseProvider).call(category.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Category "${category.name}" deleted')),
    );
  }

  List<Category> _buildHierarchicalList(List<Category> categories) {
    final topLevel = categories.where((c) => c.parentId == null).toList();
    final result = <Category>[];
    for (final parent in topLevel) {
      result.add(parent);
      final children = categories.where((c) => c.parentId == parent.id).toList();
      result.addAll(children);
    }
    // Add orphans just in case
    for (final cat in categories) {
      if (cat.parentId != null && !topLevel.any((p) => p.id == cat.parentId)) {
        result.add(cat);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesStream = ref.watch(watchAllCategoriesUseCaseProvider).call();
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: StreamBuilder<List<Category>>(
        stream: categoriesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final categories = snapshot.data ?? [];
          if (categories.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.category_outlined,
              message: 'No categories yet',
              subMessage: 'Tap + to create your first category.',
              action: FilledButton.icon(
                onPressed: () => _showAddDialog(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Add Category'),
              ),
            );
          }

          final hierarchicalList = _buildHierarchicalList(categories);

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: hierarchicalList.length,
            separatorBuilder: (_, _) => const Divider(height: 1, indent: 72),
            itemBuilder: (context, index) {
              final category = hierarchicalList[index];
              final isSub = category.parentId != null;

              return Padding(
                padding: EdgeInsets.only(left: isSub ? 32.0 : 0.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: category.color.withValues(alpha: 0.2),
                    maxRadius: isSub ? 16 : 20,
                    child: Icon(
                      category.icon, 
                      color: category.color,
                      size: isSub ? 16 : 20,
                    ),
                  ),
                  title: Row(
                    children: [
                      if (isSub) ...[
                        Text(
                          '↳ ',
                          style: TextStyle(color: Colors.grey[500], fontSize: 16),
                        ),
                      ],
                      Expanded(
                        child: Text(
                          category.name, 
                          style: isSub
                              ? textTheme.bodyLarge
                              : textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  subtitle: category.isDefault ? const Text('Default') : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: 'Edit',
                        onPressed: () => _showEditDialog(context, ref, category),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: colorScheme.error),
                        tooltip: 'Delete',
                        onPressed: category.isDefault
                            ? null
                            : () => _confirmDelete(context, ref, category, categories),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
