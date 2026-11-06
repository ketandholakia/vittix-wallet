part of '../app_database.dart';

@DriftAccessor(tables: [WalletGoals, WalletGoalContributions, WalletGoalSchedules])
class GoalDao extends DatabaseAccessor<AppDatabase> with _$GoalDaoMixin {
  GoalDao(super.db);

  Stream<List<WalletGoal>> watchGoals(int walletId) {
    return (select(walletGoals)..where((g) => g.walletId.equals(walletId))).watch();
  }

  Future<List<WalletGoal>> getGoalsForWallet(int walletId) {
    return (select(walletGoals)..where((g) => g.walletId.equals(walletId))).get();
  }

  Future<WalletGoal?> getGoalById(int id, [int? walletId]) {
    final query = select(walletGoals)..where((g) => g.id.equals(id));
    if (walletId != null) {
      query.where((g) => g.walletId.equals(walletId));
    }
    return query.getSingleOrNull();
  }

  Future<int> insertGoal(Insertable<WalletGoal> goal, [int? walletId]) async {
    if (walletId != null) {
      if (goal is WalletGoalsCompanion && goal.walletId.present) {
        if (goal.walletId.value != walletId) {
          throw const WalletPermissionDeniedException('Cannot create goal for another wallet.');
        }
      }
    }
    return into(walletGoals).insert(goal);
  }

  Future<bool> updateGoal(Insertable<WalletGoal> companion, [int? walletId]) async {
    if (walletId == null) {
      return update(walletGoals).replace(companion);
    }
    int? id;
    if (companion is WalletGoal) {
      id = companion.id;
    } else if (companion is WalletGoalsCompanion && companion.id.present) {
      id = companion.id.value;
    }
    if (id == null) return false;

    final query = update(walletGoals)..where((g) => g.id.equals(id!) & g.walletId.equals(walletId));
    final count = await query.write(companion);
    return count > 0;
  }

  Future<int> deleteGoal(int id, [int? walletId]) async {
    final query = delete(walletGoals)..where((g) => g.id.equals(id));
    if (walletId != null) {
      query.where((g) => g.walletId.equals(walletId));
    }
    return query.go();
  }

  Stream<List<WalletGoalContribution>> watchContributionsForGoal(int goalId, [int? walletId]) {
    final query = select(walletGoalContributions)..where((c) => c.goalId.equals(goalId));
    if (walletId != null) {
      query.where((c) => c.walletId.equals(walletId));
    }
    return query.watch();
  }

  Stream<List<WalletGoalContribution>> watchContributionsForWallet(int walletId) {
    return (select(walletGoalContributions)..where((c) => c.walletId.equals(walletId))).watch();
  }

  Future<List<WalletGoalContribution>> getContributionsForWallet(int walletId) {
    return (select(walletGoalContributions)..where((c) => c.walletId.equals(walletId))).get();
  }

  Future<int> addContribution(Insertable<WalletGoalContribution> contribution, [int? walletId]) async {
    if (walletId != null) {
      if (contribution is WalletGoalContributionsCompanion && contribution.walletId.present) {
        if (contribution.walletId.value != walletId) {
          throw const WalletPermissionDeniedException('Cannot add contribution for another wallet.');
        }
      }
      int? goalId;
      if (contribution is WalletGoalContribution) {
        goalId = contribution.goalId;
      } else if (contribution is WalletGoalContributionsCompanion && contribution.goalId.present) {
        goalId = contribution.goalId.value;
      }
      if (goalId != null) {
        final goal = await getGoalById(goalId, walletId);
        if (goal == null) {
          throw const WalletPermissionDeniedException('Target goal does not belong to the target wallet.');
        }
      }
    }

    return transaction(() async {
      final id = await into(walletGoalContributions).insert(contribution);

      double amount = 0;
      int goalId = 0;
      if (contribution is WalletGoalContribution) {
        amount = contribution.amount;
        goalId = contribution.goalId;
      } else if (contribution is WalletGoalContributionsCompanion) {
        amount = contribution.amount.value;
        goalId = contribution.goalId.value;
      }

      if (goalId > 0 && amount > 0) {
        final goal = await getGoalById(goalId);
        if (goal != null) {
          await (update(walletGoals)..where((g) => g.id.equals(goalId))).write(
            WalletGoalsCompanion(
              currentAmount: Value(goal.currentAmount + amount),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
      }

      return id;
    });
  }

  Future<int> deleteContribution(int id, [int? walletId]) async {
    final query = delete(walletGoalContributions)..where((c) => c.id.equals(id));
    if (walletId != null) {
      query.where((c) => c.walletId.equals(walletId));
    }
    return query.go();
  }

  Stream<List<WalletGoalSchedule>> watchSchedulesForWallet(int walletId) {
    final query = select(walletGoalSchedules).join([
      innerJoin(walletGoals, walletGoals.id.equalsExp(walletGoalSchedules.walletGoalId)),
    ])..where(walletGoals.walletId.equals(walletId));

    return query.watch().map((rows) => rows.map((r) => r.readTable(walletGoalSchedules)).toList());
  }

  Future<List<WalletGoalSchedule>> getSchedulesForWallet(int walletId) async {
    final query = select(walletGoalSchedules).join([
      innerJoin(walletGoals, walletGoals.id.equalsExp(walletGoalSchedules.walletGoalId)),
    ])..where(walletGoals.walletId.equals(walletId));

    final rows = await query.get();
    return rows.map((r) => r.readTable(walletGoalSchedules)).toList();
  }

  Future<int> addSchedule(Insertable<WalletGoalSchedule> schedule, [int? walletId]) async {
    if (walletId != null) {
      int? goalId;
      if (schedule is WalletGoalSchedule) {
        goalId = schedule.walletGoalId;
      } else if (schedule is WalletGoalSchedulesCompanion && schedule.walletGoalId.present) {
        goalId = schedule.walletGoalId.value;
      }
      if (goalId != null) {
        final goal = await getGoalById(goalId, walletId);
        if (goal == null) {
          throw const WalletPermissionDeniedException('Target goal does not belong to the target wallet.');
        }
      }
    }
    return into(walletGoalSchedules).insert(schedule);
  }

  Future<int> deleteSchedule(int id, [int? walletId]) async {
    if (walletId == null) {
      return (delete(walletGoalSchedules)..where((s) => s.id.equals(id))).go();
    }
    final allowedGoalIds = selectOnly(walletGoals)
      ..addColumns([walletGoals.id])
      ..where(walletGoals.walletId.equals(walletId));

    final query = delete(walletGoalSchedules)
      ..where((s) => s.id.equals(id) & s.walletGoalId.isInQuery(allowedGoalIds));

    return query.go();
  }

  Future<void> logGoalActivity({required int walletId, required String action, required int goalId, int? actorAccountId}) async {
    // Log goal activity helper if needed
  }
}


