import 'package:atlas_engine/atlas_engine.dart';
import 'package:test/test.dart';

void main() {
  test('creates a letter move with position and letter', () {
    const move = LetterMove(
      position: Position(2, 4),
      letter: 'T',
    );

    expect(move.position, const Position(2, 4));
    expect(move.letter, 'T');
  });

  test('considers moves with the same data equal', () {
    const first = LetterMove(
      position: Position(2, 4),
      letter: 'T',
    );

    const second = LetterMove(
      position: Position(2, 4),
      letter: 'T',
    );

    expect(first, equals(second));
    expect(first.hashCode, equals(second.hashCode));
  });


  ///
}