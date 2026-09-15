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

  /// fim 
}