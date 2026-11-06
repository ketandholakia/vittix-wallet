part of '../app_database.dart';

@DriftAccessor(tables: [Categories, Accounts, Transactions, Budgets, RecurringTransactions])
class RecurringTransactionDao extends DatabaseAccessor<AppDatabase> with _$RecurringTransactionDaoMixin {
  RecurringTransactionDao(AppDatabase db) : super(db);

  List<RecurringTransactionWithDetails> _mapRows(List<TypedResult> rows) {
    return rows.map((row) {
      return RecurringTransactionWithDetails(
        template: row.readTable(recurringTransactions),
        category: row.readTable(categories),
        account: row.readTable(accounts),
      );
    }).toList();
  }

  Stream<List<RecurringTransactionWithDetails>> watchAllWithDetails(int walletId) {
    final query = select(recurringTransactions).join([
      innerJoin(categories, categories.id.equalsExp(recurringTransactions.categoryId)),
      innerJoin(accounts, accounts.id.equalsExp(recurringTransactions.accountId)),
    ])..where(recurringTransactions.walletId.equals(walletId))
      ..orderBy([OrderingTerm.desc(recurringTransactions.nextDueDate)]);
    return query.watch().map(_mapRows);
  }

  Future<List<RecurringTransactionWithDetails>> getActiveTemplatesWithDetails(int walletId) async {
    final query = select(recurringTransactions).join([
      innerJoin(categories, categories.id.equalsExp(recurringTransactions.categoryId)),
      innerJoin(accounts, accounts.id.equalsExp(recurringTransactions.accountId)),
    ])..where(recurringTransactions.isActive.equals(true) & recurringTransactions.walletId.equals(walletId));
    final rows = await query.get();
    return _mapRows(rows);
  }

  Future<RecurringTransactionWithDetails?> getById(int id, int walletId) async {
    final query = select(recurringTransactions).join([
      innerJoin(categories, categories.id.equalsExp(recurringTransactions.categoryId)),
      innerJoin(accounts, accounts.id.equalsExp(recurringTransactions.accountId)),
    ])..where(recurringTransactions.id.equals(id) & recurringTransactions.walletId.equals(walletId));
    final rows = await query.get();
    if (rows.isEmpty) return null;
    return _mapRows(rows).first;
  }

  Future<int> insertTemplate(Insertable<RecurringTransactionDb> template, int walletId) {
    final scoped = template is RecurringTransactionsCompanion
        ? template.copyWith(walletId: Value(walletId))
        : template;
    return into(recurringTransactions).insert(scoped);
  }

  Future<bool> updateTemplate(Insertable<RecurringTransactionDb> template, int walletId) {
    final scoped = template is RecurringTransactionsCompanion
        ? template.copyWith(walletId: Value(walletId))
        : template;
    return (update(recurringTransactions)..where((t) => t.walletId.equals(walletId))).replace(scoped);
  }

  /// Updates a template and verifies it actually belongs to the wallet.
  /// Returns true if the update succeeded, false if the record doesn't belong to the wallet.
  Future<bool> updateTemplateVerified(RecurringTransactionsCompanion template, int walletId) async {
    final id = template.id;
    if (id is! Value<int>) return false;
    final count = await (update(recurringTransactions)
          ..where((t) => t.id.equals(id.value) & t.walletId.equals(walletId)))
        .write(template);
    return count > 0;
  }

  Future<int> deleteTemplate(int id, int walletId) =>
      (delete(recurringTransactions)..where((t) => t.id.equals(id) & t.walletId.equals(walletId))).go();

  /// Returns the walletId of the given account, or null if the account does not exist.
  Future<int?> getAccountWalletId(int accountId) async {
    final account = await (select(accounts)..where((a) => a.id.equals(accountId))).getSingleOrNull();
    if (account == null) return null;
    return account.walletId;
  }
}

