import 'package:atlas_engine/atlas_engine.dart';
import 'package:test/test.dart';

void main() {
  group('WordOrderer', () {
    const orderer = WordOrderer();

    test('places longer words first', () {
      final result = orderer.order([
        Word('CASA'),
        Word('COMPUTADOR'),
        Word('ATLAS'),
      ]);

      expect(
        result.map((word) => word.text).toList(),
        [
          'COMPUTADOR',
          'ATLAS',
          'CASA',
        ],
      );
    });

    test('uses unique letters as tie breaker', () {
      final result = orderer.order([
        Word('AAAAA'),
        Word('ATLAS'),
      ]);

      expect(
        result.map((word) => word.text).toList(),
        [
          'ATLAS',
          'AAAAA',
        ],
      );
    });

    test('does not modify the original list', () {
      final words = [
        Word('CASA'),
        Word('COMPUTADOR'),
        Word('ATLAS'),
      ];

      orderer.order(words);

      expect(
        words.map((word) => word.text).toList(),
        [
          'CASA',
          'COMPUTADOR',
          'ATLAS',
        ],
      );
    });

  /// Fim
  });
}
