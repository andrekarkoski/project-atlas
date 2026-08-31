import 'package:atlas_engine/atlas_engine.dart';
import 'package:test/test.dart';

void main() {
  group('PlacementValidator', () {
    const validator = PlacementValidator();

    test('accepts placement inside board', () {
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

      expect(
        validator.canPlace(
          board,
          placement,
        ),
        isTrue,
      );
    });

    test('rejects placement outside board', () {
      const size = BoardSize(
        rows: 5,
        columns: 5,
      );

      final board = Board(size: size);

      const placement = WordPlacement(
        word: Word('ATLAS'),
        position: Position(4, 3),
        direction: Direction.right,
      );

      expect(
        validator.canPlace(
          board,
          placement,
        ),
        isFalse,
      );
    });

    test('allows crossing with same letter', () {
      const size = BoardSize(
        rows: 10,
        columns: 10,
      );

      final board = Board(size: size).placeWord(
        const WordPlacement(
          word: Word('ATLAS'),
          position: Position(2, 2),
          direction: Direction.right,
        ),
      );

      const placement = WordPlacement(
        word: Word('LASER'),
        position: Position(2, 4),
        direction: Direction.down,
      );

      expect(
        validator.canPlace(
          board,
          placement,
        ),
        isTrue,
      );
    });

    test('rejects conflicting letters', () {
      const size = BoardSize(
        rows: 10,
        columns: 10,
      );

      final board = Board(size: size).placeWord(
        const WordPlacement(
          word: Word('ATLAS'),
          position: Position(2, 2),
          direction: Direction.right,
        ),
      );

      const placement = WordPlacement(
        word: Word('BOLA'),
        position: Position(2, 4),
        direction: Direction.down,
      );

      expect(
        validator.canPlace(
          board,
          placement,
        ),
        isFalse,
      );
    });

    test('rejects touching words without crossing', () {
      final board = Board(
        size: const BoardSize(
          rows: 10,
          columns: 10,
        ),
      ).placeWord(
        const WordPlacement(
          word: Word('CASA'),
          position: Position(4, 2),
          direction: Direction.right,
        ),
      );

      const placement = WordPlacement(
        word: Word('BOLA'),
        position: Position(5, 2),
        direction: Direction.right,
      );

      expect(
        validator.canPlace(
          board,
          placement,
        ),
        isFalse,
      );
    });

    test('rejects placement without a crossing on a non-empty board', () {
      final board = Board(
        size: const BoardSize(
          rows: 10,
          columns: 10,
        ),
      ).placeWord(
        const WordPlacement(
          word: Word('ATLAS'),
          position: Position(2, 2),
          direction: Direction.right,
        ),
      );

      const placement = WordPlacement(
        word: Word('HOUSE'),
        position: Position(6, 2),
        direction: Direction.right,
      );

      expect(
        validator.canPlace(board, placement),
        isFalse,
      );
    });

    test('accepts placement when it crosses an existing word', () {
      final board = Board(
        size: const BoardSize(
          rows: 10,
          columns: 10,
        ),
      ).placeWord(
        const WordPlacement(
          word: Word('ATLAS'),
          position: Position(2, 2),
          direction: Direction.right,
        ),
      );

      const placement = WordPlacement(
        word: Word('LASER'),
        position: Position(2, 4),
        direction: Direction.down,
      );

      expect(
        validator.canPlace(board, placement),
        isTrue,
      );
    });

    test('rejects words touching side by side without crossing', () {
      final board = Board(
        size: const BoardSize(
          rows: 10,
          columns: 10,
        ),
      ).placeWord(
        const WordPlacement(
          word: Word('ATLAS'),
          position: Position(2, 2),
          direction: Direction.right,
        ),
      );

      const placement = WordPlacement(
        word: Word('HOUSE'),
        position: Position(3, 2),
        direction: Direction.right,
      );

      expect(
        validator.canPlace(board, placement),
        isFalse,
      );
    });

    test('allows words crossing an existing word', () {
      final board = Board(
        size: const BoardSize(
          rows: 10,
          columns: 10,
        ),
      ).placeWord(
        const WordPlacement(
          word: Word('ATLAS'),
          position: Position(2, 2),
          direction: Direction.right,
        ),
      );

      const placement = WordPlacement(
        word: Word('LASER'),
        position: Position(2, 4),
        direction: Direction.down,
      );

      expect(
        validator.canPlace(board, placement),
        isTrue,
      );
    });

  ///////fim
  });
}
