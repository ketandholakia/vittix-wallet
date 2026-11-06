import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:expense_tracker/core/utils/app_logger.dart';
import 'package:crypto/crypto.dart' as legacy_crypto;
import 'package:cryptography/cryptography.dart';

/// Versioned PIN hashing.
///
/// **v1 (legacy)** — `hashPin()` in `settings_providers.dart`: one hard-coded
/// salt plus 10 000 raw SHA-256 iterations, stored as a bare hex digest.
///
/// **v2 (this class)** — PBKDF2-HMAC-SHA256 with a per-PIN random salt, encoded
/// as `pbkdf2-sha256$<iterations>$<salt-b64>$<hash-b64>`. The iteration count
/// travels with the hash so it can be raised later without breaking old PINs,
/// and verification is constant-time.
class PinHasher {
  static const scheme = 'pbkdf2-sha256';

  /// OWASP-recommended floor for PBKDF2-HMAC-SHA256 (2023+). Derivation runs in
  /// a background isolate so raising this does not jank the UI.
  static const defaultIterations = 210000;

  static const _saltLength = 16;
  static const _keyLength = 32;

  // Legacy v1 parameters, needed to keep verifying existing PINs.
  static const legacySalt = 'vittix_wallet_salt_!@#';
  static const legacyIterations = 10000;

  static Future<String> hash(
    String pin, {
    int iterations = defaultIterations,
  }) async {
    final salt = _randomBytes(_saltLength);
    final key = await _derive(pin, salt, iterations);
    return '$scheme\$$iterations\$${base64.encode(salt)}\$${base64.encode(key)}';
  }

  /// True when [pin] matches [stored] under whichever scheme [stored] uses.
  static Future<bool> verify(String pin, String stored) async {
    if (isLegacy(stored)) {
      return legacyHash(pin) == stored;
    }

    final parts = stored.split(r'$');
    if (parts.length != 4 || parts[0] != scheme) return false;

    final iterations = int.tryParse(parts[1]);
    if (iterations == null || iterations <= 0) return false;

    List<int> salt;
    List<int> expected;
    try {
      salt = base64.decode(parts[2]);
      expected = base64.decode(parts[3]);
    } on FormatException catch (error) {
      // A corrupted hash must fail verification, not crash the lock screen.
      AppLogger.warn('Corrupt PIN hash in secure storage', error);
      return false;
    }

    final key = await _derive(pin, salt, iterations);
    return _constantTimeEquals(key, expected);
  }

  /// A v1 bare-hex digest.
  static bool isLegacy(String stored) {
    if (stored.startsWith('$scheme\$')) return false;
    return RegExp(r'^[0-9a-f]{64}$').hasMatch(stored);
  }

  /// True when the stored hash should be re-hashed on the next success.
  ///
  /// Covers both the legacy v1 format and older v2 hashes whose iteration count
  /// is below the current [defaultIterations].
  static bool needsUpgrade(String stored) {
    if (isLegacy(stored)) return true;
    final parts = stored.split(r'$');
    if (parts.length != 4 || parts[0] != scheme) return false;
    final iterations = int.tryParse(parts[1]) ?? 0;
    return iterations < defaultIterations;
  }

  /// The original v1 algorithm, retained for verification and upgrades.
  static String legacyHash(String pin) {
    var digest = legacy_crypto.sha256.convert(utf8.encode(pin + legacySalt));
    for (var i = 0; i < legacyIterations; i++) {
      digest = legacy_crypto.sha256.convert(digest.bytes);
    }
    return digest.toString();
  }

  static Future<List<int>> _derive(
    String pin,
    List<int> salt,
    int iterations,
  ) async {
    // PBKDF2 at 210k iterations is deliberately expensive; keep it off the UI
    // isolate. The inputs are primitives, so they are safe to send.
    try {
      return await Isolate.run(() => _deriveSync(pin, salt, iterations));
    } on UnsupportedError {
      // No isolates on this platform (e.g. web): run inline.
      return _deriveSync(pin, salt, iterations);
    }
  }

  static Future<List<int>> _deriveSync(
    String pin,
    List<int> salt,
    int iterations,
  ) async {
    final kdf = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: iterations,
      bits: _keyLength * 8,
    );
    final key = await kdf.deriveKey(
      secretKey: SecretKey(utf8.encode(pin)),
      nonce: salt,
    );
    return key.extractBytes();
  }

  static bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }

  static List<int> _randomBytes(int count) {
    final random = Random.secure();
    return List<int>.generate(count, (_) => random.nextInt(256));
  }
}
