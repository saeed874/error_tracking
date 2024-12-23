import 'dart:io';
import 'package:sentry/sentry.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ErrorTracker {
  late final String _dsn;

  ErrorTracker(String sentryDsn) {
    _dsn = sentryDsn;
  }

  Future<void> initialize() async {
    if (_dsn.isEmpty) return;

    await Sentry.init(
      (options) {
        options.dsn = _dsn;
        options.tracesSampleRate = 1.0;
        options.debug = true;
      },
    );
  }

  Future<void> captureException(dynamic exception,
      {StackTrace? stackTrace, Map<String, dynamic>? extra}) async {
    if (_dsn.isEmpty) return;

    final deviceInfo = await _getDeviceInfo();
    final packageInfo = await _getPackageInfo();

    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setExtra('', {
          'device_info': deviceInfo,
          'app_info': packageInfo,
          ...?extra,
        });
      },
    );
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return {
        'model': androidInfo.model,
        'manufacturer': androidInfo.manufacturer,
        'version': androidInfo.version.release,
      };
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return {
        'model': iosInfo.model,
        'version': iosInfo.systemVersion,
      };
    }
    return {};
  }

  Future<Map<String, dynamic>> _getPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return {
      'app_name': packageInfo.appName,
      'package_name': packageInfo.packageName,
      'version': packageInfo.version,
      'build_number': packageInfo.buildNumber,
    };
  }
}
