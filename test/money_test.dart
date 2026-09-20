import 'package:expense_tracker/core/money/money.dart';
import 'package:flutter_test/flutter_test.dart';

/// A6 — integer minor units and the rounding/allocation policy.
void main() {
  group('Money conversion', () {
    test('major units convert to exact minor units', () {
      expect(Money.toMinorUnits(0), 0);
      expect(Money.toMinorUnits(1), 100);
      expect(Money.toMinorUnits(12.34), 1234);
      expect(Money.toMinorUnits(0.01), 1);
      expect(Money.toMinorUnits(19.99), 1999);
    });

    test('rounding is symmetric around zero', () {
      for (final value in [1.005, 0.004, 12.345, 19.99, 0.5]) {
        expect(
          Money.toMinorUnits(-value),
          -Money.toMinorUnits(value),
          reason: 'negative values must round symmetrically',
        );
      }
    });

    test('minor units convert back for display', () {
      expect(Money.toMajorUnits(1234), 12.34);
      expect(Money.toMajorUnits(0), 0);
      expect(Money.toMajorUnits(-101), -1.01);
    });

    test('the worst float cases are now exact', () {
      // 0.1 + 0.2 is famously not 0.3 in binary floating point.
      final asMinor = Money.toMinorUnits(0.1) + Money.toMinorUnits(0.2);
      expect(asMinor, 30);
      expect(Money.toMajorUnits(asMinor), 0.3);

      // Repeated addition of 0.1 stays exact in minor units.
      var total = 0;
      for (var i = 0; i < 10; i++) {
        total += Money.toMinorUnits(0.1);
      }
      expect(total, 100);
      expect(Money.toMajorUnits(total), 1.0);
    });

    test('the converter round-trips through the drat storage type', () {
      const converter = MoneyConverter();
      expect(converter.toSql(12.34), 1234);
      expect(converter.fromSql(1234), 12.34);
      expect(converter.fromSql(converter.toSql(19.99)), 19.99);
    });
  });

  group('Split allocation', () {
    test('an evenly divisible total splits without leftovers', () {
      expect(allocateMinorUnits(300, 3), [100, 100, 100]);
    });

    test('an indivisible total still adds back exactly', () {
      final parts = allocateMinorUnits(100, 3);
      expect(parts, [34, 33, 33]);
      expect(parts.fold<int>(0, (a, b) => a + b), 100,
          reason: 'no paise may be created or lost');
    });

    test('the remainder goes to the earliest parts and is deterministic', () {
      expect(allocateMinorUnits(10, 4), [3, 3, 2, 2]);
      expect(allocateMinorUnits(10, 4), allocateMinorUnits(10, 4));
    });

    test('a single part takes everything', () {
      expect(allocateMinorUnits(1234, 1), [1234]);
    });

    test('zero and negative totals still conserve value', () {
      expect(allocateMinorUnits(0, 3), [0, 0, 0]);
      final negative = allocateMinorUnits(-100, 3);
      expect(negative.fold<int>(0, (a, b) => a + b), -100);
    });

    test('a non-positive part count is rejected', () {
      expect(() => allocateMinorUnits(100, 0), throwsArgumentError);
      expect(() => allocateMinorUnits(100, -1), throwsArgumentError);
    });

    test('weighted allocation conserves the total', () {
      final parts = allocateMinorUnitsByWeight(1000, [1, 1, 1]);
      expect(parts.fold<int>(0, (a, b) => a + b), 1000);
      expect(parts, [334, 333, 333]);
    });

    test('weighted allocation respects the proportions', () {
      final parts = allocateMinorUnitsByWeight(1000, [70, 30]);
      expect(parts, [700, 300]);

      // Uneven proportions still conserve value.
      final uneven = allocateMinorUnitsByWeight(101, [1, 2]);
      expect(uneven.fold<int>(0, (a, b) => a + b), 101);
      expect(uneven[1], greaterThan(uneven[0]));
    });

    test('invalid weights are rejected', () {
      expect(() => allocateMinorUnitsByWeight(100, []), throwsArgumentError);
      expect(() => allocateMinorUnitsByWeight(100, [0, 0]), throwsArgumentError);
      expect(() => allocateMinorUnitsByWeight(100, [1, -1]), throwsArgumentError);
    });
  });
}
