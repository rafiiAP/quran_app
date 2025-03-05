import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran_app/components/style.dart';
import 'package:quran_app/data/db/database_helper.dart';
import 'package:quran_app/domain/use_case/quran_usecase.dart';
import 'package:quran_app/firebase_options.dart';
import 'package:quran_app/main_getx.dart';
import 'package:quran_app/presentation/controller/dashboard/get_surah_bloc/get_surah_bloc.dart';
import 'package:quran_app/presentation/controller/detail_surah/detail_surah_bloc/detail_surah_bloc.dart';
import 'package:quran_app/presentation/controller/jadwal_sholat/bloc/jadwal_sholat_bloc.dart';

import 'data/constant/color.dart';

import 'injection.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  final DatabaseHelper databaseHelper = DatabaseHelper();
  databaseHelper.db;
  await GetStorage.init();

  // Cek apakah sistem menggunakan mode gelap atau terang
  final brightness =
      PlatformDispatcher.instance.implicitView?.platformDispatcher.platformBrightness ?? Brightness.light;
  final isDarkMode = brightness == Brightness.dark;
  if (isDarkMode) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColorConfig.bgBottom,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: AppColorConfig.bgBottom,
      ),
    );
  } else {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColorConfig.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: AppColorConfig.white,
      ),
    );
  }
  di.setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final c = Get.put(MainGetx());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetSurahBloc(quranUsecase: di.locator<RemoteUsecase>()),
        ),
        BlocProvider(
          create: (context) => DetailSurahBloc(quranUsecase: di.locator<RemoteUsecase>()),
        ),
        BlocProvider(
          create: (context) => JadwalSholatBloc(usecase: di.locator<RemoteUsecase>()),
        )
      ],
      child: GetMaterialApp(
        title: 'Quran App',
        theme: MainStyle.light,
        darkTheme: MainStyle.dark,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: c.page,
      ),
    );
  }
}
