part of '../app_database.dart';

@DriftAccessor(tables: [Tags, Transactions])

@DriftAccessor(tables: [Payees])
class PayeeDao extends DatabaseAccessor<AppDatabase> with _$PayeeDaoMixin {
  PayeeDao(AppDatabase db) : super(db);
  Stream<List<Payee>> watchPayees() => select(attachedDatabase.payees).watch();
  Future<int> insertPayee(Insertable<Payee> payee) => into(attachedDatabase.payees).insert(payee);
}
