import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/features/transactions/data/tables/merchant_mappings_table.dart';
import 'package:expense_tracker/features/transactions/data/tables/unrecognized_sms_table.dart';

part 'sms_parsing_dao.g.dart';

@DriftAccessor(tables: [MerchantMappings, UnrecognizedSmsEntries])
class SmsParsingDao extends DatabaseAccessor<AppDatabase> with _$SmsParsingDaoMixin {
  SmsParsingDao(AppDatabase db) : super(db);

  Future<List<MerchantMapping>> getMerchantMappings(int walletId) {
    return (select(merchantMappings)..where((t) => t.walletId.equals(walletId))).get();
  }

  Stream<List<MerchantMapping>> watchMerchantMappings(int walletId) {
    return (select(merchantMappings)..where((t) => t.walletId.equals(walletId))).watch();
  }

  /// Inserts a merchant mapping after validating the walletId in the companion and caller permissions.
  /// Returns the inserted row ID, or throws if the walletId is invalid or permission is denied.
  Future<int> insertMerchantMapping(
    MerchantMappingsCompanion mapping, {
    required int authorizedWalletId,
    int? actorAccountId,
  }) async {
    // Extract and validate walletId from the companion.
    final mappingWalletId = mapping.walletId.present ? mapping.walletId.value : null;
    if (mappingWalletId != authorizedWalletId) {
      throw WalletPermissionDeniedException(
        'Cannot insert merchant mapping for wallet $mappingWalletId: '
        'authorized wallet is $authorizedWalletId.',
      );
    }

    await attachedDatabase.walletDao.checkPermission(
      walletId: authorizedWalletId,
      permissionCheck: (s, r) => s.canManageMerchantMappings(r),
      actorAccountId: actorAccountId,
      actionName: 'manage merchant mappings',
    );

    return into(merchantMappings).insert(mapping);
  }

  /// Updates a merchant mapping only if it belongs to the authorized wallet and caller has permission.
  /// Uses WHERE id = ? AND wallet_id = ? to prevent cross-wallet mutation.
  Future<bool> updateMerchantMapping(
    Insertable<MerchantMapping> mapping, {
    required int authorizedWalletId,
    int? actorAccountId,
  }) async {
    await attachedDatabase.walletDao.checkPermission(
      walletId: authorizedWalletId,
      permissionCheck: (s, r) => s.canManageMerchantMappings(r),
      actorAccountId: actorAccountId,
      actionName: 'manage merchant mappings',
    );

    // Extract the ID from the mapping.
    int? id;
    if (mapping is MerchantMapping) {
      id = mapping.id;
    } else if (mapping is MerchantMappingsCompanion && mapping.id.present) {
      id = mapping.id.value;
    }
    if (id == null) return false;

    final existing = await (select(merchantMappings)
          ..where((t) => t.id.equals(id!) & t.walletId.equals(authorizedWalletId)))
        .getSingleOrNull();
    if (existing == null) return false;

    final count = await (update(merchantMappings)
          ..where((t) => t.id.equals(id!) & t.walletId.equals(authorizedWalletId)))
        .write(mapping);
    return count > 0;
  }

  /// Deletes a merchant mapping only if it belongs to the authorized wallet and caller has permission.
  Future<int> deleteMerchantMapping(
    int id, {
    required int authorizedWalletId,
    int? actorAccountId,
  }) async {
    await attachedDatabase.walletDao.checkPermission(
      walletId: authorizedWalletId,
      permissionCheck: (s, r) => s.canManageMerchantMappings(r),
      actorAccountId: actorAccountId,
      actionName: 'manage merchant mappings',
    );

    return (delete(merchantMappings)
          ..where((t) => t.id.equals(id) & t.walletId.equals(authorizedWalletId)))
        .go();
  }

  Future<int> insertUnrecognizedSms(
    UnrecognizedSmsEntriesCompanion entry, {
    int? authorizedWalletId,
  }) {
    if (authorizedWalletId != null && entry.walletId.present && entry.walletId.value != authorizedWalletId) {
      throw WalletPermissionDeniedException(
        'Cannot insert unrecognized SMS for wallet ${entry.walletId.value}: '
        'authorized wallet is $authorizedWalletId.',
      );
    }
    return into(unrecognizedSmsEntries).insert(entry);
  }
  
  Stream<List<UnrecognizedSms>> watchUnresolvedSms(int walletId) {
    return (select(unrecognizedSmsEntries)
          ..where((t) => t.walletId.equals(walletId))
          ..where((t) => t.isResolved.equals(false))
          ..orderBy([(t) => OrderingTerm(expression: t.receivedAt, mode: OrderingMode.desc)]))
        .watch();
  }

  /// Marks an SMS as resolved only if it belongs to the authorized wallet.
  Future<int> markSmsResolved(int id, {required int authorizedWalletId}) {
    return (update(unrecognizedSmsEntries)
          ..where((t) => t.id.equals(id) & t.walletId.equals(authorizedWalletId)))
        .write(const UnrecognizedSmsEntriesCompanion(isResolved: Value(true)));
  }

  /// Deletes an unrecognized SMS only if it belongs to the authorized wallet.
  Future<int> deleteUnrecognizedSms(int id, {required int authorizedWalletId}) {
    return (delete(unrecognizedSmsEntries)
          ..where((t) => t.id.equals(id) & t.walletId.equals(authorizedWalletId)))
        .go();
  }

  Future<int> clearUnrecognizedSms(int walletId) {
    return (delete(unrecognizedSmsEntries)..where((t) => t.walletId.equals(walletId))).go();
  }
}
