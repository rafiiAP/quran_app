import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran_app/components/style.dart';
import 'package:quran_app/data/db/database_helper.dart';
import 'package:quran_app/main_getx.dart';
import 'package:quran_app/presentation/controller/dashboard/get_surah_bloc/get_surah_bloc.dart';
import 'package:quran_app/presentation/controller/detail_surah/bloc/detail_surah_bloc.dart';

import 'data/constant/color.dart';
import 'injection.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        statusBarBrightness: Brightness.light,
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
          create: (context) => GetSurahBloc(),
        ),
        BlocProvider(
          create: (context) => DetailSurahBloc(),
        ),
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
