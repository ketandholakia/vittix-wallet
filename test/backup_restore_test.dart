import 'dart:io';

import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart'
    hide Transaction, Category, Account, TransactionType, AccountType, isNull, isNotNull;
import 'package:expense_tracker/core/services/backup_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

/// Tests for backup/restore (backlog item A1).
void main() {
  late Directory dir;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('vittix_backup_test');
  });

  tearDown(() async {
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  });

  test('validate rejects a missing file', () {
    final result = BackupService.validate(
      File(p.join(dir.path, 'nope.db')),
      currentSchemaVersion: 11,
    );
    expect(result.isValid, isFalse);
    expect(result.error, contains('not found'));
  });

  test('validate rejects a non-SQLite file', () async {
    final junk = File(p.join(dir.path, 'junk.db'));
    await junk.writeAsString('this is definitely not a database file' * 20);

    final result = BackupService.validate(junk, currentSchemaVersion: 11);
    expect(result.isValid, isFalse);
    expect(result.error, contains('Not a SQLite'));
  });

  test('validate accepts a real migrated database', () async {
    final dbFile = File(p.join(dir.path, 'db.sqlite'));
    final db = AppDatabase.forTesting(NativeDatabase(dbFile));
    await db.into(db.wallets).insert(const WalletsCompanion(name: Value('Wallet A')));
    final schemaVersion = db.schemaVersion;
    await db.close();

    final result = BackupService.validate(dbFile, currentSchemaVersion: schemaVersion);
    expect(result.isValid, isTrue, reason: result.error);
    expect(result.schemaVersion, schemaVersion);
  });

  test('validate rejects a backup written by a newer schema', () async {
    final dbFile = File(p.join(dir.path, 'newer.sqlite'));
    final db = AppDatabase.forTesting(NativeDatabase(dbFile));
    // Drift opens lazily, so touch the database to materialise the file.
    await db.into(db.wallets).insert(const WalletsCompanion(name: Value('Wallet A')));
    await db.close();

    final result = BackupService.validate(dbFile, currentSchemaVersion: 1);
    expect(result.isValid, isFalse);
    expect(result.error, contains('newer app version'));
  });

  test('createSnapshot produces a valid copy that still validates', () async {
    final dbFile = File(p.join(dir.path, 'db.sqlite'));
    final db = AppDatabase.forTesting(NativeDatabase(dbFile));
    await db.into(db.wallets).insert(const WalletsCompanion(name: Value('Wallet A')));

    final service = BackupService(db);
    final snapshot = await service.createSnapshot(p.join(dir.path, 'snap.db'));
    final schemaVersion = db.schemaVersion;
    await db.close();

    expect(await snapshot.exists(), isTrue);
    expect(snapshot.lengthSync(), greaterThan(0));
    final check = BackupService.validate(snapshot, currentSchemaVersion: schemaVersion);
    expect(check.isValid, isTrue, reason: check.error);
  });

  group('encrypted container', () {
    test('round-trips arbitrary bytes', () async {
      final clear = List<int>.generate(1024, (i) => i % 256);
      final container = await BackupService.encryptBytes(clear, 'correct horse');

      expect(container.length, greaterThan(clear.length));
      final back = await BackupService.decryptBytes(container, 'correct horse');
      expect(back, equals(clear));
    });

    test('wrong passphrase is rejected', () async {
      final container =
          await BackupService.encryptBytes(List<int>.filled(64, 7), 'right');
      expect(
        () => BackupService.decryptBytes(container, 'wrong'),
        throwsFormatException,
      );
    });

    test('a truncated container is rejected', () async {
      final container =
          await BackupService.encryptBytes(List<int>.filled(64, 7), 'right');
      final truncated = container.sublist(0, 20);
      expect(
        () => BackupService.decryptBytes(truncated, 'right'),
        throwsFormatException,
      );
    });

    test('isEncryptedFile distinguishes containers from plain databases',
        () async {
      final dbFile = File(p.join(dir.path, 'plain.sqlite'));
      final db = AppDatabase.forTesting(NativeDatabase(dbFile));
      await db.into(db.wallets).insert(const WalletsCompanion(name: Value('Wallet A')));
      await db.close();

      final encrypted = File(p.join(dir.path, 'enc.db'))
        ..writeAsBytesSync(await BackupService.encryptBytes(
          await dbFile.readAsBytes(),
          'pw',
        ));

      expect(BackupService.isEncryptedFile(dbFile), isFalse);
      expect(BackupService.isEncryptedFile(encrypted), isTrue);
      expect(
        BackupService.validate(encrypted, currentSchemaVersion: 11).isValid,
        isFalse,
        reason: 'a container is not directly readable as SQLite',
      );
    });

    test('encrypted snapshot decrypts back into a valid database', () async {
      final dbFile = File(p.join(dir.path, 'db.sqlite'));
      final db = AppDatabase.forTesting(NativeDatabase(dbFile));
      await db.into(db.wallets).insert(const WalletsCompanion(name: Value('Wallet A')));
      final schemaVersion = db.schemaVersion;

      final service = BackupService(db);
      final container = await service.createEncryptedSnapshot(
        p.join(dir.path, 'backup.db.enc'),
        'my passphrase',
      );
      await db.close();

      expect(BackupService.isEncryptedFile(container), isTrue);

      final plain = await BackupService.decryptToFile(
        container,
        'my passphrase',
        p.join(dir.path, 'decrypted.sqlite'),
      );
      final check = BackupService.validate(plain, currentSchemaVersion: schemaVersion);
      expect(check.isValid, isTrue, reason: check.error);
    });
  });

  test('restore replaces the live database content', () async {
    // Source database with a distinctive wallet.
    final sourceFile = File(p.join(dir.path, 'source.sqlite'));
    final source = AppDatabase.forTesting(NativeDatabase(sourceFile));
    await source
        .into(source.wallets)
        .insert(const WalletsCompanion(name: Value('Restored Wallet')));
    final snapshot = await BackupService(source)
        .createSnapshot(p.join(dir.path, 'backup.db'));
    await source.close();

    // Destination database that currently holds different data.
    final liveFile = File(p.join(dir.path, 'live.sqlite'));
    final live = AppDatabase.forTesting(NativeDatabase(liveFile));
    await live.into(live.wallets).insert(const WalletsCompanion(name: Value('Old Wallet')));

    await BackupService(live).restore(snapshot, liveDbFile: liveFile);

    final reopened = AppDatabase.forTesting(NativeDatabase(liveFile));
    final wallets = await reopened.select(reopened.wallets).get();
    await reopened.close();

    final names = wallets.map((w) => w.name).toList();
    expect(names, contains('Restored Wallet'));
    expect(names, isNot(contains('Old Wallet')));
  });
}
