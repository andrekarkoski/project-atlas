import 'package:atlas_engine/atlas_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Cell', () {
    test('creates an empty cell by default', () {
      const cell = Cell(
        position: Position(0, 0),
      );

      expect(cell.position, const Position(0, 0));
      expect(cell.letter, isNull);
      expect(cell.state, CellState.empty);
      expect(cell.isEmpty, isTrue);
      expect(cell.hasLetter, isFalse);
    });

    test('creates a filled cell', () {
      const cell = Cell(
        position: Position(1, 2),
        letter: 'A',
        state: CellState.filled,
      );

      expect(cell.hasLetter, isTrue);
      expect(cell.isFilled, isTrue);
      expect(cell.isBlocked, isFalse);
    });

    test('creates a locked cell', () {
      const cell = Cell(
        position: Position(2, 3),
        letter: 'A',
        state: CellState.locked,
      );

      expect(cell.state, CellState.locked);
      expect(cell.hasLetter, isTrue);
      expect(cell.isBlocked, isFalse);
    });

    test('locked cell reports correct state', () {
      const cell = Cell(
        position: Position(2, 3),
        letter: 'A',
        state: CellState.locked,
      );

      expect(cell.isLocked, isTrue);
      expect(cell.isFilled, isFalse);
      expect(cell.isBlocked, isFalse);
    });

    test('copyWith replaces values', () {
      const original = Cell(
        position: Position(0, 0),
      );

      final updated = original.copyWith(
        letter: 'B',
        state: CellState.filled,
      );

      expect(updated.position, original.position);
      expect(updated.letter, 'B');
      expect(updated.state, CellState.filled);
    });

    test('cells with same values are equal', () {
      const a = Cell(
        position: Position(2, 3),
        letter: 'X',
        state: CellState.filled,
      );

      const b = Cell(
        position: Position(2, 3),
        letter: 'X',
        state: CellState.filled,
      );

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('blocked cell reports correct state', () {
      const cell = Cell(
        position: Position(4, 4),
        state: CellState.blocked,
      );

      expect(cell.isBlocked, isTrue);
      expect(cell.isEmpty, isFalse);
      expect(cell.isFilled, isFalse);
    });
  });

  ///
}
