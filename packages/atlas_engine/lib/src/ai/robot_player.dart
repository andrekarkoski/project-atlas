import '../core/models/board.dart';
import '../domain/letter_move.dart';
import '../game/game_turn.dart';
import '../validation/letter_move_validator.dart';

final class RobotPlayer {
  const RobotPlayer({
    this.validator = const LetterMoveValidator(),
  });

    final LetterMoveValidator validator;

    LetterMove? chooseMove(
        Board board,
        GameTurn turn,
    ) {
        LetterMove? bestMove;
        var bestCompletedWords = 0;
        var bestWordLength = 0;

        for (final cell in board.cells) {
            for (final letter in turn.rack.letters) {
                final move = LetterMove(
                    position: cell.position,
                    letter: letter,
                );

                if (!validator.isValid(board, move)) {
                    continue;
                }

                final completedWords = validator.completedWordCount(
                    board,
                    move,
                    );

                final wordLength = validator.longestCompletedWordLength(
                    board,
                    move,
                );

                if (completedWords > bestCompletedWords ||
                    (completedWords == bestCompletedWords &&
                        wordLength > bestWordLength)) {
                        bestCompletedWords = completedWords;
                        bestWordLength = wordLength;
                        bestMove = move;
                }

                if (bestMove == null) {
                    bestMove = move;
                }
            }
        }

        return bestMove;
      }
}