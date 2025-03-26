import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/injection.dart';

MainStyle get style => locator<MainStyle>();

class MainStyle {
  /// Untuk set statusBarColor, statusBarIconBrightness, statusBarBrightness, systemNavigationBarColor, systemNavigationBarIconBrightness, systemNavigationBarDividerColor
  void setSystemUIOverlay() {
    final Brightness brightness = PlatformDispatcher
            .instance.implicitView?.platformDispatcher.platformBrightness ??
        Brightness.light;
    final bool isDarkMode = brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
        systemNavigationBarColor:
            isDarkMode ? colorConfig.bgBottom : colorConfig.white,
        systemNavigationBarIconBrightness:
            isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarDividerColor:
            isDarkMode ? colorConfig.bgBottom : colorConfig.white,
      ),
    );
  }

  ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: colorConfig.white,
    appBarTheme: AppBarTheme(
      backgroundColor: colorConfig.white,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: colorConfig.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: colorConfig.white,
      ),
    ),
  );
  ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: colorConfig.background,
    appBarTheme: AppBarTheme(
      backgroundColor: colorConfig.bgBottom,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: colorConfig.bgBottom,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: colorConfig.bgBottom,
      ),
    ),
  );
}
