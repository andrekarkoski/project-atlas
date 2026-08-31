/// Immutable crossword word.
final class Word {
  /// Creates a crossword word.
  const Word(this.text) : assert(text != '', 'Word cannot be empty.');

  /// Original text.
  final String text;

  /// Number of letters.
  int get length => text.length;

  /// True when the word has no letters.
  bool get isEmpty => text.isEmpty;

  /// True when the word has at least one letter.
  bool get isNotEmpty => text.isNotEmpty;

  /// Returns one letter.
  String letterAt(int index) {
    return text[index];
  }

  /// Returns every letter.
  List<String> get letters => text.split('');

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Word && other.text == text;

  @override
  int get hashCode => text.hashCode;

  @override
  String toString() => text;
}
