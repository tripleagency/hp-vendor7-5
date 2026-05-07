import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/entities/order_entity.dart';

class OrderTotalSection extends StatelessWidget {
  final OrderEntity order;

  const OrderTotalSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الجزء العلوي: تفاصيل الفاتورة
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
            child: Column(
              children: [
                _buildRow(
                  'order_cost_label'.tr(),
                  '${order.orderCost} ${'currency_egp'.tr()}',
                ),
                SizedBox(height: 8.h),
                _buildRow(
                  'delivery_fee_label'.tr(),
                  '${order.deliveryFee} ${'currency_egp'.tr()}',
                ),
              ],
            ),
          ),
          // Divider
          Container(
            height: 1,
            margin: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.divider,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
            ),
          ),
          // المبلغ الكلي
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'total_amount_label'.tr(),
                  style: AppStyles.inter14Regular.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${order.totalAmount} ',
                        style: AppStyles.inter16MediumBlack.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                      ),
                      TextSpan(
                        text: 'currency_egp'.tr(),
                        style: AppStyles.inter12Regular.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // طريقة الدفع + حالة الدفع
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 12.h),
            child: Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_paymentIcon(order.paymentMethod),
                          size: 12.sp, color: AppColors.textSecondary),
                      SizedBox(width: 4.w),
                      Text(
                        _formatPaymentMethod(order.paymentMethod),
                        style: AppStyles.inter12Regular.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                _buildPaymentStatusBadge(order.paymentStatus),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppStyles.inter12Regular.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12.sp,
          ),
        ),
        Text(
          value,
          style: AppStyles.inter12Regular.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentStatusBadge(String status) {
    final isPaid = status == 'paid';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isPaid ? AppColors.statusPaidBg : AppColors.statusUnpaidBg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              color:
                  isPaid ? AppColors.orderSuccessGreen : AppColors.orderAmber,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            isPaid ? 'paid_label'.tr() : 'unpaid_label'.tr(),
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: isPaid
                  ? AppColors.orderSuccessGreen
                  : AppColors.orderAmber,
            ),
          ),
        ],
      ),
    );
  }

  IconData _paymentIcon(String method) {
    switch (method.toLowerCase()) {
      case 'instapay':
        return Icons.account_balance_wallet_outlined;
      case 'cash':
        return Icons.payments_outlined;
      case 'card':
      case 'visa':
      case 'mastercard':
        return Icons.credit_card_outlined;
      default:
        return Icons.payment;
    }
  }

  String _formatPaymentMethod(String method) {
    switch (method.toLowerCase()) {
      case 'instapay':
        return 'payment_instapay'.tr();
      case 'cash':
        return 'payment_cash'.tr();
      case 'card':
        return 'payment_card'.tr();
      default:
        return method;
    }
  }
}
