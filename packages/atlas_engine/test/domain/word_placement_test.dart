import 'package:atlas_engine/atlas_engine.dart';
import 'package:test/test.dart';

void main() {
  group('WordPlacement', () {
    const word = Word('ATLAS');

    test('stores values', () {
      const placement = WordPlacement(
        word: word,
        position: Position(2, 3),
        direction: Direction.right,
      );

      expect(placement.word, word);
      expect(placement.position, const Position(2, 3));
      expect(placement.direction, Direction.right);
    });

    test('calculates horizontal end position', () {
      const placement = WordPlacement(
        word: word,
        position: Position(5, 2),
        direction: Direction.right,
      );

      expect(
        placement.endPosition,
        const Position(5, 6),
      );
    });

    test('calculates vertical end position', () {
      const placement = WordPlacement(
        word: word,
        position: Position(5, 2),
        direction: Direction.down,
      );

      expect(
        placement.endPosition,
        const Position(9, 2),
      );
    });

    test('returns horizontal positions', () {
      const placement = WordPlacement(
        word: word,
        position: Position(1, 1),
        direction: Direction.right,
      );

      expect(
        placement.positionOf(0),
        const Position(1, 1),
      );

      expect(
        placement.positionOf(4),
        const Position(1, 5),
      );
    });

    test('returns vertical positions', () {
      const placement = WordPlacement(
        word: word,
        position: Position(1, 1),
        direction: Direction.down,
      );

      expect(
        placement.positionOf(0),
        const Position(1, 1),
      );

      expect(
        placement.positionOf(4),
        const Position(5, 1),
      );
    });

    test('supports equality', () {
      const a = WordPlacement(
        word: word,
        position: Position(0, 0),
        direction: Direction.right,
      );

      const b = WordPlacement(
        word: word,
        position: Position(0, 0),
        direction: Direction.right,
      );

      expect(a, b);
    });
  });
}
