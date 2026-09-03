import 'package:atlas_engine/atlas_engine.dart';
import 'package:test/test.dart';

void main() {
    test('detects when a word is completed', () {
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

        const checker = WordCompletionChecker();

        expect(
        checker.isCompleted(
            updated,
            placement,
        ),
        isTrue,
        );
    });

    test('detects when a partially filled word is completed', () {
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
            )
            .setCell(
                const Cell(
                position: Position(2, 8),
                letter: 'S',
                state: CellState.filled,
                ),
            );

        const checker = WordCompletionChecker();

        expect(
            checker.isCompleted(
            partialBoard,
            placement,
            ),
            isTrue,
        );
    });

    test('returns false when a word is still incomplete', () {
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

        const checker = WordCompletionChecker();

        expect(
            checker.isCompleted(
            partialBoard,
            placement,
            ),
            isFalse,
        );
    });
    
  ///
}