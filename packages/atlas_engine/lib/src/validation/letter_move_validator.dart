import '../core/models/board.dart';
import '../core/models/cell.dart';
import '../domain/letter_move.dart';
import '../scoring/word_completion_checker.dart';
import '../core/enums/cell_state.dart';

final class LetterMoveValidator {
  const LetterMoveValidator({
    this.completionChecker = const WordCompletionChecker(),
  });

  final WordCompletionChecker completionChecker;

  bool isCompletedWordMove(
    Board board,
    LetterMove move,
  ) {
    final placements = board.placementsAt(move.position);

    for (final placement in placements) {
      if (completionChecker.isCompleted(board, placement)) {
        return true;
      }
    }

    return false;
  }

  bool completesWord(
    Board board,
    LetterMove move,
  ) {
    final placements = board.placementsAt(move.position);

    final updatedBoard = board.setCell(
      Cell(
        position: move.position,
        letter: move.letter,
        state: CellState.filled,
      ),
    );

    for (final placement in placements) {
      if (completionChecker.isCompleted(updatedBoard, placement)) {
        return true;
      }
    }

    return false;
  }

  int completedWordCount(
    Board board,
    LetterMove move,
  ) {
    final placements = board.placementsAt(move.position);

    final updatedBoard = board.setCell(
      Cell(
        position: move.position,
        letter: move.letter,
        state: CellState.filled,
      ),
    );

    var count = 0;

    for (final placement in placements) {
      if (completionChecker.isCompleted(updatedBoard, placement)) {
        count++;
      }
    }

    return count;
  }

  int longestCompletedWordLength(
    Board board,
    LetterMove move,
  ) {
    final placements = board.placementsAt(move.position);

    final updatedBoard = board.setCell(
      Cell(
        position: move.position,
        letter: move.letter,
        state: CellState.filled,
      ),
    );

    var longestLength = 0;

    for (final placement in placements) {
      if (completionChecker.isCompleted(updatedBoard, placement) &&
          placement.word.length > longestLength) {
        longestLength = placement.word.length;
      }
    }

    return longestLength;
  }


  bool isValid(Board board, LetterMove move) {
    final cell = board.cellAt(move.position);

    if (cell.isBlocked || cell.isLocked) {
      return false;
    }

    final placements = board.placementsAt(move.position);

    for (final placement in placements) {
      if (completionChecker.isCompleted(board, placement)) {
        return false;
      }
    }

    return board.expectedLetterAt(move.position) == move.letter;
  }
}