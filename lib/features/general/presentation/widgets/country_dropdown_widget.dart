import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/features/general/domain/entities/country_entity.dart';

/// Reusable country dropdown that fetches display name based on current locale.
class CountryDropdownWidget extends StatelessWidget {
  final List<CountryEntity> countries;
  final CountryEntity? selectedCountry;
  final bool isLoading;
  final void Function(CountryEntity?) onChanged;
  final String? Function(CountryEntity?)? validator;

  const CountryDropdownWidget({
    super.key,
    required this.countries,
    required this.onChanged,
    this.selectedCountry,
    this.isLoading = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = context.locale.languageCode == 'ar';

    return DropdownButtonFormField<CountryEntity>(
      value: selectedCountry,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: isLoading ? 'loading'.tr() : 'select_country'.tr(),
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
      items: countries.map((country) {
        final name = isRtl ? country.nameAr : country.nameEn;
        return DropdownMenuItem<CountryEntity>(
          value: country,
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
