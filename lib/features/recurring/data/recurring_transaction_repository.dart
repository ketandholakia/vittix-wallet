import 'package:expense_tracker/features/recurring/domain/recurring_transaction.dart';

abstract class RecurringTransactionRepository {
  Stream<List<RecurringTransaction>> watchAll();
  Future<void> add(RecurringTransaction template);
  Future<void> update(RecurringTransaction template);
  Future<void> delete(int id);
  Future<List<RecurringTransaction>> getActiveTemplates();
}
