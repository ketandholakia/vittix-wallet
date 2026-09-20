import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

/// A person who can own or join wallets (backlog item A7).
///
/// Deliberately separate from [Accounts]: an account is a *money* container
/// ("Cash", "HDFC Card"), whereas a user is an identity. Conflating them was why
/// real multi-user collaboration could not be built — `WalletMembers` pointed at
/// money accounts, so "who did this" meant "which account".
///
/// Users are global rather than wallet-scoped, because one person can belong to
/// several wallets.
@DataClassName('User')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();

  /// Name shown in member lists, split sheets and audit entries.
  TextColumn get displayName => text()();

  /// Optional contact detail for invitations. Null when the user was created
  /// locally without an address.
  TextColumn get email => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
