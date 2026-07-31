import 'package:expense_tracker/domain/entities/category.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

const _iconOptions = [
  // Food & Dining
  Symbols.restaurant,
  Symbols.coffee,
  Symbols.local_bar,
  Symbols.fastfood,
  
  // Shopping
  Symbols.shopping_bag,
  Symbols.shopping_cart,
  Symbols.store,
  Symbols.checkroom,
  
  // Transport & Auto
  Symbols.local_gas_station,
  Symbols.directions_car,
  Symbols.directions_bus,
  Symbols.two_wheeler,
  Symbols.build,
  
  // Bills & Utilities
  Symbols.receipt_long,
  Symbols.electric_bolt,
  Symbols.water_drop,
  Symbols.wifi,
  Symbols.phone_android,
  Symbols.home_repair_service,
  
  // Health & Personal Care
  Symbols.medical_services,
  Symbols.fitness_center,
  Symbols.spa,
  Symbols.health_and_safety,
  
  // Travel & Leisure
  Symbols.flight,
  Symbols.hotel,
  Symbols.explore,
  
  // Education & Books
  Symbols.school,
  Symbols.book,
  
  // Entertainment & Hobby
  Symbols.movie,
  Symbols.sports_esports,
  Symbols.music_note,
  Symbols.subscriptions,
  
  // Home & Living
  Symbols.home,
  Symbols.apartment,
  
  // Family & Social
  Symbols.child_care,
  Symbols.group,
  
  // Pets
  Symbols.pets,
  
  // Gifts & Charity
  Symbols.card_giftcard,
  Symbols.volunteer_activism,
  
  // Finance & Money
  Symbols.payments,
  Symbols.trending_up,
  Symbols.savings,
  Symbols.monetization_on,
  Symbols.credit_card,
  Symbols.account_balance,
  Symbols.work,
  
  // Others
  Symbols.celebration,
  Symbols.help,
];

const _colorOptions = [
  Color(0xFF45D4A3),
  Color(0xFFFF9D43),
  Color(0xFF569BFF),
  Color(0xFFFF7A6B),
  Color(0xFF2196F3),
  Color(0xFF9C27B0),
  Color(0xFFE91E63),
  Color(0xFF00BCD4),
  Color(0xFF8BC34A),
  Color(0xFFFFC107),
  Color(0xFF795548),
  Color(0xFF607D8B),
];

Future<Category?> showCategoryFormDialog(
  BuildContext context,
  WidgetRef ref, {
  Category? category,
}) {
  return showDialog<Category>(
    context: context,
    builder: (context) => _CategoryFormDialog(category: category, ref: ref),
  );
}

class _CategoryFormDialog extends ConsumerStatefulWidget {
  final Category? category;
  final WidgetRef ref;

  const _CategoryFormDialog({this.category, required this.ref});

  @override
  ConsumerState<_CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends ConsumerState<_CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late IconData _selectedIcon;
  late Color _selectedColor;
  int? _selectedParentId;

  bool get _isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _selectedIcon = widget.category?.icon ?? _iconOptions.first;
    _selectedColor = widget.category?.color ?? _colorOptions.first;
    _selectedParentId = widget.category?.parentId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      Category(
        id: widget.category?.id ?? 0,
        name: _nameController.text.trim(),
        icon: _selectedIcon,
        color: _selectedColor,
        isDefault: widget.category?.isDefault ?? false,
        parentId: _selectedParentId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesStream = ref.watch(watchAllCategoriesUseCaseProvider).call();

    return AlertDialog(
      title: Text(_isEditing ? 'Edit Category' : 'Add Category'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.label_outline),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Parent Category (Subcategory mapping)
                StreamBuilder<List<Category>>(
                  stream: categoriesStream,
                  builder: (context, snapshot) {
                    final list = snapshot.data ?? [];
                    // Filter: only allow top-level categories as parents, and exclude the current category itself.
                    final parentCandidates = list.where((c) => c.parentId == null && c.id != widget.category?.id).toList();

                    return DropdownButtonFormField<int?>(
                      initialValue: _selectedParentId,
                      decoration: const InputDecoration(
                        labelText: 'Parent Category',
                        prefixIcon: Icon(Icons.subdirectory_arrow_right),
                      ),
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('None (Top-Level Category)'),
                        ),
                        ...parentCandidates.map((parent) {
                          return DropdownMenuItem<int?>(
                            value: parent.id,
                            child: Row(
                              children: [
                                Icon(parent.icon, color: parent.color, size: 20),
                                const SizedBox(width: 8),
                                Text(parent.name),
                              ],
                            ),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedParentId = value;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Icon
                Text('Icon', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _iconOptions.map((icon) {
                    final isSelected = icon.codePoint == _selectedIcon.codePoint;
                    return InkWell(
                      onTap: () => setState(() => _selectedIcon = icon),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _selectedColor.withValues(alpha: 0.2)
                              : Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(color: _selectedColor, width: 2)
                              : null,
                        ),
                        child: Icon(icon, color: isSelected ? _selectedColor : null),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Color
                Text('Color', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _colorOptions.map((color) {
                    final isSelected = color.toARGB32() == _selectedColor.toARGB32();
                    return InkWell(
                      onTap: () => setState(() => _selectedColor = color),
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 2)
                              : null,
                        ),
                        child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(_isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}
