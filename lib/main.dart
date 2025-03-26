import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/style.dart';
import 'package:quran_app/data/db/database_helper.dart';
import 'package:quran_app/domain/use_case/remote_usecase.dart';
import 'package:quran_app/firebase_options.dart';
import 'package:quran_app/injection.dart';
import 'package:quran_app/main_getx.dart';
import 'package:quran_app/presentation/controller/dashboard/get_surah_cubit/get_surah_cubit.dart';
import 'package:quran_app/presentation/controller/detail_surah/cubit/detail_surah_cubit.dart';
import 'package:quran_app/presentation/controller/jadwal_sholat/jadwal_sholat_cubit/jadwal_sholat_cubit.dart';

import 'injection.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.setup();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Pastikan Firebase Crashlytics tetap aktif di mode debug
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // Menangkap error sinkron (UI Thread)
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Menangkap error dari kode async yang tidak tertangkap di try-catch
  PlatformDispatcher.instance.onError =
      (final Object error, final StackTrace stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await C.requestAllPermissions();

  await C.initLocalNotif();

  await databaseHelper.db;
  await GetStorage.init();

  style.setSystemUIOverlay();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final MainGetx _c = Get.put(MainGetx());

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider>[
        BlocProvider<GetSurahCubit>(
          create: (final BuildContext context) =>
              GetSurahCubit(quranUsecase: locator<RemoteUsecase>()),
        ),
        BlocProvider<DetailSurahCubit>(
          create: (final BuildContext context) =>
              DetailSurahCubit(quranUsecase: di.locator<RemoteUsecase>()),
        ),
        BlocProvider<JadwalSholatCubit>(
          create: (final BuildContext context) =>
              JadwalSholatCubit(usecase: di.locator<RemoteUsecase>()),
        )
      ],
      child: GetMaterialApp(
        title: 'Quran App',
        theme: style.light,
        darkTheme: style.dark,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: _c.page,
      ),
    );
  }
}
