import 'package:expense_tracker/features/security/presentation/app_lock_wrapper.dart';
import 'package:expense_tracker/core/domain/brand_assets.dart';
import 'package:expense_tracker/core/theme/app_theme.dart';
import 'package:expense_tracker/core/presentation/main_screen.dart';
import 'package:expense_tracker/features/notifications/data/notification_provider.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/core/services/auto_backup.dart';
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
  bool _startupComplete = false;

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
    if (mounted) {
      setState(() {
        _startupComplete = true;
      });
    }
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
        await notificationService.scheduleMonthlySummary();
        await prefs.setString('lastNotificationBootstrapDay', todayKey);
      }

      if (recurringKey != todayKey) {
        await ref.read(processRecurringTransactionsUseCaseProvider).call();
        await prefs.setString('lastRecurringBootstrapDay', todayKey);
      }

      // Automatic backup: writes at most once per configured interval.
      final autoBackupKey = prefs.getString('lastAutoBackupCheckDay');
      if (autoBackupKey != todayKey) {
        try {
          final settings = AutoBackupSettings.load(prefs);
          await ref
              .read(autoBackupServiceProvider)
              .runIfDue(settings: settings, prefs: prefs);
        } catch (e) {
          debugPrint('Auto backup failed: $e');
        }
        await prefs.setString('lastAutoBackupCheckDay', todayKey);
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
      title: 'Vittix Wallet',
      theme: VittixTheme.light(),
      darkTheme: VittixTheme.dark(),
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      home: _startupComplete
          ? const AppLockWrapper(child: MainScreen())
          : const _BrandSplashScreen(),
    );
  }
}

class _BrandSplashScreen extends StatelessWidget {
  const _BrandSplashScreen();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF071524),
              Color(0xFF0B1F3A),
              Color(0xFF12315A),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                  ),
                  child: const BrandLogo(size: 112),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Vittix Wallet',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Personal & Family Finance Simplified',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Color(0xFFD7E3F5)),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: 180,
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(99),
                    backgroundColor: Colors.white.withValues(alpha: 0.12),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5AD84F)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
