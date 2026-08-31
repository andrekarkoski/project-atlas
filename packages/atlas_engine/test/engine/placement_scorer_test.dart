import 'package:atlas_engine/atlas_engine.dart';
import 'package:test/test.dart';

void main() {
  const scorer = PlacementScorer();

  test('crossing scores higher than empty placement', () {
    final board = Board(
      size: const BoardSize(
        rows: 10,
        columns: 10,
      ),
    ).placeWord(
      const WordPlacement(
        word: Word('ATLAS'),
        position: Position(2, 2),
        direction: Direction.right,
      ),
    );

    const crossing = WordPlacement(
      word: Word('LASER'),
      position: Position(2, 4),
      direction: Direction.down,
    );

    const empty = WordPlacement(
      word: Word('LASER'),
      position: Position(6, 5),
      direction: Direction.right,
    );

    expect(
      scorer.score(board, crossing),
      greaterThan(
        scorer.score(board, empty),
      ),
    );
  });

  test('more crossings score higher', () {
    final board = Board(
      size: const BoardSize(
        rows: 10,
        columns: 10,
      ),
    ).placeWord(
      const WordPlacement(
        word: Word('ATLAS'),
        position: Position(2, 2),
        direction: Direction.right,
      ),
    );

    final oneCrossing = const WordPlacement(
      word: Word('LASER'),
      position: Position(2, 4),
      direction: Direction.down,
    );

    final twoCrossingsBoard = board.placeWord(
      const WordPlacement(
        word: Word('CROSS'),
        position: Position(0, 4),
        direction: Direction.down,
      ),
    );

    final twoCrossings = const WordPlacement(
      word: Word('LASER'),
      position: Position(2, 2),
      direction: Direction.right,
    );

    expect(
      scorer.score(twoCrossingsBoard, twoCrossings),
      greaterThan(
        scorer.score(board, oneCrossing),
      ),
    );
  });

  test('placement with more crossings scores higher', () {
    final board = Board(
      size: const BoardSize(
        rows: 15,
        columns: 15,
      ),
    )
        .placeWord(
          const WordPlacement(
            word: Word('ATLAS'),
            position: Position(7, 5),
            direction: Direction.right,
          ),
        )
        .placeWord(
          const WordPlacement(
            word: Word('LASER'),
            position: Position(5, 7),
            direction: Direction.down,
          ),
        );

    const oneCrossing = WordPlacement(
      word: Word('START'),
      position: Position(7, 7),
      direction: Direction.right,
    );

    const twoCrossings = WordPlacement(
      word: Word('STARS'),
      position: Position(6, 7),
      direction: Direction.down,
    );

    expect(
      scorer.score(board, twoCrossings),
      greaterThan(
        scorer.score(board, oneCrossing),
      ),
    );
  });

  test('supports custom scoring weights', () {
    const scorer = PlacementScorer(
      crossingScore: 20,
      centerDistancePenalty: 2,
    );

    expect(
      scorer.crossingScore,
      20,
    );

    expect(
      scorer.centerDistancePenalty,
      2,
    );
  });

  test('supports custom scoring weights', () {
    const scorer = PlacementScorer(
      crossingScore: 20,
      centerDistancePenalty: 2,
    );

    final board = Board(
      size: const BoardSize(
        rows: 10,
        columns: 10,
      ),
    ).placeWord(
      const WordPlacement(
        word: Word('ATLAS'),
        position: Position(5, 2),
        direction: Direction.right,
      ),
    );

    const crossing = WordPlacement(
      word: Word('LASER'),
      position: Position(3, 4),
      direction: Direction.down,
    );

    final score = scorer.score(
      board,
      crossing,
    );

    expect(score, isA<int>());
  });

  test('an empty placement can still receive a positive score near the center',
      () {
    const scorer = PlacementScorer(
      crossingScore: 10,
      centerDistancePenalty: 1,
    );

    final board = Board(
      size: const BoardSize(
        rows: 10,
        columns: 10,
      ),
    );

    const placement = WordPlacement(
      word: Word('ATLAS'),
      position: Position(5, 5),
      direction: Direction.right,
    );

    final score = scorer.score(
      board,
      placement,
    );

    expect(score, greaterThanOrEqualTo(0));
  });

  test('returns the same score for the same placement', () {
    const scorer = PlacementScorer();

    final board = Board(
      size: const BoardSize(
        rows: 10,
        columns: 10,
      ),
    ).placeWord(
      const WordPlacement(
        word: Word('ATLAS'),
        position: Position(4, 2),
        direction: Direction.right,
      ),
    );

    const placement = WordPlacement(
      word: Word('LASER'),
      position: Position(2, 4),
      direction: Direction.down,
    );

    final firstScore = scorer.score(
      board,
      placement,
    );

    final secondScore = scorer.score(
      board,
      placement,
    );

    expect(
      firstScore,
      secondScore,
    );
  });

  test('multiple crossings score higher than a single crossing', () {
    final board = Board(
      size: const BoardSize(
        rows: 10,
        columns: 10,
      ),
    ).placeWord(
      const WordPlacement(
        word: Word('ATLAS'),
        position: Position(2, 2),
        direction: Direction.right,
      ),
    );

    const singleCrossing = WordPlacement(
      word: Word('LASER'),
      position: Position(2, 4),
      direction: Direction.down,
    );

    const multipleCrossings = WordPlacement(
      word: Word('ATLAS'),
      position: Position(2, 2),
      direction: Direction.right,
    );

    final singleScore = scorer.score(
      board,
      singleCrossing,
    );

    final multipleScore = scorer.score(
      board,
      multipleCrossings,
    );

    expect(
      multipleScore,
      greaterThan(singleScore),
    );
  });

  test('center placement scores higher than distant placement', () {
    final board = Board(
      size: const BoardSize(
        rows: 10,
        columns: 10,
      ),
    );

    const center = WordPlacement(
      word: Word('ATLAS'),
      position: Position(5, 3),
      direction: Direction.right,
    );

    const distant = WordPlacement(
      word: Word('ATLAS'),
      position: Position(0, 0),
      direction: Direction.right,
    );

    expect(
      scorer.score(board, center),
      greaterThan(
        scorer.score(board, distant),
      ),
    );
  });

  test('multiple crossings score higher than a single crossing', () {
    final board = Board(
      size: const BoardSize(
        rows: 10,
        columns: 10,
      ),
    ).placeWord(
      const WordPlacement(
        word: Word('ATLAS'),
        position: Position(2, 2),
        direction: Direction.right,
      ),
    );

    const singleCrossing = WordPlacement(
      word: Word('LASER'),
      position: Position(2, 4),
      direction: Direction.down,
    );

    const multipleCrossings = WordPlacement(
      word: Word('ATLAS'),
      position: Position(2, 2),
      direction: Direction.right,
    );

    expect(
      scorer.score(board, multipleCrossings),
      greaterThan(
        scorer.score(board, singleCrossing),
      ),
    );
  });

  test('compact placements score higher than distant placements', () {
    final board = Board(
      size: const BoardSize(
        rows: 15,
        columns: 15,
      ),
    ).placeWord(
      const WordPlacement(
        word: Word('ATLAS'),
        position: Position(7, 5),
        direction: Direction.right,
      ),
    );

    const compact = WordPlacement(
      word: Word('LASER'),
      position: Position(7, 7),
      direction: Direction.down,
    );

    const distant = WordPlacement(
      word: Word('LASER'),
      position: Position(0, 0),
      direction: Direction.down,
    );

    expect(
      scorer.score(board, compact),
      greaterThan(
        scorer.score(board, distant),
      ),
    );
  });

  test('compact placements score higher than distant placements', () {
    const scorer = PlacementScorer(
      crossingScore: 0,
      centerDistancePenalty: 0,
    );

    final board = Board(
      size: const BoardSize(
        rows: 15,
        columns: 15,
      ),
    ).placeWord(
      const WordPlacement(
        word: Word('ATLAS'),
        position: Position(7, 5),
        direction: Direction.right,
      ),
    );

    const compact = WordPlacement(
      word: Word('LASER'),
      position: Position(7, 7),
      direction: Direction.down,
    );

    const distant = WordPlacement(
      word: Word('LASER'),
      position: Position(0, 0),
      direction: Direction.down,
    );

    expect(
      scorer.score(board, compact),
      greaterThan(
        scorer.score(board, distant),
      ),
    );
  });

  test('compact placement scores higher when it expands the board less', () {
    const scorer = PlacementScorer(
      crossingScore: 0,
      centerDistancePenalty: 0,
      compactnessPenalty: 1,
    );

    final board = Board(
      size: const BoardSize(
        rows: 15,
        columns: 15,
      ),
    ).placeWord(
      const WordPlacement(
        word: Word('ATLAS'),
        position: Position(7, 5),
        direction: Direction.right,
      ),
    );

    const compact = WordPlacement(
      word: Word('LASER'),
      position: Position(7, 7),
      direction: Direction.down,
    );

    const distant = WordPlacement(
      word: Word('LASER'),
      position: Position(1, 1),
      direction: Direction.down,
    );

    expect(
      scorer.score(board, compact),
      greaterThan(
        scorer.score(board, distant),
      ),
    );
  });

  test('crossing score changes the value of a crossing', () {
    final board = Board(
      size: const BoardSize(
        rows: 10,
        columns: 10,
      ),
    ).placeWord(
      const WordPlacement(
        word: Word('ATLAS'),
        position: Position(2, 2),
        direction: Direction.right,
      ),
    );

    const crossing = WordPlacement(
      word: Word('LASER'),
      position: Position(2, 4),
      direction: Direction.down,
    );

    const withoutCrossingScore = PlacementScorer(
      crossingScore: 0,
      centerDistancePenalty: 0,
      compactnessPenalty: 0,
    );

    const withCrossingScore = PlacementScorer(
      crossingScore: 10,
      centerDistancePenalty: 0,
      compactnessPenalty: 0,
    );

    expect(
      withCrossingScore.score(board, crossing),
      greaterThan(
        withoutCrossingScore.score(board, crossing),
      ),
    );
  });

  test('center distance penalty affects the score', () {
    final board = Board(
      size: const BoardSize(
        rows: 10,
        columns: 10,
      ),
    );

    const nearCenter = WordPlacement(
      word: Word('ATLAS'),
      position: Position(5, 3),
      direction: Direction.right,
    );

    const farFromCenter = WordPlacement(
      word: Word('ATLAS'),
      position: Position(0, 0),
      direction: Direction.right,
    );

    const withoutCenterPenalty = PlacementScorer(
      crossingScore: 0,
      centerDistancePenalty: 0,
      compactnessPenalty: 0,
    );

    const withCenterPenalty = PlacementScorer(
      crossingScore: 0,
      centerDistancePenalty: 1,
      compactnessPenalty: 0,
    );

    expect(
      withoutCenterPenalty.score(board, nearCenter),
      equals(
        withoutCenterPenalty.score(board, farFromCenter),
      ),
    );

    expect(
      withCenterPenalty.score(board, nearCenter),
      greaterThan(
        withCenterPenalty.score(board, farFromCenter),
      ),
    );
  });

  test('compactness penalty affects the score', () {
    final board = Board(
      size: const BoardSize(
        rows: 15,
        columns: 15,
      ),
    ).placeWord(
      const WordPlacement(
        word: Word('ATLAS'),
        position: Position(7, 5),
        direction: Direction.right,
      ),
    );

    const nearBoard = WordPlacement(
      word: Word('LASER'),
      position: Position(7, 7),
      direction: Direction.down,
    );

    const farFromBoard = WordPlacement(
      word: Word('LASER'),
      position: Position(0, 0),
      direction: Direction.down,
    );

    const withoutCompactnessPenalty = PlacementScorer(
      crossingScore: 0,
      centerDistancePenalty: 0,
      compactnessPenalty: 0,
    );

    const withCompactnessPenalty = PlacementScorer(
      crossingScore: 0,
      centerDistancePenalty: 0,
      compactnessPenalty: 1,
    );

    expect(
      withoutCompactnessPenalty.score(board, nearBoard),
      equals(
        withoutCompactnessPenalty.score(board, farFromBoard),
      ),
    );

    expect(
      withCompactnessPenalty.score(board, nearBoard),
      greaterThan(
        withCompactnessPenalty.score(board, farFromBoard),
      ),
    );
  });

  ///Fim
}
