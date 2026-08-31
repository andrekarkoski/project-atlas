/// Represents the orientation of an element inside the board.
enum Axis {
  horizontal,
  vertical;

  /// Returns the opposite axis.
  Axis get opposite {
    switch (this) {
      case Axis.horizontal:
        return Axis.vertical;
      case Axis.vertical:
        return Axis.horizontal;
    }
  }

  bool get isHorizontal => this == Axis.horizontal;

  bool get isVertical => this == Axis.vertical;
}
