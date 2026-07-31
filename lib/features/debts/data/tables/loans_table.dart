import 'package:drift/drift.dart';
import 'package:expense_tracker/features/accounts/data/tables/accounts_table.dart';
import 'package:expense_tracker/features/family/data/tables/wallets_table.dart';
import 'package:uuid/uuid.dart';

@DataClassName('LoanDb')
class Loans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId => integer().withDefault(const Constant(1))();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get accountId => integer().references(Accounts, #id, onDelete: KeyAction.cascade)();
  RealColumn get principalAmount => real()();
  RealColumn get interestRate => real()();
  IntColumn get tenureMonths => integer()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get nextEmiDate => dateTime().nullable()();
  RealColumn get emiAmount => real()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
}
