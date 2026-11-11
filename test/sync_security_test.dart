import 'package:vittix_wallet/features/security/data/secure_key_value_store.dart';
import 'package:vittix_wallet/features/settings/presentation/settings_providers.dart';
import 'package:vittix_wallet/features/sync/data/sync_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('validateSyncUrl', () {
    test('accepts https in any build', () {
      expect(
        validateSyncUrl(
          'https://cloud.example.com/remote.php/webdav/',
          debugOverride: false,
        ).scheme,
        'https',
      );
    });

    test('release builds reject plain http even for localhost', () {
      expect(
        () =>
            validateSyncUrl('http://localhost:8080/sync', debugOverride: false),
        throwsFormatException,
      );
      expect(
        () => validateSyncUrl('http://10.0.0.5/sync', debugOverride: false),
        throwsFormatException,
      );
    });

    test('debug builds allow http for localhost and private hosts', () {
      for (final url in const [
        'http://localhost:8080/sync',
        'http://127.0.0.1:8080/sync',
        'http://10.1.2.3/sync',
        'http://192.168.1.20/sync',
      ]) {
        expect(
          validateSyncUrl(url, debugOverride: true).scheme,
          'http',
          reason: url,
        );
      }
    });

    test('debug builds reject plain http for public hosts', () {
      expect(
        () => validateSyncUrl('http://example.com/sync', debugOverride: true),
        throwsFormatException,
      );
      expect(
        () => validateSyncUrl('http://172.16.0.2/sync', debugOverride: true),
        throwsFormatException,
      );
    });

    test('rejects malformed URLs', () {
      expect(
        () => validateSyncUrl('', debugOverride: true),
        throwsFormatException,
      );
      expect(
        () => validateSyncUrl('not a url', debugOverride: true),
        throwsFormatException,
      );
      expect(
        () => validateSyncUrl('/relative/path', debugOverride: true),
        throwsFormatException,
      );
    });
  });

  group('SyncTokenMigration', () {
    test(
      'migrates a legacy SharedPreferences token and deletes the old key',
      () async {
        SharedPreferences.setMockInitialValues({'syncToken': 'legacy-token'});
        final prefs = await SharedPreferences.getInstance();
        final secure = InMemorySecureKeyValueStore();

        final token = await SyncTokenMigration.load(
          secure: secure,
          prefs: prefs,
        );

        expect(token, 'legacy-token');
        expect(await secure.read(SyncTokenMigration.key), 'legacy-token');
        expect(
          prefs.getString(SyncTokenMigration.key),
          isNull,
          reason: 'the plaintext token must be removed once migrated',
        );
      },
    );

    test('prefers an existing secure token and never rewrites it', () async {
      SharedPreferences.setMockInitialValues({'syncToken': 'legacy-token'});
      final prefs = await SharedPreferences.getInstance();
      final secure = InMemorySecureKeyValueStore();
      await secure.write(SyncTokenMigration.key, 'secure-token');

      final token = await SyncTokenMigration.load(secure: secure, prefs: prefs);

      expect(token, 'secure-token');
      expect(await secure.read(SyncTokenMigration.key), 'secure-token');
    });

    test('returns an empty token when nothing is stored', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final secure = InMemorySecureKeyValueStore();

      expect(await SyncTokenMigration.load(secure: secure, prefs: prefs), '');
    });
  });
}
