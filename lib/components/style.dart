import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_app/data/constant/color.dart';

class MainStyle {
  static final MainStyle _instance = MainStyle._internal();

  MainStyle._internal();

  factory MainStyle() {
    return _instance;
  }

  /// Untuk set statusBarColor, statusBarIconBrightness, statusBarBrightness, systemNavigationBarColor, systemNavigationBarIconBrightness, systemNavigationBarDividerColor
  static setSystemUIOverlay() {
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
  }

  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColorConfig.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColorConfig.white,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColorConfig.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: AppColorConfig.white,
      ),
    ),
  );
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColorConfig.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColorConfig.bgBottom,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColorConfig.bgBottom,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: AppColorConfig.bgBottom,
      ),
    ),
  );
}
