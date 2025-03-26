part of 'main_widget.dart';

mixin ButtonWidget {
  Widget button({
    required final Function()? onPressed,
    required final Widget child,
    final Color? textColor,
    final Color? backgroundColor,
    final double? elevation,
    final EdgeInsetsGeometry? padding,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: elevation ?? 5,
        foregroundColor: textColor ?? colorConfig.white,
        backgroundColor: backgroundColor ?? colorConfig.primary,
        padding: padding ??
            const EdgeInsets.symmetric(
              vertical: 15,
            ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }

  Widget outlinedButton({
    required final Function()? onPressed,
    required final Widget child,
    final Color? borderColor,
    final EdgeInsetsGeometry? padding,
    final Color? backgroundColor,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: borderColor,
        side: BorderSide(
          color: borderColor ?? colorConfig.primary,
          style: BorderStyle.solid,
          width: 3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        padding: padding ??
            const EdgeInsets.symmetric(
              vertical: 15,
            ),
        backgroundColor: backgroundColor,
      ),
      onPressed: onPressed,
      child: child,
    );
  }

  Widget textButton({
    required final Function()? onPressed,
    required final Widget child,
    final Color? textColor,
    final OutlinedBorder? shape,
    final EdgeInsetsGeometry? padding,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? colorConfig.primary,
        padding: padding ??
            const EdgeInsets.symmetric(
              vertical: 15,
            ),
        shape: shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }

  Widget buttonAKP({
    required final String text,
    final Color? textColor,
    required final dynamic Function()? onPressed,
    final double? paddingHorizontal,
  }) {
    return Container(
      width: C.getWidth(),
      padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal ?? C.getWidth() * 0.03),
      child: W.button(
        onPressed: onPressed,
        child: W.textBody(
          text: text,
          color: textColor ?? colorConfig.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
