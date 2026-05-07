import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';import 'package:easy_localization/easy_localization.dart';import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/widgets/custom_dropdown.dart';

class WorkingHoursRow extends StatefulWidget {
  final String day;
  final bool isSelected;
  final String? fromTime;
  final String? toTime;
  final List<String> times;
  final ValueChanged<bool?>? onCheckboxChanged;
  final ValueChanged<String?>? onFromChanged;
  final ValueChanged<String?>? onToChanged;

  const WorkingHoursRow({
    super.key,
    required this.day,
    this.isSelected = false,
    this.fromTime,
    this.toTime,
    required this.times,
    this.onCheckboxChanged,
    this.onFromChanged,
    this.onToChanged,
  });

  @override
  State<WorkingHoursRow> createState() => _WorkingHoursRowState();
}

class _WorkingHoursRowState extends State<WorkingHoursRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          // Checkbox
          SizedBox(
            width: 24.w,
            height: 24.h,
            child: Checkbox(
              value: widget.isSelected,
              onChanged: widget.onCheckboxChanged,
              activeColor: const Color(0xFFE59A53),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
              side: BorderSide(color: Colors.grey.shade400),
            ),
          ),
          SizedBox(width: 8.w),

          // Day Name
          Expanded(
            flex: 2,
            child: Container(
              height: 48.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Text(
                widget.day,
                style: AppStyles.inter14Regular.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),

          // From Time
          Expanded(
            flex: 2,
            child: widget.isSelected
                ? CustomDropdown<String>(
                    value: widget.fromTime,
                    hintText: 'from_time_label'.tr(),
                    borderRadius: 24.r,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 8.h,
                    ),
                    items: widget.times.map((time) {
                      return DropdownMenuItem(value: time, child: Text(time));
                    }).toList(),
                    onChanged: widget.onFromChanged,
                  )
                : _buildDisabledBox('from_time_label'.tr()),
          ),
          SizedBox(width: 8.w),

          // To Time
          Expanded(
            flex: 2,
            child:
                (widget.isSelected &&
                    widget.fromTime != null &&
                    widget.fromTime!.isNotEmpty)
                ? CustomDropdown<String>(
                    value: widget.toTime,
                    hintText: 'to_time_label'.tr(),
                    borderRadius: 24.r,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 8.h,
                    ),
                    items: widget.times.map((time) {
                      return DropdownMenuItem(value: time, child: Text(time));
                    }).toList(),
                    onChanged: widget.onToChanged,
                  )
                : _buildDisabledBox('to_time_label'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledBox(String text) {
    return Container(
      height: 48.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Text(
        text,
        style: AppStyles.inter14Regular.copyWith(color: Colors.grey.shade400),
      ),
    );
  }
}
