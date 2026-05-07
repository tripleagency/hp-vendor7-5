import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/utils/app_assets.dart';
import 'package:home_plate_vendor/core/widgets/widgets.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';

class CustomSuccessScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback onButtonPressed;
  final String? imagePath;

  const CustomSuccessScreen({
    super.key,
    required this.title,
    required this.subtitle,
    this.buttonText,
    required this.onButtonPressed,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
          child: Column(
            children: [
              SizedBox(height: 110.h),
              // Success Image
              Image.asset(
                imagePath ?? AppAssets.successImage,
                width: 200.w,
                height: 200.h,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 50.h),

              // Title
              Text(
                title,
                style: AppStyles.inter18MediumBlack.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),

              // Subtitle
              Text(
                subtitle,
                style: AppStyles.inter14Regular.copyWith(
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 60.h),

              // Action Button
              CustomElevatedButton(
                text: buttonText ?? 'home_button'.tr(),
                textStyle: AppStyles.inter16RegularWhite,
                backGroundColor: AppColors.primary,
                onButtonClicked: onButtonPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
