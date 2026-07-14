import 'package:flutter/material.dart';

import 'package:quran_app/core/constants/color.dart';
import 'package:quran_app/core/di/injection.dart';

/// Convenience getter for the [AppButtonFactory] singleton.
AppButtonFactory get appButton => locator<AppButtonFactory>();

/// Abstract interface for button widget utilities.
/// Can be mocked independently in widget tests.
abstract class AppButtonFactory {
  Widget button({
    required void Function()? onPressed,
    required Widget child,
    Color? textColor,
    Color? backgroundColor,
    double? elevation,
    EdgeInsetsGeometry? padding,
  });

  Widget outlinedButton({
    required void Function()? onPressed,
    required Widget child,
    Color? borderColor,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
  });
}

/// Standalone button widget utility registered in GetIt.
class AppButtonFactoryImpl implements AppButtonFactory {
  @override
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

  @override
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
