part of 'main_widget.dart';

mixin ButtonWidget {
  Widget button({
    required final void Function()? onPressed,
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
    required final void Function()? onPressed,
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
}
