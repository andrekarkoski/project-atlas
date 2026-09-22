import 'package:atlas_engine/atlas_engine.dart';

final class GameController {
  const GameController({
    this.validator = const LetterMoveValidator(),
    this.applier = const LetterMoveApplier(),
    this.scorer = const LetterMoveScorer(),
    this.robotPlayer = const RobotPlayer(),
  });

  final LetterMoveValidator validator;
  final LetterMoveApplier applier;
  final LetterMoveScorer scorer;
  final RobotPlayer robotPlayer;

  bool isGameComplete(Board board) {
    const completionChecker = WordCompletionChecker();

    for (final placement in board.placements) {
      if (!completionChecker.isCompleted(board, placement)) {
        return false;
      }
    }

    return true;
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

  int scoreLetterMove(
    Board board,
    LetterMove move,
  ) {
    return scorer.score(board, move);
  }

  Board createInitialBoard() {
    const generator = CrosswordGenerator();

    const size = BoardSize(rows: 10, columns: 10);

    final generatedBoard = generator.generate(size, [
      Word('ATLAS'),
      Word('LASER'),
      Word('LETRA'),
      Word('REDE'),
    ]);

    var board = generatedBoard;

    for (final cell in generatedBoard.filledCells) {
      board = board.setCell(
        cell.copyWith(
          letter: null,
          state: CellState.empty,
        ),
      );
    }

    return board;
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

  GameMoveResult applyMove(
    Board board,
    GameTurn turn,
    LetterMove move,
  ) {
    if (!turn.rack.letters.contains(move.letter)) {
      return GameMoveResult(
        board: board,
        turn: turn,
      );
    }

    if (validator.isCompletedWordMove(board, move)) {
      return GameMoveResult(
        board: board,
        turn: turn,
      );
    }

    if (!validator.isValid(board, move)) {
      return GameMoveResult(
        board: board,
        turn: turn.addScore(scorer.score(board, move)),
      );
    }

    final updatedBoard = applier.apply(board, move);

    final score = scorer.score(board, move);

    final updatedTurn = turn
      .removeLetter(move.letter)
      .addMove(move)
      .addScore(score)
      .nextTurn();

    return GameMoveResult(
      board: updatedBoard,
      turn: updatedTurn,
    );
  }

  GameMoveResult applyRobotTurn(
    Board board,
    GameTurn turn,
  ) {
    final move = robotPlayer.chooseMove(board, turn);

    if (move == null) {
      return GameMoveResult(
        board: board,
        turn: turn,
      );
    }

    return applyMove(board, turn, move);
  }



  /// Fim
}
