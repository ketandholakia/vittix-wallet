import 'package:expense_tracker/features/categories/presentation/category_form_dialog.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/domain/entities/category.dart';
import 'package:expense_tracker/presentation/widgets/empty_state_widget.dart';
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

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Category category) async {
    final colorScheme = Theme.of(context).colorScheme;
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
                            : () => _confirmDelete(context, ref, category),
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
