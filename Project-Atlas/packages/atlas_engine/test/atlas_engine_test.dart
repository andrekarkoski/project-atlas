import 'package:test/test.dart';
import 'package:atlas_engine/atlas_engine.dart';

void main() {
  test('engine initializes correctly', () async {
    final engine = AtlasEngineImpl();

    expect(engine.initialized, isFalse);

    await engine.initialize();

    expect(engine.initialized, isTrue);

    await engine.shutdown();

    expect(engine.initialized, isFalse);
  });
}
