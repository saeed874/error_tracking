import 'package:analytics_tracker/analytics_error_tracking.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AnalyticsErrorTracking.initialize(
    platforms: [],
    sentryDsn: 'your-sentry-dsn',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Error Tracking Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ErrorTrackingDemo(),
    );
  }
}

class ErrorTrackingDemo extends StatelessWidget {
  const ErrorTrackingDemo({super.key});

  void _generateError() async {
    try {
      // Generating a sample error
      throw Exception('This is a test error');
    } catch (error, stackTrace) {
      await AnalyticsErrorTracking.logError(
        error,
        stackTrace,
        extra: {
          'screen': 'ErrorTrackingDemo',
          'action': 'Generate Error Button Press',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    }
  }

  void _generateCustomError() async {
    try {
      // Generating a custom error scenario
      final List<String> emptyList = [];
      // This will throw a RangeError
      print(emptyList[1]);
    } catch (error, stackTrace) {
      await AnalyticsErrorTracking.logError(
        error,
        stackTrace,
        extra: {
          'screen': 'ErrorTrackingDemo',
          'action': 'List Access Error',
          'custom_data': 'Attempted to access empty list',
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Tracking Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _generateError,
              child: const Text('Generate Test Error'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateCustomError,
              child: const Text('Generate Custom Error'),
            ),
          ],
        ),
      ),
    );
  }
}
