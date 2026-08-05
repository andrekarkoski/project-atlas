class Position {
  const Position(this.row, this.column);

  final int row;
  final int column;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Position &&
        other.row == row &&
        other.column == column;
  }

  @override
  int get hashCode => Object.hash(row, column);

  @override
  String toString() => 'Position(row: $row, column: $column)';
}