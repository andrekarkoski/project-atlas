import 'package:atlas_game/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:atlas_game/widgets/letter_keyboard.dart';

void main() {
  testWidgets('Atlas app renders', (tester) async {
    await tester.pumpWidget(const AtlasGameApp());

    expect(find.text('Atlas'), findsOneWidget);
  });

  testWidgets('selects a board cell when tapped', (tester) async {
    await tester.pumpWidget(const AtlasGameApp());

    final cell = find.byType(GestureDetector).first;

    expect(cell, findsOneWidget);

    await tester.tap(cell);
    await tester.pump();

    final amberCell = find.byWidgetPredicate((widget) {
      if (widget is! Container) {
        return false;
      }

      final decoration = widget.decoration;

      if (decoration is! BoxDecoration) {
        return false;
      }

      return decoration.color == Colors.amber;
    });

    expect(amberCell, findsOneWidget);
  });

  testWidgets('places a selected letter on the board cell', (tester) async {
    await tester.pumpWidget(const AtlasGameApp());

    const cellKey = ValueKey('cell-0-0');

    final cell = find.byKey(cellKey);

    expect(cell, findsOneWidget);

    await tester.tap(cell);
    await tester.pump();

    await tester.tap(find.widgetWithText(ElevatedButton, 'A'));
    await tester.pump();

    expect(
      find.descendant(of: find.byKey(cellKey), matching: find.text('A')),
      findsOneWidget,
    );
  });

  testWidgets(
    'moves selection to the next playable cell after placing a letter',
    (tester) async {
      await tester.pumpWidget(const AtlasGameApp());

      const firstCellKey = ValueKey('cell-0-0');
      const secondCellKey = ValueKey('cell-0-1');

      final firstCell = find.byKey(firstCellKey);

      expect(firstCell, findsOneWidget);

      // Seleciona a primeira célula.
      await tester.tap(firstCell);
      await tester.pump();

      // A primeira célula deve estar selecionada.
      final firstSelected = find.byWidgetPredicate((widget) {
        if (widget is! Container) {
          return false;
        }

        final decoration = widget.decoration;

        return decoration is BoxDecoration &&
            decoration.color == Colors.amber &&
            widget.key == firstCellKey;
      });

      expect(firstSelected, findsOneWidget);

      // Coloca a letra A.
      await tester.tap(find.widgetWithText(ElevatedButton, 'A'));
      await tester.pump();

      // A seleção deve ter avançado para a próxima célula.
      final secondSelected = find.byWidgetPredicate((widget) {
        if (widget is! Container) {
          return false;
        }

        final decoration = widget.decoration;

        return decoration is BoxDecoration &&
            decoration.color == Colors.amber &&
            widget.key == secondCellKey;
      });

      expect(secondSelected, findsOneWidget);

      // A primeira célula não deve mais estar selecionada.
      final firstStillSelected = find.byWidgetPredicate((widget) {
        if (widget is! Container) {
          return false;
        }

        final decoration = widget.decoration;

        return decoration is BoxDecoration &&
            decoration.color == Colors.amber &&
            widget.key == firstCellKey;
      });

      expect(firstStillSelected, findsNothing);
    },
  );

  testWidgets('backspace button triggers callback', (tester) async {
    var backspacePressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: LetterKeyboard(
          letters: const ['A', 'B', 'C'],
          onLetterSelected: (_) {},
          onBackspace: () {
            backspacePressed = true;
          },
        ),
      ),
    );

    expect(find.text('⌫'), findsOneWidget);

    await tester.tap(find.text('⌫'));
    await tester.pump();

    expect(backspacePressed, isTrue);
  });

  /// Fim
}
