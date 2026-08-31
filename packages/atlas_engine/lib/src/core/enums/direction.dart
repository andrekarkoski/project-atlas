import 'axis.dart';

/// Represents movement inside the board.
enum Direction {
  up(
    rowOffset: -1,
    columnOffset: 0,
    axis: Axis.vertical,
  ),

  down(
    rowOffset: 1,
    columnOffset: 0,
    axis: Axis.vertical,
  ),

  left(
    rowOffset: 0,
    columnOffset: -1,
    axis: Axis.horizontal,
  ),

  right(
    rowOffset: 0,
    columnOffset: 1,
    axis: Axis.horizontal,
  );

  const Direction({
    required this.rowOffset,
    required this.columnOffset,
    required this.axis,
  });

  final int rowOffset;

  final int columnOffset;

  final Axis axis;

  bool get isHorizontal => axis.isHorizontal;

  bool get isVertical => axis.isVertical;

  Direction get opposite {
    switch (this) {
      case Direction.up:
        return Direction.down;

      case Direction.down:
        return Direction.up;

      case Direction.left:
        return Direction.right;

      case Direction.right:
        return Direction.left;
    }
  }
}
