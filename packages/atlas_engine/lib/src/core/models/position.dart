/// Represents an immutable position inside a board.
///
/// A [Position] is identified by its row and column.
/// It is a Value Object and contains no business logic related
/// to boards, words or cells.
///
/// Example:
///
/// ```dart
/// const position = Position(3, 5);
/// ```

import '../enums/direction.dart';

final class Position {
  /// Creates a new immutable position.
  const Position(this.row, this.column);

  /// Row index.
  final int row;

  /// Column index.
  final int column;

  /// Creates a new [Position] replacing only the supplied values.
  Position copyWith({
    int? row,
    int? column,
  }) {
    return Position(
      row ?? this.row,
      column ?? this.column,
    );
  }

  Position move(Direction direction) {
    return translate(
      direction.rowOffset,
      direction.columnOffset,
    );
  }

  /// Returns a translated position.
  Position translate(
    int rowOffset,
    int columnOffset,
  ) {
    return Position(
      row + rowOffset,
      column + columnOffset,
    );
  }

  /// Returns true if two positions touch horizontally or vertically.
  bool isAdjacentTo(Position other) {
    final rowDistance = (row - other.row).abs();
    final columnDistance = (column - other.column).abs();

    return rowDistance + columnDistance == 1;
  }

  /// Manhattan distance.
  int distanceTo(Position other) {
    return (row - other.row).abs() + (column - other.column).abs();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Position && row == other.row && column == other.column;

  @override
  int get hashCode => Object.hash(row, column);

  @override
  String toString() => 'Position(row: $row, column: $column)';
}
