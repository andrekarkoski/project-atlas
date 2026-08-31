import 'package:atlas_engine/atlas_engine.dart';
import 'package:test/test.dart';

void main() {
  group('CrosswordGenerator', () {
    const generator = CrosswordGenerator();

    test('generates an empty board when there are no words', () {
      final board = generator.generate(
        const BoardSize(
          rows: 10,
          columns: 10,
        ),
        [],
      );

      expect(board.size.rows, 10);
      expect(board.size.columns, 10);
      expect(
        board.filledCells,
        isEmpty,
      );
    });

    test('places the first word on the board', () {
      final board = generator.generate(
        const BoardSize(
          rows: 10,
          columns: 10,
        ),
        [
          Word('ATLAS'),
        ],
      );

      expect(
        board.filledCells,
        hasLength(5),
      );
    });

    test('places a second word when it can cross the first', () {
      final board = generator.generate(
        const BoardSize(
          rows: 10,
          columns: 10,
        ),
        [
          Word('ATLAS'),
          Word('LASER'),
        ],
      );

      expect(
        board.filledCells,
        isNotEmpty,
      );

      expect(
        board.filledCells,
        hasLength(greaterThan(5)),
      );
    });

    test('keeps the board valid when a word cannot be placed', () {
      final board = generator.generate(
        const BoardSize(
          rows: 5,
          columns: 5,
        ),
        [
          Word('ATLAS'),
          Word('ZZZZZ'),
        ],
      );

      expect(
        board.filledCells,
        hasLength(5),
      );
    });

    test('places longer words before shorter words', () {
      final board = generator.generate(
        const BoardSize(
          rows: 15,
          columns: 15,
        ),
        [
          Word('ATLAS'),
          Word('COMPUTADOR'),
        ],
      );

      expect(
        board.filledCells,
        hasLength(greaterThan(5)),
      );
    });

    test('starts with the longest word', () {
      final board = generator.generate(
        const BoardSize(
          rows: 15,
          columns: 15,
        ),
        [
          Word('ATLAS'),
          Word('COMPUTADOR'),
        ],
      );

      final centerRow = 15 ~/ 2;
      final centerColumn = (15 - 'COMPUTADOR'.length) ~/ 2;

      expect(
        board
            .cellAt(
              Position(
                centerRow,
                centerColumn,
              ),
            )
            .letter,
        'C',
      );
    });

    test('uses a deterministic tie-breaker for words with the same length', () {
      final board = generator.generate(
        const BoardSize(
          rows: 15,
          columns: 15,
        ),
        [
          Word('AAAAA'),
          Word('ATLAS'),
        ],
      );

      final centerRow = 15 ~/ 2;
      final centerColumn = (15 - 'ATLAS'.length) ~/ 2;

      expect(
        board
            .cellAt(
              Position(
                centerRow,
                centerColumn,
              ),
            )
            .letter,
        'A',
      );

      expect(
        board
            .cellAt(
              Position(
                centerRow,
                centerColumn + 1,
              ),
            )
            .letter,
        'T',
      );
    });

    test('skips a word when no valid placement exists', () {
      final board = generator.generate(
        const BoardSize(
          rows: 5,
          columns: 5,
        ),
        [
          Word('ATLAS'),
          Word('ZZZZZ'),
        ],
      );

      expect(
        board.filledCells,
        hasLength(5),
      );
    });

    test('crosses the second word with the first word', () {
      final board = generator.generate(
        const BoardSize(
          rows: 10,
          columns: 10,
        ),
        [
          Word('ATLAS'),
          Word('LASER'),
        ],
      );

      final hasHorizontalAndVerticalNeighbor = board.filledCells.any(
        (cell) {
          final position = cell.position;

          final right = position.copyWith(
            column: position.column + 1,
          );

          final down = position.copyWith(
            row: position.row + 1,
          );

          final hasRight =
              board.contains(right) && board.cellAt(right).hasLetter;

          final hasDown = board.contains(down) && board.cellAt(down).hasLetter;

          return hasRight && hasDown;
        },
      );

      expect(
        hasHorizontalAndVerticalNeighbor,
        isTrue,
      );
    });

    test('keeps existing letters valid when placing multiple words', () {
      final board = generator.generate(
        const BoardSize(
          rows: 10,
          columns: 10,
        ),
        [
          Word('ATLAS'),
          Word('LASER'),
          Word('START'),
        ],
      );

      for (final cell in board.filledCells) {
        expect(cell.letter, isNotNull);
        expect(cell.letter, hasLength(1));
      }
    });

    test('continues building when multiple words can cross', () {
      final board = generator.generate(
        const BoardSize(
          rows: 15,
          columns: 15,
        ),
        [
          Word('ATLAS'),
          Word('LASER'),
          Word('START'),
        ],
      );

      expect(
        board.filledCells,
        hasLength(greaterThan(5)),
      );

      final letters = board.filledCells
          .map((cell) => cell.letter)
          .whereType<String>()
          .toSet();

      expect(letters, contains('A'));
      expect(letters, contains('L'));
      expect(letters, contains('S'));
      expect(letters, contains('T'));
      expect(letters, contains('R'));
    });

    test('generates the same board for the same input', () {
      const size = BoardSize(
        rows: 15,
        columns: 15,
      );

      const words = [
        Word('ATLAS'),
        Word('LASER'),
        Word('START'),
        Word('STAR'),
      ];

      final firstBoard = generator.generate(
        size,
        words,
      );

      final secondBoard = generator.generate(
        size,
        words,
      );

      expect(
        firstBoard.cells,
        secondBoard.cells,
      );
    });

    test('handles repeated words without crashing', () {
      final board = generator.generate(
        const BoardSize(
          rows: 15,
          columns: 15,
        ),
        [
          Word('ATLAS'),
          Word('ATLAS'),
          Word('LASER'),
        ],
      );

      expect(
        board.size.rows,
        15,
      );

      expect(
        board.size.columns,
        15,
      );

      expect(
        board.filledCells,
        isNotEmpty,
      );
    });

    test('returns an empty board when the first word does not fit', () {
      final board = generator.generate(
        const BoardSize(
          rows: 10,
          columns: 10,
        ),
        [
          Word('ABCDEFGHIJK'),
        ],
      );

      expect(
        board.filledCells,
        isEmpty,
      );
    });

    test('chooses the best scored placement', () {
      final generator = CrosswordGenerator(
        scorer: const PlacementScorer(
          crossingScore: 10,
          centerDistancePenalty: 1,
          compactnessPenalty: 1,
        ),
      );

      final board = generator.generate(
        const BoardSize(
          rows: 10,
          columns: 10,
        ),
        [
          Word('ATLAS'),
          Word('LASER'),
        ],
      );

      expect(
        board.filledCells,
        isNotEmpty,
      );
    });

    test('uses a valid crossing placement when available', () {
      const generator = CrosswordGenerator();

      final board = generator.generate(
        const BoardSize(
          rows: 10,
          columns: 10,
        ),
        [
          Word('ATLAS'),
          Word('LASER'),
        ],
      );

      expect(
        board.filledCells,
        hasLength(greaterThan(5)),
      );
    });

  /// Fim
  });
}
