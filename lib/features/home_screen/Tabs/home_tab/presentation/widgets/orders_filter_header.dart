import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:intl/intl.dart';

class OrdersFilterHeader extends StatefulWidget {
  const OrdersFilterHeader({super.key});

  @override
  State<OrdersFilterHeader> createState() => _OrdersFilterHeaderState();
}

class _OrdersFilterHeaderState extends State<OrdersFilterHeader> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    if (_selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day) {
      return 'today_label'.tr();
    }
    return DateFormat('dd/MM/yyyy').format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'orders_title'.tr(),
          style: AppStyles.inter20RegularBlack.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1B2A4B),
          ),
        ),
        InkWell(
          onTap: () => _selectDate(context),
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16.sp,
                  color: AppColors.textPrimary,
                ),
                SizedBox(width: 8.w),
                Text(
                  _getFormattedDate(),
                  style: AppStyles.inter14Regular.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 18.sp,
                  color: AppColors.textLight,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
