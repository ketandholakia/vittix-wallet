import 'package:expense_tracker/features/security/data/secure_key_value_store.dart';

/// Progressive lockout for PIN entry.
///
/// The first [freeAttempts] failures are free; after that each further failure
/// imposes a cooldown that doubles (30 s, 60 s, 120 s, ... up to ~32 min). The
/// counter and expiry live in secure storage so killing the app does not reset
/// them.
class PinAttemptLimiter {
  PinAttemptLimiter(this._store);

  final SecureKeyValueStore _store;

  static const _failuresKey = 'pin_failed_attempts';
  static const _lockedUntilKey = 'pin_locked_until';

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

  Future<bool> isLocked({DateTime? now}) async {
    final until = await lockedUntil();
    if (until == null) return false;
    return until.isAfter(now ?? DateTime.now());
  }

  /// Remaining time before another PIN attempt is accepted.
  Future<Duration> remainingLockout({DateTime? now}) async {
    final until = await lockedUntil();
    if (until == null) return Duration.zero;
    final at = now ?? DateTime.now();
    return until.isAfter(at) ? until.difference(at) : Duration.zero;
  }

  /// Attempts left before the next (or first) cooldown kicks in.
  Future<int> attemptsRemaining() async {
    final count = await failures();
    return count >= freeAttempts ? 0 : freeAttempts - count;
  }

  /// Records a failure and returns the lock expiry it triggered (if any).
  Future<DateTime?> registerFailure({DateTime? now}) async {
    final at = now ?? DateTime.now();
    final count = (await failures()) + 1;
    await _store.write(_failuresKey, '$count');

    final cooldown = cooldownFor(count);
    if (cooldown == Duration.zero) return null;

    final until = at.add(cooldown);
    await _store.write(_lockedUntilKey, '${until.millisecondsSinceEpoch}');
    return until;
  }

  /// Clears the counter after a successful unlock.
  Future<void> clear() async {
    await _store.delete(_failuresKey);
    await _store.delete(_lockedUntilKey);
  }
}
