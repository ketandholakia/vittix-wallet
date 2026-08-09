import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:expense_tracker/features/settings/presentation/settings_providers.dart';
import 'package:expense_tracker/features/security/presentation/security_providers.dart';

enum LockScreenMode { unlock, setup, verify }

class LockScreen extends ConsumerStatefulWidget {
  final LockScreenMode mode;
  final ValueChanged<String>? onSuccess;
  final VoidCallback? onCancel;

  const LockScreen({
    super.key,
    required this.mode,
    this.onSuccess,
    this.onCancel,
  });

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  String _inputPin = '';
  String? _setupFirstPin;
  String _instructionText = '';
  bool _isError = false;
  String? _errorMessage;
  bool _deviceSupportsBiometrics = false;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -12.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: -12.0, end: 12.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 12.0, end: -8.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: -8.0, end: 8.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 8.0, end: -4.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: -4.0, end: 4.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 4.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));

    _initInstruction();
    _checkBiometricsSupport();

    if (widget.mode == LockScreenMode.unlock) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Trigger auto-auth after a tiny delay so the UI settles
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            _authenticateWithBiometrics();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _initInstruction() {
    switch (widget.mode) {
      case LockScreenMode.unlock:
        _instructionText = 'Enter PIN to Unlock';
        break;
      case LockScreenMode.setup:
        _instructionText = 'Choose a 4-digit PIN';
        break;
      case LockScreenMode.verify:
        _instructionText = 'Enter Current PIN';
        break;
    }
  }

  Future<void> _checkBiometricsSupport() async {
    if (widget.mode != LockScreenMode.unlock) return;
    final auth = LocalAuthentication();
    try {
      final canCheck = await auth.canCheckBiometrics;
      final isSupported = await auth.isDeviceSupported();
      setState(() {
        _deviceSupportsBiometrics = canCheck || isSupported;
      });
    } catch (e) {
      debugPrint('Error checking biometrics support: $e');
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    final isBiometricsEnabled = ref.read(biometricsEnabledProvider);
    if (!isBiometricsEnabled) return;

    final auth = LocalAuthentication();
    try {
      final authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to unlock your expense tracker',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );

      if (authenticated) {
        HapticFeedback.mediumImpact();
        ref.read(appLockStateProvider.notifier).unlock();
        widget.onSuccess?.call('');
      }
    } catch (e) {
      debugPrint('Biometric authentication failed: $e');
    }
  }

  void _triggerError(String message) {
    HapticFeedback.heavyImpact();
    setState(() {
      _isError = true;
      _errorMessage = message;
      _inputPin = '';
    });
    _shakeController.forward(from: 0.0).then((_) {
      setState(() {
        _isError = false;
      });
    });
  }

  void _onKeyPress(String value) {
    if (_inputPin.length >= 4) return;
    HapticFeedback.lightImpact();
    setState(() {
      _inputPin += value;
      _errorMessage = null;
    });

    if (_inputPin.length == 4) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          _processFullPin();
        }
      });
    }
  }

  void _onBackspace() {
    if (_inputPin.isEmpty) return;
    HapticFeedback.lightImpact();
    setState(() {
      _inputPin = _inputPin.substring(0, _inputPin.length - 1);
      _errorMessage = null;
    });
  }

  void _processFullPin() {
    final storedHash = ref.read(pinHashProvider).value;

    switch (widget.mode) {
      case LockScreenMode.unlock:
        if (storedHash != null && hashPin(_inputPin) == storedHash) {
          HapticFeedback.mediumImpact();
          ref.read(appLockStateProvider.notifier).unlock();
          widget.onSuccess?.call(_inputPin);
        } else {
          _triggerError('Incorrect PIN');
        }
        break;

      case LockScreenMode.setup:
        if (_setupFirstPin == null) {
          setState(() {
            _setupFirstPin = _inputPin;
            _inputPin = '';
            _instructionText = 'Confirm your 4-digit PIN';
          });
        } else {
          if (_inputPin == _setupFirstPin) {
            HapticFeedback.mediumImpact();
            widget.onSuccess?.call(_inputPin);
          } else {
            setState(() {
              _setupFirstPin = null;
              _instructionText = 'Choose a 4-digit PIN';
            });
            _triggerError('PINs did not match');
          }
        }
        break;

      case LockScreenMode.verify:
        if (storedHash != null && hashPin(_inputPin) == storedHash) {
          HapticFeedback.mediumImpact();
          widget.onSuccess?.call(_inputPin);
        } else {
          _triggerError('Incorrect PIN');
        }
        break;
    }
  }

  Widget _buildDot(int index) {
    final isFilled = index < _inputPin.length;
    final theme = Theme.of(context);
    final color = _isError
        ? theme.colorScheme.error
        : (isFilled ? theme.colorScheme.primary : theme.colorScheme.outlineVariant);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: isFilled ? color : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: color,
          width: 2.5,
        ),
      ),
    );
  }

  Widget _buildKeypadButton(String value, {VoidCallback? onPressed, Widget? icon}) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed ?? () => _onKeyPress(value),
        customBorder: const CircleBorder(),
        child: Container(
          width: 76,
          height: 76,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.08),
              width: 1.5,
            ),
            color: theme.cardColor.withValues(alpha: 0.4),
          ),
          child: icon ??
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnlockMode = widget.mode == LockScreenMode.unlock;
    final isBiometricsEnabled = ref.watch(biometricsEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.onCancel != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onCancel,
              )
            : null,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon or Logo
                  Icon(
                    isUnlockMode ? Icons.lock_outline : Icons.security,
                    size: 64,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 24),

                  // Title/Instruction Text
                  Text(
                    _instructionText,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Error / Status Message
                  SizedBox(
                    height: 24,
                    child: Text(
                      _errorMessage ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // PIN Dots Row with Shake Animation
                  AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_shakeAnimation.value, 0),
                        child: child,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, _buildDot),
                    ),
                  ),
                  const SizedBox(height: 64),

                  // Keypad Grid
                  Container(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildKeypadButton('1'),
                            _buildKeypadButton('2'),
                            _buildKeypadButton('3'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildKeypadButton('4'),
                            _buildKeypadButton('5'),
                            _buildKeypadButton('6'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildKeypadButton('7'),
                            _buildKeypadButton('8'),
                            _buildKeypadButton('9'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Biometric button (only for unlock mode if enabled)
                            isUnlockMode && isBiometricsEnabled && _deviceSupportsBiometrics
                                ? _buildKeypadButton(
                                    '',
                                    onPressed: _authenticateWithBiometrics,
                                    icon: Icon(
                                      Icons.fingerprint,
                                      size: 32,
                                      color: theme.colorScheme.primary,
                                    ),
                                  )
                                : const SizedBox(width: 76, height: 76),
                            _buildKeypadButton('0'),
                            _buildKeypadButton(
                              '',
                              onPressed: _onBackspace,
                              icon: const Icon(Icons.backspace_outlined, size: 24),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
