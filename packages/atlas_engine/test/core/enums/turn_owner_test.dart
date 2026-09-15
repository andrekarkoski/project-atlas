import 'package:atlas_engine/atlas_engine.dart';
import 'package:test/test.dart';

void main() {
  test('TurnOwner contains player and robot', () {
    expect(TurnOwner.values, [
      TurnOwner.player,
      TurnOwner.robot,
    ]);
  });
}