import 'package:atlas_engine/atlas_engine.dart';
import 'package:test/test.dart';

void main() {
  group('GameTurn', () {
    test('starts with a letter rack', () {
      const rack = LetterRack([
        'Z',
        'R',
        'T',
        'L',
        'A',
      ]);

      const turn = GameTurn(rack);

      expect(turn.rack.letters, [
        'Z',
        'R',
        'T',
        'L',
        'A',
      ]);
    });

    test('starts with zero score', () {
      const rack = LetterRack([
        'Z',
        'R',
        'T',
        'L',
        'A',
      ]);

      const turn = GameTurn(rack);

      expect(turn.score, 0);
    });

    test('stores the current score', () {
        const rack = LetterRack([
            'Z',
            'R',
            'T',
            'L',
            'A',
        ]);

        const turn = GameTurn(
            rack,
            score: 30,
        );

        expect(turn.score, 30);
    });

    test('adds points to the current score', () {
        const rack = LetterRack([
            'Z',
            'R',
            'T',
            'L',
            'A',
        ]);

        const turn = GameTurn(rack);

        final updatedTurn = turn.addScore(10);

        expect(updatedTurn.score, 10);
    });

    test('adds negative points to the current score', () {
        const rack = LetterRack([
            'Z',
            'R',
            'T',
            'L',
            'A',
        ]);

        const turn = GameTurn(
            rack,
            score: 10,
        );

        final updatedTurn = turn.addScore(-10);

        expect(updatedTurn.score, 0);
    });

    test('keeps the original turn unchanged when adding score', () {
        const rack = LetterRack([
            'Z',
            'R',
            'T',
            'L',
            'A',
        ]);

        const turn = GameTurn(
            rack,
            score: 10,
        );

        final updatedTurn = turn.addScore(10);

        expect(turn.score, 10);
        expect(updatedTurn.score, 20);
    });

    test('keeps the same rack when adding score', () {
        const rack = LetterRack([
            'Z',
            'R',
            'T',
            'L',
            'A',
        ]);

        const turn = GameTurn(rack);

        final updatedTurn = turn.addScore(10);

        expect(updatedTurn.rack.letters, [
            'Z',
            'R',
            'T',
            'L',
            'A',
        ]);
    });

    test('removes a letter from the rack', () {
      const rack = LetterRack([
        'Z',
        'R',
        'T',
        'L',
        'A',
      ]);

      const turn = GameTurn(rack);

      final updatedTurn = turn.removeLetter('A');

      expect(updatedTurn.rack.letters, [
        'Z',
        'R',
        'T',
        'L',
      ]);
    });

    test('keeps the turn unchanged when removing an unavailable letter', () {
      const rack = LetterRack([
        'Z',
        'R',
        'T',
        'L',
        'A',
      ]);

      const turn = GameTurn(
        rack,
        score: 20,
      );

      final updatedTurn = turn.removeLetter('X');

      expect(updatedTurn.rack.letters, [
        'Z',
        'R',
        'T',
        'L',
        'A',
      ]);

      expect(updatedTurn.score, 20);
    });


    test('stores a letter move made during the turn', () {
      const rack = LetterRack([
        'A',
        'T',
        'L',
      ]);

      const turn = GameTurn(rack);

      const move = LetterMove(
        position: Position(2, 3),
        letter: 'A',
      );

      final updatedTurn = turn.addMove(move);

      expect(updatedTurn.moves, [
        move,
      ]);
    });

    test('keeps the original turn unchanged when adding a move', () {
      const rack = LetterRack([
        'A',
        'T',
        'L',
      ]);

      const turn = GameTurn(rack);

      const move = LetterMove(
        position: Position(2, 3),
        letter: 'A',
      );

      final updatedTurn = turn.addMove(move);

      expect(turn.moves, isEmpty);
      expect(updatedTurn.moves, [
        move,
      ]);
    });

    test('GameTurn stores its owner', () {
      const playerTurn = GameTurn(
        LetterRack(['A']),
        owner: TurnOwner.player,
      );

      const robotTurn = GameTurn(
        LetterRack(['B']),
        owner: TurnOwner.robot,
      );

      expect(playerTurn.owner, TurnOwner.player);
      expect(robotTurn.owner, TurnOwner.robot);
    });

    test('GameTurn switches to the other owner', () {
      const playerTurn = GameTurn(
        LetterRack(['A']),
        owner: TurnOwner.player,
      );

      const robotTurn = GameTurn(
        LetterRack(['B']),
        owner: TurnOwner.robot,
      );

      expect(playerTurn.nextOwner, TurnOwner.robot);
      expect(robotTurn.nextOwner, TurnOwner.player);
    });

    test('nextTurn preserves turn data and switches owner', () {
      const playerTurn = GameTurn(
        LetterRack(['A', 'B']),
        owner: TurnOwner.player,
        score: 30,
        moves: [
          LetterMove(
            position: Position(2, 1),
            letter: 'A',
          ),
        ],
      );

      final robotTurn = playerTurn.nextTurn();

      expect(robotTurn.owner, TurnOwner.robot);
      expect(robotTurn.rack.letters, ['A', 'B']);
      expect(robotTurn.score, 30);
      expect(robotTurn.moves, [
        LetterMove(
          position: Position(2, 1),
          letter: 'A',
        ),
      ]);
    });

  /// Fim do Group 
  });
}
