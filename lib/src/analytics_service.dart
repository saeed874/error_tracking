abstract class AnalyticsService {
  Future<void> logEvent(String eventName, {Map<String, dynamic>? parameters});
  Future<void> setUserProperties(
      {required String userId, Map<String, dynamic>? properties});
  Future<void> beginSession();
  Future<void> endSession();
}

class AnalyticsConfig {
  final String? firebaseProjectId;
  final String? sentryDsn;

  AnalyticsConfig({
    this.firebaseProjectId,
    this.sentryDsn,
  });
}
