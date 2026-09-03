import '../core/enums/cell_state.dart';
import '../core/models/board.dart';
import '../core/models/cell.dart';
import '../domain/letter_move.dart';
import '../validation/letter_move_validator.dart';
import 'word_completion_checker.dart';

final class LetterMoveScorer {
  const LetterMoveScorer({
    this.validator = const LetterMoveValidator(),
    this.completionChecker = const WordCompletionChecker(),
  });

  final LetterMoveValidator validator;
  final WordCompletionChecker completionChecker;

  int score(
    Board board,
    LetterMove move,
    ) {
        if (!validator.isValid(board, move)) {
            return -10;
        }

        final updatedBoard = board.setCell(
            Cell(
            position: move.position,
            letter: move.letter,
            state: CellState.filled,
            ),
        );

        var score = 10;

        for (final placement in board.placements) {
            final wasCompleted = completionChecker.isCompleted(
            board,
            placement,
            );

            final isCompleted = completionChecker.isCompleted(
            updatedBoard,
            placement,
            );

            if (!wasCompleted && isCompleted) {
            score += 20;
            }
        }

        return score;
    }
}