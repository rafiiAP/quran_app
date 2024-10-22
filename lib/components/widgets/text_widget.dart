part of 'main_widget.dart';

mixin TextWidget {
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
    TextDecoration textDecoration = TextDecoration.none,
    Color? underlineColor,
    FontStyle? fontStyle,
  }) {
    if (Theme.of(Get.context!).brightness == Brightness.dark) {
      color ??= AppColorConfig.white;
    } else {
      color ??= AppColorConfig.black;
    }
    return Text(
      text,
      style: GoogleFonts.poppins(
        textStyle: Get.textTheme.bodyMedium!.copyWith(
          decoration: textDecoration,
          decorationColor: underlineColor,
          color: color,
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
    required String text,
    Color? color,
    List<Shadow>? shadows,
    double? textHeight,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? letterSpacing,
    TextDecoration textDecoration = TextDecoration.none,
    Color? underlineColor,
    FontStyle? fontStyle,
  }) {
    if (Theme.of(Get.context!).brightness == Brightness.dark) {
      color ??= AppColorConfig.white;
    } else {
      color ??= AppColorConfig.black;
    }
    return Text(
      text,
      style: GoogleFonts.poppins(
        textStyle: Get.textTheme.bodyMedium!.copyWith(
          decoration: textDecoration,
          decorationColor: underlineColor,
          color: color,
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
