import 'package:flutter/material.dart';

class AppColorConfig {
  AppColorConfig._();

  static const MaterialColor primary = MaterialColor(
    _primary,
    <int, Color>{
      50: Color(0xFFE0F6F5),
      100: Color(0xFFC0ECEA),
      200: Color(0xFFA1E3E0),
      300: Color(0xFF81D9D5),
      400: Color(0xFF81D9D5),
      500: Color(0xFF62D0CB),
      600: Color(0xFF52CBC6),
      700: Color(0xFF42C6C0),
      800: Color(0xFF33C2BB),
      900: Color(0xFF23BDB5),
    },
  );
  static const MaterialColor secondary = MaterialColor(
    _secondary,
    <int, Color>{
      50: Color(0xFFfff7e0),
      100: Color(0xFFffe9b1),
      200: Color(0xFFffda7e),
      300: Color(0xFFfecd4a),
      400: Color(0xFFfec122),
      500: Color(0xFFfdb700),
      600: Color(0xFFfda900),
      700: Color(0xFFfc9600),
      800: Color(0xFFfc8501),
      900: Color(0xFFfb6406),
    },
  );

  static const int _primary = 0xFF672CBC;
  // static const int _primaryColorValue = 0xFF00A2E9;
  static const int _secondary = 0xFFDF98FA;

  static const Color maroon = Color(0xFF7f0001);
  static const Color darkCandyAppleRed = Color(0xFFA10000);
  static const Color white = Color(0xFFffffff);
  static const Color btnTextColor = Color(0xFF000000);
  static const Color background = Color(0xFF040C23);
  static const Color lightGrey = Color(0xFFD8D8D8);
  static const Color bgBottom = Color(0xFF121931);
  static const Color aureolin = Color(0xFFFCEE10);
  static const Color deepCarminePink = Color(0xFFE63235);
  static const Color princetonOrange = Color(0xFFFB842A);
  static const Color fuzzyWuzzy = Color(0xFFce6e6f);
  static const Color subtitle = Color.fromARGB(255, 86, 86, 86);
  static const Color black = Color(0xFF000000);
  static const Color bondiBlue = Color(0xFF0093ba);
  static const Color grey = Color(0xFFA19CC5);
  static const Color colorCard = Color(0xFF004B48);
  static const Color tes = Color.fromARGB(167, 148, 216, 255);
}
