import 'package:atlas_engine/atlas_engine.dart';
import 'package:test/test.dart';

void main() {
  group('LetterMoveApplier', () {
    test('applies a correct letter move to the board', () {
      const placement = WordPlacement(
        word: Word('ATLAS'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      final board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [placement],
      );

      const move = LetterMove(
        position: Position(2, 0),
        letter: 'A',
      );

      const applier = LetterMoveApplier();

      final updatedBoard = applier.apply(board, move);

      final cell = updatedBoard.cellAt(const Position(2, 0));

      expect(cell.letter, 'A');
      expect(cell.state, CellState.filled);
    });

    test('locks a word when the move completes it', () {
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

        const move = LetterMove(
            position: Position(2, 4),
            letter: 'S',
        );

        const applier = LetterMoveApplier();

        final updatedBoard = applier.apply(board, move);

        for (var i = 0; i < placement.word.length; i++) {
            final position = placement.positionOf(i);
            final cell = updatedBoard.cellAt(position);

            expect(cell.state, CellState.locked);
            expect(cell.isLocked, isTrue);
        }
    });

    test('keeps cells filled when the word is incomplete', () {
        const placement = WordPlacement(
            word: Word('ATLAS'),
            position: Position(2, 0),
            direction: Direction.right,
        );

        var board = Board(
            size: const BoardSize(rows: 5, columns: 5),
            placements: [placement],
        );

        board = board.setCell(
            const Cell(
            position: Position(2, 0),
            letter: 'A',
            state: CellState.filled,
            ),
        );

        const move = LetterMove(
            position: Position(2, 1),
            letter: 'T',
        );

        const applier = LetterMoveApplier();

        final updatedBoard = applier.apply(board, move);

        expect(
            updatedBoard.cellAt(const Position(2, 0)).state,
            CellState.filled,
        );

        expect(
            updatedBoard.cellAt(const Position(2, 1)).state,
            CellState.filled,
        );
    });
    
    /// Additional tests can be added here to cover more scenarios.
  });

  /// Additional tests can be added here to cover more scenarios.
}