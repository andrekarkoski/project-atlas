import 'package:atlas_engine/atlas_engine.dart';
import 'package:atlas_game/game/game_controller.dart';
import 'package:test/test.dart';

void main() {
  group('GameController', () {
    const controller = GameController();

    test('places a letter on the selected position', () {
      final board = controller.createInitialBoard();
      const position = Position(0, 0);

      final updatedBoard = controller.placeLetter(
        board,
        position,
        'A',
      );

      final cell = updatedBoard.cellAt(position);

      expect(cell.letter, 'A');
      expect(cell.isFilled, isTrue);
    });

    test('does not place a letter on a blocked cell', () {
      final board = controller.createInitialBoard();
      const position = Position(0, 0);

      final blockedCell = board
          .cellAt(position)
          .copyWith(state: CellState.blocked);

      final blockedBoard = board.setCell(blockedCell);

      final updatedBoard = controller.placeLetter(
        blockedBoard,
        position,
        'A',
      );

      final cell = updatedBoard.cellAt(position);

      expect(cell.isBlocked, isTrue);
      expect(cell.letter, isNull);
    });

    test('does not overwrite a filled cell', () {
      final board = controller.createInitialBoard();
      const position = Position(0, 0);

      final boardWithLetter = controller.placeLetter(
        board,
        position,
        'A',
      );

      final updatedBoard = controller.placeLetter(
        boardWithLetter,
        position,
        'B',
      );

      final cell = updatedBoard.cellAt(position);

      expect(cell.letter, 'A');
      expect(cell.isFilled, isTrue);
    });

    test('finds the next playable position', () {
      final board = controller.createInitialBoard();

      const position = Position(0, 0);

      final nextPosition = controller.nextPlayablePosition(
        board,
        position,
      );

      expect(nextPosition, const Position(0, 1));
    });

    test('skips filled and blocked cells', () {
      final board = controller.createInitialBoard();

      const position = Position(0, 0);

      final filledBoard = controller.placeLetter(
        board,
        const Position(0, 1),
        'A',
      );

      final blockedCell = filledBoard
          .cellAt(const Position(0, 2))
          .copyWith(state: CellState.blocked);

      final blockedBoard = filledBoard.setCell(blockedCell);

      final nextPosition = controller.nextPlayablePosition(
        blockedBoard,
        position,
      );

      expect(nextPosition, const Position(0, 3));
    });

    test('returns null when there is no next playable position', () {
      const size = BoardSize(rows: 1, columns: 2);

      final board = Board(size: size);

      final filledBoard = controller.placeLetter(
        board,
        const Position(0, 1),
        'A',
      );

      final nextPosition = controller.nextPlayablePosition(
        filledBoard,
        const Position(0, 0),
      );

      expect(nextPosition, isNull);
    });

    test('removes a letter from a filled cell', () {
      final board = controller.createInitialBoard();
      const position = Position(0, 0);

      final filledBoard = controller.placeLetter(
        board,
        position,
        'A',
      );

      final updatedBoard = controller.removeLetter(
        filledBoard,
        position,
      );

      final cell = updatedBoard.cellAt(position);

      expect(cell.letter, isNull);
      expect(cell.isEmpty, isTrue);
    });

    test('applies a correct letter move and returns the updated board', () {
      const placement = WordPlacement(
        word: Word('ATLAS'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      final board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [placement],
      );

      final updatedBoard = controller.applyLetterMove(
        board,
        const LetterMove(
          position: Position(2, 0),
          letter: 'A',
        ),
      );

      final cell = updatedBoard.cellAt(
        const Position(2, 0),
      );

      expect(cell.letter, 'A');
      expect(cell.state, CellState.filled);
    });

    test('returns the score for a correct letter move', () {
      const placement = WordPlacement(
        word: Word('ATLAS'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      final board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [placement],
      );

      final score = controller.scoreLetterMove(
        board,
        const LetterMove(
          position: Position(2, 0),
          letter: 'A',
        ),
      );

      expect(score, 10);
    });

    test('applies a valid letter move to the turn', () {
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
        LetterRack([
          'A',
          'T',
          'L',
        ]),
      );

      const move = LetterMove(
        position: Position(2, 0),
        letter: 'A',
      );

      final updatedTurn = controller.applyMove(
        board,
        turn,
        move,
      );

      expect(updatedTurn.turn.rack.letters, [
        'T',
        'L',
      ]);

      expect(updatedTurn.turn.moves, [
        move,
      ]);
    });

    test('adds 10 points for a correct letter move', () {
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
        LetterRack(['A']),
      );

      const move = LetterMove(
        position: Position(2, 0),
        letter: 'A',
      );

      final result = controller.applyMove(
        board,
        turn,
        move,
      );

      expect(result.turn.score, 10);
    });

    test('adds 20 bonus points when a move completes a word', () {
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
        LetterRack(['T']),
      );

      const move = LetterMove(
        position: Position(2, 1),
        letter: 'T',
      );

      const controller = GameController();

      final result = controller.applyMove(board, turn, move);

      expect(result.turn.score, 30);
    });

    test('adds 20 bonus points for each word completed by the move', () {
      const firstPlacement = WordPlacement(
        word: Word('AT'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      const secondPlacement = WordPlacement(
        word: Word('TA'),
        position: Position(2, 1),
        direction: Direction.down,
      );

      var board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [
          firstPlacement,
          secondPlacement,
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
          position: Position(3, 1),
          letter: 'A',
          state: CellState.filled,
        ),
      );

      const turn = GameTurn(
        LetterRack(['T']),
      );

      const move = LetterMove(
        position: Position(2, 1),
        letter: 'T',
      );

      const controller = GameController();

      final result = controller.applyMove(board, turn, move);

      expect(result.turn.score, 50);
    });

    test('subtracts 10 points for an incorrect letter move', () {
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
        LetterRack(['B']),
      );

      const move = LetterMove(
        position: Position(2, 0),
        letter: 'B',
      );

      final result = controller.applyMove(
        board,
        turn,
        move,
      );

      expect(result.turn.score, -10);
    });

    test('applies the move to the board and turn', () {
      const controller = GameController();

      final board = controller.createInitialBoard();

      final position = board.placements.first.position;
      final letter = board.expectedLetterAt(position)!;

      final turn = GameTurn(
        LetterRack([letter]),
      );

      final move = LetterMove(
        position: position,
        letter: letter,
      );

      expect(
        board.expectedLetterAt(position),
        letter,
      );

      expect(
        board.cellAt(position).isBlocked,
        isFalse,
      );

      expect(
        board.cellAt(position).isLocked,
        isFalse,
      );

      final result = controller.applyMove(
        board,
        turn,
        move,
      );

      expect(result.board.cellAt(position).letter, letter);
      expect(result.turn.moves, contains(move));
    });

    test('does not apply a letter move when the letter is not in the rack', () {
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
        LetterRack(['A', 'T']),
      );

      const move = LetterMove(
        position: Position(2, 2),
        letter: 'L',
      );

      final result = controller.applyMove(
        board,
        turn,
        move,
      );

      expect(result.board.cellAt(move.position).isEmpty, isTrue);
      expect(result.turn.moves, isEmpty);
      expect(result.turn.rack.letters, [
        'A',
        'T',
      ]);
    });

    test('does not apply a move to a completed word', () {
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
        LetterRack(['A']),
      );

      const move = LetterMove(
        position: Position(2, 0),
        letter: 'A',
      );

      const controller = GameController();

      final result = controller.applyMove(board, turn, move);

      expect(result.turn.score, 0);
      expect(result.turn.moves, isEmpty);
      expect(result.turn.rack.letters, ['A']);
      expect(result.board.cellAt(Position(2, 0)).letter, 'A');
    });

    test('applies a robot turn using RobotPlayer', () {
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
        LetterRack(['T']),
      );

      const controller = GameController();

      final result = controller.applyRobotTurn(board, turn);

      expect(result.board.cellAt(Position(2, 1)).letter, 'T');
      expect(result.turn.rack.letters, isEmpty);
      expect(result.turn.score, 30);
      expect(result.turn.moves, [
        LetterMove(
          position: Position(2, 1),
          letter: 'T',
        ),
      ]);
    });

    test('does nothing when robot has no valid move', () {
      const placement = WordPlacement(
        word: Word('AT'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      final board = Board(
        size: BoardSize(rows: 5, columns: 5),
        placements: [placement],
      );

      const turn = GameTurn(
        LetterRack(['Z']),
      );

      const controller = GameController();

      final result = controller.applyRobotTurn(board, turn);

      expect(result.board, board);
      expect(result.turn, turn);
    });

    test('applies completion bonus for each word completed by robot move', () {
      const horizontal = WordPlacement(
        word: Word('AT'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      const vertical = WordPlacement(
        word: Word('BT'),
        position: Position(1, 1),
        direction: Direction.down,
      );

      var board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [
          horizontal,
          vertical,
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
          position: Position(1, 1),
          letter: 'B',
          state: CellState.filled,
        ),
      );

      const turn = GameTurn(
        LetterRack(['T']),
      );

      const controller = GameController();

      final result = controller.applyRobotTurn(board, turn);

      expect(result.board.cellAt(Position(2, 1)).letter, 'T');
      expect(result.turn.rack.letters, isEmpty);
      expect(result.turn.score, 50);
      expect(result.turn.moves, [
        LetterMove(
          position: Position(2, 1),
          letter: 'T',
        ),
      ]);
    });

    test('robot move removes only the letter used from the rack', () {
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
        LetterRack(['T', 'A', 'Z']),
      );

      const controller = GameController();

      final result = controller.applyRobotTurn(board, turn);

      expect(result.board.cellAt(Position(2, 1)).letter, 'T');
      expect(result.turn.rack.letters, ['A', 'Z']);
      expect(result.turn.score, 30);
    });


    test('robot turn does not change score or rack when no move is available', () {
      const placement = WordPlacement(
        word: Word('AT'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      final board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [placement],
      );

      const turn = GameTurn(
        LetterRack(['Z', 'X']),
        score: 40,
      );

      const controller = GameController();

      final result = controller.applyRobotTurn(board, turn);

      expect(result.board, board);
      expect(result.turn.rack.letters, ['Z', 'X']);
      expect(result.turn.score, 40);
      expect(result.turn.moves, isEmpty);
    });

    test('player move passes the turn to the robot', () {
      const placement = WordPlacement(
        word: Word('AT'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      var board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [placement],
      );

      const playerTurn = GameTurn(
        LetterRack(['T']),
      );

      const controller = GameController();

      final playerResult = controller.applyMove(
        board,
        playerTurn,
        const LetterMove(
          position: Position(2, 1),
          letter: 'T',
        ),
      );

      board = playerResult.board;

      expect(board.cellAt(Position(2, 1)).letter, 'T');
      expect(playerResult.turn.rack.letters, isEmpty);
      expect(playerResult.turn.score, 10);
    });

    test('valid move passes the turn to the next owner', () {
      const placement = WordPlacement(
        word: Word('AT'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      final board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [placement],
      );

      const playerTurn = GameTurn(
        LetterRack(['T']),
        owner: TurnOwner.player,
      );

      const controller = GameController();

      final result = controller.applyMove(
        board,
        playerTurn,
        const LetterMove(
          position: Position(2, 1),
          letter: 'T',
        ),
      );

      expect(result.turn.owner, TurnOwner.robot);
    });

    test('robot move passes the turn back to the player', () {
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

      const robotTurn = GameTurn(
        LetterRack(['T']),
        owner: TurnOwner.robot,
      );

      const controller = GameController();

      final result = controller.applyRobotTurn(board, robotTurn);

      expect(result.board.cellAt(Position(2, 1)).letter, 'T');
      expect(result.turn.owner, TurnOwner.player);
    });

    test('valid move removes the used letter from the rack', () {
      const placement = WordPlacement(
        word: Word('AT'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      final board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [placement],
      );

      const playerTurn = GameTurn(
        LetterRack(['A', 'T']),
        owner: TurnOwner.player,
      );

      const controller = GameController();

      final result = controller.applyMove(
        board,
        playerTurn,
        const LetterMove(
          position: Position(2, 0),
          letter: 'A',
        ),
      );

      expect(result.turn.rack.letters, ['T']);
    });

    test('invalid move keeps the letter in the rack', () {
      const placement = WordPlacement(
        word: Word('AT'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      final board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [placement],
      );

      const playerTurn = GameTurn(
        LetterRack(['Z']),
        owner: TurnOwner.player,
      );

      const controller = GameController();

      final result = controller.applyMove(
        board,
        playerTurn,
        const LetterMove(
          position: Position(2, 0),
          letter: 'Z',
        ),
      );

      expect(result.turn.rack.letters, ['Z']);
    });

    test('invalid move keeps the board unchanged', () {
      const placement = WordPlacement(
        word: Word('AT'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      final board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [placement],
      );

      const playerTurn = GameTurn(
        LetterRack(['Z']),
        owner: TurnOwner.player,
      );

      const controller = GameController();

      final result = controller.applyMove(
        board,
        playerTurn,
        const LetterMove(
          position: Position(2, 0),
          letter: 'Z',
        ),
      );

      expect(result.board.cellAt(const Position(2, 0)).letter, isNull);
    });

    test('valid move awards completion bonus for each completed word', () {
      const horizontal = WordPlacement(
        word: Word('AT'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      const vertical = WordPlacement(
        word: Word('AT'),
        position: Position(1, 1),
        direction: Direction.down,
      );

      var board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [
          horizontal,
          vertical,
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
          position: Position(1, 1),
          letter: 'A',
          state: CellState.filled,
        ),
      );

      const playerTurn = GameTurn(
        LetterRack(['T']),
        owner: TurnOwner.player,
      );

      const controller = GameController();

      final result = controller.applyMove(
        board,
        playerTurn,
        const LetterMove(
          position: Position(2, 1),
          letter: 'T',
        ),
      );

      expect(result.turn.score, 50);
    });

    test('valid move does not award a second bonus for an already completed word', () {
      const completedWord = WordPlacement(
        word: Word('AT'),
        position: Position(0, 0),
        direction: Direction.right,
      );

      const incompleteWord = WordPlacement(
        word: Word('AT'),
        position: Position(2, 0),
        direction: Direction.right,
      );

      var board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [
          completedWord,
          incompleteWord,
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
          position: Position(0, 1),
          letter: 'T',
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

      const playerTurn = GameTurn(
        LetterRack(['T']),
        owner: TurnOwner.player,
      );

      const controller = GameController();

      final result = controller.applyMove(
        board,
        playerTurn,
        const LetterMove(
          position: Position(2, 1),
          letter: 'T',
        ),
      );

      expect(result.turn.score, 30);
    });

  /// Fim do Group
  });
}