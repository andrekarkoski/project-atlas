import 'package:atlas_engine/atlas_engine.dart';
import 'package:test/test.dart';

void main() {
  group('AtlasEngine', () {
    test('creates board with first word', () {
      final engine = AtlasEngine();

      final board = engine.generate([
        const Word('ATLAS'),
      ]);

      expect(
        board.cells.where((c) => c.hasLetter).length,
        5,
      );
    });

    test('returns empty board for empty list', () {
      final engine = AtlasEngine();

      final board = engine.generate([]);

      expect(
        board.cells.where((c) => c.hasLetter).length,
        0,
      );
    });

    test('places multiple words', () {
      final engine = AtlasEngine();

      final board = engine.generate([
        const Word('ATLAS'),
        const Word('SOL'),
        const Word('DART'),
      ]);

      expect(
        board.cells.where((c) => c.hasLetter).length,
        greaterThan(5),
      );
    });

  /// Fim
  });
}
