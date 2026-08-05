import 'package:atlas_engine/atlas_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Position', () {
    test('stores row and column values', () {
      const position = Position(2, 4);

      expect(position.row, 2);
      expect(position.column, 4);
    });

    test('supports value equality', () {
      const a = Position(1, 2);
      const b = Position(1, 2);

      expect(a, equals(b));
    });

    test('different positions are not equal', () {
      const a = Position(1, 2);
      const b = Position(2, 1);

      expect(a, isNot(equals(b)));
    });

    test('equal positions have the same hashCode', () {
      const a = Position(5, 7);
      const b = Position(5, 7);

      expect(a.hashCode, equals(b.hashCode));
    });

    test('toString is readable', () {
      const position = Position(3, 7);

      expect(
        position.toString(),
        'Position(row: 3, column: 7)',
      );
    });
  });
}