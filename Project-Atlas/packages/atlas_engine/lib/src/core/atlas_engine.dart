abstract interface class AtlasEngine {
  Future<void> initialize();
  Future<void> shutdown();
  bool get initialized;
}

class AtlasEngineImpl implements AtlasEngine {
  bool _initialized = false;

  @override
  bool get initialized => _initialized;

  @override
  Future<void> initialize() async {
    _initialized = true;
  }

  @override
  Future<void> shutdown() async {
    _initialized = false;
  }
}
