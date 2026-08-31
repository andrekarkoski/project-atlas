import '../core/models/board.dart';
import '../core/models/board_size.dart';
import '../domain/word.dart';
import 'placement_finder.dart';
import '../core/enums/direction.dart';
import '../core/models/position.dart';
import '../domain/word_placement.dart';
import 'placement_scorer.dart';
import 'word_orderer.dart';
import 'placement_validator.dart';

final class CrosswordGenerator {
  const CrosswordGenerator({
    this.finder = const PlacementFinder(),
    this.scorer = const PlacementScorer(),
    this.validator = const PlacementValidator(),
    this.orderer = const WordOrderer(),
  });

  final PlacementFinder finder;
  final PlacementScorer scorer;
  final PlacementValidator validator;
  final WordOrderer orderer;

  Board generate(
    BoardSize size,
    List<Word> words,
  ) {
    var board = Board(size: size);

    if (words.isEmpty) {
      return board;
    }

    final orderedWords = orderer.order(words);

    final firstWord = orderedWords.first;

    final startRow = size.rows ~/ 2;

    final startColumn = (size.columns - firstWord.length) ~/ 2;

    final firstPlacement = WordPlacement(
      word: firstWord,
      position: Position(
        startRow,
        startColumn,
      ),
      direction: Direction.right,
    );

    if (!validator.canPlace(board, firstPlacement)) {
      return board;
    }

    board = board.placeWord(firstPlacement);

    for (final word in orderedWords.skip(1)) {
      final candidates = finder.findCandidates(
        board,
        word,
      );

      WordPlacement? bestPlacement;
      var bestScore = -1;

      for (final placement in candidates) {
        final score = scorer.score(
          board,
          placement,
        );

        if (score > bestScore) {
          bestScore = score;
          bestPlacement = placement;
        }
      }

      if (bestPlacement != null) {
        board = board.placeWord(bestPlacement);
      }
    }

    return board;
  }
}
