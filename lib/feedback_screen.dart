import 'package:expense_tracker/core/database/app_database.dart' as db;
import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/features/dashboard/presentation/dashboard_providers.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:expense_tracker/wallet_permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  db.FeedbackCategory _category = db.FeedbackCategory.bug;
  db.FeedbackSeverity _severity = db.FeedbackSeverity.medium;
  String _workflow = 'dashboard';

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final walletId = ref.read(currentWalletIdProvider);
    await ref.read(feedbackDaoProvider).insertFeedback(
          db.FeedbackEntriesCompanion.insert(
            walletId: walletId,
            category: _category,
            severity: _severity,
            workflow: _workflow,
            description: _descriptionController.text.trim(),
            resolutionStatus: db.FeedbackResolutionStatus.open,
          ),
        );
    _descriptionController.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Feedback saved locally')));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleAsync = ref.watch(currentWalletRoleProvider);
    final permissionService = ref.watch(walletPermissionServiceProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Beta Feedback')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          roleAsync.when(
            data: (role) {
              if (!permissionService.canViewActivity(role)) return const SizedBox.shrink();
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DropdownButtonFormField<db.FeedbackCategory>(
                          initialValue: _category,
                          decoration: const InputDecoration(labelText: 'Category'),
                          items: db.FeedbackCategory.values
                              .map((item) => DropdownMenuItem(value: item, child: Text(item.name)))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) setState(() => _category = value);
                          },
                        ),
                        DropdownButtonFormField<db.FeedbackSeverity>(
                          initialValue: _severity,
                          decoration: const InputDecoration(labelText: 'Severity'),
                          items: db.FeedbackSeverity.values
                              .map((item) => DropdownMenuItem(value: item, child: Text(item.name)))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) setState(() => _severity = value);
                          },
                        ),
                        DropdownButtonFormField<String>(
                          initialValue: _workflow,
                          decoration: const InputDecoration(labelText: 'Workflow'),
                          items: const [
                            DropdownMenuItem(value: 'dashboard', child: Text('Dashboard')),
                            DropdownMenuItem(value: 'wallet switching', child: Text('Wallet switching')),
                            DropdownMenuItem(value: 'invitations', child: Text('Invitations')),
                            DropdownMenuItem(value: 'goals', child: Text('Goals')),
                            DropdownMenuItem(value: 'allowances', child: Text('Allowances')),
                            DropdownMenuItem(value: 'splits', child: Text('Splits')),
                            DropdownMenuItem(value: 'settlements', child: Text('Settlements')),
                            DropdownMenuItem(value: 'sms import', child: Text('SMS import')),
                          ],
                          onChanged: (value) {
                            if (value != null) setState(() => _workflow = value);
                          },
                        ),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 4,
                          decoration: const InputDecoration(labelText: 'Description'),
                          validator: (value) => (value == null || value.trim().isEmpty) ? 'Describe the issue' : null,
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton.icon(
                            onPressed: _submit,
                            icon: const Icon(Icons.send),
                            label: const Text('Submit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),
          FutureBuilder<db.SmsImportMetric?>(
            future: ref.read(smsImportMetricsDaoProvider).getForWallet(ref.read(currentWalletIdProvider)),
            builder: (context, snapshot) {
              final metric = snapshot.data;
              if (metric == null) return const SizedBox.shrink();
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.sms_outlined),
                  title: const Text('SMS quality'),
                  subtitle: Text(
                    'Accepted: ${metric.acceptedImports}  Rejected: ${metric.rejectedImports}  Duplicate: ${metric.duplicateDetections}',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<db.FeedbackEntry>>(
            future: ref.read(feedbackEntriesProvider.future),
            builder: (context, snapshot) {
              final entries = snapshot.data ?? const <db.FeedbackEntry>[];
              if (entries.isEmpty) {
                return const ListTile(
                  leading: Icon(Icons.feedback_outlined),
                  title: Text('No feedback yet'),
                );
              }
              return Column(
                children: entries
                    .map(
                      (entry) => Card(
                        child: ListTile(
                          title: Text('${entry.category.name} • ${entry.severity.name}'),
                          subtitle: Text('${entry.workflow}\n${entry.description}\n${entry.resolutionStatus.name}'),
                          isThreeLine: true,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
