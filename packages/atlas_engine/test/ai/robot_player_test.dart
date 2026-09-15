import 'package:atlas_engine/atlas_engine.dart';
import 'package:test/test.dart';

void main() {
  group('RobotPlayer', () {
    test('returns a valid move from the board and turn rack', () {
        const placement = WordPlacement(
            word: Word('ATLAS'),
            position: Position(2, 0),
            direction: Direction.right,
        );

        final board = Board(
            size: const BoardSize(rows: 5, columns: 5),
            placements: [placement],
        );

        const turn = GameTurn(
            LetterRack(['A', 'T', 'L']),
        );

        const robot = RobotPlayer();

        final move = robot.chooseMove(board, turn);

        expect(move, isNotNull);
        expect(turn.rack.letters, contains(move!.letter));
        expect(board.expectedLetterAt(move.position), move.letter);
        });
    });

    test('returns null when no letter in the rack is valid', () {
        const placement = WordPlacement(
            word: Word('ATLAS'),
            position: Position(2, 0),
            direction: Direction.right,
        );

        final board = Board(
            size: const BoardSize(rows: 5, columns: 5),
            placements: [placement],
        );

        const turn = GameTurn(
            LetterRack(['Z']),
        );

        const robot = RobotPlayer();

        final move = robot.chooseMove(board, turn);

        expect(move, isNull);
    });

    test('does not choose a move on a completed word', () {
        const placement = WordPlacement(
            word: Word('AT'),
            position: Position(2, 0),
            direction: Direction.right,
        );

        var board = Board(
            size: const BoardSize(rows: 5, columns: 5),
            placements: [placement],
        );

        board = board.setCell(
            const Cell(
            position: Position(2, 0),
            letter: 'A',
            state: CellState.filled,
            ),
        );

        board = board.setCell(
            const Cell(
            position: Position(2, 1),
            letter: 'T',
            state: CellState.filled,
            ),
        );

        const turn = GameTurn(
            LetterRack(['A', 'T']),
        );

        const robot = RobotPlayer();

        final move = robot.chooseMove(board, turn);

        expect(move, isNull);
    });

    test('chooses one of the valid moves when multiple moves are available', () {
        const placement = WordPlacement(
            word: Word('ATLAS'),
            position: Position(2, 0),
            direction: Direction.right,
        );

        final board = Board(
            size: const BoardSize(rows: 5, columns: 5),
            placements: [placement],
        );

        const turn = GameTurn(
            LetterRack(['A', 'T', 'L']),
        );

        const robot = RobotPlayer();

        final move = robot.chooseMove(board, turn);

        expect(move, isNotNull);
        expect(
            [
            const LetterMove(
                position: Position(2, 0),
                letter: 'A',
            ),
            const LetterMove(
                position: Position(2, 1),
                letter: 'T',
            ),
            const LetterMove(
                position: Position(2, 2),
                letter: 'L',
            ),
            ],
            contains(move),
        );
    });

    test('prefers a move that completes a word', () {
        const placement = WordPlacement(
            word: Word('AT'),
            position: Position(2, 0),
            direction: Direction.right,
        );

        var board = Board(
            size: const BoardSize(rows: 5, columns: 5),
            placements: [placement],
        );

        board = board.setCell(
            const Cell(
            position: Position(2, 0),
            letter: 'A',
            state: CellState.filled,
            ),
        );

        const turn = GameTurn(
            LetterRack(['T', 'L']),
        );

        const robot = RobotPlayer();

        final move = robot.chooseMove(board, turn);

        expect(
            move,
            const LetterMove(
            position: Position(2, 1),
            letter: 'T',
            ),
        );
    });

    test('prefers completing a word over an earlier valid move', () {
        const placement1 = WordPlacement(
            word: Word('ALA'),
            position: Position(0, 0),
            direction: Direction.right,
        );

        const placement2 = WordPlacement(
            word: Word('AT'),
            position: Position(2, 0),
            direction: Direction.right,
        );

        var board = Board(
            size: const BoardSize(rows: 5, columns: 5),
            placements: [placement1, placement2],
        );

        // A primeira palavra precisa de L na posição (0, 1).
        // Essa será a primeira jogada válida encontrada pelo algoritmo atual.
        board = board.setCell(
            const Cell(
            position: Position(0, 0),
            letter: 'A',
            state: CellState.filled,
            ),
        );

        // A segunda palavra precisa de T na posição (2, 1).
        // Essa jogada completa a palavra e deve ser priorizada.
        board = board.setCell(
            const Cell(
            position: Position(2, 0),
            letter: 'A',
            state: CellState.filled,
            ),
        );

        const turn = GameTurn(
            LetterRack(['L', 'T']),
        );

        const robot = RobotPlayer();

        final move = robot.chooseMove(board, turn);

        expect(
            move,
            const LetterMove(
            position: Position(2, 1),
            letter: 'T',
            ),
        );
    });

    test('returns a valid move when no move completes a word', () {
        const placement = WordPlacement(
            word: Word('ATLAS'),
            position: Position(2, 0),
            direction: Direction.right,
        );

        var board = Board(
            size: const BoardSize(rows: 5, columns: 5),
            placements: [placement],
        );

        board = board.setCell(
            const Cell(
            position: Position(2, 0),
            letter: 'A',
            state: CellState.filled,
            ),
        );

        const turn = GameTurn(
            LetterRack(['L']),
        );

        const robot = RobotPlayer();

        final move = robot.chooseMove(board, turn);

        expect(move, isNotNull);
        expect(move!.letter, 'L');
        expect(board.expectedLetterAt(move.position), 'L');
    });


    test('prefers a move that completes more than one word', () {
        const placement1 = WordPlacement(
            word: Word('AT'),
            position: Position(2, 0),
            direction: Direction.right,
        );

        const placement2 = WordPlacement(
            word: Word('BAT'),
            position: Position(0, 1),
            direction: Direction.down,
        );

        const placement3 = WordPlacement(
            word: Word('AL'),
            position: Position(0, 3),
            direction: Direction.right,
        );

        var board = Board(
            size: const BoardSize(rows: 5, columns: 5),
            placements: [
            placement1,
            placement2,
            placement3,
            ],
        );

        board = board.setCell(
            const Cell(
            position: Position(2, 0),
            letter: 'A',
            state: CellState.filled,
            ),
        );

        board = board.setCell(
            const Cell(
            position: Position(0, 1),
            letter: 'B',
            state: CellState.filled,
            ),
        );

        board = board.setCell(
            const Cell(
            position: Position(1, 1),
            letter: 'A',
            state: CellState.filled,
            ),
        );

        board = board.setCell(
            const Cell(
            position: Position(0, 3),
            letter: 'A',
            state: CellState.filled,
            ),
        );

        const turn = GameTurn(
            LetterRack(['L', 'T']),
        );

        const robot = RobotPlayer();

        final move = robot.chooseMove(board, turn);

        expect(
            move,
            const LetterMove(
            position: Position(2, 1),
            letter: 'T',
            ),
        );
    });

    test('prefers completing the longer word when completion count is tied', () {
        const shortPlacement = WordPlacement(
            word: Word('AL'),
            position: Position(0, 0),
            direction: Direction.right,
        );

        const longPlacement = WordPlacement(
            word: Word('ATLAS'),
            position: Position(2, 0),
            direction: Direction.right,
        );

        var board = Board(
            size: const BoardSize(rows: 5, columns: 5),
            placements: [
            shortPlacement,
            longPlacement,
            ],
        );

        board = board.setCell(
            const Cell(
            position: Position(0, 0),
            letter: 'A',
            state: CellState.filled,
            ),
        );

        board = board.setCell(
            const Cell(
            position: Position(2, 0),
            letter: 'A',
            state: CellState.filled,
            ),
        );

        board = board.setCell(
            const Cell(
            position: Position(2, 1),
            letter: 'T',
            state: CellState.filled,
            ),
        );

        board = board.setCell(
            const Cell(
            position: Position(2, 2),
            letter: 'L',
            state: CellState.filled,
            ),
        );

        board = board.setCell(
            const Cell(
            position: Position(2, 3),
            letter: 'A',
            state: CellState.filled,
            ),
        );

        const turn = GameTurn(
            LetterRack(['L', 'S']),
        );

        const robot = RobotPlayer();

        final move = robot.chooseMove(board, turn);

        expect(
            move,
            const LetterMove(
            position: Position(2, 4),
            letter: 'S',
            ),
        );
    });

  /// Fim Group
}