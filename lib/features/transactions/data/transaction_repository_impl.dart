import 'package:drift/drift.dart';
import 'package:expense_tracker/data/local/app_database.dart' as db;
import 'package:expense_tracker/data/local/mappers/transaction_mapper.dart';
import 'package:expense_tracker/domain/entities/transaction.dart';
import 'package:expense_tracker/domain/entities/trend_data_point.dart';
import 'package:expense_tracker/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final db.TransactionDao _transactionDao;
  final db.WalletDao? _walletDao;
  final int walletId;

  /// Actor identity injected from application context (not per-call).
  /// Null when no authenticated user context exists (e.g. background operations).
  final int? actorAccountId;

  TransactionRepositoryImpl(this._transactionDao, this.walletId, [this._walletDao, this.actorAccountId]);

  db.WalletDao get _auditDao => _walletDao ?? db.WalletDao(_transactionDao.attachedDatabase);

  Future<void> _insertAuditEvent({
    required String action,
    required int entityId,
    String? entityUuid,
    String source = 'user',
  }) async {
    // Background sources must not be attributed to the current user.
    final effectiveActor = source == 'user' ? actorAccountId : null;
    await _auditDao.insertActivity(
      db.WalletActivitiesCompanion.insert(
        walletId: walletId,
        action: action,
        entityType: 'transaction',
        entityId: entityId,
        entityUuid: db.Value(entityUuid),
        source: source,
      ),
      walletId,
      actorAccountId: effectiveActor,
    );
  }

  @override
  Future<void> addTransaction(Transaction transaction, {String source = 'user'}) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canAddTransactions(r),
      actorAccountId: actorAccountId,
      actionName: 'add transactions',
    );
    final companion = transaction.toCompanion().copyWith(id: const Value.absent());
    final database = _transactionDao.attachedDatabase;
    await database.transaction(() async {
      final id = await _transactionDao.insertTransaction(
        companion.copyWith(
          walletId: Value(walletId),
        ),
        walletId,
      );
      // Read back the stored row to capture the generated uuid (inside the same transaction).
      final row = await _transactionDao.getTransactionById(id, walletId);
      await _insertAuditEvent(
        action: source == 'recurring' ? 'RECURRING_GENERATED' : 'TRANSACTION_CREATED',
        entityId: id,
        entityUuid: row?.uuid,
        source: source,
      );
    });
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canAddTransactions(r),
      actorAccountId: actorAccountId,
      actionName: 'delete transactions',
    );
    // Capture uuid before deletion (the row will be gone after delete).
    final existing = await _transactionDao.getTransactionById(id, walletId);
    if (existing == null) return;
    final database = _transactionDao.attachedDatabase;
    await database.transaction(() async {
      final deleted = await _transactionDao.deleteTransaction(id, walletId);
      if (deleted > 0) {
        await _insertAuditEvent(
          action: 'TRANSACTION_DELETED',
          entityId: id,
          entityUuid: existing.uuid,
          source: 'user',
        );
      }
    });
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canAddTransactions(r),
      actorAccountId: actorAccountId,
      actionName: 'update transactions',
    );
    final companion = transaction.toCompanion();
    final database = _transactionDao.attachedDatabase;
    await database.transaction(() async {
      final updated = await _transactionDao.updateTransaction(
        companion.copyWith(
          walletId: Value(walletId),
        ),
        walletId,
      );
      if (updated) {
        final row = await _transactionDao.getTransactionById(transaction.id, walletId);
        await _insertAuditEvent(
          action: 'TRANSACTION_UPDATED',
          entityId: transaction.id,
          entityUuid: row?.uuid,
          source: 'user',
        );
      }
    });
  }

  @override
  Future<Transaction?> getTransactionById(int id) async {
    final details = await _transactionDao.getTransactionWithDetailsById(id, walletId);
    return details?.toDomain();
  }

  @override
  Stream<List<Transaction>> watchTransactionsInMonth(DateTime month) {
    return _transactionDao.watchTransactionsInMonth(month, walletId).map((dbTransactions) {
      return dbTransactions.map((dbTx) => dbTx.toDomain()).toList();
    });
  }

  @override
  Stream<List<Transaction>> watchRecentTransactions({int limit = 10}) {
    return _transactionDao.watchRecentTransactions(limit: limit, walletId: walletId).map((dbTransactions) {
      return dbTransactions.map((dbTx) => dbTx.toDomain()).toList();
    });
  }

  @override
  Stream<List<Transaction>> watchAllTransactions() {
    return _transactionDao.watchAllTransactions(walletId).map((dbTransactions) {
      return dbTransactions.map((dbTx) => dbTx.toDomain()).toList();
    });
  }

  @override
  Future<List<TrendDataPoint>> getMonthlyTrend(int months) async {
    final result = await _transactionDao.getMonthlyExpensesForLastNMonths(months, walletId);
    return result.map((monthlyTotal) {
      return TrendDataPoint(
        date: DateTime(monthlyTotal.year, monthlyTotal.month),
        amount: monthlyTotal.total,
      );
    }).toList();
  }

  @override
  Future<(double totalIncome, double totalExpense)> getMonthlySummaryTotals(DateTime month) async {
    final summary = await _transactionDao.getMonthlySummaryTotals(month, walletId);
    return (summary.totalIncome, summary.totalExpense);
  }
}
