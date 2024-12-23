// lib/src/analytics_manager.dart
import 'package:analytics_tracker/analytics_tracker.dart';
import 'package:analytics_tracker/src/analytics_platform.dart';
import 'package:analytics_tracker/src/analytics_service.dart';

import 'error_tracker.dart';
import 'performance_monitor.dart';

class AnalyticsManager {
  final ErrorTracker _errorTracker;
  final PerformanceMonitor _performanceMonitor;
  final List<AnalyticsPlatform> _platforms;

  static AnalyticsManager? _instance;

  AnalyticsManager._({
    required ErrorTracker errorTracker,
    required PerformanceMonitor performanceMonitor,
    required List<AnalyticsPlatform> platforms,
  })  : _errorTracker = errorTracker,
        _performanceMonitor = performanceMonitor,
        _platforms = platforms;

  static Future<AnalyticsManager> initialize(AnalyticsConfig config) async {
    if (_instance == null) {
      final errorTracker = ErrorTracker(config.sentryDsn ?? '');
      await errorTracker.initialize();

      _instance = AnalyticsManager._(
        errorTracker: errorTracker,
        performanceMonitor: PerformanceMonitor(),
        platforms: [],
      );
    }
    return _instance!;
  }

  static AnalyticsManager get instance {
    if (_instance == null) {
      throw StateError('AnalyticsManager not initialized');
    }
    return _instance!;
  }

  Future<void> logError(dynamic error, StackTrace stackTrace,
      {Map<String, dynamic>? extra}) {
    return _errorTracker.captureException(
      error,
      stackTrace: stackTrace,
      extra: extra,
    );
  }

  List<AnalyticsPlatform> get platforms => List.unmodifiable(_platforms);
}
