import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/widgets/custom_button.dart';
import 'package:home_plate_vendor/core/utils/language_helper.dart';

class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({super.key});

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  // 0 for English, 1 for Arabic. Default is 0.
  int _selectedLanguageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'change_language_title'.tr(),
            style: AppStyles.inter20RegularBlack.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 24.h),
          _buildLanguageOption(index: 0, title: 'language_english'.tr(), subtitle: 'language_default_label'.tr()),
          SizedBox(height: 16.h),
          _buildLanguageOption(index: 1, title: 'language_arabic'.tr(), subtitle: 'language_default_label'.tr()),
          SizedBox(height: 32.h),
          CustomElevatedButton(
            text: 'apply_button'.tr(),
            textStyle: AppStyles.inter16RegularWhite.copyWith(
              fontWeight: FontWeight.w600,
            ),
            backGroundColor: AppColors.primary,
            onButtonClicked: () async {
              final locale = _selectedLanguageIndex == 0
                  ? const Locale('en')
                  : const Locale('ar');
              await LanguageHelper.changeLanguage(context, locale);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required int index,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedLanguageIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLanguageIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[200]!,
            width: isSelected ? 1.5 : 1,
          ),
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.inter16MediumBlack.copyWith(
                      color: isSelected ? AppColors.primary : Colors.black,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey[300]!,
                  width: 1.5,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
