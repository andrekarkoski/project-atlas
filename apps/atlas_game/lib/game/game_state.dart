import 'package:atlas_engine/atlas_engine.dart';

import 'game_controller.dart';

final class GameState {
    const GameState({
    required this.board,
    required this.turn,
    this.playerScore = 0,
    this.robotScore = 0,
  });

  final Board board;
  final GameTurn turn;
  final int playerScore;
  final int robotScore;

  GameState nextTurn() {
    return GameState(
      board: board,
      turn: turn.nextTurn(),
      playerScore: playerScore,
      robotScore: robotScore,
    );
  }

  GameState applyMove(LetterMove move) {
    const controller = GameController();

    final result = controller.applyMove(
      board,
      turn,
      move,
    );

    final points = result.turn.score - turn.score;

    var updatedPlayerScore = playerScore;
    var updatedRobotScore = robotScore;

    if (turn.owner == TurnOwner.player) {
      updatedPlayerScore += points;
    } else {
      updatedRobotScore += points;
    }

    return GameState(
      board: result.board,
      turn: result.turn,
      playerScore: updatedPlayerScore,
      robotScore: updatedRobotScore,
    );
  }

  GameState applyRobotTurn() {
    const controller = GameController();

    final result = controller.applyRobotTurn(
        board,
        turn,
    );

    return GameState(
      board: result.board,
      turn: result.turn,
      playerScore: playerScore,
      robotScore: robotScore,
    );
  }

  /// Fim Game State
}