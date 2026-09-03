import '../core/enums/cell_state.dart';
import '../core/models/board.dart';
import '../core/models/cell.dart';
import '../domain/letter_move.dart';

final class LetterMoveApplier {
  const LetterMoveApplier();

  Board apply(
    Board board,
    LetterMove move,
    ) {
    final updatedCell = Cell(
        position: move.position,
        letter: move.letter,
        state: CellState.filled,
    );

    final updatedBoard = board.setCell(updatedCell);

    return updatedBoard.lockCompletedWords();
  }

  /// Applies a letter move to the board and returns a new board with the updated state.
}