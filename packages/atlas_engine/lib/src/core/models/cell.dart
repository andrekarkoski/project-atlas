import '../enums/cell_state.dart';
import 'position.dart';

/// Represents a single immutable board cell.
final class Cell {
  /// Creates a board cell.
  const Cell({
    required this.position,
    this.letter,
    this.state = CellState.empty,
  });

  /// Position inside the board.
  final Position position;

  /// Letter stored in the cell.
  final String? letter;

  /// Current state.
  final CellState state;

  /// Returns true when the cell has a letter.
  bool get hasLetter => letter != null && letter!.isNotEmpty;

  /// Returns true when the cell is empty.
  bool get isEmpty => state == CellState.empty;

  /// Returns true when the cell is filled.
  bool get isFilled => state == CellState.filled;

  /// Returns true when the cell is blocked.
  bool get isBlocked => state == CellState.blocked;

  static const Object _noLetterChange = Object();

  /// Creates a copy replacing only supplied values.
  Cell copyWith({
    Position? position,
    Object? letter = _noLetterChange,
    CellState? state,
  }) {
    return Cell(
      position: position ?? this.position,
      letter: identical(letter, _noLetterChange)
          ? this.letter
          : letter as String?,
      state: state ?? this.state,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cell &&
          position == other.position &&
          letter == other.letter &&
          state == other.state;

  @override
  int get hashCode => Object.hash(position, letter, state);

  @override
  String toString() =>
      'Cell(position: $position, letter: $letter, state: $state)';
}
