import 'package:drift/drift.dart';
import 'package:expense_tracker/data/local/app_database.dart' as db;
import 'package:expense_tracker/features/recurring/domain/recurring_transaction.dart';
import 'package:expense_tracker/features/recurring/data/recurring_transaction_mapper.dart';
import 'package:expense_tracker/features/recurring/data/recurring_transaction_repository.dart';

class RecurringTransactionRepositoryImpl implements RecurringTransactionRepository {
  final db.RecurringTransactionDao _dao;
  final db.WalletDao _walletDao;
  final int walletId;

  /// Actor identity injected from application context (not per-call).
  /// Null when no authenticated user context exists (e.g. background operations).
  final int? actorAccountId;

  RecurringTransactionRepositoryImpl(
    this._dao,
    this._walletDao,
    this.walletId, {
    this.actorAccountId,
  });

  Future<void> _insertAuditEvent({
    required String action,
    required int entityId,
    String? entityUuid,
    String source = 'user',
  }) async {
    final effectiveActor = source == 'user' ? actorAccountId : null;
    await _walletDao.insertActivity(
      db.WalletActivitiesCompanion.insert(
        walletId: walletId,
        action: action,
        entityType: 'recurring_transaction',
        entityId: entityId,
        entityUuid: db.Value(entityUuid),
        source: source,
      ),
      walletId,
      actorAccountId: effectiveActor,
    );
  }

  /// Checks if the wallet has any active membership with the required permission.
  /// This is a wallet-level check (no specific actor) that ensures the wallet
  /// is accessible and has at least one active member with the required role.
  Future<void> _checkManagePermission() async {
    final hasActiveMember = await _walletDao.hasActiveMemberWithPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageRecurringTransactions(r),
    );
    if (!hasActiveMember) {
      throw db.WalletPermissionDeniedException(
        'Permission denied: Wallet $walletId does not have any active member with permission to manage recurring transactions.',
      );
    }
  }

  /// Validates that the referenced account belongs to the same wallet as the
  /// recurring transaction. Rejects cross-wallet account references.
  Future<void> _validateAccountBelongsToWallet(int accountId) async {
    final accountWalletId = await _dao.getAccountWalletId(accountId);
    if (accountWalletId == null) {
      throw db.WalletPermissionDeniedException(
        'Account $accountId does not exist.',
      );
    }
    if (accountWalletId != walletId) {
      throw db.WalletPermissionDeniedException(
        'Recurring transaction wallet ($walletId) does not match account wallet ($accountWalletId). Cross-wallet account references are not allowed.',
      );
    }
  }

  @override
  Stream<List<RecurringTransaction>> watchAll() {
    return _dao.watchAllWithDetails(walletId).map((rows) {
      return rows.map((row) => row.toDomain()).toList();
    });
  }

  @override
  Future<void> add(RecurringTransaction template) async {
    await _checkManagePermission();
    await _validateAccountBelongsToWallet(template.account.id);
    final companion = template.toCompanion(overrideWalletId: walletId).copyWith(id: const Value.absent());
    final database = _dao.attachedDatabase;
    await database.transaction(() async {
      final id = await _dao.insertTemplate(companion, walletId);
      final row = await _dao.getById(id, walletId);
      await _insertAuditEvent(
        action: 'RECURRING_TRANSACTION_CREATED',
        entityId: id,
        entityUuid: row?.template.uuid,
      );
    });
  }

  @override
  Future<void> update(RecurringTransaction template) async {
    await _checkManagePermission();
    await _validateAccountBelongsToWallet(template.account.id);
    final companion = template.toCompanion(overrideWalletId: walletId);
    final database = _dao.attachedDatabase;
    await database.transaction(() async {
      final success = await _dao.updateTemplateVerified(companion, walletId);
      if (!success) {
        throw db.WalletPermissionDeniedException(
          'Recurring transaction ${template.id} does not belong to wallet $walletId or does not exist.',
        );
      }
      final row = await _dao.getById(template.id, walletId);
      await _insertAuditEvent(
        action: 'RECURRING_TRANSACTION_UPDATED',
        entityId: template.id,
        entityUuid: row?.template.uuid,
      );
    });
  }

  @override
  Future<void> delete(int id) async {
    await _checkManagePermission();
    final existing = await _dao.getById(id, walletId);
    final database = _dao.attachedDatabase;
    await database.transaction(() async {
      final deleted = await _dao.deleteTemplate(id, walletId);
      if (deleted > 0) {
        await _insertAuditEvent(
          action: 'RECURRING_TRANSACTION_DELETED',
          entityId: id,
          entityUuid: existing?.template.uuid,
        );
      }
    });
  }

  @override
  Future<List<RecurringTransaction>> getActiveTemplates() async {
    final rows = await _dao.getActiveTemplatesWithDetails(walletId);
    return rows.map((row) => row.toDomain()).toList();
  }
}
