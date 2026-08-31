import 'package:flutter/material.dart';

final class LetterKeyboard extends StatelessWidget {
  const LetterKeyboard({
    super.key,
    required this.letters,
    required this.onLetterSelected,
    this.onBackspace,
  });

  final List<String> letters;
  final ValueChanged<String> onLetterSelected;
  final VoidCallback? onBackspace;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final letter in letters)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              onPressed: () => onLetterSelected(letter),
              child: Text(
                letter,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        if (onBackspace != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              onPressed: onBackspace,
              child: const Text(
                '⌫',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }
}
