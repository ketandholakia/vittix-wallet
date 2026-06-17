import 'package:expense_tracker/app_lock_wrapper.dart';
import 'package:expense_tracker/app_theme.dart';
import 'package:expense_tracker/main_screen.dart';
import 'package:expense_tracker/notification_provider.dart';
import 'package:expense_tracker/settings_providers.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  final startup = Stopwatch()..start();
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    debugPrint('Flutter binding initialized in ${startup.elapsedMilliseconds}ms');
  }
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      debugPrint('MyApp initState at ${DateTime.now().toIso8601String()}');
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _deferStartupWork());
  }

  Future<void> _deferStartupWork() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    await _initNotificationsAndRecurringWork();
  }

  Future<void> _initNotificationsAndRecurringWork() async {
    final startup = Stopwatch()..start();
    try {
      final prefs = await SharedPreferences.getInstance();
      final todayKey = DateTime.now().toIso8601String().substring(0, 10);
      final scheduledKey = prefs.getString('lastNotificationBootstrapDay');
      final recurringKey = prefs.getString('lastRecurringBootstrapDay');
      final notificationService = ref.read(notificationServiceProvider);

      if (scheduledKey != todayKey) {
        await notificationService.init();
        await notificationService.requestPermissions();
        await notificationService.scheduleDailyReminder();
        await prefs.setString('lastNotificationBootstrapDay', todayKey);
      }

      if (recurringKey != todayKey) {
        await ref.read(processRecurringTransactionsUseCaseProvider).call();
        await prefs.setString('lastRecurringBootstrapDay', todayKey);
      }

      if (kDebugMode) {
        debugPrint('Background startup work finished in ${startup.elapsedMilliseconds}ms');
      }
    } catch (e, stack) {
      debugPrint('Background startup work failed: $e\n$stack');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Expense Tracker',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      home: const AppLockWrapper(child: MainScreen()),
    );
  }
}
