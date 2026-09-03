import '../core/models/board.dart';
import '../domain/word_placement.dart';

final class WordCompletionChecker {
  const WordCompletionChecker();

  bool isCompleted(
    Board board,
    WordPlacement placement,
  ) {
    for (var i = 0; i < placement.word.length; i++) {
      final position = placement.positionOf(i);
      final cell = board.cellAt(position);

      if (!cell.hasLetter ||
          cell.letter != placement.word.text[i]) {
        return false;
      }
    }

    return true;
  }
}