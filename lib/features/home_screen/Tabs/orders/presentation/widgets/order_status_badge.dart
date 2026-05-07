import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/entities/order_entity.dart';

class StatusConfig {
  final Color backgroundColor;
  final Color textColor;
  final String text;

  const StatusConfig({
    required this.backgroundColor,
    required this.textColor,
    required this.text,
  });

  static StatusConfig fromStatus(OrderStatus status) {
    switch (status) {
      case OrderStatus.pendingVendorPreparation:
        return StatusConfig(
          backgroundColor: AppColors.statusNewBg,
          textColor: AppColors.orderAmber,
          text: 'order_status_new'.tr(),
        );
      case OrderStatus.searchingDelivery:
        return StatusConfig(
          backgroundColor: AppColors.statusCookingBg,
          textColor: AppColors.orderBlue,
          text: 'order_status_searching_delivery'.tr(),
        );
      case OrderStatus.deliveryAssigned:
        return StatusConfig(
          backgroundColor: AppColors.statusCookingBg,
          textColor: AppColors.orderBlue,
          text: 'order_status_delivery_assigned'.tr(),
        );
      case OrderStatus.readyForPickup:
        return StatusConfig(
          backgroundColor: AppColors.statusReadyBg,
          textColor: AppColors.orderSuccessGreen,
          text: 'order_status_ready_for_delivery'.tr(),
        );
      case OrderStatus.handoverPendingConfirmation:
        return StatusConfig(
          backgroundColor: AppColors.statusReadyBg,
          textColor: AppColors.orderOrange,
          text: 'order_status_handover_pending'.tr(),
        );
      case OrderStatus.pickedUp:
        return StatusConfig(
          backgroundColor: AppColors.statusDeliveryBg,
          textColor: AppColors.orderBlue,
          text: 'order_status_picked_up'.tr(),
        );
      case OrderStatus.outForDelivery:
        return StatusConfig(
          backgroundColor: AppColors.statusDeliveryBg,
          textColor: AppColors.orderBlue,
          text: 'order_status_in_the_way'.tr(),
        );
      case OrderStatus.delivered:
        return StatusConfig(
          backgroundColor: AppColors.statusDeliveredBg,
          textColor: AppColors.orderSuccessGreen,
          text: 'order_status_delivered'.tr(),
        );
      case OrderStatus.cancelled:
        return StatusConfig(
          backgroundColor: AppColors.statusCancelledBg,
          textColor: AppColors.orderCancelledRed,
          text: 'order_status_canceled'.tr(),
        );
      case OrderStatus.unknown:
        return StatusConfig(
          backgroundColor: Colors.grey[200]!,
          textColor: Colors.grey[600]!,
          text: 'Unknown',
        );
    }
  }
}

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = StatusConfig.fromStatus(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        config.text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: config.textColor,
        ),
      ),
    );
  }
}
