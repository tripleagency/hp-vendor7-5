import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/app_assets.dart';
import 'package:home_plate_vendor/core/widgets/custom_button.dart';

enum VerificationStatus { none, success, failure }

class DeliveryVerificationView extends StatefulWidget {
  final VoidCallback onDone;

  const DeliveryVerificationView({super.key, required this.onDone});

  @override
  State<DeliveryVerificationView> createState() =>
      _DeliveryVerificationViewState();
}

class _DeliveryVerificationViewState extends State<DeliveryVerificationView> {
  VerificationStatus _status = VerificationStatus.none;

  @override
  Widget build(BuildContext context) {
    if (_status == VerificationStatus.success) {
      return _buildResult(true);
    } else if (_status == VerificationStatus.failure) {
      return _buildResult(false);
    }

    return Column(
      children: [
        SizedBox(height: 24.h),
        CustomElevatedButton(
          height: 54.h,
          text: 'confirm_delivery_button'.tr(),
          backGroundColor: AppColors.orderDarkGreen,
          borderRadius: 12,
          textStyle: AppStyles.inter16RegularWhite.copyWith(
            fontWeight: FontWeight.w600,
          ),
          onButtonClicked: () {
            setState(() => _status = VerificationStatus.success);
          },
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _buildResult(bool isSuccess) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Image.asset(
          isSuccess ? AppAssets.orderSuccess : AppAssets.orderFailed,
          width: 200.w,
          height: 200.h,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 24.h),
        Text(
          isSuccess
              ? 'verification_success'.tr()
              : 'code_not_recognized'.tr(),
          style: AppStyles.inter20RegularBlack.copyWith(
            fontWeight: FontWeight.w600,
            color: isSuccess
                ? AppColors.orderSuccessGreen
                : AppColors.orderRed,
          ),
        ),
        if (!isSuccess) ...[
          SizedBox(height: 8.h),
          Text(
            'failed_order_label'.tr(),
            style: AppStyles.inter16Regular.copyWith(color: Colors.grey),
          ),
        ],
        SizedBox(height: 30.h),
        if (isSuccess)
          CustomElevatedButton(
            height: 48,
            text: 'done_button'.tr(),
            backGroundColor: AppColors.orderDarkGreen,
            borderRadius: 12,
            textStyle: AppStyles.inter16RegularWhite,
            onButtonClicked: widget.onDone,
          )
        else
          CustomElevatedButton(
            height: 48,
            text: 'try_again_button'.tr(),
            backGroundColor: AppColors.orderRed,
            borderRadius: 12,
            textStyle: AppStyles.inter16RegularWhite,
            onButtonClicked: () {
              setState(() => _status = VerificationStatus.none);
            },
          ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
