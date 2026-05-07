import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/routes/navigation_helper.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/app_assets.dart';
import 'package:home_plate_vendor/core/widgets/custom_button.dart';
import 'package:home_plate_vendor/features/auth/presentation/pages/login/login_screen.dart';
import 'package:home_plate_vendor/core/di/di.dart';
import 'package:home_plate_vendor/core/cache/cache_helper.dart';
import 'package:home_plate_vendor/core/utils/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      image: AppAssets.intro1,
      title: 'onboarding_title_1'.tr(),
      subtitle: 'onboarding_desc_1'.tr(),
      height: 226.h,
      width: 296.w,
    ),
    OnboardingContent(
      image: AppAssets.intro2,
      title: 'onboarding_title_2'.tr(),
      subtitle: 'onboarding_desc_2'.tr(),
      height: 307.h,
      width: 307.w,
    ),
    OnboardingContent(
      image: AppAssets.intro3,
      title: 'onboarding_title_3'.tr(),
      subtitle: 'onboarding_desc_3'.tr(),
      height: 226.h,
      width: 246.w,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPress() {
    if (_currentPage == _contents.length - 1) {
      _completeOnboarding();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onSkip() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    sl<CacheHelper>().saveData(key: AppConstants.onboardingKey, value: true);
    context.slideReplace(const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 60.h),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _contents.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _buildPage(_contents[index]);
                  },
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30,
            color: _currentPage == 0
                ? Colors.transparent
                : AppColors.backgroundDark,
          ),
          onPressed: _currentPage == 0
              ? null
              : () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
        ),
        TextButton(
          onPressed: _onSkip,
          child: Text('skip'.tr(), style: AppStyles.inter18RegularBlack),
        ),
      ],
    );
  }

  Widget _buildPage(OnboardingContent content) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          content.image,
          fit: BoxFit.contain,
          height: content.height ?? 305.h,
          width: content.width ?? 387.w,
        ),
        SizedBox(height: 48.h),
        Text(
          content.title,
          style: AppStyles.inter26Regular,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Text(
          content.subtitle,
          style: AppStyles.inter20Regular,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        SmoothPageIndicator(
          controller: _pageController,
          count: _contents.length,
          effect: ExpandingDotsEffect(
            expansionFactor: 3,
            dotHeight: 8.h,
            dotWidth: 8.w,
            spacing: 4.w,
            radius: 4.r,
            activeDotColor: AppColors.primary,
            dotColor: AppColors.divider,
          ),
        ),
        SizedBox(height: 24.h),
        CustomElevatedButton(
          text: _currentPage == _contents.length - 1
              ? 'get_started'.tr()
              : 'next'.tr(),
          backGroundColor: AppColors.primary,
          textStyle: AppStyles.inter20Regularwhite,
          onButtonClicked: _onNextPress,
        ),
        SizedBox(height: 48.h),
      ],
    );
  }
}

class OnboardingContent {
  final String image;
  final String title;
  final String subtitle;

  final double? height;
  final double? width;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.subtitle,
    this.height,
    this.width,
  });
}
