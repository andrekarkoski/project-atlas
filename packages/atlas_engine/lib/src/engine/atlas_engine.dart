import '../core/models/board.dart';
import '../core/models/board_size.dart';
import '../domain/word.dart';
import 'placement_finder.dart';

/// Main crossword generation engine.
final class AtlasEngine {
  AtlasEngine({
    PlacementFinder? finder,
  }) : _finder = finder ?? const PlacementFinder();

  final PlacementFinder _finder;

  Board generate(
    List<Word> words, {
    BoardSize size = const BoardSize(
      rows: 15,
      columns: 15,
    ),
  }) {
    var board = Board(size: size);

    for (final word in words) {
      final candidates = _finder
          .findCandidates(
            board,
            word,
          )
          .toList();

      if (candidates.isEmpty) {
        continue;
      }

      board = board.placeWord(
        candidates.first,
      );
    }

    return board;
  }
}
