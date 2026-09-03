import '../core/models/board.dart';
import '../core/models/position.dart';

final class LetterPlacementValidator {
  const LetterPlacementValidator();

  bool isCorrect(
    Board board,
    Position position,
    String letter,
  ) {
    return board.expectedLetterAt(position) == letter;
  }
}