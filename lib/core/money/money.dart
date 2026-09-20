import 'package:drift/drift.dart';

/// Money helpers (backlog item A6).
///
/// Amounts are currently stored as `REAL` (IEEE double) and summed in Dart by
/// loading every row, so rounding error accumulates. The fix is to store
/// integer **minor units** (paise for INR) and let SQLite do the arithmetic.
///
/// [MoneyConverter] lets the change happen without touching hundreds of call
/// sites: the Dart-facing API keeps using `double` major units while storage is
/// an exact integer.
class Money {
  const Money._();

  /// Minor units per major unit (paise per rupee, cents per dollar).
  static const int minorUnitsPerUnit = 100;

  /// Converts major units (e.g. rupees) to exact minor units (paise).
  ///
  /// Rounds half away from zero so `-1.005` and `1.005` are symmetric.
  static int toMinorUnits(double majorUnits) =>
      (majorUnits * minorUnitsPerUnit).round();

  /// Converts minor units back to major units for display.
  static double toMajorUnits(int minorUnits) =>
      minorUnits / minorUnitsPerUnit;
}

/// Drift converter: integer minor units in SQLite, `double` major units in Dart.
class MoneyConverter extends TypeConverter<double, int> {
  const MoneyConverter();

  @override
  double fromSql(int fromDb) => Money.toMajorUnits(fromDb);

  @override
  int toSql(double value) => Money.toMinorUnits(value);
}

/// Deterministic allocation of [totalMinorUnits] across [parts].
///
/// Used for splits and any other division of a sum. Integer division alone
/// loses money (3 ways for 100 paise = 33 each, 1 paise vanished); this uses
/// the largest-remainder method so the parts always add back to the total
/// exactly, with the leftover minor units going to the earliest parts.
///
/// Throws [ArgumentError] when [parts] is not positive.
List<int> allocateMinorUnits(int totalMinorUnits, int parts) {
  if (parts <= 0) {
    throw ArgumentError.value(parts, 'parts', 'must be positive');
  }

  // Allocate on the magnitude and flip the signs: Dart's `~/` truncates toward
  // zero, so splitting a negative total directly would not conserve value.
  if (totalMinorUnits < 0) {
    return allocateMinorUnits(-totalMinorUnits, parts)
        .map((part) => -part)
        .toList();
  }

  final base = totalMinorUnits ~/ parts;
  final remainder = totalMinorUnits - base * parts;

  return List<int>.generate(
    parts,
    (i) => base + (i < remainder ? 1 : 0),
  );
}

/// Allocates [totalMinorUnits] in proportion to [weights] (largest remainder).
///
/// Weights must be non-negative and sum to more than zero.
List<int> allocateMinorUnitsByWeight(
  int totalMinorUnits,
  List<int> weights,
) {
  if (weights.isEmpty) {
    throw ArgumentError.value(weights, 'weights', 'must not be empty');
  }
  final totalWeight = weights.fold<int>(0, (a, b) => a + b);
  if (totalWeight <= 0) {
    throw ArgumentError.value(weights, 'weights', 'must sum to more than zero');
  }
  if (weights.any((w) => w < 0)) {
    throw ArgumentError.value(weights, 'weights', 'must not be negative');
  }

  final floors = <int>[];
  final remainders = <int>[];
  for (final weight in weights) {
    final exact = totalMinorUnits * weight;
    floors.add(exact ~/ totalWeight);
    remainders.add(exact % totalWeight);
  }

  var leftover = totalMinorUnits - floors.fold<int>(0, (a, b) => a + b);

  // Hand the leftover minor units to the largest remainders first, breaking
  // ties by index so the result is deterministic.
  final order = List<int>.generate(weights.length, (i) => i)
    ..sort((a, b) {
      final byRemainder = remainders[b].compareTo(remainders[a]);
      return byRemainder != 0 ? byRemainder : a.compareTo(b);
    });

  final result = List<int>.from(floors);
  for (final index in order) {
    if (leftover <= 0) break;
    result[index] += 1;
    leftover--;
  }
  return result;
}
