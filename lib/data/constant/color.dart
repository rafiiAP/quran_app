import 'package:flutter/material.dart';
import 'package:quran_app/injection.dart';

AppColorConfig get colorConfig => locator<AppColorConfig>();

class AppColorConfig {
  MaterialColor primary = const MaterialColor(
    0xFF672CBC,
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
  MaterialColor secondary = const MaterialColor(
    0xFFDF98FA,
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

  Color maroon = const Color(0xFF7f0001);
  Color darkCandyAppleRed = const Color(0xFFA10000);
  Color white = const Color(0xFFffffff);
  Color btnTextColor = const Color(0xFF000000);
  Color background = const Color(0xFF040C23);
  Color lightGrey = const Color(0xFFD8D8D8);
  Color bgBottom = const Color(0xFF121931);
  Color aureolin = const Color(0xFFFCEE10);
  Color deepCarminePink = const Color(0xFFE63235);
  Color princetonOrange = const Color(0xFFFB842A);
  Color fuzzyWuzzy = const Color(0xFFce6e6f);
  Color subtitle = const Color.fromARGB(255, 86, 86, 86);
  Color black = const Color(0xFF000000);
  Color bondiBlue = const Color(0xFF0093ba);
  Color grey = const Color(0xFFA19CC5);
  Color colorCard = const Color(0xFF004B48);
  Color tes = const Color.fromARGB(167, 148, 216, 255);
}
