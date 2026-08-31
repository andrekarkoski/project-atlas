import 'package:atlas_engine/atlas_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Word', () {
    test('stores text', () {
      const word = Word('ATLAS');

      expect(word.text, 'ATLAS');
    });

    test('returns correct length', () {
      const word = Word('ATLAS');

      expect(word.length, 5);
    });

    test('is not empty', () {
      const word = Word('ATLAS');

      expect(word.isNotEmpty, isTrue);
      expect(word.isEmpty, isFalse);
    });

    test('returns correct letter', () {
      const word = Word('ATLAS');

      expect(word.letterAt(0), 'A');
      expect(word.letterAt(1), 'T');
      expect(word.letterAt(2), 'L');
    });

    test('returns all letters', () {
      const word = Word('DOG');

      expect(
        word.letters,
        ['D', 'O', 'G'],
      );
    });

    test('supports equality', () {
      const a = Word('DOG');
      const b = Word('DOG');

      expect(a, b);
    });

    test('different words are different', () {
      const a = Word('DOG');
      const b = Word('CAT');

      expect(a == b, isFalse);
    });
  });
}
