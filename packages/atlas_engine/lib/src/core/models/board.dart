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
    this.placements = const [],
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
    required this.placements,
  });

  /// Board dimensions.
  final BoardSize size;

  /// Cells stored in row-major order.
  final List<Cell> cells;
  final List<WordPlacement> placements;

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

  /// Returns the letter expected at the given position.
  ///
  /// Returns null when no word placement covers the position.
  String? expectedLetterAt(Position position) {
    for (final placement in placements) {
      for (var i = 0; i < placement.word.length; i++) {
        if (placement.positionOf(i) == position) {
          return placement.word.text[i];
        }
      }
    }

    return null;
  }

  /// Returns all word placements that contain the given position.
  List<WordPlacement> placementsAt(Position position) {
    return placements.where((placement) {
      for (var i = 0; i < placement.word.length; i++) {
        if (placement.positionOf(i) == position) {
          return true;
        }
      }

      return false;
    }).toList();
  }

  /// Calculates the internal list index.
  int _indexOf(Position position) {
    return position.row * size.columns + position.column;
  }

  /// Returns a new board replacing only the provided values.
  Board copyWith({
    BoardSize? size,
    List<Cell>? cells,
    List<WordPlacement>? placements,
  }) {
    return Board._(
      size: size ?? this.size,
      cells: cells ?? this.cells,
      placements: placements ?? this.placements,
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
  /// Places an entire word on the board.
  Board placeWord(WordPlacement placement) {
    for (var i = 0; i < placement.word.length; i++) {
      final position = placement.positionOf(i);

      if (!contains(position)) {
        throw StateError(
          'Word placement is outside board bounds.',
        );
      }

      final currentCell = cellAt(position);
      final expectedLetter = placement.word.text[i];

      if (currentCell.hasLetter &&
          currentCell.letter != expectedLetter) {
        throw StateError(
          'Word placement conflicts at $position.',
        );
      }
    }

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

    return result.copyWith(
      placements: [
        ...result.placements,
        placement,
      ],
    );
  }

  Board lockCompletedWords() {
    var result = this;

    for (final placement in placements) {
      
      var wordIsComplete = true;

      for (var i = 0; i < placement.word.length; i++) {
        final position = placement.positionOf(i);
        final cell = result.cellAt(position);

        if (!cell.hasLetter ||
            cell.letter != placement.word.text[i]) {
          wordIsComplete = false;
          break;
        }
      }

      if (!wordIsComplete) {
        continue;
      }

      for (var i = 0; i < placement.word.length; i++) {
        final position = placement.positionOf(i);
        final cell = result.cellAt(position);

        result = result.setCell(
          cell.copyWith(state: CellState.locked),
        );
      }
    }

    return result;
  }

  @override
  String toString() {
    return 'Board(size: $size, cells: ${cells.length})';
  }
}
