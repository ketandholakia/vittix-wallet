// Phase 4I test-failure probe (temporary, disposable branch only).
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Phase 4I deliberate failure probe', () {
    expect(1 + 1, equals(3));
  });
}
