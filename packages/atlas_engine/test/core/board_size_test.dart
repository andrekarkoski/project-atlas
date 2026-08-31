import 'package:atlas_engine/atlas_engine.dart';
import 'package:test/test.dart';

void main() {
  group('BoardSize', () {
    test('stores dimensions', () {
      const size = BoardSize(
        rows: 10,
        columns: 15,
      );

      expect(size.rows, 10);
      expect(size.columns, 15);
    });

    test('computes total cells', () {
      const size = BoardSize(
        rows: 10,
        columns: 15,
      );

      expect(size.totalCells, 150);
    });

    test('detects square boards', () {
      const square = BoardSize(
        rows: 8,
        columns: 8,
      );

      const rectangle = BoardSize(
        rows: 8,
        columns: 10,
      );

      expect(square.isSquare, isTrue);
      expect(rectangle.isSquare, isFalse);
    });

    test('contains valid positions', () {
      const size = BoardSize(
        rows: 5,
        columns: 5,
      );

      expect(
        size.contains(const Position(0, 0)),
        isTrue,
      );

      expect(
        size.contains(const Position(4, 4)),
        isTrue,
      );
    });

    test('rejects invalid positions', () {
      const size = BoardSize(
        rows: 5,
        columns: 5,
      );

      expect(
        size.contains(const Position(-1, 0)),
        isFalse,
      );

      expect(
        size.contains(const Position(5, 0)),
        isFalse,
      );

      expect(
        size.contains(const Position(0, 5)),
        isFalse,
      );
    });

    test('supports equality', () {
      const a = BoardSize(
        rows: 12,
        columns: 15,
      );

      const b = BoardSize(
        rows: 12,
        columns: 15,
      );

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });
  });

  test('operator [] returns correct cell', () {
    const size = BoardSize(
      rows: 4,
      columns: 4,
    );

    final board = Board(size: size);

    final cell = board[const Position(2, 1)];

    expect(
      cell.position,
      const Position(2, 1),
    );
  });

  test('operator [] throws for invalid position', () {
    const size = BoardSize(
      rows: 4,
      columns: 4,
    );

    final board = Board(size: size);

    expect(
      () => board[const Position(9, 9)],
      throwsRangeError,
    );
  });
}
