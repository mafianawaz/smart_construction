import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/app_color.dart';

class CustomTextField extends StatelessWidget {
  final String? heading;
  final bool isMuted;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool autocorrect;
  final bool readOnly;
  final TextCapitalization textCapitalization;
  final String? leftIconPath;
  final Widget? rightIcon;
  final VoidCallback? onClick;
  final Function(String?)? onChange;
  final Function(String?)? onSubmit;
  final Function(String?)? validate;
  final VoidCallback? onTogglePasswordStatus;
  final bool? obscureText;
  final int? maxLines;
  final Color? filledColor;
  final bool? isFilled;
  final List<TextInputFormatter>?inputFormatter;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.onClick,
    this.onSubmit,
    this.keyboardType = TextInputType.text,
    this.obscureText,
    this.autocorrect = true,
    this.readOnly = false,
    this.textCapitalization = TextCapitalization.none,
    this.leftIconPath,
    this.rightIcon,
    this.heading,
    this.isMuted = false,
    this.onChange,
    this.validate,
    this.onTogglePasswordStatus,
    this.maxLines,
    this.filledColor,
    this.isFilled = false,
    this.inputFormatter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        if ((heading ?? '').isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: isMuted ?
              Text(
                heading!.toUpperCase(),
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ):
              Text(
                heading!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),
        TextFormField(
          inputFormatters: inputFormatter,
          controller: controller,
          onChanged: onChange,
          readOnly: readOnly,
          maxLines: maxLines ?? 1,
          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
          validator: (value) => validate?.call(value),
          onTap: onClick,
          keyboardType: keyboardType,
          obscureText: obscureText ?? false,
          autocorrect: autocorrect,
          textCapitalization: textCapitalization,
          onSaved: onSubmit,
          style: const TextStyle(fontSize: 14, color: AppColors.textDark),
          decoration: InputDecoration(
            filled: isFilled ?? true,
            fillColor: filledColor ?? AppColors.fieldFill,
            hintText: hintText,
            hintStyle: TextStyle(
              color: theme.hintColor,
              fontSize: 13,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.fieldBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.fieldBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryOrange),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            prefixIcon: leftIconPath != null
                ? Padding(
              padding: const EdgeInsets.all(14.0),
              child: SvgPicture.asset(
                leftIconPath!,
                color: AppColors.textMuted,
                height: 10,
              ),
            )
                : null,
            suffixIcon: (obscureText != null)
                ? IconButton(
              icon: Icon(
                obscureText == true
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: !obscureText!
                    ? AppColors.primaryOrange
                    : theme.disabledColor,
              ),
              onPressed: onTogglePasswordStatus,
            )
                : Padding(
              padding: const EdgeInsets.all(8.0),
              child: rightIcon,
            ),
          ),
        ),
      ],
    );
  }
}
