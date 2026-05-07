import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/app_assets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('notifications_title'.tr(), style: AppStyles.inter20RegularBlack),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.emptyNotifications,
              width: 314.w,
              height: 314.h,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 314.w,
                  height: 314.h,
                  color: Colors.grey[100],
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.grey[400],
                    size: 40.sp,
                  ),
                );
              },
            ),
            SizedBox(height: 32.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                'no_notifications_empty_state'.tr(),
                textAlign: TextAlign.center,
                style: AppStyles.inter14Regular.copyWith(color: AppColors.gray),
              ),
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }
}
