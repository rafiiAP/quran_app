import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/style.dart';
import 'package:quran_app/core/services/crash_reporter.dart';
import 'package:quran_app/core/services/flutter_notification_service.dart';
import 'package:quran_app/core/services/permission_service.dart';
import 'package:quran_app/core/storage/database_helper.dart';
import 'package:quran_app/features/surah/domain/usecases/get_surah_usecase.dart';
import 'package:quran_app/firebase_options.dart';
import 'package:quran_app/core/di/injection.dart';
import 'package:quran_app/core/di/injection.dart' as di;
import 'package:quran_app/features/bookmark/presentation/cubits/bookmark_cubit/bookmark_cubit.dart';
import 'package:quran_app/features/dashboard/presentation/cubits/dashboard_cubit/dashboard_cubit.dart';
import 'package:quran_app/features/surah/presentation/cubits/get_surah_cubit/get_surah_cubit.dart';
import 'package:quran_app/features/dashboard/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:quran_app/core/router/app_router.dart';
import 'package:quran_app/core/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setup();
  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Firebase Crashlytics collection — platform-level init (cannot be abstracted)
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // Route uncaught errors through the CrashReporter abstraction
  final crashReporter = locator<CrashReporter>();

  // Menangkap error sinkron (UI Thread)
  FlutterError.onError = (details) {
    crashReporter.recordError(
      details.exception,
      details.stack,
    );
  };

  // Menangkap error dari kode async yang tidak tertangkap di try-catch
  PlatformDispatcher.instance.onError =
      (final Object error, final StackTrace stack) {
    crashReporter.recordError(error, stack);
    return true;
  };

  await locator<PermissionService>().requestAllPermissions();

  final notificationService =
      locator<NotificationService>() as FlutterNotificationService;
  await notificationService.initLocalNotif();

  await databaseHelper.db;

  style.setSystemUIOverlay();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider>[
        BlocProvider<DashboardCubit>(
          create: (final BuildContext context) =>
              DashboardCubit(storageService: di.locator()),
        ),
        BlocProvider<HomeCubit>(
          create: (final BuildContext context) =>
              HomeCubit(storageService: di.locator()),
        ),
        BlocProvider<GetSurahCubit>(
          create: (final BuildContext context) =>
              GetSurahCubit(usecase: locator<GetSurahUseCase>()),
        ),
        BlocProvider<BookmarkCubit>(
          create: (final BuildContext context) =>
              BookmarkCubit(databaseHelper: di.locator()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Quran App',
        theme: style.light,
        darkTheme: style.dark,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        routerConfig: locator<AppRouter>().router,
      ),
    );
  }
}
