import 'package:expense_tracker/core/utils/csv_importer.dart';
import 'package:flutter_test/flutter_test.dart';

/// Regression tests for CSV amount parsing. The importer must handle Western
/// grouping (1,234.56), Indian grouping (1,50,000.00) and a comma used as the
/// decimal separator (1,50), without silently rescaling values.
void main() {
  double parse(String v) => CsvTransactionImporter.parseAmountForTest(v);

  group('CSV amount parsing', () {
    test('plain integer and decimal values', () {
      expect(parse('500'), 500);
      expect(parse('500.5'), 500.5);
      expect(parse('500.50'), 500.5);
    });

    test('Western thousands grouping', () {
      expect(parse('1,234'), 1234);
      expect(parse('1,234,567'), 1234567);
      expect(parse('1,234.56'), 1234.56);
    });

    test('Indian lakh grouping', () {
      expect(parse('1,50,000'), 150000);
      expect(parse('1,50,000.75'), 150000.75);
    });

    test('comma as decimal separator', () {
      expect(parse('1,5'), 1.5);
      expect(parse('1,50'), 1.5);
    });

    test('European grouping with decimal comma', () {
      expect(parse('1.234,56'), 1234.56);
      expect(parse('1.234.567'), 1234567);
    });

    test('currency symbols and spaces are stripped', () {
      expect(parse('Rs. 1,234.56'), 1234.56);
      expect(parse('₹ 1,50,000'), 150000);
      expect(parse('500'), 500);
    });

    test('negative amounts', () {
      expect(parse('-1,234.56'), -1234.56);
      expect(parse('-500'), -500);
    });

    test('invalid amounts throw FormatException', () {
      expect(() => parse('abc'), throwsFormatException);
      expect(() => parse(''), throwsFormatException);
      expect(() => parse('Rs.'), throwsFormatException);
    });
  });
}
