import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quran_app/core/di/injection.dart' as di;
import 'package:quran_app/core/di/injection.dart';
import 'package:quran_app/core/services/crash_reporter.dart';
import 'package:quran_app/core/services/notification_service.dart';
import 'package:quran_app/core/services/permission_service.dart';
import 'package:quran_app/core/storage/database_helper.dart';
import 'package:quran_app/core/style.dart';
import 'package:quran_app/firebase_options.dart';

/// Encapsulates all app startup logic into a single testable class.
///
/// Separates concerns:
/// - [initDependencies] — DI, env, Firebase
/// - [initServices] — permissions, notifications, database
/// - [configureErrorReporting] — crash reporting hooks
/// - [configureUI] — system UI overlay
class AppBootstrap {
  const AppBootstrap._();

  /// Runs the full bootstrap sequence. Call from [main] before [runApp].
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _initDependencies();
    await _configureErrorReporting();
    await _initServices();
    _configureUI();
  }

  /// Registers all DI singletons, loads env, initializes Firebase.
  static Future<void> _initDependencies() async {
    await di.setup();
    await dotenv.load(fileName: '.env');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }

  /// Hooks uncaught Flutter and platform errors into [CrashReporter].
  static Future<void> _configureErrorReporting() async {
    final crashReporter = locator<CrashReporter>();

    FlutterError.onError = (details) {
      crashReporter.recordError(details.exception, details.stack);
    };

    PlatformDispatcher.instance.onError =
        (final Object error, final StackTrace stack) {
      crashReporter.recordError(error, stack);
      return true;
    };
  }

  /// Initializes runtime services: permissions, notifications, database.
  static Future<void> _initServices() async {
    await locator<PermissionService>().requestAllPermissions();
    await locator<NotificationService>().initLocalNotif();
    await databaseHelper.db;
  }

  /// Configures system UI overlays (status bar, navigation bar).
  static void _configureUI() {
    style.setSystemUIOverlay();
  }
}
