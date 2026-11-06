/// Shared last-write-wins / conflict handling for every synced entity.
///
/// Before this, each entity carried its own copy of
/// `remote.updatedAt.isAfter(local.updatedAt)`, which is easy to get subtly
/// different. This module centralises the rules:
///
/// * A remote timestamp more than [syncClockSkewTolerance] in the future is
///   ignored (a device with a wrong clock must not win forever).
/// * A remote row newer than the local row by more than [syncConflictWindow]
///   wins.
/// * Timestamps within [syncConflictWindow] are ambiguous: the local row is
///   kept and the remote payload is recorded as a conflict instead of being
///   dropped silently.
library;

/// Remote timestamps further ahead than this are treated as clock skew.
const Duration syncClockSkewTolerance = Duration(minutes: 5);

/// Two edits closer than this are considered concurrent.
const Duration syncConflictWindow = Duration(seconds: 2);

enum SyncMergeAction { takeRemote, keepLocal, conflict }

/// Classifies a local/remote timestamp pair.
SyncMergeAction resolveSyncConflict(
  DateTime localUpdatedAt,
  DateTime remoteUpdatedAt, {
  DateTime? now,
}) {
  final clock = now ?? DateTime.now();
  if (remoteUpdatedAt.isAfter(clock.add(syncClockSkewTolerance))) {
    return SyncMergeAction.keepLocal;
  }
  if (remoteUpdatedAt.isAfter(localUpdatedAt.add(syncConflictWindow))) {
    return SyncMergeAction.takeRemote;
  }
  if (localUpdatedAt.isAfter(remoteUpdatedAt.add(syncConflictWindow))) {
    return SyncMergeAction.keepLocal;
  }
  return SyncMergeAction.conflict;
}

/// Counters from one [mergeEntityChanges] pass.
class SyncMergeStats {
  int inserted = 0;
  int updated = 0;
  int keptLocal = 0;
  int conflicts = 0;
  int skippedClockSkew = 0;
  int blockedByTombstone = 0;

  @override
  String toString() => 'SyncMergeStats(inserted: $inserted, updated: $updated, '
      'keptLocal: $keptLocal, conflicts: $conflicts, '
      'skippedClockSkew: $skippedClockSkew, '
      'blockedByTombstone: $blockedByTombstone)';
}

/// Merges [changes] into the local store using the caller's per-entity
/// callbacks (the "adapter").
///
/// [tombstoneByKey] maps `'<entity>:<uuid>'` to the local deletion time. A
/// tombstone at least as new as the remote row blocks the change so deleted
/// rows are not resurrected.
Future<SyncMergeStats> mergeEntityChanges<T>({
  required String entity,
  required Iterable<dynamic> changes,
  required String Function(Map<String, dynamic> data) uuidOf,
  required DateTime Function(Map<String, dynamic> data) remoteUpdatedAt,
  required Future<T?> Function(String uuid) findLocal,
  required DateTime Function(T local) localUpdatedAt,
  required Future<void> Function(Map<String, dynamic> data) insertRemote,
  required Future<void> Function(T local, Map<String, dynamic> data) updateRemote,
  Future<void> Function(Map<String, dynamic> data, T local)? recordConflict,
  Map<String, DateTime>? tombstoneByKey,
  DateTime? now,
}) async {
  final stats = SyncMergeStats();
  final clock = now ?? DateTime.now();

  for (final raw in changes) {
    final data = raw as Map<String, dynamic>;
    final uuid = uuidOf(data);
    final remoteAt = remoteUpdatedAt(data);

    final tombstoneAt = tombstoneByKey?['$entity:$uuid'];
    if (tombstoneAt != null && !tombstoneAt.isBefore(remoteAt)) {
      stats.blockedByTombstone++;
      continue;
    }

    if (remoteAt.isAfter(clock.add(syncClockSkewTolerance))) {
      stats.skippedClockSkew++;
      continue;
    }

    final local = await findLocal(uuid);
    if (local == null) {
      await insertRemote(data);
      stats.inserted++;
      continue;
    }

    switch (resolveSyncConflict(localUpdatedAt(local), remoteAt, now: clock)) {
      case SyncMergeAction.takeRemote:
        await updateRemote(local, data);
        stats.updated++;
      case SyncMergeAction.keepLocal:
        stats.keptLocal++;
      case SyncMergeAction.conflict:
        if (recordConflict != null) {
          await recordConflict(data, local);
        }
        stats.conflicts++;
    }
  }

  return stats;
}
