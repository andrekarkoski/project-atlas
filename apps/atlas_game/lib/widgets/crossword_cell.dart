import 'package:atlas_engine/atlas_engine.dart';
import 'package:flutter/material.dart';

final class CrosswordCell extends StatelessWidget {
  const CrosswordCell({super.key, required this.cell, required this.selected});

  final Cell cell;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('cell-${cell.position.row}-${cell.position.column}'),
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: selected
            ? Colors.amber
            : cell.hasLetter
            ? Colors.white
            : const Color(0xFF1E293B),
        border: Border.all(color: Colors.black12),
      ),
      alignment: Alignment.center,
      child: cell.hasLetter
          ? Text(
              cell.letter!,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            )
          : null,
    );
  }
}
