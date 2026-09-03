import 'package:atlas_engine/atlas_engine.dart';
import 'package:atlas_game/game/game_controller.dart';
import 'package:test/test.dart';

void main() {
  group('GameController', () {
    const controller = GameController();

    test('applies a correct letter move and returns the updated board', () {
      const placement = WordPlacement(
        word: Word('ATLAS'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      final board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [placement],
      );

      final updatedBoard = controller.applyLetterMove(
        board,
        const LetterMove(
          position: Position(2, 0),
          letter: 'A',
        ),
      );

      final cell = updatedBoard.cellAt(
        const Position(2, 0),
      );

      expect(cell.letter, 'A');
      expect(cell.state, CellState.filled);
    });

    test('returns the score for a correct letter move', () {
      const placement = WordPlacement(
        word: Word('ATLAS'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      final board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [placement],
      );

      final score = controller.scoreLetterMove(
        board,
        const LetterMove(
          position: Position(2, 0),
          letter: 'A',
        ),
      );

      expect(score, 10);
    });

    test('returns 30 points when the move completes a word', () {
      const placement = WordPlacement(
        word: Word('ATLAS'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      var board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [placement],
      );

      board = board
          .setCell(const Cell(
            position: Position(2, 0),
            letter: 'A',
            state: CellState.filled,
          ))
          .setCell(const Cell(
            position: Position(2, 1),
            letter: 'T',
            state: CellState.filled,
          ))
          .setCell(const Cell(
            position: Position(2, 2),
            letter: 'L',
            state: CellState.filled,
          ))
          .setCell(const Cell(
            position: Position(2, 3),
            letter: 'A',
            state: CellState.filled,
          ));

      final score = controller.scoreLetterMove(
        board,
        const LetterMove(
          position: Position(2, 4),
          letter: 'S',
        ),
      );

      expect(score, 30);
    });

    test('returns -10 points for an incorrect letter move', () {
      const placement = WordPlacement(
        word: Word('ATLAS'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      final board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [placement],
      );

      final score = controller.scoreLetterMove(
        board,
        const LetterMove(
          position: Position(2, 0),
          letter: 'Z',
        ),
      );

      expect(score, -10);
    });

    test('locks a word after the move completes it', () {
      const placement = WordPlacement(
        word: Word('ATLAS'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      var board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [placement],
      );

      board = board
          .setCell(const Cell(
            position: Position(2, 0),
            letter: 'A',
            state: CellState.filled,
          ))
          .setCell(const Cell(
            position: Position(2, 1),
            letter: 'T',
            state: CellState.filled,
          ))
          .setCell(const Cell(
            position: Position(2, 2),
            letter: 'L',
            state: CellState.filled,
          ))
          .setCell(const Cell(
            position: Position(2, 3),
            letter: 'A',
            state: CellState.filled,
          ));

      final updatedBoard = controller.applyLetterMove(
        board,
        const LetterMove(
          position: Position(2, 4),
          letter: 'S',
        ),
      );

      for (var column = 0; column < 5; column++) {
        final cell = updatedBoard.cellAt(
          Position(2, column),
        );

        expect(cell.state, CellState.locked);
      }
    });

    test('keeps a word incomplete when the move does not complete it', () {
      const placement = WordPlacement(
        word: Word('ATLAS'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      final board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [placement],
      );

      final updatedBoard = controller.applyLetterMove(
        board,
        const LetterMove(
          position: Position(2, 0),
          letter: 'A',
        ),
      );

      final cell = updatedBoard.cellAt(
        const Position(2, 0),
      );

      expect(cell.letter, 'A');
      expect(cell.state, CellState.filled);
    });

    test('does not change the board for an incorrect letter move', () {
      const placement = WordPlacement(
        word: Word('ATLAS'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      final board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [placement],
      );

      final updatedBoard = controller.applyLetterMove(
        board,
        const LetterMove(
          position: Position(2, 0),
          letter: 'Z',
        ),
      );

      final cell = updatedBoard.cellAt(
        const Position(2, 0),
      );

      expect(cell.letter, isNull);
      expect(cell.state, CellState.empty);
    });

    test('does not change an already filled cell', () {
      const placement = WordPlacement(
        word: Word('ATLAS'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      final board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [placement],
      ).setCell(
        const Cell(
          position: Position(2, 0),
          letter: 'A',
          state: CellState.filled,
        ),
      );

      final updatedBoard = controller.applyLetterMove(
        board,
        const LetterMove(
          position: Position(2, 0),
          letter: 'T',
        ),
      );

      final cell = updatedBoard.cellAt(
        const Position(2, 0),
      );

      expect(cell.letter, 'A');
      expect(cell.state, CellState.filled);
    });

    test('does not change a blocked cell', () {
      const placement = WordPlacement(
        word: Word('ATLAS'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      final board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [placement],
      ).setCell(
        const Cell(
          position: Position(2, 0),
          state: CellState.blocked,
        ),
      );

      final updatedBoard = controller.applyLetterMove(
        board,
        const LetterMove(
          position: Position(2, 0),
          letter: 'A',
        ),
      );

      final cell = updatedBoard.cellAt(
        const Position(2, 0),
      );

      expect(cell.letter, isNull);
      expect(cell.state, CellState.blocked);
    });

  /// Fim Group  
  });

  /// Fim Main
}
