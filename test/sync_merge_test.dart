import 'package:vittix_wallet/features/sync/data/sync_merge.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 6, 1, 12, 0, 0);

  group('resolveSyncConflict', () {
    test('ignores remote timestamps more than 5 minutes in the future', () {
      expect(
        resolveSyncConflict(
          now,
          now.add(const Duration(minutes: 6)),
          now: now,
        ),
        SyncMergeAction.keepLocal,
      );
    });

    test('a clearly newer remote wins', () {
      expect(
        resolveSyncConflict(
          now,
          now.add(const Duration(seconds: 5)),
          now: now,
        ),
        SyncMergeAction.takeRemote,
      );
    });

    test('a clearly older remote loses', () {
      expect(
        resolveSyncConflict(
          now,
          now.subtract(const Duration(seconds: 5)),
          now: now,
        ),
        SyncMergeAction.keepLocal,
      );
    });

    test('near-simultaneous edits are a conflict, not a silent drop', () {
      expect(
        resolveSyncConflict(
          now,
          now.add(const Duration(seconds: 1)),
          now: now,
        ),
        SyncMergeAction.conflict,
      );
      expect(resolveSyncConflict(now, now, now: now), SyncMergeAction.conflict);
    });
  });

  group('mergeEntityChanges', () {
    late Map<String, Map<String, dynamic>> local;
    final conflicts = <String>[];

    setUp(() {
      local = {};
      conflicts.clear();
    });

    Map<String, dynamic> remote(String uuid, DateTime updatedAt,
            {String name = 'remote'}) =>
        {
          'uuid': uuid,
          'updatedAt': updatedAt.millisecondsSinceEpoch,
          'name': name,
        };

    Future<SyncMergeStats> merge(
      List<Map<String, dynamic>> changes, {
      Map<String, DateTime>? tombstones,
      DateTime? at,
    }) {
      return mergeEntityChanges<Map<String, dynamic>>(
        entity: 'things',
        changes: changes,
        now: at ?? now,
        tombstoneByKey: tombstones,
        uuidOf: (data) => data['uuid'] as String,
        remoteUpdatedAt: (data) =>
            DateTime.fromMillisecondsSinceEpoch(data['updatedAt'] as int),
        findLocal: (uuid) async => local[uuid],
        localUpdatedAt: (item) =>
            DateTime.fromMillisecondsSinceEpoch(item['updatedAt'] as int),
        insertRemote: (data) async => local[data['uuid'] as String] = data,
        updateRemote: (existing, data) async =>
            local[data['uuid'] as String] = data,
        recordConflict: (data, existing) async =>
            conflicts.add('${data['uuid']}:${data['name']}'),
      );
    }

    test('inserts a row that does not exist locally', () async {
      final stats = await merge([
        remote('a', now, name: 'new'),
      ]);

      expect(stats.inserted, 1);
      expect(local['a']!['name'], 'new');
    });

    test('takes a clearly newer remote row', () async {
      local['a'] = remote('a', now.subtract(const Duration(seconds: 10)),
          name: 'local');

      final stats = await merge([
        remote('a', now, name: 'remote-new'),
      ]);

      expect(stats.updated, 1);
      expect(local['a']!['name'], 'remote-new');
    });

    test('keeps a clearly newer local row', () async {
      local['a'] = remote('a', now, name: 'local');

      final stats = await merge([
        remote('a', now.subtract(const Duration(seconds: 10)), name: 'older'),
      ]);

      expect(stats.keptLocal, 1);
      expect(local['a']!['name'], 'local');
    });

    test('records a conflict and keeps local for near-simultaneous edits',
        () async {
      local['a'] = remote('a', now, name: 'local');

      final stats = await merge([
        remote('a', now.add(const Duration(seconds: 1)), name: 'remote'),
      ]);

      expect(stats.conflicts, 1);
      expect(conflicts, ['a:remote']);
      expect(local['a']!['name'], 'local',
          reason: 'the local row is kept and the remote payload is logged');
    });

    test('ignores remote timestamps more than 5 minutes ahead', () async {
      final stats = await merge([
        remote('a', now.add(const Duration(minutes: 30))),
      ]);

      expect(stats.skippedClockSkew, 1);
      expect(local, isEmpty);
    });

    test('a newer tombstone blocks a remote change', () async {
      final stats = await merge(
        [remote('a', now)],
        tombstones: {'things:a': now.add(const Duration(minutes: 1))},
      );

      expect(stats.blockedByTombstone, 1);
      expect(local, isEmpty);
    });
  });
}
