import 'package:atlas_engine/atlas_engine.dart';
import 'package:test/test.dart';

void main() {
  group('LetterRack', () {
    test('contains the available letters', () {
      const rack = LetterRack([
        'Z',
        'R',
        'T',
        'L',
        'A',
      ]);

      expect(rack.letters, [
        'Z',
        'R',
        'T',
        'L',
        'A',
      ]);
    });

    test('removes a letter from the rack', () {
      const rack = LetterRack([
        'Z',
        'R',
        'T',
        'L',
        'A',
      ]);

      final updatedRack = rack.remove('A');

      expect(updatedRack.letters, [
        'Z',
        'R',
        'T',
        'L',
      ]);
    });

    test('keeps the rack unchanged when removing an unavailable letter', () {
      const rack = LetterRack([
        'Z',
        'R',
        'T',
        'L',
        'A',
      ]);

      final updatedRack = rack.remove('X');

      expect(updatedRack.letters, [
        'Z',
        'R',
        'T',
        'L',
        'A',
      ]);
    });

    test('removes only one occurrence when the letter appears multiple times', () {
      const rack = LetterRack([
        'A',
        'A',
        'T',
        'L',
        'S',
      ]);

      final updatedRack = rack.remove('A');

      expect(updatedRack.letters, [
        'A',
        'T',
        'L',
        'S',
      ]);
    });

    test('keeps the original rack unchanged after removing a letter', () {
      const rack = LetterRack([
        'Z',
        'R',
        'T',
        'L',
        'A',
      ]);

      final updatedRack = rack.remove('A');

      expect(rack.letters, [
        'Z',
        'R',
        'T',
        'L',
        'A',
      ]);

      expect(updatedRack.letters, [
        'Z',
        'R',
        'T',
        'L',
      ]);
    });

    test('checks whether a letter is available', () {
      const rack = LetterRack([
        'Z',
        'R',
        'T',
        'L',
        'A',
      ]);

      expect(rack.contains('A'), isTrue);
      expect(rack.contains('X'), isFalse);
    });

    test('reports the number of available letters', () {
      const rack = LetterRack([
        'Z',
        'R',
        'T',
        'L',
        'A',
      ]);

      expect(rack.length, 5);
    });

    test('creates an independent rack copy', () {
      const original = LetterRack([
        'A',
        'T',
        'L',
      ]);

      final copy = LetterRack.from(original);

      final updatedCopy = copy.remove('A');

      expect(original.letters, [
        'A',
        'T',
        'L',
      ]);

      expect(updatedCopy.letters, [
        'T',
        'L',
      ]);
    });
    
        
  /// Fim do Group
  });
}
