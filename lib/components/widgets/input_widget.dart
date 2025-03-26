part of 'main_widget.dart';

mixin InputWidget {
  Widget input({
    final TextInputType keyboardType = TextInputType.text,
    final AutovalidateMode? autoValidateMode,
    final FormFieldValidator<String>? validator,
    final bool? enabled,
    final Widget? icon,
    final String? hintText,
    final TextEditingController? controller,
    final String? initialValue,
    final List<TextInputFormatter>? inputFormatters,
    final Function(String)? onChanged,
    final Function(String?)? onSaved,
    final Function(String)? onFieldSubmitted,
    final FocusNode? focusNode,
    final TextInputAction? textInputAction,
    final TextAlign textAlign = TextAlign.start,
    final double? fontSize,
    final FontWeight? fontWeight,
    final double? letterSpacing,
    final int? maxLength,
    final BorderRadius? borderRadius,
    final Widget? suffixIcon,
    final bool readOnly = false,
    final bool filled = true,
    final Color? color,
    final Color? colorHint,
    final Widget? prefixIcon,
    final void Function()? onTap,
    final int? maxLines = 1,
    final String? labelText,
    final Widget? prefix,
    final String? prefixText,
    final bool autofocus = false,
    final EdgeInsetsGeometry? contentPadding,
    final bool? isDense,
    final bool hideMaxLength = false,
    final FontWeight? fontWeightHint,
  }) {
    return TextFormField(
      onTapOutside: (final PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      readOnly: readOnly,
      enabled: enabled,
      maxLines: maxLines,
      onTap: onTap,
      autofocus: autofocus,
      autovalidateMode: autoValidateMode,
      validator: validator,
      keyboardType: keyboardType,
      buildCounter: hideMaxLength
          ? (final BuildContext context,
              {required final int currentLength,
              required final bool isFocused,
              final int? maxLength}) {
              return null;
            }
          : null,
      decoration: InputDecoration(
        filled: filled,
        isDense: isDense,
        prefixIcon: prefixIcon,
        prefixStyle: GoogleFonts.poppins(
          textStyle: Get.textTheme.titleLarge!.copyWith(
            fontSize: fontSize,
            fontWeight: fontWeight,
            letterSpacing: letterSpacing,
            color: color,
          ),
        ),

        // fillColor: Color(0xFFeeeef8),
        fillColor:
            C.isDark(Get.context!) ? colorConfig.bgBottom : colorConfig.white,
        labelText: labelText,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
        border: OutlineInputBorder(
          borderRadius:
              borderRadius ?? const BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
            color: colorConfig.grey.withValues(alpha: 0.4),
          ),
          // borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              borderRadius ?? const BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
            color: colorConfig.grey.withValues(alpha: 0.4),
          ),
          // borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              borderRadius ?? const BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
            color: colorConfig.grey.withValues(alpha: 0.4),
          ),

          // borderSide: BorderSide.none,
        ),

        icon: icon,
        prefix: prefix,
        prefixText: prefixText,
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          textStyle: Get.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: colorConfig.grey.withValues(alpha: 0.4),
          ),
        ),
        labelStyle: labelText == null
            ? null
            : GoogleFonts.poppins(
                textStyle: Get.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorConfig.grey.withValues(alpha: 0.4),
                ),
              ),

        suffixIcon: suffixIcon,
        errorMaxLines: 3,
      ),
      style: GoogleFonts.poppins(
        textStyle: Get.textTheme.bodyMedium!.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
          color: color,
        ),
      ),
      controller: controller,
      initialValue: initialValue,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onSaved: onSaved,
      onFieldSubmitted: onFieldSubmitted,
      focusNode: focusNode,
      textInputAction: textInputAction,
      textAlign: textAlign,
      maxLength: maxLength,
    );
  }

  Widget inputPassword({
    final TextInputType keyboardType = TextInputType.text,
    final AutovalidateMode? autoValidateMode,
    final FormFieldValidator<String>? validator,
    final bool? enabled,
    final Widget? icon,
    final String? hintText,
    final TextEditingController? controller,
    final String? initialValue,
    final List<TextInputFormatter>? inputFormatters,
    final Function(String)? onChanged,
    final Function(String?)? onSaved,
    final Function(String)? onFieldSubmitted,
    final FocusNode? focusNode,
    final TextInputAction? textInputAction,
    final TextAlign textAlign = TextAlign.start,
    final double? fontSize,
    final FontWeight? fontWeight,
    final double? letterSpacing,
    final int? maxLength,
    final bool obscureText = false,
    final Function()? obscureTextPressed,
    final Color? fillColor,
    final String? labelText,
    final BorderRadius? borderRadius,
  }) {
    return TextFormField(
      enabled: enabled,
      autovalidateMode: autoValidateMode,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onTapOutside: (final PointerDownEvent event) {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      decoration: InputDecoration(
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelText: labelText,
        fillColor: fillColor ?? colorConfig.white,
        border: OutlineInputBorder(
          borderRadius:
              borderRadius ?? const BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
            color: colorConfig.grey,
          ),
          // borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              borderRadius ?? const BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
            color: colorConfig.grey,
          ),
          // borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          onPressed: obscureTextPressed,
          icon: Icon(
            obscureText ? Iconsax.eye_slash : Iconsax.eye,
            color: colorConfig.grey,
          ),
        ),
        errorMaxLines: 3,
        labelStyle: labelText == null
            ? null
            : GoogleFonts.poppins(
                textStyle: Get.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorConfig.grey.withValues(alpha: 0.4),
                ),
              ),
      ),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
      ),
      controller: controller,
      initialValue: initialValue,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onSaved: onSaved,
      onFieldSubmitted: onFieldSubmitted,
      focusNode: focusNode,
      textInputAction: textInputAction,
      textAlign: textAlign,
      maxLength: maxLength,
    );
  }
}
