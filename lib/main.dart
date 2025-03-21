import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran_app/components/style.dart';
import 'package:quran_app/core/service/local_notification_service.dart';
import 'package:quran_app/core/service/permission_service.dart';
import 'package:quran_app/data/db/database_helper.dart';
import 'package:quran_app/domain/use_case/quran_usecase.dart';
import 'package:quran_app/firebase_options.dart';
import 'package:quran_app/main_getx.dart';
import 'package:quran_app/presentation/controller/dashboard/get_surah_cubit/get_surah_cubit.dart';
import 'package:quran_app/presentation/controller/detail_surah/cubit/detail_surah_cubit.dart';
import 'package:quran_app/presentation/controller/jadwal_sholat/jadwal_sholat_cubit/jadwal_sholat_cubit.dart';

import 'injection.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Pastikan Firebase Crashlytics tetap aktif di mode debug
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // Menangkap error sinkron (UI Thread)
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Menangkap error dari kode async yang tidak tertangkap di try-catch
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await PermissionService.requestAllPermissions();

  await LocalNotificationService.init();

  final DatabaseHelper databaseHelper = DatabaseHelper();
  databaseHelper.db;
  await GetStorage.init();

  MainStyle.setSystemUIOverlay();
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
          create: (context) =>
              GetSurahCubit(quranUsecase: di.locator<RemoteUsecase>()),
        ),
        BlocProvider(
          create: (context) =>
              DetailSurahCubit(quranUsecase: di.locator<RemoteUsecase>()),
        ),
        BlocProvider(
          create: (context) =>
              JadwalSholatCubit(usecase: di.locator<RemoteUsecase>()),
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
