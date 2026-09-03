import 'package:atlas_engine/atlas_engine.dart';

final class GameController {
  const GameController({
    this.validator = const LetterMoveValidator(),
    this.applier = const LetterMoveApplier(),
  });

  final LetterMoveValidator validator;
  final LetterMoveApplier applier;

  Board createInitialBoard() {
    const generator = CrosswordGenerator();

    const size = BoardSize(rows: 10, columns: 10);

    return generator.generate(size, [
      Word('ATLAS'),
      Word('LASER'),
      Word('LETRA'),
      Word('REDE'),
    ]);
  }

  Board applyLetterMove(
    Board board,
    LetterMove move,
  ) {
    if (!validator.isValid(board, move)) {
      return board;
    }

    return applier.apply(board, move);
  }

  Board placeLetter(Board board, Position position, String letter) {
    final currentCell = board.cellAt(position);

    if (currentCell.isBlocked || currentCell.isFilled) {
      return board;
    }

    final updatedCell = currentCell.copyWith(
      letter: letter,
      state: CellState.filled,
    );

    return board.setCell(updatedCell);
  }

  Board removeLetter(Board board, Position position) {
    final currentCell = board.cellAt(position);

    if (currentCell.isEmpty || currentCell.isBlocked) {
      return board;
    }

    final updatedCell = currentCell.copyWith(
      letter: null,
      state: CellState.empty,
    );

    return board.setCell(updatedCell);
  }

  Position? nextPlayablePosition(Board board, Position position) {
    var nextColumn = position.column + 1;
    var nextRow = position.row;

    while (nextRow < board.size.rows) {
      while (nextColumn < board.size.columns) {
        final nextPosition = Position(nextRow, nextColumn);
        final cell = board.cellAt(nextPosition);

        if (!cell.isBlocked && !cell.isFilled) {
          return nextPosition;
        }

        nextColumn++;
      }

      nextRow++;
      nextColumn = 0;
    }

    return null;
  }
}