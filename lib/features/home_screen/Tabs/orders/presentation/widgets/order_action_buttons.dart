import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/widgets/custom_button.dart';
import 'package:home_plate_vendor/core/routes/navigation_helper.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/entities/order_entity.dart';
import 'package:home_plate_vendor/features/support/presentation/pages/chat_screen.dart';

class OrderActionButtons extends StatelessWidget {
  final OrderStatus status;
  final VoidCallback? onActionPressed;
  final bool isLoading;

  const OrderActionButtons({
    super.key,
    required this.status,
    this.onActionPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final showActionButton = _shouldShowActionButton(status);

    return Row(
      children: [
        Expanded(
          child: CustomElevatedButton(
            height: 48,
            text: 'support_button'.tr(),
            backGroundColor: Colors.white,
            borderColor: AppColors.cardBorder,
            borderRadius: 12,
            textStyle: AppStyles.inter16Regular.copyWith(
              color: Colors.grey[400],
            ),
            onButtonClicked: () {
              context.slideTo(const ChatScreen());
            },
          ),
        ),
        if (showActionButton) ...[
          SizedBox(width: 16.w),
          Expanded(
            child: CustomElevatedButton(
              height: 48,
              text: _getButtonText(status),
              backGroundColor: _getButtonColor(status),
              borderRadius: 12,
              textStyle: AppStyles.inter16RegularWhite,
              isLoading: isLoading,
              onButtonClicked: isLoading ? null : onActionPressed,
            ),
          ),
        ],
      ],
    );
  }

  bool _shouldShowActionButton(OrderStatus status) {
    switch (status) {
      case OrderStatus.pendingVendorPreparation:
      case OrderStatus.deliveryAssigned:
      case OrderStatus.readyForPickup:
        return true;
      case OrderStatus.searchingDelivery:
      case OrderStatus.handoverPendingConfirmation:
      case OrderStatus.pickedUp:
      case OrderStatus.outForDelivery:
      case OrderStatus.delivered:
      case OrderStatus.cancelled:
      case OrderStatus.unknown:
        return false;
    }
  }

  String _getButtonText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pendingVendorPreparation:
        return 'order_action_start_cooking'.tr();
      case OrderStatus.searchingDelivery:
        return 'order_action_ready_delivery'.tr();
      case OrderStatus.deliveryAssigned:
        return 'order_action_ready_delivery'.tr();
      case OrderStatus.readyForPickup:
        return 'order_action_deliver'.tr();
      case OrderStatus.handoverPendingConfirmation:
        return 'order_action_confirm_handover'.tr();
      case OrderStatus.pickedUp:
        return 'order_action_picked_up'.tr();
      case OrderStatus.outForDelivery:
        return 'order_action_in_the_way'.tr();
      case OrderStatus.delivered:
        return 'order_action_delivered'.tr();
      case OrderStatus.cancelled:
        return 'order_action_canceled'.tr();
      case OrderStatus.unknown:
        return '';
    }
  }

  Color _getButtonColor(OrderStatus status) {
    if (status == OrderStatus.cancelled) return AppColors.orderRed;
    if (status == OrderStatus.delivered) return Colors.grey;
    return AppColors.orderDarkGreen;
  }
}
