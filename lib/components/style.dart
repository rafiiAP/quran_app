import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_app/data/constant/color.dart';

class MainStyle {
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
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColorConfig.bgBottom,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: AppColorConfig.bgBottom,
      ),
    ),
  );
}
