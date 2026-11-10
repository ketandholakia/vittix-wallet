import 'dart:math';

import 'package:vittix_wallet/features/security/data/secure_key_value_store.dart';

/// Progressive lockout for PIN entry.
///
/// The first [freeAttempts] failures are free; after that each further failure
/// imposes a cooldown that doubles (30 s, 60 s, 120 s, ... up to ~32 min). The
/// counter and expiry live in secure storage so killing the app does not reset
/// them.
///
/// Two independent clocks guard the lockout:
/// * a persisted high-water mark of the wall clock, so moving the device clock
///   backwards cannot shorten an existing cooldown, and
/// * a [Stopwatch] reference that is only trusted inside the process that wrote
///   it, so pausing/wall-clock changes during the session cannot clear it.
class PinAttemptLimiter {
  PinAttemptLimiter(this._store);

  final SecureKeyValueStore _store;

  static const _failuresKey = 'pin_failed_attempts';
  static const _lockedUntilKey = 'pin_locked_until';
  static const _lockedUntilMonotonicKey = 'pin_locked_until_monotonic';
  static const _lockProcessKey = 'pin_lock_process';
  static const _lastSeenKey = 'pin_last_seen_epoch_ms';

  /// Process-local monotonic clock. Persisted values are only honoured when the
  /// stored process id matches this process.
  static final Stopwatch _uptime = Stopwatch()..start();
  static final String _processId =
      List<int>.generate(8, (_) => Random.secure().nextInt(256))
          .map((b) => b.toRadixString(16).padLeft(2, '0'))
          .join();

  /// Failures tolerated before the first cooldown.
  static const freeAttempts = 5;

  /// Longest cooldown, so a locked-out user is never permanently shut out.
  static const maxCooldown = Duration(minutes: 30);

  static Duration cooldownFor(int failures) {
    // The first [freeAttempts] wrong tries are free; the next one starts the
    // cooldown, which then doubles on every further failure.
    if (failures <= freeAttempts) return Duration.zero;
    final steps = (failures - freeAttempts - 1).clamp(0, 10);
    final seconds = 30 * (1 << steps);
    final cooldown = Duration(seconds: seconds);
    return cooldown > maxCooldown ? maxCooldown : cooldown;
  }

  Future<int> failures() async {
    final raw = await _store.read(_failuresKey);
    return int.tryParse(raw ?? '') ?? 0;
  }

  Future<DateTime?> lockedUntil() async {
    final raw = await _store.read(_lockedUntilKey);
    final ms = int.tryParse(raw ?? '');
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  /// The current time, never earlier than the last time this device observed.
  ///
  /// Persisting the high-water mark is what makes a backwards clock change
  /// unable to clear a lockout.
  Future<DateTime> _effectiveNow(DateTime? now) async {
    final current = now ?? DateTime.now();
    final lastSeenMs = int.tryParse(await _store.read(_lastSeenKey) ?? '');
    if (lastSeenMs == null || current.millisecondsSinceEpoch > lastSeenMs) {
      await _store.write(_lastSeenKey, '${current.millisecondsSinceEpoch}');
      return current;
    }
    return DateTime.fromMillisecondsSinceEpoch(lastSeenMs);
  }

  /// True while the monotonic reference written by this process says locked.
  Future<bool> _lockedByMonotonic() async {
    final process = await _store.read(_lockProcessKey);
    if (process != _processId) return false;
    final target =
        int.tryParse(await _store.read(_lockedUntilMonotonicKey) ?? '');
    return target != null && _uptime.elapsedMilliseconds < target;
  }

  Future<bool> isLocked({DateTime? now}) async {
    // An explicit clock is used by tests; the monotonic reference only applies
    // to real calls so a stale synthetic time cannot interfere.
    if (now == null && await _lockedByMonotonic()) return true;

    final until = await lockedUntil();
    if (until == null) return false;
    final at = await _effectiveNow(now);
    return until.isAfter(at);
  }

  /// Remaining time before another PIN attempt is accepted.
  Future<Duration> remainingLockout({DateTime? now}) async {
    var remaining = Duration.zero;

    if (now == null) {
      final process = await _store.read(_lockProcessKey);
      if (process == _processId) {
        final target =
            int.tryParse(await _store.read(_lockedUntilMonotonicKey) ?? '');
        if (target != null) {
          final leftMs = target - _uptime.elapsedMilliseconds;
          if (leftMs > 0) remaining = Duration(milliseconds: leftMs);
        }
      }
    }

    final until = await lockedUntil();
    if (until != null) {
      final at = await _effectiveNow(now);
      if (until.isAfter(at)) {
        final wall = until.difference(at);
        if (wall > remaining) remaining = wall;
      }
    }
    return remaining;
  }

  /// Attempts left before the next (or first) cooldown kicks in.
  Future<int> attemptsRemaining() async {
    final count = await failures();
    return count >= freeAttempts ? 0 : freeAttempts - count;
  }

  /// Records a failure and returns the lock expiry it triggered (if any).
  Future<DateTime?> registerFailure({DateTime? now}) async {
    final at = await _effectiveNow(now);
    final count = (await failures()) + 1;
    await _store.write(_failuresKey, '$count');

    final cooldown = cooldownFor(count);
    if (cooldown == Duration.zero) return null;

    final until = at.add(cooldown);
    await _store.write(_lockedUntilKey, '${until.millisecondsSinceEpoch}');
    await _store.write(_lockProcessKey, _processId);
    await _store.write(
      _lockedUntilMonotonicKey,
      '${_uptime.elapsedMilliseconds + cooldown.inMilliseconds}',
    );
    return until;
  }

  /// Clears the counter after a successful unlock.
  Future<void> clear() async {
    await _store.delete(_failuresKey);
    await _store.delete(_lockedUntilKey);
    await _store.delete(_lockedUntilMonotonicKey);
    await _store.delete(_lockProcessKey);
  }
}
