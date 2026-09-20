import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/features/family/domain/wallet_permissions.dart';

abstract class GoalRepository {
  Stream<List<WalletGoal>> watchGoals();
  Future<List<WalletGoal>> getGoals();
  Future<WalletGoal?> getGoalById(int id);
  Future<int> addGoal(Insertable<WalletGoal> goal, {int? actorAccountId});
  Future<bool> updateGoal(Insertable<WalletGoal> goal, {int? actorAccountId});
  Future<int> deleteGoal(int id, {int? actorAccountId});

  Stream<List<WalletGoalContribution>> watchContributionsForGoal(int goalId);
  Stream<List<WalletGoalContribution>> watchContributions();
  Future<List<WalletGoalContribution>> getContributions();
  Future<int> addContribution(Insertable<WalletGoalContribution> contribution, {int? actorAccountId});
  Future<int> deleteContribution(int id, {int? actorAccountId});

  Stream<List<WalletGoalSchedule>> watchSchedules();
  Future<List<WalletGoalSchedule>> getSchedules();
  Future<int> addSchedule(Insertable<WalletGoalSchedule> schedule, {int? actorAccountId});
  Future<int> deleteSchedule(int id, {int? actorAccountId});
}

class GoalRepositoryImpl implements GoalRepository {
  final GoalDao _goalDao;
  final int walletId;
  final WalletDao? _walletDao;

  GoalRepositoryImpl(this._goalDao, this.walletId, [this._walletDao]);

  @override
  Stream<List<WalletGoal>> watchGoals() {
    return _goalDao.watchGoals(walletId);
  }

  @override
  Future<List<WalletGoal>> getGoals() {
    return _goalDao.getGoalsForWallet(walletId);
  }

  @override
  Future<WalletGoal?> getGoalById(int id) {
    return _goalDao.getGoalById(id, walletId);
  }

  @override
  Future<int> addGoal(Insertable<WalletGoal> goal, {int? actorAccountId}) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageGoals(r),
      actorAccountId: actorAccountId,
      actionName: 'manage goals',
    );
    return _goalDao.insertGoal(goal, walletId);
  }

  @override
  Future<bool> updateGoal(Insertable<WalletGoal> goal, {int? actorAccountId}) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageGoals(r),
      actorAccountId: actorAccountId,
      actionName: 'manage goals',
    );
    return _goalDao.updateGoal(goal, walletId);
  }

  @override
  Future<int> deleteGoal(int id, {int? actorAccountId}) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageGoals(r),
      actorAccountId: actorAccountId,
      actionName: 'manage goals',
    );
    return _goalDao.deleteGoal(id, walletId);
  }

  @override
  Stream<List<WalletGoalContribution>> watchContributionsForGoal(int goalId) {
    return _goalDao.watchContributionsForGoal(goalId, walletId);
  }

  @override
  Stream<List<WalletGoalContribution>> watchContributions() {
    return _goalDao.watchContributionsForWallet(walletId);
  }

  @override
  Future<List<WalletGoalContribution>> getContributions() {
    return _goalDao.getContributionsForWallet(walletId);
  }

  @override
  Future<int> addContribution(Insertable<WalletGoalContribution> contribution, {int? actorAccountId}) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canContributeToGoals(r),
      actorAccountId: actorAccountId,
      actionName: 'contribute to goals',
    );
    return _goalDao.addContribution(contribution, walletId);
  }

  @override
  Future<int> deleteContribution(int id, {int? actorAccountId}) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canContributeToGoals(r),
      actorAccountId: actorAccountId,
      actionName: 'contribute to goals',
    );
    return _goalDao.deleteContribution(id, walletId);
  }

  @override
  Stream<List<WalletGoalSchedule>> watchSchedules() {
    return _goalDao.watchSchedulesForWallet(walletId);
  }

  @override
  Future<List<WalletGoalSchedule>> getSchedules() {
    return _goalDao.getSchedulesForWallet(walletId);
  }

  @override
  Future<int> addSchedule(Insertable<WalletGoalSchedule> schedule, {int? actorAccountId}) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageGoals(r),
      actorAccountId: actorAccountId,
      actionName: 'manage goal schedules',
    );
    return _goalDao.addSchedule(schedule, walletId);
  }

  @override
  Future<int> deleteSchedule(int id, {int? actorAccountId}) async {
    await _walletDao?.checkPermission(
      walletId: walletId,
      permissionCheck: (s, r) => s.canManageGoals(r),
      actorAccountId: actorAccountId,
      actionName: 'manage goal schedules',
    );
    return _goalDao.deleteSchedule(id, walletId);
  }
}
