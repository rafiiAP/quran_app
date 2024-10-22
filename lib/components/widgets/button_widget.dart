part of 'main_widget.dart';

mixin ButtonWidget {
  Widget button({
    required Function()? onPressed,
    required Widget child,
    Color? textColor,
    Color? backgroundColor,
    double? elevation,
    EdgeInsetsGeometry? padding,
  }) {
    textColor ??= AppColorConfig.primary;
    backgroundColor ??= AppColorConfig.primary;
    padding ??= const EdgeInsets.symmetric(
      vertical: 15,
    );
    elevation ??= 5;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: elevation,
        foregroundColor: textColor,
        backgroundColor: backgroundColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }

  Widget outlinedButton({
    required Function()? onPressed,
    required Widget child,
    Color? borderColor,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
  }) {
    borderColor ??= AppColorConfig.primary;
    padding ??= const EdgeInsets.symmetric(
      vertical: 18.0,
    );
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: borderColor,
        side: BorderSide(
          color: borderColor,
          style: BorderStyle.solid,
          width: 3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        padding: padding,
        backgroundColor: backgroundColor,
      ),
      onPressed: onPressed,
      child: child,
    );
  }

  Widget textButton({
    required Function()? onPressed,
    required Widget child,
    Color? textColor,
    OutlinedBorder? shape,
    EdgeInsetsGeometry? padding,
  }) {
    textColor ??= Get.theme.colorScheme.primary;
    padding ??= const EdgeInsets.symmetric(
      vertical: 18.0,
    );
    shape ??= RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    );
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: textColor,
        padding: padding,
        shape: shape,
      ),
      onPressed: onPressed,
      child: child,
    );
  }

  Widget buttonAKP({
    required String text,
    Color? textColor,
    required dynamic Function()? onPressed,
    double? paddingHorizontal,
  }) {
    textColor ??= AppColorConfig.white;
    paddingHorizontal ??= C.getWidth() * 0.03;
    return Container(
      width: C.getWidth(),
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal ?? 16),
      child: W.button(
        onPressed: onPressed,
        child: W.textBody(
          text: text,
          color: textColor,
        ),
      ),
    );
  }
}
