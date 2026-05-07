import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/entities/order_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderCardSummary extends StatelessWidget {
  final OrderEntity order;

  const OrderCardSummary({super.key, required this.order});

  Future<void> _callCustomer() async {
    final uri = Uri(scheme: 'tel', path: order.customerPhone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  bool _isArabic(String text) {
    final arabic = RegExp(r'[\u0600-\u06FF]');
    return arabic.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer name + call button
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.person_outline,
                    size: 18.sp, color: AppColors.primary),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customerName,
                      style: AppStyles.inter14Regular.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      order.customerPhone,
                      style: AppStyles.inter12Regular.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _callCustomer,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.phone, size: 14.sp, color: AppColors.white),
                      SizedBox(width: 4.w),
                      Text(
                        'rider_call_action'.tr(),
                        style: AppStyles.inter12Regular.copyWith(
                          color: AppColors.white,
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
          if (order.deliveryAddress != null &&
              order.deliveryAddress!.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Container(height: 1, color: AppColors.divider),
            SizedBox(height: 10.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28.w,
                  height: 28.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.location_on_outlined,
                      size: 16.sp, color: AppColors.primary),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Directionality(
                    textDirection: _isArabic(order.deliveryAddress!)
                        ? ui.TextDirection.rtl
                        : ui.TextDirection.ltr,
                    child: Text(
                      order.deliveryAddress!,
                      style: AppStyles.inter12Regular.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
