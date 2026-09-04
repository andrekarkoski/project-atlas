import 'letter_rack.dart';
import '../domain/letter_move.dart';

final class GameTurn {
  const GameTurn(
    this.rack, {
    this.score = 0,
    this.moves = const [],
  });

  final LetterRack rack;
  final int score;
  final List<LetterMove> moves;

  GameTurn addScore(int points) {
    return GameTurn(
        rack,
        score: score + points,
        moves: moves,
    );
  }

    GameTurn removeLetter(String letter) {
        return GameTurn(
            rack.remove(letter),
            score: score,
            moves: moves,
        );
    }

  GameTurn addMove(LetterMove move) {
    return GameTurn(
        rack,
        score: score,
        moves: [
        ...moves,
        move,
        ],
    );
  }

///
}