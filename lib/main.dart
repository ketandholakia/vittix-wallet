import 'package:expense_tracker/core/database/sqlcipher_loader.dart';
import 'package:expense_tracker/features/security/presentation/app_lock_wrapper.dart';
import 'package:expense_tracker/core/domain/brand_assets.dart';
import 'package:expense_tracker/core/theme/app_theme.dart';
import 'package:expense_tracker/core/presentation/main_screen.dart';
import 'package:expense_tracker/features/notifications/data/notification_provider.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:expense_tracker/core/providers/database_provider.dart';
import 'package:expense_tracker/core/providers/usecase_providers.dart';
import 'package:expense_tracker/core/services/auto_backup.dart';
import 'package:expense_tracker/core/utils/app_logger.dart';
import 'package:expense_tracker/features/security/presentation/database_recovery_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';

Future<void> main() async {
  final startup = Stopwatch()..start();
  WidgetsFlutterBinding.ensureInitialized();

  // A3: load the SQLCipher build before any database is opened. The workaround
  // needs the Flutter engine (platform channel), so it runs here; the plain
  // override is also applied inside the database isolate by `_openConnection`.
  await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
  useSqlCipher();

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
    // No fixed delay: wait for the first rendered frame, then for the database
    // to be genuinely ready (open + migrated).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onFirstFrame();
    });
  }

  Future<void> _onFirstFrame() async {
    final ready = await _waitForDatabaseReady();
    if (!mounted) return;
    setState(() => _startupComplete = true);
    if (ready) {
      // Runs after the UI is interactive; each job has its own gate and error
      // handling, so one failure cannot skip the others.
      await _runStartupWork();
    }
  }

  /// Opens the database (running migrations) and verifies it responds.
  ///
  /// Returns false when the database could not be opened; the UI shows the
  /// recovery screen in that case and background work must not run.
  Future<bool> _waitForDatabaseReady() async {
    try {
      await ref.read(databaseOpenPlanProvider.future);
      await ref.read(databaseProvider).customSelect('SELECT 1').get();
      return true;
    } on Object catch (error, stackTrace) {
      AppLogger.error('Database is not ready at startup', error, stackTrace);
      return false;
    }
  }

  Future<void> _runStartupWork() async {
    final startup = Stopwatch()..start();
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);

    await _runOncePerDay(
      prefs,
      key: 'lastNotificationBootstrapDay',
      today: today,
      label: 'notification setup',
      action: () async {
        final service = ref.read(notificationServiceProvider);
        await service.init();
        await service.requestPermissions();
        await service.scheduleDailyReminder();
        await service.scheduleMonthlySummary();
      },
    );

    await _runOncePerDay(
      prefs,
      key: 'lastRecurringBootstrapDay',
      today: today,
      label: 'recurring transactions',
      action: () => ref.read(processRecurringTransactionsUseCaseProvider).call(),
    );

    await _runOncePerDay(
      prefs,
      key: 'lastAutoBackupCheckDay',
      today: today,
      label: 'automatic backup',
      action: () async {
        final settings = AutoBackupSettings.load(prefs);
        await ref
            .read(autoBackupServiceProvider)
            .runIfDue(settings: settings, prefs: prefs);
      },
    );

    if (kDebugMode) {
      debugPrint(
        'Background startup work finished in '
        '${startup.elapsedMilliseconds}ms',
      );
    }
  }

  Future<void> _runOncePerDay(
    SharedPreferences prefs, {
    required String key,
    required String today,
    required String label,
    required Future<void> Function() action,
  }) async {
    if (prefs.getString(key) == today) return;
    try {
      await action();
      await prefs.setString(key, today);
    } on Object catch (error, stackTrace) {
      AppLogger.error('Startup $label failed', error, stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    // Database key resolution must finish before any screen touches the
    // database. An encrypted database whose key cannot open it shows the
    // recovery screen instead of silently running on a plaintext file.
    final openPlan = ref.watch(databaseOpenPlanProvider);
    return MaterialApp(
      title: 'Vittix Wallet',
      theme: VittixTheme.light(),
      darkTheme: VittixTheme.dark(),
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final warning = ref.watch(databaseEncryptionWarningProvider);
        if (warning == null || child == null) {
          return child ?? const SizedBox.shrink();
        }
        return _EncryptionWarningBanner(message: warning, child: child);
      },
      home: openPlan.when(
        loading: () => const _BrandSplashScreen(),
        error: (error, stackTrace) => DatabaseRecoveryScreen(error: error),
        data: (_) => _startupComplete
            ? const AppLockWrapper(child: MainScreen())
            : const _BrandSplashScreen(),
      ),
    );
  }
}

/// Persistent, non-dismissible banner shown while the database is unencrypted.
class _EncryptionWarningBanner extends StatelessWidget {
  const _EncryptionWarningBanner({required this.message, required this.child});

  final String message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Material(
          color: colors.errorContainer,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 18,
                    color: colors.onErrorContainer,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(child: child),
      ],
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
