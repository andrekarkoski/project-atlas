import '../core/enums/direction.dart';
import '../core/models/position.dart';
import 'word.dart';

/// Immutable placement of a word on the board.
final class WordPlacement {
  const WordPlacement({
    required this.word,
    required this.position,
    required this.direction,
  });

  /// Word being placed.
  final Word word;

  /// Initial position.
  final Position position;

  /// Placement direction.
  final Direction direction;

  /// Last occupied position.
  Position get endPosition {
    final offset = word.length - 1;

    switch (direction) {
      case Direction.right:
        return Position(
          position.row,
          position.column + offset,
        );

      case Direction.down:
        return Position(
          position.row + offset,
          position.column,
        );

      case Direction.left:
      case Direction.up:
        throw UnsupportedError(
          'WordPlacement currently supports only right and down directions.',
        );
    }
  }

  /// Returns the board position of one letter.
  Position positionOf(int index) {
    switch (direction) {
      case Direction.right:
        return Position(
          position.row,
          position.column + index,
        );

      case Direction.down:
        return Position(
          position.row + index,
          position.column,
        );

      case Direction.left:
      case Direction.up:
        throw UnsupportedError(
          'WordPlacement currently supports only right and down directions.',
        );
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordPlacement &&
          word == other.word &&
          position == other.position &&
          direction == other.direction;

  @override
  int get hashCode => Object.hash(
        word,
        position,
        direction,
      );

  @override
  String toString() {
    return '$word @ $position ($direction)';
  }
}
