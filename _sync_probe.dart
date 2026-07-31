import 'dart:convert';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/app_database.dart';
import 'package:expense_tracker/sync_service.dart';
import 'package:expense_tracker/database_provider.dart';

Future<void> main() async {
  SharedPreferences.setMockInitialValues({'isSimulatedSync': true});
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  final container = ProviderContainer(overrides: [databaseProvider.overrideWithValue(db)]);
  final originalTime = DateTime(2026, 6, 1, 10, 0, 0);
  await db.into(db.categories).insert(CategoriesCompanion.insert(uuid: const Value('cat-lww-1'), name: 'Old Local Name', icon: 1, color: 'FFFFFF', updatedAt: Value(originalTime)));
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('simulated_server_state', jsonEncode({
    'accounts': [],
    'categories': [
      {'uuid': 'cat-lww-1','name': 'New Remote Name','icon': 1,'color': '00FF00','isDefault': false,'parentUuid': null,'updatedAt': DateTime(2026,6,1,12,0,0).millisecondsSinceEpoch}
    ],
    'transactions': [],
    'budgets': [],
    'recurring_transactions': [],
    'deletions': [],
  }));
  await container.read(syncStateProvider.notifier).performSync();
  final state = container.read(syncStateProvider);
  print(state.status);
  print(state.errorMessage);
  await db.close();
  container.dispose();
}
