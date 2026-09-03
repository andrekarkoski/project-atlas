import 'package:atlas_engine/atlas_engine.dart';
import 'package:test/test.dart';

void main() {
  test('awards 10 points for a correct letter', () {
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

    final updated = board.copyWith(
        placements: [placement],
    );

    const scorer = LetterMoveScorer();

    expect(
      scorer.score(
        updated,
        const LetterMove(
          position: Position(2, 5),
          letter: 'T',
        ),
      ),
      10,
    );
  });

  test('awards -10 points for an incorrect letter', () {
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

    const scorer = LetterMoveScorer();

    expect(
        scorer.score(
        updated,
        const LetterMove(
            position: Position(2, 5),
            letter: 'X',
        ),
        ),
        -10,
    );
  });

  test('awards 30 points when a correct letter completes a word', () {
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

    final partialBoard = board
    .copyWith(
      placements: [placement],
    )
    .setCell(
      const Cell(
        position: Position(2, 4),
        letter: 'A',
        state: CellState.filled,
      ),
    )
    .setCell(
      const Cell(
        position: Position(2, 5),
        letter: 'T',
        state: CellState.filled,
      ),
    )
    .setCell(
      const Cell(
        position: Position(2, 6),
        letter: 'L',
        state: CellState.filled,
      ),
    )
    .setCell(
      const Cell(
        position: Position(2, 7),
        letter: 'A',
        state: CellState.filled,
      ),
    );

    const scorer = LetterMoveScorer();

    expect(
        scorer.score(
        partialBoard,
        const LetterMove(
            position: Position(2, 8),
            letter: 'S',
        ),
        ),
        30,
    );
  });  

  test('awards 50 points when one letter completes two crossing words', () {
    const size = BoardSize(
        rows: 10,
        columns: 10,
    );

    final board = Board(size: size);

    const atlasPlacement = WordPlacement(
        word: Word('ATLAS'),
        position: Position(4, 2),
        direction: Direction.right,
    );

    const casaPlacement = WordPlacement(
        word: Word('CASA'),
        position: Position(1, 5),
        direction: Direction.down,
    );

    final partialBoard = board
        .copyWith(
            placements: [
            atlasPlacement,
            casaPlacement,
            ],
        )
        .setCell(
            const Cell(
            position: Position(4, 2),
            letter: 'A',
            state: CellState.filled,
            ),
        )
        .setCell(
            const Cell(
            position: Position(4, 3),
            letter: 'T',
            state: CellState.filled,
            ),
        )
        .setCell(
            const Cell(
            position: Position(4, 4),
            letter: 'L',
            state: CellState.filled,
            ),
        )
        .setCell(
            const Cell(
            position: Position(4, 6),
            letter: 'S',
            state: CellState.filled,
            ),
        )
        .setCell(
            const Cell(
            position: Position(1, 5),
            letter: 'C',
            state: CellState.filled,
            ),
        )
        .setCell(
            const Cell(
            position: Position(2, 5),
            letter: 'A',
            state: CellState.filled,
            ),
        )
        .setCell(
            const Cell(
            position: Position(3, 5),
            letter: 'S',
            state: CellState.filled,
            ),
        );

    const scorer = LetterMoveScorer();

    expect(
        scorer.score(
        partialBoard,
        const LetterMove(
            position: Position(4, 5),
            letter: 'A',
        ),
        ),
        50,
    );
    });

  ///
}