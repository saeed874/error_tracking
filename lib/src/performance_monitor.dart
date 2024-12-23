class PerformanceMonitor {
  final Map<String, Stopwatch> _trackers = {};

  void startTrace(String traceName) {
    _trackers[traceName] = Stopwatch()..start();
  }

  Duration? stopTrace(String traceName) {
    final tracker = _trackers[traceName];
    if (tracker != null) {
      tracker.stop();
      final duration = tracker.elapsed;
      _trackers.remove(traceName);
      return duration;
    }
    return null;
  }

  Map<String, Duration> get activeTraces {
    return Map.fromEntries(
      _trackers.entries.map(
        (e) => MapEntry(e.key, e.value.elapsed),
      ),
    );
  }
}
