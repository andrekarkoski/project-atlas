import 'package:atlas_engine/atlas_engine.dart';
import 'package:test/test.dart';

void main() {
  test('accepts a move on an empty playable cell', () {
    const size = BoardSize(
      rows: 10,
      columns: 10,
    );

    final board = Board(size: size);

    const placement = WordPlacement(
      word: Word('ATLAS'),
      position: Position(2, 3),
      direction: Direction.right,
    );

    final updated = board.copyWith(
      placements: [placement],
    );

    const validator = LetterMoveValidator();

    expect(
      validator.isValid(
        updated,
        const LetterMove(
          position: Position(2, 4),
          letter: 'T',
        ),
      ),
      isTrue,
    );
  });

  test('rejects a move with the wrong letter', () {
    const size = BoardSize(
      rows: 10,
      columns: 10,
    );

    final board = Board(size: size);

    const placement = WordPlacement(
      word: Word('ATLAS'),
      position: Position(2, 4),
      direction: Direction.right,
    );

    final updated = board.placeWord(placement);

    const validator = LetterMoveValidator();

    expect(
      validator.isValid(
        updated,
        const LetterMove(
          position: Position(2, 5),
          letter: 'X',
        ),
      ),
      isFalse,
    );
  });

  test('rejects a move on a cell without a word', () {
    const size = BoardSize(
      rows: 10,
      columns: 10,
    );

    final board = Board(size: size);

    const placement = WordPlacement(
      word: Word('ATLAS'),
      position: Position(2, 4),
      direction: Direction.right,
    );

    final updated = board.placeWord(placement);

    const validator = LetterMoveValidator();

    expect(
      validator.isValid(
        updated,
        const LetterMove(
          position: Position(0, 0),
          letter: 'A',
        ),
      ),
      isFalse,
    );
  });

  test('rejects a move on a blocked cell', () {
    const size = BoardSize(
      rows: 10,
      columns: 10,
    );

    final board = Board(size: size);

    final blockedBoard = board.setCell(
      const Cell(
        position: Position(2, 4),
        state: CellState.blocked,
      ),
    );

    const validator = LetterMoveValidator();

    expect(
      validator.isValid(
        blockedBoard,
        const LetterMove(
          position: Position(2, 4),
          letter: 'A',
        ),
      ),
      isFalse,
    );
  });

  test('rejects a move on a cell belonging to a completed word', () {
    const size = BoardSize(
      rows: 10,
      columns: 10,
    );

    final board = Board(size: size);

    const placement = WordPlacement(
      word: Word('ATLAS'),
      position: Position(2, 2),
      direction: Direction.right,
    );

    final completedBoard = board.placeWord(placement);

    const validator = LetterMoveValidator();

    expect(
      validator.isValid(
        completedBoard,
        const LetterMove(
          position: Position(2, 4),
          letter: 'L',
        ),
      ),
      false,
    );
  });

  test('rejects a move on a locked cell', () {
    const placement = WordPlacement(
      word: Word('ATLAS'),
      position: Position(2, 2),
      direction: Direction.right,
    );

    final board = Board(
      size: const BoardSize(rows: 5, columns: 5),
    ).setCell(
      const Cell(
        position: Position(2, 2),
        letter: 'A',
        state: CellState.locked,
      ),
    );

    const move = LetterMove(
      position: Position(2, 2),
      letter: 'A',
    );

    final validator = LetterMoveValidator();

    expect(validator.isValid(board.copyWith(
      placements: [placement],
    ), move), isFalse);
  });

  ///
}