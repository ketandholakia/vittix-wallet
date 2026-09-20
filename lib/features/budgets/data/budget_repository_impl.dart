import 'package:drift/drift.dart';
import 'package:expense_tracker/data/local/app_database.dart' as db;
import 'package:expense_tracker/data/local/mappers/budget_mapper.dart';
import 'package:expense_tracker/domain/entities/budget.dart';
import 'package:expense_tracker/domain/repositories/budget_repository.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final db.BudgetDao _budgetDao;
  final db.WalletDao? _walletDao;
  final int walletId;

  /// Actor identity injected from application context (not per-call).
  /// Null when no authenticated user context exists.
  final int? actorAccountId;

  BudgetRepositoryImpl(this._budgetDao, this.walletId, [this._walletDao, this.actorAccountId]);

  db.WalletDao get _auditDao => _walletDao ?? db.WalletDao(_budgetDao.attachedDatabase);

  Future<void> _insertAuditEvent({
    required String action,
    required int entityId,
    String? entityUuid,
    String source = 'user',
  }) async {
    final effectiveActor = source == 'user' ? actorAccountId : null;
    await _auditDao.insertActivity(
      db.WalletActivitiesCompanion.insert(
        walletId: walletId,
        action: action,
        entityType: 'budget',
        entityId: entityId,
        entityUuid: db.Value(entityUuid),
        source: source,
      ),
      walletId,
      actorAccountId: effectiveActor,
    );
  }

  @override
  Future<void> addBudget(Budget budget) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageBudgets(r),
      actorAccountId: actorAccountId,
      actionName: 'manage budgets',
    );
    final companion = budget.toCompanion(walletId).copyWith(id: const Value.absent());
    final database = _budgetDao.attachedDatabase;
    await database.transaction(() async {
      final id = await _budgetDao.insertBudget(companion);
      final row = await _budgetDao.getBudgetById(id, walletId);
      await _insertAuditEvent(action: 'BUDGET_CREATED', entityId: id, entityUuid: row?.uuid);
    });
  }

  @override
  Future<void> deleteBudget(int id) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageBudgets(r),
      actorAccountId: actorAccountId,
      actionName: 'manage budgets',
    );
    final existing = await _budgetDao.getBudgetById(id, walletId);
    final database = _budgetDao.attachedDatabase;
    await database.transaction(() async {
      final deleted = await _budgetDao.deleteBudget(id, walletId);
      if (deleted > 0 && existing != null) {
        await _insertAuditEvent(action: 'BUDGET_DELETED', entityId: id, entityUuid: existing.uuid);
      }
    });
  }

  @override
  Future<void> updateBudget(Budget budget) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageBudgets(r),
      actorAccountId: actorAccountId,
      actionName: 'manage budgets',
    );
    final companion = budget.toCompanion(walletId);
    final database = _budgetDao.attachedDatabase;
    await database.transaction(() async {
      final updated = await _budgetDao.updateBudget(walletId, companion);
      if (updated) {
        final row = await _budgetDao.getBudgetById(budget.id, walletId);
        await _insertAuditEvent(action: 'BUDGET_UPDATED', entityId: budget.id, entityUuid: row?.uuid);
      }
    });
  }

  @override
  Stream<List<Budget>> watchAllBudgets() {
    return _budgetDao.watchBudgetsWithCategory(walletId).map((dbBudgets) {
      return dbBudgets.map((dbBudget) => dbBudget.toDomain()).toList();
    });
  }
}
