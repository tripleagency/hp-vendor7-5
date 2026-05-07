import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final String? hintText;
  final String? labelText;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final Color? fillColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final String? errorText;

  const CustomDropdown({
    super.key,
    this.value,
    this.hintText,
    this.labelText,
    required this.items,
    this.onChanged,
    this.validator,
    this.fillColor,
    this.borderRadius,
    this.contentPadding,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = BorderRadius.circular(borderRadius ?? 15.r);
    return DropdownButtonFormField<T>(
      isExpanded: true,
      isDense: true,
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      style: AppStyles.inter14Regular.copyWith(color: AppColors.black),
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.grey[400],
        size: 20.sp,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? AppColors.white,
        labelText: labelText,
        labelStyle: AppStyles.inter16Regular,
        hintText: hintText,
        hintStyle: AppStyles.inter16Regular,
        errorText: errorText,
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
        enabledBorder: OutlineInputBorder(
          borderRadius: effectiveBorderRadius,
          borderSide: BorderSide(color: AppColors.gray, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: effectiveBorderRadius,
          borderSide: BorderSide(color: AppColors.primary, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: effectiveBorderRadius,
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: effectiveBorderRadius,
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
      ),
    );
  }
}
