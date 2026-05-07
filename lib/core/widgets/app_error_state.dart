import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';

class AppErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AppErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    // Auto-translate the message if it's a localization key
    final displayMessage = message.tr();
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red[300]),
            SizedBox(height: 16.h),
            Text(
              displayMessage,
              style: AppStyles.inter16Regularblack,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orderGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 32.w,
                  vertical: 12.h,
                ),
              ),
              child: Text(
                'tap_to_retry'.tr(),
                style: AppStyles.inter16RegularWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
