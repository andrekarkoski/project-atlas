import '../core/models/board.dart';
import '../domain/word_placement.dart';

final class PlacementScorer {
  const PlacementScorer({
    this.crossingScore = 10,
    this.centerDistancePenalty = 1,
    this.compactnessPenalty = 1,
  });

  final int crossingScore;
  final int centerDistancePenalty;
  final int compactnessPenalty;

  int score(
    Board board,
    WordPlacement placement,
  ) {
    var score = 0;

    // 1. Pontuação pelos cruzamentos.
    for (var i = 0; i < placement.word.length; i++) {
      final position = placement.positionOf(i);

      final cell = board.cellAt(position);

      if (cell.hasLetter) {
        score += crossingScore;
      }
    }

    // 2. Penalidade pela distância do centro.
    final centerRow = board.size.rows ~/ 2;
    final centerColumn = board.size.columns ~/ 2;

    final centerDistance = (placement.position.row - centerRow).abs() +
        (placement.position.column - centerColumn).abs();

    score -= centerDistance * centerDistancePenalty;

    // 3. Penalidade pela distância em relação
    //    às células já preenchidas.
    if (board.filledCells.isNotEmpty) {
      var minimumDistance = 999999;

      for (final cell in board.filledCells) {
        for (var i = 0; i < placement.word.length; i++) {
          final position = placement.positionOf(i);

          final distance = position.distanceTo(
            cell.position,
          );

          if (distance < minimumDistance) {
            minimumDistance = distance;
          }
        }
      }

      score -= minimumDistance * compactnessPenalty;
    }

    return score;
  }
}
