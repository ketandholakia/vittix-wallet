import 'package:drift/drift.dart';
import 'package:expense_tracker/features/accounts/data/account_mapper.dart';
import 'package:expense_tracker/data/local/app_database.dart' as db;
import 'package:expense_tracker/data/local/mappers/category_mapper.dart';
import 'package:expense_tracker/domain/entities/transaction.dart' as domain;

extension TransactionWithDetailsMapper on db.TransactionWithDetails {
  domain.Transaction toDomain() {
    return domain.Transaction(
      id: transaction.id,
      amount: transaction.amount,
      date: transaction.date,
      note: transaction.note,
      type: domain.TransactionType.values.byName(transaction.type.name),
      category: category.toDomain(),
      account: account.toDomain(),
      // payee: payee != null ? domain.Payee(id: payee!.id, name: payee!.name) : null,
      tags: [], // tags.map((t) => domain.Tag(id: t.id, name: t.name, color: t.color)).toList(),
      attachments: [], // attachments.map((a) => domain.Attachment(id: a.id, filePath: a.filePath, fileType: a.fileType)).toList(),
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
    );
  }
}

extension TransactionDomainMapper on domain.Transaction {
  db.TransactionsCompanion toCompanion() {
    return db.TransactionsCompanion(
      id: Value(id),
      amount: Value(amount),
      date: Value(date),
      note: Value(note),
      type: Value(db.TransactionType.values.byName(type.name)),
      categoryId: Value(category.id),
      accountId: Value(account.id),
      // payeeId: Value(payee?.id),
    );
  }
}
