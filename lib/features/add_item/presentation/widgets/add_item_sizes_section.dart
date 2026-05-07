import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/widgets/widgets.dart';

class SizeRow {
  final TextEditingController sizeController;
  final TextEditingController priceController;

  SizeRow()
      : sizeController = TextEditingController(),
        priceController = TextEditingController();

  void dispose() {
    sizeController.dispose();
    priceController.dispose();
  }
}

class AddItemSizesSection extends StatelessWidget {
  final List<SizeRow> rows;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;
  final Map<String, dynamic>? errors;
  final bool showHeader;

  const AddItemSizesSection({
    super.key,
    required this.rows,
    required this.onAdd,
    required this.onRemove,
    this.errors,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'sizes_section_title'.tr(),
                style: AppStyles.inter16MediumBlack.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
              TextButton.icon(
                onPressed: onAdd,
                icon: Icon(Icons.add, size: 18.sp, color: AppColors.primary),
                label: Text(
                  'add_size_button'.tr(),
                  style: AppStyles.inter16MediumBlack.copyWith(
                    color: AppColors.primary,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'sizes_hint'.tr(),
            style: AppStyles.inter16MediumBlack.copyWith(
              fontSize: 11.sp,
              color: AppColors.textLight,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        if (rows.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              'sizes_empty'.tr(),
              style: AppStyles.inter16MediumBlack.copyWith(
                fontSize: 12.sp,
                color: AppColors.textLight,
              ),
            ),
          ),
        ...List.generate(rows.length, (index) {
          final row = rows[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CustomTextField(
                    hintText: 'size_label_hint'.tr(),
                    controller: row.sizeController,
                    errorText: errors?['sizes.$index.size']?.toString(),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'error_field_required_name'.tr(
                          namedArgs: {'fieldName': 'size_label_hint'.tr()},
                        );
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  flex: 2,
                  child: CustomTextField(
                    hintText: '0.00',
                    keyBoardType: TextInputType.number,
                    controller: row.priceController,
                    errorText: errors?['sizes.$index.price']?.toString(),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return null;
                      if (double.tryParse(val) == null) {
                        return 'error_invalid_number'.tr();
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                  onPressed: () => onRemove(index),
                  icon: Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                    size: 22.sp,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
