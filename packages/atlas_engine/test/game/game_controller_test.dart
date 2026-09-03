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
  });
}