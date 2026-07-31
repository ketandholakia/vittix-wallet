// BROKEN DEPENDENCY: smsParsingDao
/*
import 'package:expense_tracker/core/database/app_database.dart' hide Column, AccountType;
import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/llm/llm_service.dart';
import 'package:expense_tracker/domain/entities/transaction.dart' as domain;
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/features/accounts/domain/account.dart';
// Removed unused category.dart

class UnrecognizedSmsScreen extends ConsumerWidget {
  const UnrecognizedSmsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWalletId = ref.watch(currentWalletIdProvider);
    final dao = ref.watch(smsParsingDaoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unrecognized SMS'),
      ),
      body: StreamBuilder<List<UnrecognizedSms>>(
        stream: dao.watchUnresolvedSms(currentWalletId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          if (items.isEmpty) {
            return const Center(child: Text('No unrecognized SMS found!'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.sender, style: Theme.of(context).textTheme.titleMedium),
                          Text(item.receivedAt.toString().split('.')[0]),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(item.smsBody),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () async {
                              final scaffoldMessenger = ScaffoldMessenger.of(context);
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(content: Text('Asking AI to parse SMS...')),
                              );
                              try {
                                final candidate = await ref.read(llmServiceProvider).parseSms(item.smsBody);
                                
                                if (!context.mounted) return;
                                
                                // Show a dialog with the parsed data to confirm import
                                final categories = await ref.read(watchAllCategoriesUseCaseProvider).call().first;
                                final accounts = await ref.read(watchAllAccountsUseCaseProvider).call().first;
                                final cashAccount = accounts.firstWhere((a) => a.type == AccountType.cash, orElse: () => accounts.first);
                                
                                if (!context.mounted) return;
                                
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('AI Extracted Data'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Merchant: ${candidate.merchant}'),
                                          Text('Amount: ${candidate.amount}'),
                                          Text('Type: ${candidate.type.name}'),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                        FilledButton(
                                          onPressed: () async {
                                            final transaction = domain.Transaction(
                                              id: 0,
                                              amount: candidate.amount,
                                              date: candidate.date,
                                              note: '[AI] ${candidate.merchant}',
                                              type: candidate.type,
                                              category: categories.first,
                                              account: cashAccount,
                                              createdAt: DateTime.now(),
                                              updatedAt: DateTime.now(),
                                            );
                                            await ref.read(addTransactionUseCaseProvider).call(transaction);
                                            await dao.markSmsResolved(item.id);
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaction saved!')));
                                            }
                                          },
                                          child: const Text('Save & Resolve'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                
                              } catch (e) {
                                if (context.mounted) {
                                  scaffoldMessenger.showSnackBar(
                                    SnackBar(content: Text('AI Parse Failed: $e')),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.smart_toy),
                            label: const Text('Ask AI'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await dao.markSmsResolved(item.id);
                            },
                            child: const Text('Mark Resolved'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

*/