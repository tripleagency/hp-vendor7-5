import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/date_formatter.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/entities/order_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/presentation/widgets/order_status_badge.dart';

class OrderCardHeader extends StatelessWidget {
  final OrderEntity order;
  final bool isExpanded;
  final VoidCallback onTap;

  const OrderCardHeader({
    super.key,
    required this.order,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'order_number'.tr(
                      namedArgs: {'number': order.orderNumber},
                    ),
                    style: AppStyles.inter20RegularBlack.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        DateFormatter.formatDate(order.orderedAt),
                        style: AppStyles.inter12Regular.copyWith(
                          color: AppColors.gray,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        DateFormatter.formatTime(order.orderedAt),
                        style: AppStyles.inter12Regular.copyWith(
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            OrderStatusBadge(status: order.status),
          ],
        ),
      ),
    );
  }
}
