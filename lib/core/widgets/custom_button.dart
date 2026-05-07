import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final Color? backGroundColor;
  final String text;
  final TextStyle? textStyle;
  final void Function()? onButtonClicked;
  final double? borderRadius;
  final Color? borderColor;
  final double? height;
  final bool isLoading;

  const CustomElevatedButton({
    super.key,
    this.backGroundColor,
    required this.text,
    this.textStyle,
    required this.onButtonClicked,
    this.borderRadius,
    this.borderColor,
    this.height,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backGroundColor ?? AppColors.background,
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        elevation: 0,
        side: borderColor != null ? BorderSide(color: borderColor!) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius?.r ?? 10.r),
        ),
      ),
      onPressed: isLoading ? null : onButtonClicked,
      child: SizedBox(
        height: height?.h ?? 60.h,
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : AutoSizeText(text, style: textStyle),
        ),
      ),
    );
  }
}
