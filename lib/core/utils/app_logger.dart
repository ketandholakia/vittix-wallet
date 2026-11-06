import 'package:flutter/foundation.dart';

/// One place for non-fatal diagnostics.
///
/// Logging is a no-op in release builds so diagnostics never end up in a
/// shipped app's logcat, and sensitive values must never be passed here.
class AppLogger {
  const AppLogger._();

  static bool get _enabled => !kReleaseMode;

  static void info(String message) {
    if (!_enabled) return;
    debugPrint('[info] $message');
  }

  static void warn(String message, [Object? error, StackTrace? stackTrace]) {
    if (!_enabled) return;
    debugPrint('[warn] $message${error == null ? '' : ': $error'}');
    if (stackTrace != null) {
      // Plain text rather than debugPrintStack: Flutter's frame parser asserts
      // on the "asynchronous gap" markers that test stacks contain.
      debugPrint('$stackTrace');
    }
  }

  static void error(String message, Object error, [StackTrace? stackTrace]) {
    if (!_enabled) return;
    debugPrint('[error] $message: $error');
    if (stackTrace != null) {
      debugPrint('$stackTrace');
    }
  }
}
