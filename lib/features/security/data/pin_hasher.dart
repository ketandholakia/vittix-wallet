import 'dart:convert';
import 'dart:math';

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

  /// Kept modest because PBKDF2 here is pure Dart; a 4-digit PIN has only
  /// 10 000 combinations, so at-rest encryption (A3 remainder) is the real fix.
  static const defaultIterations = 50000;

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
    } catch (_) {
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

  /// True when the stored hash should be re-hashed to v2 on next success.
  static bool needsUpgrade(String stored) => isLegacy(stored);

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
