import '../domain/word.dart';

/// Orders words for crossword generation.
final class WordOrderer {
  const WordOrderer();

  /// Returns a new list ordered by placement priority.
  List<Word> order(List<Word> words) {
    final result = [...words];

    result.sort(
      (a, b) {
        final lengthComparison = b.length.compareTo(a.length);

        if (lengthComparison != 0) {
          return lengthComparison;
        }

        final uniqueLettersA = a.text.split('').toSet().length;

        final uniqueLettersB = b.text.split('').toSet().length;

        return uniqueLettersB.compareTo(
          uniqueLettersA,
        );
      },
    );

    return result;
  }
}
