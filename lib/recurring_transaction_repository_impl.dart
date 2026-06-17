import 'package:expense_tracker/data/local/app_database.dart' as db;
import 'package:expense_tracker/recurring_transaction.dart';
import 'package:expense_tracker/recurring_transaction_mapper.dart';
import 'package:expense_tracker/recurring_transaction_repository.dart';

class RecurringTransactionRepositoryImpl implements RecurringTransactionRepository {
  final db.RecurringTransactionDao _dao;

  RecurringTransactionRepositoryImpl(this._dao);

  @override
  Stream<List<RecurringTransaction>> watchAll() {
    return _dao.watchAllWithDetails().map((rows) {
      return rows.map((row) => row.toDomain()).toList();
    });
  }

  @override
  Future<void> add(RecurringTransaction template) {
    final companion = template.toCompanion().copyWith(id: const db.Value.absent());
    return _dao.insertTemplate(companion);
  }

  @override
  Future<void> update(RecurringTransaction template) {
    return _dao.updateTemplate(template.toCompanion());
  }

  @override
  Future<void> delete(int id) {
    return _dao.deleteTemplate(id);
  }

  @override
  Future<List<RecurringTransaction>> getActiveTemplates() async {
    final rows = await _dao.getActiveTemplatesWithDetails();
    return rows.map((row) => row.toDomain()).toList();
  }
}
