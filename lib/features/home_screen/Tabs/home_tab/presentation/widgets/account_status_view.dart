import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/app_assets.dart';
import 'package:home_plate_vendor/core/routes/navigation_helper.dart';
import 'package:home_plate_vendor/features/support/presentation/pages/chat_screen.dart';

enum AccountStatus { normal, waiting, rejection, suspended }

class AccountStatusView extends StatelessWidget {
  final AccountStatus status;
  final String? reason;

  const AccountStatusView({super.key, required this.status, this.reason});

  @override
  Widget build(BuildContext context) {
    if (status == AccountStatus.normal) return const SizedBox.shrink();

    String imagePath;
    String title;
    String subTitle;
    Color? boxColor;
    Color? textColor;
    bool isSuspended = status == AccountStatus.suspended;

    switch (status) {
      case AccountStatus.waiting:
        imagePath = AppAssets.accountWaiting;
        title = 'account_status_waiting_title'.tr();
        subTitle = 'account_status_waiting_subtitle'.tr();
        boxColor = Colors.white;
        textColor = AppColors.black;
        break;
      case AccountStatus.rejection:
        imagePath = AppAssets.accountRejection;
        title = 'account_status_rejection_title'.tr();
        // Prefer the API rejection reason; fall back to the localized default.
        subTitle = (reason != null && reason!.trim().isNotEmpty)
            ? reason!
            : 'account_status_rejection_subtitle'.tr();
        boxColor = const Color(0xFFFFEBEE); // Light red
        textColor = const Color(0xFFD32F2F); // Darker red
        break;
      case AccountStatus.suspended:
        imagePath = AppAssets.accountSuspended;
        title = 'account_status_suspended_title'.tr();
        subTitle = 'account_status_suspended_subtitle'.tr();
        boxColor = AppColors.black;
        textColor = Colors.white;
        break;
      default:
        return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 80.h),
          Image.asset(
            imagePath,
            width: 180.w,
            height: 141.w,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 180.w,
                height: 141.w,
                color: Colors.grey[100],
                child: Icon(
                  Icons.error_outline,
                  color: Colors.grey[400],
                  size: 40.sp,
                ),
              );
            },
          ),
          SizedBox(height: 40.h),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: boxColor,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                if (!isSuspended)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppStyles.inter16MediumBlack.copyWith(
                    color: textColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style: AppStyles.inter12Regular.copyWith(
                    color: AppColors.gray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (isSuspended) ...[
            SizedBox(height: 24.h),
            _buildSupportButton(context),
          ],
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  Widget _buildSupportButton(BuildContext context) {
    return InkWell(
      onTap: () {
        context.slideTo(const ChatScreen());
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(AppAssets.supportIcon, width: 62.w, height: 47.h),
            SizedBox(width: 12.w),
            Text(
              'support_button'.tr(),
              style: AppStyles.inter16Medium.copyWith(color: Color(0xff142E4B)),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
