// lib/src/analytics_error_tracking.dart
import 'package:analytics_tracker/analytics_tracker.dart';
import 'package:analytics_tracker/src/analytics_manager.dart';
import 'package:analytics_tracker/src/analytics_platform.dart';
import 'package:analytics_tracker/src/analytics_service.dart';

class AnalyticsErrorTracking {
  static Future<void> initialize({
    required List<AnalyticsPlatform> platforms,
    required String? sentryDsn,
  }) async {
    await AnalyticsManager.initialize(
      AnalyticsConfig(
        sentryDsn: sentryDsn,
        // platforms: platforms,
      ),
    );
  }

  static Future<void> logError(
    dynamic error,
    StackTrace stackTrace, {
    Map<String, dynamic>? extra,
  }) async {
    await AnalyticsManager.instance.logError(
      error,
      stackTrace,
      extra: extra,
    );
  }
}
