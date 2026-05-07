import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/utils/app_assets.dart';

class MyEmptyStateRecipes extends StatelessWidget {
  const MyEmptyStateRecipes();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.emptyFood,
            width: 300.w,
            height: 300.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 16.h),
          Text(
            'empty_state'.tr(),
            style: AppStyles.inter26Regular.copyWith(color: Colors.black),
          ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}
