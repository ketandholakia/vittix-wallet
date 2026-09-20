import 'package:expense_tracker/features/security/data/pin_attempt_limiter.dart';
import 'package:expense_tracker/features/security/data/pin_hasher.dart';
import 'package:expense_tracker/features/security/data/secure_key_value_store.dart';
import 'package:flutter_test/flutter_test.dart';

/// A3 (PIN hardening): real key derivation, versioned hashes, attempt limits.
void main() {
  group('PinHasher', () {
    test('v2 hashes verify and reject correctly', () async {
      final stored = await PinHasher.hash('1234');
      expect(PinHasher.isLegacy(stored), isFalse);
      expect(stored.startsWith('pbkdf2-sha256\$'), isTrue);

      expect(await PinHasher.verify('1234', stored), isTrue);
      expect(await PinHasher.verify('4321', stored), isFalse);
    });

    test('the same PIN hashes differently each time (random salt)', () async {
      final a = await PinHasher.hash('1234');
      final b = await PinHasher.hash('1234');
      expect(a, isNot(equals(b)));
      expect(await PinHasher.verify('1234', a), isTrue);
      expect(await PinHasher.verify('1234', b), isTrue);
    });

    test('the iteration count travels with the hash', () async {
      final stored = await PinHasher.hash('9999', iterations: 1000);
      expect(stored.split(r'$')[1], '1000');
      expect(await PinHasher.verify('9999', stored), isTrue);
    });

    test('legacy v1 hashes still verify and are flagged for upgrade', () async {
      final legacy = PinHasher.legacyHash('1234');
      expect(PinHasher.isLegacy(legacy), isTrue);
      expect(PinHasher.needsUpgrade(legacy), isTrue);

      expect(await PinHasher.verify('1234', legacy), isTrue);
      expect(await PinHasher.verify('0000', legacy), isFalse);

      final upgraded = await PinHasher.hash('1234');
      expect(PinHasher.needsUpgrade(upgraded), isFalse);
    });

    test('malformed stored values are rejected rather than throwing', () async {
      expect(await PinHasher.verify('1234', 'not-a-hash'), isFalse);
      expect(await PinHasher.verify('1234', 'pbkdf2-sha256\$bad\$x\$y'), isFalse);
      expect(
        await PinHasher.verify('1234', 'pbkdf2-sha256\$0\$AAAA\$AAAA'),
        isFalse,
      );
    });
  });

  group('PinAttemptLimiter', () {
    late InMemorySecureKeyValueStore store;
    late PinAttemptLimiter limiter;

    setUp(() {
      store = InMemorySecureKeyValueStore();
      limiter = PinAttemptLimiter(store);
    });

    test('first freeAttempts failures do not lock out', () async {
      final now = DateTime(2026, 1, 1, 12);
      for (var i = 0; i < PinAttemptLimiter.freeAttempts; i++) {
        expect(await limiter.registerFailure(now: now), isNull);
      }
      expect(await limiter.isLocked(now: now), isFalse);
      expect(await limiter.attemptsRemaining(), 0);
    });

    test('the next failure locks out and blocks further attempts', () async {
      final now = DateTime(2026, 1, 1, 12);
      for (var i = 0; i < PinAttemptLimiter.freeAttempts; i++) {
        await limiter.registerFailure(now: now);
      }

      final until = await limiter.registerFailure(now: now);
      expect(until, isNotNull);
      expect(await limiter.isLocked(now: now), isTrue);
      expect(await limiter.isLocked(now: until!.add(const Duration(seconds: 1))), isFalse);
    });

    test('cooldown starts after the free attempts and then grows', () {
      expect(PinAttemptLimiter.cooldownFor(5), Duration.zero);
      expect(PinAttemptLimiter.cooldownFor(6), const Duration(seconds: 30));
      expect(PinAttemptLimiter.cooldownFor(7), const Duration(seconds: 60));
      expect(PinAttemptLimiter.cooldownFor(8), const Duration(seconds: 120));
      expect(PinAttemptLimiter.cooldownFor(50), PinAttemptLimiter.maxCooldown);
    });

    test('clear resets the counter and the lock', () async {
      final now = DateTime(2026, 1, 1, 12);
      for (var i = 0; i < PinAttemptLimiter.freeAttempts + 1; i++) {
        await limiter.registerFailure(now: now);
      }
      expect(await limiter.isLocked(now: now), isTrue);

      await limiter.clear();
      expect(await limiter.isLocked(now: now), isFalse);
      expect(await limiter.failures(), 0);
      expect(await limiter.attemptsRemaining(), PinAttemptLimiter.freeAttempts);
    });

    test('remainingLockout reports time left', () async {
      final now = DateTime(2026, 1, 1, 12);
      for (var i = 0; i < PinAttemptLimiter.freeAttempts; i++) {
        await limiter.registerFailure(now: now);
      }
      await limiter.registerFailure(now: now);

      final remaining = await limiter.remainingLockout(now: now);
      expect(remaining.inSeconds, closeTo(30, 1));
    });
  });
}
