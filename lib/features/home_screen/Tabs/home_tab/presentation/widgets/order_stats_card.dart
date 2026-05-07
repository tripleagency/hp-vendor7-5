import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';

class OrderStatsCard extends StatelessWidget {
  final String title;
  final String count;
  final String icon;
  final Color iconColor;
  final Color iconBgColor;
  final VoidCallback? onTap;

  const OrderStatsCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24.r),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 12.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                icon.endsWith('.svg')
                    ? SvgPicture.asset(
                        icon,
                        width: 48.w,
                        height: 48.h,
                        fit: BoxFit.contain,
                        colorFilter:
                            ColorFilter.mode(iconColor, BlendMode.srcIn),
                      )
                    : Image.asset(
                        icon,
                        width: 48.w,
                        height: 48.h,
                        fit: BoxFit.contain,
                      ),
                SizedBox(height: 6.h),
                Text(
                  title,
                  style: AppStyles.inter16MediumBlack.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    color: const Color(0xFF101828),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'order_count'.tr(args: [count]),
                      style: AppStyles.inter12Regular.copyWith(
                        color: const Color(0xFF667085),
                        fontSize: 14.sp,
                      ),
                    ),
                    Container(
                      height: 32.w,
                      width: 32.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE4E7EC)),
                      ),
                      child: Tooltip(
                        message: 'view_details'.tr(),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 14.sp,
                          color: const Color(0xFFD0D5DD),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
