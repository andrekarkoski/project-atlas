import 'position.dart';

/// Immutable board dimensions.
final class BoardSize {
  const BoardSize({
    required this.rows,
    required this.columns,
  });

  final int rows;

  final int columns;

  /// Total number of cells.
  int get totalCells => rows * columns;

  /// True when rows == columns.
  bool get isSquare => rows == columns;

  /// Checks whether a position belongs to this board.
  bool contains(Position position) {
    return position.row >= 0 &&
        position.column >= 0 &&
        position.row < rows &&
        position.column < columns;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardSize && rows == other.rows && columns == other.columns;

  @override
  int get hashCode => Object.hash(
        rows,
        columns,
      );

  @override
  String toString() => 'BoardSize(rows: $rows, columns: $columns)';
}
