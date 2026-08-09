import 'package:expense_tracker/features/accounts/domain/account_repository.dart';

class DeleteAccount {
  final AccountRepository repository;

  DeleteAccount(this.repository);

  Future<void> call(int id) => repository.deleteAccount(id);
}
