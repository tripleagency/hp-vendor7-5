import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';

class CustomTextField extends StatefulWidget {
  final Color? filledColor;
  final Color? borderColor;
  final bool isPassword;
  final String hintText;
  final String? labelText;
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? labelStyle;
  final int maxLines;
  final TextStyle? style;
  final TextInputType keyBoardType;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final bool readOnly;
  final double? borderSize;
  final String? errorText;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    this.borderSize,
    this.readOnly = false,
    this.onTap,
    this.filledColor = AppColors.white,
    this.onChanged,
    this.keyBoardType = TextInputType.text,
    this.validator,
    this.borderColor = AppColors.gray,
    required this.hintText,
    this.labelText,
    this.controller,
    this.hintStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.labelStyle,
    this.style,
    this.isPassword = false,
    this.maxLines = 1,
    this.errorText,
    this.inputFormatters,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      onChanged: widget.onChanged,
      controller: widget.controller,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: widget.inputFormatters,

      cursorColor: AppColors.black,
      style: AppStyles.inter18RegularBlack,
      obscureText: widget.isPassword ? _obscureText : false,
      keyboardType: widget.keyBoardType,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.filledColor,
        prefixIcon: widget.prefixIcon,
        suffixIcon: _buildSuffixIcon(),
        hintText: widget.hintText,
        labelText: widget.labelText,
        labelStyle: widget.labelStyle,
        errorText: widget.errorText,

        hintStyle: widget.hintStyle ?? AppStyles.inter16Regular,
        contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(
            color: widget.borderColor ?? AppColors.gray,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: AppColors.primary, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off_sharp : Icons.visibility_outlined,
          color: const Color(0x80000000),
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    if (widget.suffixIcon != null) {
      return widget.suffixIcon;
    }
    return null;
  }
}
