part of 'main_widget.dart';

mixin InputWidget {
  Widget input({
    TextInputType keyboardType = TextInputType.text,
    AutovalidateMode? autoValidateMode,
    FormFieldValidator<String>? validator,
    bool? enabled,
    Widget? icon,
    String? hintText,
    TextEditingController? controller,
    String? initialValue,
    List<TextInputFormatter>? inputFormatters,
    Function(String)? onChanged,
    Function(String?)? onSaved,
    Function(String)? onFieldSubmitted,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    TextAlign? textAlign,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    int? maxLength,
    BorderRadius? borderRadius,
    Widget? suffixIcon,
    bool readOnly = false,
    bool filled = true,
    Color? color,
    Color? colorHint,
    Widget? prefixIcon,
    void Function()? onTap,
    int? maxLines = 1,
    String? labelText,
    Widget? prefix,
    String? prefixText,
    bool autofocus = false,
    EdgeInsetsGeometry? contentPadding,
    bool? isDense,
    bool hideMaxLength = false,
    FontWeight? fontWeightHint,
  }) {
    textAlign ??= TextAlign.start;

    borderRadius ??= const BorderRadius.all(Radius.circular(20));
    contentPadding ??= const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    );

    return TextFormField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus!.unfocus();
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
          ? (context, {required currentLength, required isFocused, maxLength}) {
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
        fillColor: C.isDark(Get.context!) ? AppColorConfig.bgBottom : AppColorConfig.white,
        labelText: labelText,
        contentPadding: contentPadding,
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: AppColorConfig.grey.withOpacity(0.4),
          ),
          // borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: AppColorConfig.grey.withOpacity(0.4),
          ),
          // borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: AppColorConfig.grey.withOpacity(0.4),
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
            color: AppColorConfig.grey.withOpacity(0.4),
          ),
        ),
        labelStyle: labelText == null
            ? null
            : GoogleFonts.poppins(
                textStyle: Get.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColorConfig.grey.withOpacity(0.4),
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
    TextInputType keyboardType = TextInputType.text,
    AutovalidateMode? autoValidateMode,
    FormFieldValidator<String>? validator,
    bool? enabled,
    Widget? icon,
    String? hintText,
    TextEditingController? controller,
    String? initialValue,
    List<TextInputFormatter>? inputFormatters,
    Function(String)? onChanged,
    Function(String?)? onSaved,
    Function(String)? onFieldSubmitted,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    TextAlign? textAlign,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    int? maxLength,
    bool obscureText = false,
    Function()? obscureTextPressed,
    Color? fillColor,
    String? labelText,
    BorderRadius? borderRadius,
  }) {
    textAlign ??= TextAlign.start;
    fillColor ??= AppColorConfig.white;
    borderRadius ??= const BorderRadius.all(Radius.circular(20));

    return TextFormField(
      enabled: enabled,
      autovalidateMode: autoValidateMode,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      decoration: InputDecoration(
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelText: labelText,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(
            color: AppColorConfig.grey,
          ),
          // borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(
            color: AppColorConfig.grey,
          ),
          // borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          onPressed: obscureTextPressed,
          icon: Icon(
            obscureText ? Iconsax.eye_slash : Iconsax.eye,
            color: AppColorConfig.grey,
          ),
        ),
        errorMaxLines: 3,
        labelStyle: labelText == null
            ? null
            : GoogleFonts.poppins(
                textStyle: Get.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColorConfig.grey.withOpacity(0.4),
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
