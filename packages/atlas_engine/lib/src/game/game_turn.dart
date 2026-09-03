import 'letter_rack.dart';

final class GameTurn {
  const GameTurn(
    this.rack, {
    this.score = 0,
  });

  final LetterRack rack;
  final int score;

  GameTurn addScore(int points) {
    return GameTurn(
      rack,
      score: score + points,
    );
  }
}