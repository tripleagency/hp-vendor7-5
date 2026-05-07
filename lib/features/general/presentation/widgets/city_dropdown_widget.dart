import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/city_entity.dart';

/// Reusable city dropdown that fetches display name based on current locale.
/// Pass [cities] from [GeneralCubit] state, [isLoading] while data is loading,
/// and handle selection via [onChanged].
class CityDropdownWidget extends StatelessWidget {
  final List<CityEntity> cities;
  final CityEntity? selectedCity;
  final bool isLoading;
  final void Function(CityEntity?) onChanged;
  final String? Function(CityEntity?)? validator;

  const CityDropdownWidget({
    super.key,
    required this.cities,
    required this.onChanged,
    this.selectedCity,
    this.isLoading = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = context.locale.languageCode == 'ar';

    return DropdownButtonFormField<CityEntity>(
      value: selectedCity,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: isLoading ? 'loading'.tr() : 'select_city'.tr(),
        hintStyle: AppStyles.inter14Regular.copyWith(color: AppColors.gray),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.gray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.gray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        // Show a spinner inside the field while loading
        suffixIcon: isLoading
            ? Padding(
                padding: EdgeInsets.all(12.w),
                child: SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              )
            : null,
      ),
      items: cities.map((city) {
        final name = isRtl ? city.nameAr : city.nameEn;
        return DropdownMenuItem<CityEntity>(
          value: city,
          child: Text(
            name,
            style: AppStyles.inter14Regular,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: isLoading ? null : onChanged,
      validator: validator,
      style: AppStyles.inter14Regular,
      icon: isLoading
          ? const SizedBox.shrink()
          : Icon(Icons.keyboard_arrow_down, color: AppColors.gray, size: 24.sp),
    );
  }
}
