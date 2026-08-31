import '../core/enums/direction.dart';
import '../core/models/board.dart';
import '../core/models/position.dart';
import '../domain/word_placement.dart';

/// Validates whether a word placement is allowed.
final class PlacementValidator {
  const PlacementValidator();

  /// Returns true if the placement is valid.
  bool canPlace(
    Board board,
    WordPlacement placement,
  ) {
    return _fitsInsideBoard(
          board,
          placement,
        ) &&
        _matchesExistingLetters(
          board,
          placement,
        ) &&
        _respectsAdjacency(
          board,
          placement,
        ) &&
        (board.filledCells.isEmpty ||
            _hasCrossing(
              board,
              placement,
            ));
  }

  bool _fitsInsideBoard(
    Board board,
    WordPlacement placement,
  ) {
    for (var i = 0; i < placement.word.length; i++) {
      if (!board.contains(
        placement.positionOf(i),
      )) {
        return false;
      }
    }

    return true;
  }

  bool _matchesExistingLetters(
    Board board,
    WordPlacement placement,
  ) {
    for (var i = 0; i < placement.word.length; i++) {
      final position = placement.positionOf(i);

      final cell = board.cellAt(position);

      if (!cell.hasLetter) {
        continue;
      }

      if (cell.letter != placement.word.text[i]) {
        return false;
      }
    }

    return true;
  }

  bool _respectsAdjacency(
    Board board,
    WordPlacement placement,
  ) {
    for (var i = 0; i < placement.word.length; i++) {
      final position = placement.positionOf(i);

      final currentCell = board.cellAt(position);

      // Uma célula já ocupada representa um cruzamento válido.
      final isCrossing = currentCell.hasLetter;

      if (placement.direction == Direction.right) {
        final above = position.translate(-1, 0);
        final below = position.translate(1, 0);

        if (!isCrossing) {
          if (_hasLetter(board, above) || _hasLetter(board, below)) {
            return false;
          }
        }
      } else {
        final left = position.translate(0, -1);
        final right = position.translate(0, 1);

        if (!isCrossing) {
          if (_hasLetter(board, left) || _hasLetter(board, right)) {
            return false;
          }
        }
      }
    }

    // Não permite que outra palavra fique imediatamente
    // antes ou depois desta palavra.
    final before = placement.position.translate(
      -placement.direction.rowOffset,
      -placement.direction.columnOffset,
    );

    final after = placement.endPosition.translate(
      placement.direction.rowOffset,
      placement.direction.columnOffset,
    );

    if (_hasLetter(board, before) || _hasLetter(board, after)) {
      return false;
    }

    return true;
  }

  bool _hasLetter(
    Board board,
    Position position,
  ) {
    if (!board.contains(position)) {
      return false;
    }

    return board.cellAt(position).hasLetter;
  }

  bool _hasCrossing(
    Board board,
    WordPlacement placement,
  ) {
    for (var i = 0; i < placement.word.length; i++) {
      final position = placement.positionOf(i);
      final cell = board.cellAt(position);

      if (cell.hasLetter) {
        return true;
      }
    }

    return false;
  }

  ////Fim
}
