import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_plate_vendor/core/utils/extensions.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/entities/order_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/presentation/manager/orders_cubit/orders_cubit.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/presentation/widgets/order_card_header.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/presentation/widgets/order_card_summary.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/presentation/widgets/order_notes_section.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/presentation/widgets/order_total_section.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/presentation/widgets/order_item_row.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/presentation/widgets/order_rider_details.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/presentation/widgets/order_action_buttons.dart';

class OrderCard extends StatefulWidget {
  final OrderEntity order;

  const OrderCard({super.key, required this.order});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          OrderCardHeader(
            order: widget.order,
            isExpanded: _isExpanded,
            onTap: () => setState(() => _isExpanded = !_isExpanded),
          ),
          if (_isExpanded) _buildExpandedContent(),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    final shouldShowRider =
        widget.order.status != OrderStatus.pendingVendorPreparation &&
            widget.order.status != OrderStatus.searchingDelivery &&
            widget.order.status != OrderStatus.cancelled;

    return BlocListener<OrdersCubit, OrdersState>(
      listenWhen: (previous, current) =>
          previous.actionStatus != current.actionStatus &&
          current.actionOrderId == widget.order.id,
      listener: (context, state) {
        if (state.actionStatus == OrderActionStatus.success) {
          final updatedOrder = state.orders.firstWhere(
            (o) => o.id == widget.order.id,
            orElse: () => widget.order,
          );
          context.showSuccessSnackBar(
            _getSuccessMessage(updatedOrder.status),
          );
          context.read<OrdersCubit>().resetActionStatus();
        } else if (state.actionStatus == OrderActionStatus.failure) {
          final errorMsg = state.actionErrorMessage ?? 'error_generic_message';
          context.showErrorSnackBar(errorMsg.tr());
          context.read<OrdersCubit>().resetActionStatus();
        }
      },
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderCardSummary(order: widget.order),
            SizedBox(height: 12.h),
            if (shouldShowRider)
              OrderRiderDetails(
                riderName: widget.order.delivery?.displayName,
                riderPhone: widget.order.delivery?.phone,
              ),
            // Order items list
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.order.orderItems.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                return OrderItemRow(item: widget.order.orderItems[index]);
              },
            ),
            // Notes
            if (widget.order.notes != null &&
                widget.order.notes!.isNotEmpty) ...[
              SizedBox(height: 16.h),
              OrderNotesSection(notes: widget.order.notes!),
            ],
            // Payment & total
            SizedBox(height: 16.h),
            OrderTotalSection(order: widget.order),
            SizedBox(height: 24.h),
            // Action buttons
            BlocBuilder<OrdersCubit, OrdersState>(
              buildWhen: (previous, current) =>
                  previous.actionStatus != current.actionStatus &&
                  current.actionOrderId == widget.order.id,
              builder: (context, state) {
                final isLoading =
                    state.actionStatus == OrderActionStatus.loading &&
                        state.actionOrderId == widget.order.id;
                return OrderActionButtons(
                  status: widget.order.status,
                  isLoading: isLoading,
                  onActionPressed: () => _handleActionPress(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleActionPress(BuildContext context) {
    switch (widget.order.status) {
      case OrderStatus.pendingVendorPreparation:
        context.read<OrdersCubit>().startCooking(widget.order.id);
        break;
      case OrderStatus.deliveryAssigned:
        context.read<OrdersCubit>().readyForPickup(widget.order.id);
        break;
      case OrderStatus.readyForPickup:
        context.read<OrdersCubit>().confirmHandover(widget.order.id);
        break;
      case OrderStatus.searchingDelivery:
      case OrderStatus.handoverPendingConfirmation:
      case OrderStatus.pickedUp:
      case OrderStatus.outForDelivery:
      case OrderStatus.delivered:
      case OrderStatus.cancelled:
      case OrderStatus.unknown:
        break;
    }
  }

  String _getSuccessMessage(OrderStatus status) {
    switch (status) {
      case OrderStatus.searchingDelivery:
        return 'start_cooking_success'.tr();
      case OrderStatus.readyForPickup:
        return 'ready_for_pickup_success'.tr();
      case OrderStatus.handoverPendingConfirmation:
        return 'confirm_handover_success'.tr();
      default:
        return 'order_action_success'.tr();
    }
  }
}
