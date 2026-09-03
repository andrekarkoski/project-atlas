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

  /// Fim do Group
  });
}