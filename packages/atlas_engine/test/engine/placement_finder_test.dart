import 'package:atlas_engine/atlas_engine.dart';
import 'package:test/test.dart';

void main() {
  group('PlacementFinder', () {
    const finder = PlacementFinder();

    test('finds candidates on empty board', () {
      const size = BoardSize(
        rows: 5,
        columns: 5,
      );

      final board = Board(size: size);

      final candidates = finder.findCandidates(
        board,
        const Word('ABC'),
      );

      expect(
        candidates,
        isNotEmpty,
      );
    });

    test('every returned placement is valid', () {
      const size = BoardSize(
        rows: 5,
        columns: 5,
      );

      final board = Board(size: size);

      const validator = PlacementValidator();

      final candidates = finder.findCandidates(
        board,
        const Word('ABC'),
      );

      for (final placement in candidates) {
        expect(
          validator.canPlace(
            board,
            placement,
          ),
          isTrue,
        );
      }
    });

    test('returns no candidates when word is larger than board', () {
      const size = BoardSize(
        rows: 3,
        columns: 3,
      );

      final board = Board(size: size);

      final candidates = finder.findCandidates(
        board,
        const Word('ABCDEFGHIJ'),
      );

      expect(
        candidates,
        isEmpty,
      );
    });

    test('finds crossing candidates', () {
      final finder = PlacementFinder();

      var board = Board(
        size: const BoardSize(
          rows: 10,
          columns: 10,
        ),
      );

      board = board.placeWord(
        const WordPlacement(
          word: Word('ATLAS'),
          position: Position(2, 2),
          direction: Direction.right,
        ),
      );

      final placements = finder
          .findCandidates(
            board,
            const Word('LASER'),
          )
          .toList();

      expect(
        placements,
        isNotEmpty,
      );
    });

    test('returns only crossing candidates on a non-empty board', () {
      var board = Board(
        size: const BoardSize(
          rows: 10,
          columns: 10,
        ),
      );

      board = board.placeWord(
        const WordPlacement(
          word: Word('ATLAS'),
          position: Position(2, 2),
          direction: Direction.right,
        ),
      );

      final placements = finder
          .findCandidates(
            board,
            const Word('LASER'),
          )
          .toList();

      expect(
        placements,
        isNotEmpty,
      );

      for (final placement in placements) {
        var crossesExistingLetter = false;

        for (var i = 0; i < placement.word.length; i++) {
          final position = placement.positionOf(i);
          final cell = board.cellAt(position);

          if (cell.hasLetter) {
            crossesExistingLetter = true;
            break;
          }
        }

        expect(
          crossesExistingLetter,
          isTrue,
        );
      }
    });

  ///Fim
  });
}
