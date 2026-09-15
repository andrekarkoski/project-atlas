import 'package:atlas_engine/atlas_engine.dart';

import 'game_controller.dart';

final class GameState {
  const GameState({
    required this.board,
    required this.turn,
  });

  final Board board;
  final GameTurn turn;

  GameState nextTurn() {
    return GameState(
      board: board,
      turn: turn.nextTurn(),
    );
  }

  GameState applyMove(LetterMove move) {
    const controller = GameController();

    final result = controller.applyMove(
      board,
      turn,
      move,
    );

    return GameState(
      board: result.board,
      turn: result.turn,
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
    );
  }

  /// Fim Game State
}