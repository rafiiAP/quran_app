part of 'main_widget.dart';

mixin TextWidget {
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
    return Text(
      text,
      style: GoogleFonts.poppins(
        textStyle: Get.textTheme.bodyMedium!.copyWith(
          decoration: textDecoration,
          decorationColor: underlineColor,
          color: color ??
              (Theme.of(Get.context!).brightness == Brightness.dark
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
    return Text(
      text,
      style: GoogleFonts.poppins(
        textStyle: Get.textTheme.bodyMedium!.copyWith(
          decoration: textDecoration,
          decorationColor: underlineColor,
          color: color ??
              (Theme.of(Get.context!).brightness == Brightness.dark
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
