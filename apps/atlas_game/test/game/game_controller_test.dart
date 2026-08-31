import 'package:atlas_engine/atlas_engine.dart';
import 'package:atlas_game/game/game_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameController', () {
    const controller = GameController();

    test('places a letter on the selected position', () {
      final board = controller.createInitialBoard();
      const position = Position(0, 0);

      final updatedBoard = controller.placeLetter(board, position, 'A');

      final cell = updatedBoard.cellAt(position);

      expect(cell.letter, 'A');
      expect(cell.isFilled, isTrue);
    });

    test('does not place a letter on a blocked cell', () {
      final board = controller.createInitialBoard();
      const position = Position(0, 0);

      final blockedCell = board
          .cellAt(position)
          .copyWith(state: CellState.blocked);

      final blockedBoard = board.setCell(blockedCell);

      final updatedBoard = controller.placeLetter(blockedBoard, position, 'A');

      final cell = updatedBoard.cellAt(position);

      expect(cell.isBlocked, isTrue);
      expect(cell.letter, isNull);
    });

    test('does not overwrite a filled cell', () {
      final board = controller.createInitialBoard();
      const position = Position(0, 0);

      final boardWithLetter = controller.placeLetter(board, position, 'A');

      final updatedBoard = controller.placeLetter(
        boardWithLetter,
        position,
        'B',
      );

      final cell = updatedBoard.cellAt(position);

      expect(cell.letter, 'A');
      expect(cell.isFilled, isTrue);
    });

    test('finds the next playable position', () {
      final board = controller.createInitialBoard();

      const position = Position(0, 0);

      final nextPosition = controller.nextPlayablePosition(board, position);

      expect(nextPosition, const Position(0, 1));
    });

    test('skips filled and blocked cells', () {
      final board = controller.createInitialBoard();

      const position = Position(0, 0);

      final filledBoard = controller.placeLetter(
        board,
        const Position(0, 1),
        'A',
      );

      final blockedCell = filledBoard
          .cellAt(const Position(0, 2))
          .copyWith(state: CellState.blocked);

      final blockedBoard = filledBoard.setCell(blockedCell);

      final nextPosition = controller.nextPlayablePosition(
        blockedBoard,
        position,
      );

      expect(nextPosition, const Position(0, 3));
    });

    test('returns null when there is no next playable position', () {
      const size = BoardSize(rows: 1, columns: 2);

      final board = Board(size: size);

      final filledBoard = controller.placeLetter(
        board,
        const Position(0, 1),
        'A',
      );

      final nextPosition = controller.nextPlayablePosition(
        filledBoard,
        const Position(0, 0),
      );

      expect(nextPosition, isNull);
    });

    test('removes a letter from a filled cell', () {
      final board = controller.createInitialBoard();
      const position = Position(0, 0);

      final filledBoard = controller.placeLetter(board, position, 'A');

      final updatedBoard = controller.removeLetter(filledBoard, position);

      final cell = updatedBoard.cellAt(position);

      expect(cell.letter, isNull);
      expect(cell.isEmpty, isTrue);
    });

    /// Fim Group
  });

  /// Fim
}
