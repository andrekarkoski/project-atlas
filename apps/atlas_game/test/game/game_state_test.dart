import 'package:atlas_engine/atlas_engine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:atlas_game/game/game_state.dart';

void main() {
  test('GameState stores board and current turn', () {
    final board = Board(
      size: const BoardSize(rows: 5, columns: 5),
    );

    const turn = GameTurn(
      LetterRack(['A', 'B']),
      owner: TurnOwner.player,
      score: 10,
    );

    final state = GameState(
      board: board,
      turn: turn,
    );

    expect(state.board, board);
    expect(state.turn, turn);
  });

  test('GameState switches to the next turn', () {
    final board = Board(
        size: const BoardSize(rows: 5, columns: 5),
    );

    const playerTurn = GameTurn(
        LetterRack(['A']),
        owner: TurnOwner.player,
    );

    final state = GameState(
        board: board,
        turn: playerTurn,
    );

    final nextState = state.nextTurn();

    expect(nextState.board, board);
    expect(nextState.turn.owner, TurnOwner.robot);
    expect(nextState.turn.rack.letters, ['A']);
  });

  test('GameState applies a move and updates board and turn', () {
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
        LetterRack(['A', 'T']),
        owner: TurnOwner.player,
    );

    final state = GameState(
        board: board,
        turn: playerTurn,
    );

    final nextState = state.applyMove(
        LetterMove(
        position: Position(2, 0),
        letter: 'A',
        ),
    );

    expect(nextState.board.cellAt(Position(2, 0)).letter, 'A');
    expect(nextState.turn.owner, TurnOwner.robot);
    expect(nextState.turn.rack.letters, ['T']);
    expect(nextState.turn.score, 10);
  });

  test('GameState keeps the board and rack unchanged for an invalid move', () {
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
        score: 20,
    );

    final state = GameState(
        board: board,
        turn: playerTurn,
    );

    final nextState = state.applyMove(
        LetterMove(
        position: Position(2, 0),
        letter: 'Z',
        ),
    );

    expect(nextState.board.cellAt(Position(2, 0)).letter, isNull);
    expect(nextState.turn.owner, TurnOwner.player);
    expect(nextState.turn.rack.letters, ['Z']);
    expect(nextState.turn.score, 10);
  });

  test('GameState applies completion bonus when a move completes a word', () {
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

    const playerTurn = GameTurn(
        LetterRack(['T']),
        owner: TurnOwner.player,
    );

    final state = GameState(
        board: board,
        turn: playerTurn,
    );

    final nextState = state.applyMove(
        const LetterMove(
        position: Position(2, 1),
        letter: 'T',
        ),
    );

    expect(nextState.board.cellAt(Position(2, 1)).letter, 'T');
    expect(nextState.turn.score, 30);
    expect(nextState.turn.rack.letters, isEmpty);
    expect(nextState.turn.owner, TurnOwner.robot);
  });

  test('GameState applies the robot turn and returns control to the player', () {
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

    final state = GameState(
        board: board,
        turn: robotTurn,
    );

    final nextState = state.applyRobotTurn();

    expect(nextState.board.cellAt(Position(2, 1)).letter, 'T');
    expect(nextState.turn.owner, TurnOwner.player);
    expect(nextState.turn.rack.letters, isEmpty);
    expect(nextState.turn.score, 30);
  });

  test('GameState stores separate player and robot scores', () {
    final board = Board(
        size: const BoardSize(rows: 5, columns: 5),
    );

    const turn = GameTurn(
        LetterRack(['A']),
        owner: TurnOwner.player,
    );

    final state = GameState(
        board: board,
        turn: turn,
        playerScore: 30,
        robotScore: 20,
    );

    expect(state.playerScore, 30);
    expect(state.robotScore, 20);
  });

  test('GameState preserves player and robot scores when switching turns', () {
    final board = Board(
        size: const BoardSize(rows: 5, columns: 5),
    );

    const turn = GameTurn(
        LetterRack(['A']),
        owner: TurnOwner.player,
    );

    final state = GameState(
        board: board,
        turn: turn,
        playerScore: 30,
        robotScore: 20,
    );

    final nextState = state.nextTurn();

    expect(nextState.playerScore, 30);
    expect(nextState.robotScore, 20);
  });

  test('GameState adds valid player move score to player score', () {
    final board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [
          WordPlacement(
            word: Word('AT'),
            position: const Position(0, 0),
            direction: Direction.right,
          ),
        ],
    );

    const turn = GameTurn(
        LetterRack(['A']),
        owner: TurnOwner.player,
    );

    final state = GameState(
        board: board,
        turn: turn,
        playerScore: 0,
        robotScore: 0,
    );

    final nextState = state.applyMove(
        const LetterMove(
        position: Position(0, 0),
        letter: 'A',
        ),
    );

    expect(nextState.playerScore, 10);
    expect(nextState.robotScore, 0);
  });

  test('GameState adds valid robot move score to robot score', () {
    final board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [
        WordPlacement(
            word: Word('AT'),
            position: const Position(0, 0),
            direction: Direction.right,
        ),
        ],
    );

    const turn = GameTurn(
        LetterRack(['A']),
        owner: TurnOwner.robot,
    );

    final state = GameState(
        board: board,
        turn: turn,
        playerScore: 0,
        robotScore: 0,
    );

    final nextState = state.applyMove(
        const LetterMove(
        position: Position(0, 0),
        letter: 'A',
        ),
    );

    expect(nextState.playerScore, 0);
    expect(nextState.robotScore, 10);
  });

  test('GameState does not change player score for an invalid move', () {
    final board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [
        WordPlacement(
            word: Word('AT'),
            position: const Position(0, 0),
            direction: Direction.right,
        ),
        ],
    );

    const turn = GameTurn(
        LetterRack(['Z']),
        owner: TurnOwner.player,
    );

    final state = GameState(
        board: board,
        turn: turn,
        playerScore: 30,
        robotScore: 20,
    );

    final nextState = state.applyMove(
        const LetterMove(
        position: Position(0, 0),
        letter: 'Z',
        ),
    );

    expect(nextState.playerScore, 20);
    expect(nextState.robotScore, 20);
  });

  test('GameState applies penalty to robot score for an invalid move', () {
    final board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [
        WordPlacement(
            word: Word('AT'),
            position: const Position(0, 0),
            direction: Direction.right,
        ),
        ],
    );

    const turn = GameTurn(
        LetterRack(['Z']),
        owner: TurnOwner.robot,
    );

    final state = GameState(
        board: board,
        turn: turn,
        playerScore: 20,
        robotScore: 30,
    );

    final nextState = state.applyMove(
        const LetterMove(
        position: Position(0, 0),
        letter: 'Z',
        ),
    );

    expect(nextState.playerScore, 20);
    expect(nextState.robotScore, 20);
  });

  test('GameState adds completion bonus to player score', () {
    const placement = WordPlacement(
        word: Word('AT'),
        position: Position(0, 0),
        direction: Direction.right,
    );

    var board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [placement],
    );

    board = board.setCell(
        const Cell(
        position: Position(0, 0),
        letter: 'A',
        state: CellState.filled,
        ),
    );

    const turn = GameTurn(
        LetterRack(['T']),
        owner: TurnOwner.player,
    );

    final state = GameState(
        board: board,
        turn: turn,
        playerScore: 10,
        robotScore: 20,
    );

    final nextState = state.applyMove(
        const LetterMove(
        position: Position(0, 1),
        letter: 'T',
        ),
    );

    expect(nextState.playerScore, 40);
    expect(nextState.robotScore, 20);
  });

  test('GameState adds completion bonus to robot score', () {
    const placement = WordPlacement(
        word: Word('AT'),
        position: Position(0, 0),
        direction: Direction.right,
    );

    var board = Board(
        size: const BoardSize(rows: 5, columns: 5),
        placements: [placement],
    );

    board = board.setCell(
        const Cell(
        position: Position(0, 0),
        letter: 'A',
        state: CellState.filled,
        ),
    );

    const turn = GameTurn(
        LetterRack(['T']),
        owner: TurnOwner.robot,
    );

    final state = GameState(
        board: board,
        turn: turn,
        playerScore: 10,
        robotScore: 20,
    );

    final nextState = state.applyMove(
        const LetterMove(
        position: Position(0, 1),
        letter: 'T',
        ),
    );

    expect(nextState.playerScore, 10);
    expect(nextState.robotScore, 50);
  });

  test('GameState preserves player and robot scores after robot turn', () {
    const turn = GameTurn(
    LetterRack(['A']),
    owner: TurnOwner.robot,
    );

    final state = GameState(
    board: Board(
        size: const BoardSize(rows: 5, columns: 5),
    ),
    turn: turn,
    playerScore: 30,
    robotScore: 40,
    );

    final nextState = state.applyRobotTurn();

    expect(nextState.playerScore, 30);
    expect(nextState.robotScore, 40);
  });

  /// End Game State Tests
}