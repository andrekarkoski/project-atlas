import '../core/models/board.dart';
import 'game_turn.dart';

final class GameMoveResult {
  const GameMoveResult({
    required this.board,
    required this.turn,
  });

  final Board board;
  final GameTurn turn;
}
