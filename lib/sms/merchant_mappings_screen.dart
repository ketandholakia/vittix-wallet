// BROKEN DEPENDENCY: smsParsingDao
/*
import 'package:expense_tracker/core/database/app_database.dart' hide Column, Category;
import 'package:flutter/material.dart';
import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

class MerchantMappingsScreen extends ConsumerStatefulWidget {
  const MerchantMappingsScreen({super.key});

  @override
  ConsumerState<MerchantMappingsScreen> createState() => _MerchantMappingsScreenState();
}

class _MerchantMappingsScreenState extends ConsumerState<MerchantMappingsScreen> {
  @override
  Widget build(BuildContext context) {
    final currentWalletId = ref.watch(currentWalletIdProvider);
    final dao = ref.watch(smsParsingDaoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Merchant Mappings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showMappingDialog(context, null),
          ),
        ],
      ),
      body: FutureBuilder<List<MerchantMapping>>(
        future: dao.getMerchantMappings(currentWalletId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final mappings = snapshot.data!;
          if (mappings.isEmpty) {
            return const Center(child: Text('No custom merchant mappings yet.'));
          }
          return ListView.builder(
            itemCount: mappings.length,
            itemBuilder: (context, index) {
              final mapping = mappings[index];
              return ListTile(
                title: Text(mapping.cleanName),
                subtitle: Text('Pattern: ${mapping.originalPattern}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showMappingDialog(context, mapping),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await dao.deleteMerchantMapping(mapping.id);
                        setState(() {});
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showMappingDialog(BuildContext context, MerchantMapping? existing) async {
    final patternController = TextEditingController(text: existing?.originalPattern);
    final cleanNameController = TextEditingController(text: existing?.cleanName);
    int? selectedCategoryId = existing?.defaultCategoryId;

    final categoriesStream = ref.read(watchAllCategoriesUseCaseProvider).call();
    final categories = await categoriesStream.first;

    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(existing == null ? 'Add Mapping' : 'Edit Mapping'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: patternController,
                      decoration: const InputDecoration(labelText: 'Original Pattern (Regex allowed)'),
                    ),
                    TextField(
                      controller: cleanNameController,
                      decoration: const InputDecoration(labelText: 'Clean Name'),
                    ),
                    DropdownButtonFormField<int>(
                      initialValue: selectedCategoryId,
                      decoration: const InputDecoration(labelText: 'Default Category (Optional)'),
                      items: [
                        const DropdownMenuItem<int>(
                          value: null,
                          child: Text('None'),
                        ),
                        ...categories.map(
                          (c) => DropdownMenuItem<int>(
                            value: c.id,
                            child: Text(c.name),
                          ),
                        )
                      ],
                      onChanged: (val) {
                        setStateDialog(() {
                          selectedCategoryId = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    if (patternController.text.isEmpty || cleanNameController.text.isEmpty) return;

                    final dao = ref.read(smsParsingDaoProvider);
                    final currentWalletId = ref.read(currentWalletIdProvider);

                    if (existing == null) {
                      await dao.insertMerchantMapping(
                        MerchantMappingsCompanion.insert(
                          walletId: currentWalletId,
                          originalPattern: patternController.text,
                          cleanName: cleanNameController.text,
                          defaultCategoryId: drift.Value(selectedCategoryId),
                        ),
                      );
                    } else {
                      await dao.updateMerchantMapping(
                        existing.copyWith(
                          originalPattern: patternController.text,
                          cleanName: cleanNameController.text,
                          defaultCategoryId: drift.Value(selectedCategoryId),
                        ),
                      );
                    }
                    if (context.mounted) Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

*/