import '../core/models/position.dart';

/// Immutable representation of a player's letter move.
final class LetterMove {
  const LetterMove({
    required this.position,
    required this.letter,
  });

  final Position position;
  final String letter;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LetterMove &&
          position == other.position &&
          letter == other.letter;

  @override
  int get hashCode => Object.hash(position, letter);

  @override
  String toString() => '$letter @ $position';
}