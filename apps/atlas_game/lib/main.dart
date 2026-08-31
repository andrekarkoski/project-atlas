import 'package:atlas_engine/atlas_engine.dart';
import 'package:flutter/material.dart';
import 'game/game_controller.dart';
import 'widgets/crossword_cell.dart';
import 'widgets/letter_keyboard.dart';

void main() {
  runApp(const AtlasGameApp());
}

class AtlasGameApp extends StatelessWidget {
  const AtlasGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atlas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E293B)),
        useMaterial3: true,
      ),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final GameController _controller = const GameController();

  Position? _selectedPosition;
  String? _selectedLetter;

  late Board _board;

  @override
  void initState() {
    super.initState();
    _board = _controller.createInitialBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Atlas')),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: CrosswordBoard(
                  board: _board,
                  selectedPosition: _selectedPosition,
                  onCellTap: (position) {
                    setState(() {
                      _selectedPosition = position;
                    });
                  },
                ),
              ),
            ),

            if (_selectedLetter != null)
              Text(
                'Letra: $_selectedLetter',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 8),

            LetterKeyboard(
              letters: const ['A', 'B', 'C', 'D', 'E'],
              onLetterSelected: (letter) {
                final position = _selectedPosition;

                if (position == null) {
                  return;
                }

                setState(() {
                  _board = _controller.placeLetter(_board, position, letter);

                  _selectedLetter = letter;

                  _selectedPosition = _controller.nextPlayablePosition(
                    _board,
                    position,
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CrosswordBoard extends StatelessWidget {
  const CrosswordBoard({
    super.key,
    required this.board,
    required this.selectedPosition,
    required this.onCellTap,
  });

  final Board board;
  final Position? selectedPosition;
  final ValueChanged<Position> onCellTap;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: board.size.columns / board.size.rows,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: board.size.columns,
        ),
        itemCount: board.size.rows * board.size.columns,
        itemBuilder: (context, index) {
          final row = index ~/ board.size.columns;
          final column = index % board.size.columns;

          final cell = board.cellAt(Position(row, column));

          return GestureDetector(
            onTap: () => onCellTap(cell.position),
            child: CrosswordCell(
              cell: cell,
              selected: cell.position == selectedPosition,
            ),
          );
        },
      ),
    );
  }
}
