import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/app_assets.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderRiderDetails extends StatelessWidget {
  final String? riderName;
  final String? riderPhone;
  final String? riderRating;
  final String? riderExperience;

  const OrderRiderDetails({
    super.key,
    this.riderName,
    this.riderPhone,
    this.riderRating,
    this.riderExperience,
  });

  Future<void> _callRider(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasRider = riderName != null && riderName!.trim().isNotEmpty;
    final hasPhone = riderPhone != null && riderPhone!.trim().isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.delivery_dining,
                  size: 16.sp, color: AppColors.textSecondary),
              SizedBox(width: 6.w),
              Text(
                'rider_section_title'.tr(),
                style: AppStyles.inter12Regular.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  AppAssets.rider,
                  width: 44.w,
                  height: 44.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasRider ? riderName! : 'rider_not_assigned'.tr(),
                      style: AppStyles.inter14Regular.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        _buildMiniInfo(
                          Icons.star_rounded,
                          riderRating ?? '—',
                          isRating: true,
                        ),
                        SizedBox(width: 10.w),
                        _buildMiniInfo(
                          Icons.access_time_filled_rounded,
                          riderExperience ?? '—',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (hasPhone)
                GestureDetector(
                  onTap: () => _callRider(riderPhone!),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone,
                            size: 14.sp, color: AppColors.success),
                        SizedBox(width: 4.w),
                        Text(
                          'rider_call_action'.tr(),
                          style: AppStyles.inter12Regular.copyWith(
                            color: AppColors.success,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniInfo(IconData icon, String text, {bool isRating = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12.sp,
          color: isRating ? AppColors.orderAmber : AppColors.textLight,
        ),
        SizedBox(width: 3.w),
        Text(
          text,
          style: AppStyles.inter12Regular.copyWith(
            color: AppColors.textSecondary,
            fontSize: 10.sp,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
