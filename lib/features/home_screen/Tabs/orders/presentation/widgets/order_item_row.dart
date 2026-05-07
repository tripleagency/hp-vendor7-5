import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/config/app_config.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/entities/order_item_entity.dart';

class OrderItemRow extends StatelessWidget {
  final OrderItemEntity item;

  const OrderItemRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.itemThumbnailUrl != null
        ? '${AppConfig.baseUrl}/storage/${item.itemThumbnailUrl}'
        : null;

    return Container(
      height: 88.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 100.w,
                    height: 75.h,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _imagePlaceholder(),
                    errorWidget: (_, __, ___) => _imageError(),
                    errorListener: (_) {},
                  )
                : _imageError(),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.itemName,
                  style: AppStyles.inter16MediumBlack,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'items_count'.tr(
                        namedArgs: {'count': item.quantity},
                      ),
                      style: AppStyles.inter12Regular.copyWith(
                        color: AppColors.gray,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${item.lineTotal} ',
                            style: AppStyles.inter14MediumPrimary.copyWith(
                              color: AppColors.orderOrange,
                            ),
                          ),
                          TextSpan(
                            text: 'currency_egp'.tr(),
                            style: AppStyles.inter12Regular.copyWith(
                              color: AppColors.orderDarkGreen,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 100.w,
      height: 75.h,
      color: Colors.grey[200],
      child: Center(
        child: SizedBox(
          width: 20.w,
          height: 20.h,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.orderGreen,
          ),
        ),
      ),
    );
  }

  Widget _imageError() {
    return Container(
      width: 100.w,
      height: 75.h,
      color: Colors.grey[100],
      child: Icon(
        Icons.fastfood_outlined,
        color: Colors.grey[300],
        size: 24.sp,
      ),
    );
  }
}
