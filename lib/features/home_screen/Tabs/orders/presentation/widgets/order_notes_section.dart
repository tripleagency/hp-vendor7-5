import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';

class OrderNotesSection extends StatelessWidget {
  final String notes;

  const OrderNotesSection({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.statusNewBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.notesBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.note_outlined,
              size: 16.sp, color: AppColors.orderAmber),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              notes,
              style: AppStyles.inter12Regular.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
