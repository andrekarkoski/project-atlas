import 'package:atlas_engine/atlas_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Board', () {
    test('creates correct number of cells', () {
      const size = BoardSize(
        rows: 10,
        columns: 15,
      );

      final board = Board(size: size);

      expect(
        board.cells.length,
        150,
      );
    });

    test('stores board size', () {
      const size = BoardSize(
        rows: 5,
        columns: 7,
      );

      final board = Board(size: size);

      expect(board.size, size);
    });

    test('first cell starts at (0,0)', () {
      const size = BoardSize(
        rows: 2,
        columns: 2,
      );

      final board = Board(size: size);

      expect(
        board.cells.first.position,
        const Position(0, 0),
      );
    });

    test('last cell has correct position', () {
      const size = BoardSize(
        rows: 3,
        columns: 4,
      );

      final board = Board(size: size);

      expect(
        board.cells.last.position,
        const Position(2, 3),
      );
    });

    test('setCell returns updated board', () {
      const size = BoardSize(
        rows: 3,
        columns: 3,
      );

      final board = Board(size: size);

      final updated = board.setCell(
        const Cell(
          position: Position(1, 1),
          letter: 'A',
          state: CellState.filled,
        ),
      );

      expect(
        updated
            .cellAt(
              const Position(1, 1),
            )
            .letter,
        'A',
      );
    });

    test('original board remains unchanged', () {
      const size = BoardSize(
        rows: 3,
        columns: 3,
      );

      final board = Board(size: size);

      final updated = board.setCell(
        const Cell(
          position: Position(1, 1),
          letter: 'A',
          state: CellState.filled,
        ),
      );

      expect(
        board
            .cellAt(
              const Position(1, 1),
            )
            .letter,
        isNull,
      );

      expect(
        updated
            .cellAt(
              const Position(1, 1),
            )
            .letter,
        'A',
      );
    });

    test('copyWith creates identical board', () {
      const size = BoardSize(
        rows: 2,
        columns: 2,
      );

      final board = Board(size: size);

      final copy = board.copyWith();

      expect(copy.size, board.size);
      expect(copy.cells, board.cells);
    });

    test('placeWord writes every letter', () {
      const size = BoardSize(
        rows: 10,
        columns: 10,
      );

      final board = Board(size: size);

      const placement = WordPlacement(
        word: Word('ATLAS'),
        position: Position(2, 3),
        direction: Direction.right,
      );

      final updated = board.placeWord(placement);

      expect(
        updated.cellAt(const Position(2, 3)).letter,
        'A',
      );

      expect(
        updated.cellAt(const Position(2, 4)).letter,
        'T',
      );

      expect(
        updated.cellAt(const Position(2, 5)).letter,
        'L',
      );

      expect(
        updated.cellAt(const Position(2, 6)).letter,
        'A',
      );

      expect(
        updated.cellAt(const Position(2, 7)).letter,
        'S',
      );
    });
  });
}
