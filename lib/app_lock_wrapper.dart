import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/lock_screen.dart';
import 'package:expense_tracker/settings_providers.dart';

class AppLockWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const AppLockWrapper({super.key, required this.child});

  @override
  ConsumerState<AppLockWrapper> createState() => _AppLockWrapperState();
}

class _AppLockWrapperState extends ConsumerState<AppLockWrapper> with WidgetsBindingObserver {
  DateTime? _pausedTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final isPinEnabled = ref.read(pinLockEnabledProvider);
    final hasPin = ref.read(pinHashProvider) != null;

    if (!isPinEnabled || !hasPin) return;

    if (state == AppLifecycleState.paused) {
      _pausedTime = clock.now();
    } else if (state == AppLifecycleState.resumed) {
      if (_pausedTime != null) {
        final elapsed = clock.now().difference(_pausedTime!);
        if (elapsed.inSeconds >= 5) {
          ref.read(appLockStateProvider.notifier).lock();
        }
        _pausedTime = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLocked = ref.watch(appLockStateProvider);
    final isPinEnabled = ref.watch(pinLockEnabledProvider);
    final hasPin = ref.watch(pinHashProvider) != null;

    if (isLocked && isPinEnabled && hasPin) {
      return const LockScreen(
        mode: LockScreenMode.unlock,
      );
    }

    return widget.child;
  }
}
