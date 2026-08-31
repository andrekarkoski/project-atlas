import '../core/models/board.dart';
import '../core/enums/direction.dart';
import '../domain/word.dart';
import '../domain/word_placement.dart';
import 'placement_validator.dart';
import '../core/models/position.dart';

/// Finds every valid position for a word.
final class PlacementFinder {
  const PlacementFinder({
    this.validator = const PlacementValidator(),
  });

  final PlacementValidator validator;

  Iterable<WordPlacement> findCandidates(
    Board board,
    Word word,
  ) sync* {
    if (board.filledCells.isEmpty) {
      for (var row = 0; row < board.size.rows; row++) {
        for (var column = 0; column < board.size.columns; column++) {
          for (final direction in [
            Direction.right,
            Direction.down,
          ]) {
            final placement = WordPlacement(
              word: word,
              position: Position(row, column),
              direction: direction,
            );

            if (validator.canPlace(board, placement)) {
              yield placement;
            }
          }
        }
      }

      return;
    }

    for (final cell in board.filledCells) {
      for (var offset = 0; offset < word.length; offset++) {
        if (word.text[offset] != cell.letter) {
          continue;
        }

        for (final direction in [
          Direction.right,
          Direction.down,
        ]) {
          final start = Position(
            cell.position.row - direction.rowOffset * offset,
            cell.position.column - direction.columnOffset * offset,
          );

          final placement = WordPlacement(
            word: word,
            position: start,
            direction: direction,
          );

          if (validator.canPlace(board, placement)) {
            yield placement;
          }
        }
      }
    }
  }
}
