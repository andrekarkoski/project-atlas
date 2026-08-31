import '../enums/cell_state.dart';

import 'board_size.dart';
import 'cell.dart';
import 'position.dart';

import '../../domain/word_placement.dart';

/// Immutable crossword board.
final class Board {
  /// Creates a new empty board.
  Board({
    required this.size,
  }) : cells = List.generate(
          size.totalCells,
          (index) {
            final row = index ~/ size.columns;
            final column = index % size.columns;

            return Cell(
              position: Position(row, column),
            );
          },
        );

  /// Internal constructor used by copyWith().
  const Board._({
    required this.size,
    required this.cells,
  });

  /// Board dimensions.
  final BoardSize size;

  /// Cells stored in row-major order.
  final List<Cell> cells;

  /// Returns only cells that already contain letters.
  Iterable<Cell> get filledCells sync* {
    for (final cell in cells) {
      if (cell.hasLetter) {
        yield cell;
      }
    }
  }

  /// Returns true if the position belongs to the board.
  bool contains(Position position) {
    return size.contains(position);
  }

  /// Returns the cell at the given position.
  Cell cellAt(Position position) {
    if (!contains(position)) {
      throw RangeError(
        'Position $position is outside board bounds.',
      );
    }

    return cells[_indexOf(position)];
  }

  /// Allows board[position] syntax.
  Cell operator [](Position position) {
    return cellAt(position);
  }

  /// Calculates the internal list index.
  int _indexOf(Position position) {
    return position.row * size.columns + position.column;
  }

  /// Returns a new board replacing only the provided values.
  Board copyWith({
    BoardSize? size,
    List<Cell>? cells,
  }) {
    return Board._(
      size: size ?? this.size,
      cells: cells ?? this.cells,
    );
  }

  /// Returns a new board with one updated cell.
  Board setCell(Cell cell) {
    final updated = List<Cell>.from(cells);

    updated[_indexOf(cell.position)] = cell;

    return copyWith(
      cells: updated,
    );
  }

  /// Places an entire word on the board.
  Board placeWord(WordPlacement placement) {
    var result = this;

    for (var i = 0; i < placement.word.length; i++) {
      final position = placement.positionOf(i);

      final cell = Cell(
        position: position,
        letter: placement.word.text[i],
        state: CellState.filled,
      );

      result = result.setCell(cell);
    }

    return result;
  }

  @override
  String toString() {
    return 'Board(size: $size, cells: ${cells.length})';
  }
}
