import 'letter_rack.dart';
import '../domain/letter_move.dart';
import '../core/enums/turn_owner.dart';

final class GameTurn {
  const GameTurn(
    this.rack, {
    this.owner = TurnOwner.player,
    this.score = 0,
    this.moves = const [],
  });

  final LetterRack rack;
  final int score;
  final List<LetterMove> moves;
  final TurnOwner owner;

  TurnOwner get nextOwner {
    return owner == TurnOwner.player
        ? TurnOwner.robot
        : TurnOwner.player;
  }

  GameTurn nextTurn() {
    return GameTurn(
      rack,
      owner: nextOwner,
      score: score,
      moves: moves,
    );
  }

  GameTurn addScore(int points) {
    return GameTurn(
      rack,
      owner: owner,
      score: score + points,
      moves: moves,
    );
  }

  GameTurn removeLetter(String letter) {
    return GameTurn(
      rack.remove(letter),
      owner: owner,
      score: score,
      moves: moves,
    );
  }

  GameTurn addMove(LetterMove move) {
    return GameTurn(
      rack,
      owner: owner,
      score: score,
      moves: [
        ...moves,
        move,
      ],
    );
  }

///
}