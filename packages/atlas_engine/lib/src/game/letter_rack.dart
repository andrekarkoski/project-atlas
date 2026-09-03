final class LetterRack {
  const LetterRack(this.letters);

  LetterRack.from(LetterRack other) : letters = List<String>.from(other.letters);

  final List<String> letters;

  int get length => letters.length;

  LetterRack remove(String letter) {
    final updatedLetters = List<String>.from(letters);
    updatedLetters.remove(letter);

    return LetterRack(updatedLetters);
  }

  bool contains(String letter) {
    return letters.contains(letter);
  }
}