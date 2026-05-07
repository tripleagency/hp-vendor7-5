import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/routes/navigation_helper.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/presentation/pages/terms_and_conditions_screen.dart';

class CustomTermsConditionsCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  /// لو null → بيفتح TermsAndConditionsScreen تلقائياً
  final VoidCallback? onTermsTap;

  /// لو null → بيفتح TermsAndConditionsScreen تلقائياً (شاشة واحدة لأن الـ Privacy لسه مش متفصلة)
  final VoidCallback? onPrivacyTap;

  const CustomTermsConditionsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.onTermsTap,
    this.onPrivacyTap,
  });

  @override
  State<CustomTermsConditionsCheckbox> createState() =>
      _CustomTermsConditionsCheckboxState();
}

class _CustomTermsConditionsCheckboxState
    extends State<CustomTermsConditionsCheckbox> {
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  void _openTerms() {
    if (widget.onTermsTap != null) {
      widget.onTermsTap!();
    } else {
      context.slideTo(const TermsAndConditionsScreen());
    }
  }

  void _openPrivacy() {
    if (widget.onPrivacyTap != null) {
      widget.onPrivacyTap!();
    } else {
      context.slideTo(const TermsAndConditionsScreen());
    }
  }

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()..onTap = _openTerms;
    _privacyRecognizer = TapGestureRecognizer()..onTap = _openPrivacy;
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24.w,
          height: 24.h,
          child: Checkbox(
            value: widget.value,
            onChanged: widget.onChanged,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: 'terms_checkbox_prefix'.tr(),
              style: AppStyles.inter14Regular.copyWith(
                color: Colors.grey,
                fontSize: 12.sp,
              ),
              children: [
                TextSpan(
                  text: 'terms_conditions_link'.tr(),
                  style: AppStyles.inter12semiBoldBlack.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                  recognizer: _termsRecognizer,
                ),
                TextSpan(
                  text: 'terms_checkbox_and'.tr(),
                  style: AppStyles.inter14Regular.copyWith(
                    color: Colors.grey,
                    fontSize: 12.sp,
                  ),
                ),
                TextSpan(
                  text: 'privacy_policy_link'.tr(),
                  style: AppStyles.inter12semiBoldBlack.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                  recognizer: _privacyRecognizer,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
