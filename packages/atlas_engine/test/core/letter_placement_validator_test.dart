import 'package:atlas_engine/atlas_engine.dart';
import 'package:test/test.dart';

void main() {
    test('accepts a letter that matches the expected letter', () {
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

        final updated = board.placeWord(placement);

        const validator = LetterPlacementValidator();

        expect(
            validator.isCorrect(
            updated,
            Position(2, 4),
            'T',
            ),
            isTrue,
        );
    });

    test('rejects a letter that does not match the expected letter', () {
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

        final updated = board.placeWord(placement);

        const validator = LetterPlacementValidator();

        expect(
        validator.isCorrect(
            updated,
            Position(2, 4),
            'X',
        ),
        isFalse,
        );
    });

    test('rejects a letter on a position without a word', () {
        const size = BoardSize(
        rows: 10,
        columns: 10,
        );

        final board = Board(size: size);

        const validator = LetterPlacementValidator();

        expect(
        validator.isCorrect(
            board,
            Position(5, 5),
            'A',
        ),
        isFalse,
        );
    });

  ///
}