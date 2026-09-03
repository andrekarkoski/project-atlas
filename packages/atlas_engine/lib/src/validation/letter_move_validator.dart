import '../core/models/board.dart';
import '../domain/letter_move.dart';
import '../scoring/word_completion_checker.dart';

final class LetterMoveValidator {
  const LetterMoveValidator({
    this.completionChecker = const WordCompletionChecker(),
  });

  final WordCompletionChecker completionChecker;

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