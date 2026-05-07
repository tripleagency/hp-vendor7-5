import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/data/models/food_item.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem item;
  final ValueChanged<bool> onToggle;

  const FoodItemCard({super.key, required this.item, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              item.imagePath,
              width: 150.w,
              height: 100.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 150.w,
                height: 100.h,
                color: Colors.grey[300],
                child: Icon(Icons.fastfood, color: Colors.grey[500]),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: AppStyles.inter16MediumBlack),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      item.price,
                      style: AppStyles.inter14MediumPrimary.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '  EGP',
                      style: AppStyles.inter12semiBoldBlack.copyWith(
                        color: const Color(0xFF1BAC4B),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    // Edit Button
                    InkWell(
                      onTap: () {
                        // Edit action
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1BAC4B), // Green color
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'edit_button'.tr(),
                          style: AppStyles.inter12semiBoldBlack.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Toggle
                    Text(
                      item.isPublished ? 'publish_label'.tr() : 'pause_label'.tr(),
                      style: AppStyles.inter12Regular.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Switch(
                      value: item.isPublished,
                      onChanged: onToggle,
                      activeColor: const Color(0xFF1BAC4B),
                      activeTrackColor: const Color(
                        0xFF1BAC4B,
                      ).withOpacity(0.2),
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey[300],
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
}
