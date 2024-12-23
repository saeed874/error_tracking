// lib/src/models/analytics_config.dart

import 'package:analytics_tracker/src/analytics_platform.dart';

class AnalyticsConfig {
  final String? sentryDsn;
  final List<AnalyticsPlatform>? platforms;

  const AnalyticsConfig({
    this.sentryDsn,
    this.platforms,
  });
}
