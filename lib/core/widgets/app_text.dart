import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:quran_app/core/navigator_key.dart';
import 'package:quran_app/core/constants/color.dart';
import 'package:quran_app/core/di/injection.dart';

/// Convenience getter for the [AppTextFactory] singleton.
AppTextFactory get appText => locator<AppTextFactory>();

/// Abstract interface for text widget utilities.
/// Can be mocked independently in widget tests.
abstract class AppTextFactory {
  Widget textBody({
    required String text,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    List<Shadow>? shadows,
    double? textHeight,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? letterSpacing,
    TextDecoration textDecoration,
    Color? underlineColor,
    FontStyle? fontStyle,
  });

  Widget title({
    required String text,
    Color? color,
    List<Shadow>? shadows,
    double? textHeight,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? letterSpacing,
    TextDecoration textDecoration,
    Color? underlineColor,
    FontStyle? fontStyle,
  });
}

/// Standalone text widget utility registered in GetIt.
class AppTextFactoryImpl implements AppTextFactory {
  @override
  Widget textBody({
    required final String text,
    final Color? color,
    final double? fontSize,
    final FontWeight? fontWeight,
    final List<Shadow>? shadows,
    final double? textHeight,
    final TextAlign? textAlign,
    final int? maxLines,
    final TextOverflow? overflow,
    final double? letterSpacing,
    final TextDecoration textDecoration = TextDecoration.none,
    final Color? underlineColor,
    final FontStyle? fontStyle,
  }) {
    final BuildContext ctx = navigatorKey.currentContext!;
    return Text(
      text,
      style: GoogleFonts.poppins(
        textStyle: Theme.of(ctx).textTheme.bodyMedium!.copyWith(
              decoration: textDecoration,
              decorationColor: underlineColor,
              color: color ??
                  (Theme.of(ctx).brightness == Brightness.dark
                      ? colorConfig.white
                      : colorConfig.black),
              fontSize: fontSize,
              fontWeight: fontWeight,
              shadows: shadows,
              height: textHeight,
              letterSpacing: letterSpacing,
              fontStyle: fontStyle,
            ),
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: true,
    );
  }

  @override
  Widget title({
    required final String text,
    final Color? color,
    final List<Shadow>? shadows,
    final double? textHeight,
    final TextAlign? textAlign,
    final int? maxLines,
    final TextOverflow? overflow,
    final double? letterSpacing,
    final TextDecoration textDecoration = TextDecoration.none,
    final Color? underlineColor,
    final FontStyle? fontStyle,
  }) {
    final BuildContext ctx = navigatorKey.currentContext!;
    return Text(
      text,
      style: GoogleFonts.poppins(
        textStyle: Theme.of(ctx).textTheme.bodyMedium!.copyWith(
              decoration: textDecoration,
              decorationColor: underlineColor,
              color: color ??
                  (Theme.of(ctx).brightness == Brightness.dark
                      ? colorConfig.white
                      : colorConfig.black),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              shadows: shadows,
              height: textHeight,
              letterSpacing: letterSpacing,
              fontStyle: fontStyle,
            ),
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: true,
    );
  }
}
