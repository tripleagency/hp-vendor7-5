import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/routes/navigation_helper.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/app_assets.dart';
import 'package:home_plate_vendor/core/widgets/custom_button.dart';
import 'package:home_plate_vendor/core/utils/language_helper.dart';
import 'package:home_plate_vendor/features/on_boarding/presentation/introduction_screen.dart';
import 'package:home_plate_vendor/core/di/di.dart';
import 'package:home_plate_vendor/core/cache/cache_helper.dart';
import 'package:home_plate_vendor/core/utils/constants.dart';
import 'package:home_plate_vendor/core/routes/routes.dart';
import 'package:home_plate_vendor/core/routes/app_router.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  /// Guard: if onboarding is already completed, redirect immediately.
  /// This prevents the language selection screen from showing when
  /// the navigator pops back to the root route '/'.
  void _checkOnboardingStatus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cacheHelper = sl<CacheHelper>();
      final bool onboardingCompleted =
          cacheHelper.getData(key: AppConstants.onboardingKey) ?? false;

      if (onboardingCompleted) {
        final String? token =
            cacheHelper.getData(key: AppConstants.accessTokenKey);
        final String route =
            (token != null && token.isNotEmpty) ? Routes.home : Routes.login;
        AppRouter.navigateAndRemoveUntil(context, route);
      }
    });
  }

  Future<void> _changeLanguage(BuildContext context, Locale locale) async {
    await LanguageHelper.changeLanguage(context, locale);
    // Navigate after language is set
    if (context.mounted) {
      context.slideReplace(const OnboardingScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              SvgPicture.asset(
                AppAssets.logo,
                height: 100.h,
                width: 100.w,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              const Spacer(),
              Text(
                'choose_language_title'.tr(),
                style: AppStyles.inter18RegularBlack.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 24.h),
              CustomElevatedButton(
                text: 'language_english'.tr(),
                backGroundColor: AppColors.primary,
                textStyle: AppStyles.inter20Regularwhite,
                onButtonClicked: () {
                  _changeLanguage(context, const Locale('en'));
                },
              ),
              SizedBox(height: 16.h),
              CustomElevatedButton(
                text: 'language_arabic'.tr(),
                backGroundColor: AppColors.primary,
                textStyle: AppStyles.inter20Regularwhite,
                onButtonClicked: () {
                  _changeLanguage(context, const Locale('ar'));
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
