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

    test('stores word placement', () {
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

      expect(updated.placements, contains(placement));
    });

    test('returns expected letter for a horizontal word placement', () {
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

      expect(updated.expectedLetterAt(Position(2, 3)), 'A');
      expect(updated.expectedLetterAt(Position(2, 4)), 'T');
      expect(updated.expectedLetterAt(Position(2, 5)), 'L');
      expect(updated.expectedLetterAt(Position(2, 6)), 'A');
      expect(updated.expectedLetterAt(Position(2, 7)), 'S');
    });

    test('returns expected letter for a vertical word placement', () {
      const size = BoardSize(
        rows: 10,
        columns: 10,
      );

      final board = Board(size: size);

      const placement = WordPlacement(
        word: Word('ATLAS'),
        position: Position(2, 3),
        direction: Direction.down,
      );

      final updated = board.placeWord(placement);

      expect(updated.expectedLetterAt(Position(2, 3)), 'A');
      expect(updated.expectedLetterAt(Position(3, 3)), 'T');
      expect(updated.expectedLetterAt(Position(4, 3)), 'L');
      expect(updated.expectedLetterAt(Position(5, 3)), 'A');
      expect(updated.expectedLetterAt(Position(6, 3)), 'S');
    });

    test('returns the same expected letter at a word intersection', () {
      const size = BoardSize(
        rows: 10,
        columns: 10,
      );

      final board = Board(size: size);

      const horizontal = WordPlacement(
        word: Word('ATLAS'),
        position: Position(4, 2),
        direction: Direction.right,
      );

      const vertical = WordPlacement(
        word: Word('LASER'),
        position: Position(4, 4),
        direction: Direction.down,
      );

      final updated = board
          .placeWord(horizontal)
          .placeWord(vertical);

      expect(updated.expectedLetterAt(Position(4, 4)), 'L');
    });

    test('does not allow a word placement with conflicting letters', () {
      const size = BoardSize(
        rows: 10,
        columns: 10,
      );

      final board = Board(size: size);

      const firstPlacement = WordPlacement(
        word: Word('ATLAS'),
        position: Position(4, 2),
        direction: Direction.right,
      );

      final updated = board.placeWord(firstPlacement);

      const conflictingPlacement = WordPlacement(
        word: Word('LUA'),
        position: Position(3, 4),
        direction: Direction.down,
      );

      expect(
        () => updated.placeWord(conflictingPlacement),
        throwsA(isA<StateError>()),
      );
    });

    test('returns word placements that contain a position', () {
      const size = BoardSize(
        rows: 10,
        columns: 10,
      );

      final board = Board(size: size);

      const horizontal = WordPlacement(
        word: Word('ATLAS'),
        position: Position(4, 2),
        direction: Direction.right,
      );

      const vertical = WordPlacement(
        word: Word('LASER'),
        position: Position(4, 4),
        direction: Direction.down,
      );

      final updated = board
          .placeWord(horizontal)
          .placeWord(vertical);

      final result = updated.placementsAt(Position(4, 4));

      expect(result, contains(horizontal));
      expect(result, contains(vertical));
      expect(result.length, 2);
    });

    test('locks cells when a word is completed', () {
      const placement = WordPlacement(
        word: Word('ATLAS'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      var board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [placement],
      );

      for (var i = 0; i < placement.word.length; i++) {
        final position = placement.positionOf(i);

        board = board.setCell(
          Cell(
            position: position,
            letter: placement.word.text[i],
            state: CellState.filled,
          ),
        );
      }

      final lockedBoard = board.lockCompletedWords();

      for (var i = 0; i < placement.word.length; i++) {
        final position = placement.positionOf(i);
        final cell = lockedBoard.cellAt(position);

        expect(cell.state, CellState.locked);
        expect(cell.isLocked, isTrue);
      }
    });

    test('does not lock cells when a word is incomplete', () {
      const placement = WordPlacement(
        word: Word('ATLAS'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      var board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [placement],
      );

      for (var i = 0; i < 4; i++) {
        final position = placement.positionOf(i);

        board = board.setCell(
          Cell(
            position: position,
            letter: placement.word.text[i],
            state: CellState.filled,
          ),
        );
      }

      final result = board.lockCompletedWords();

      for (var i = 0; i < 4; i++) {
        final position = placement.positionOf(i);

        expect(result.cellAt(position).state, CellState.filled);
        expect(result.cellAt(position).isLocked, isFalse);
      }
    });

    ///

  });
}
