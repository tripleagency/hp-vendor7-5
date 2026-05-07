import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/presentation/manager/profile_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/toast_helper.dart';
import 'package:home_plate_vendor/core/utils/app_assets.dart';
import 'package:home_plate_vendor/core/widgets/custom_button.dart';
import 'package:home_plate_vendor/core/routes/navigation_helper.dart';
import 'package:home_plate_vendor/features/auth/presentation/manager/verify_registration_cubit/verify_registration_cubit.dart';
import 'package:home_plate_vendor/features/auth/presentation/manager/verify_registration_cubit/verify_registration_state.dart';
import 'package:home_plate_vendor/features/home_screen/presentation/views/home_screen.dart';

class VerifyRegistrationScreen extends StatefulWidget {
  final String phone;
  const VerifyRegistrationScreen({super.key, required this.phone});

  @override
  State<VerifyRegistrationScreen> createState() =>
      _VerifyRegistrationScreenState();
}

class _VerifyRegistrationScreenState extends State<VerifyRegistrationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpDigitChanged(int index, String value) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _onVerify() {
    String otp = _controllers.map((c) => c.text).join();
    if (otp.length == 4) {
      context.read<VerifyRegistrationCubit>().verifyRegistration(
        phone: widget.phone,
        code: otp,
      );
    } else {
      ToastHelper.showError(context, 'error_invalid_otp'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyRegistrationCubit, VerifyRegistrationState>(
      listener: (context, state) {
        if (state is VerifyRegistrationFailure) {
          ToastHelper.showError(context, state.message);
        } else if (state is VerifyRegistrationSuccess) {
          // Update profile cubit with vendor info
          context.read<ProfileCubit>().updateFromVendor(state.response.vendor);

          // Navigate to Home
          context.slideReplace(const HomeScreen());
          ToastHelper.showSuccess(context, state.response.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          size: 30.sp,
                          color: AppColors.black,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      SvgPicture.asset(
                        AppAssets.logo,
                        height: 67.h,
                        width: 102.w,
                      ),
                      const Spacer(),
                      SizedBox(width: 40.w),
                    ],
                  ),
                  SizedBox(height: 60.h),
                  Text(
                    'enter_code_title'.tr(),
                    style: AppStyles.inter30Regular,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'otp_sent_whatsapp'.tr(),
                    style: AppStyles.inter16Regular.copyWith(
                      color: AppColors.gray,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        width: 60.w,
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: AppStyles.inter30Regular,
                          decoration: InputDecoration(
                            counterText: "",
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 16.h,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: const BorderSide(
                                color: AppColors.gray,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) =>
                              _onOtpDigitChanged(index, value),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 32.h),
                  BlocBuilder<VerifyRegistrationCubit, VerifyRegistrationState>(
                    builder: (context, state) {
                      return CustomElevatedButton(
                        text: 'verify_button'.tr(),
                        backGroundColor: AppColors.primary,
                        textStyle: AppStyles.inter20Regularwhite,
                        isLoading: state is VerifyRegistrationLoading,
                        onButtonClicked: _onVerify,
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implement resend code if API supports it
                      },
                      child: Text(
                        'resend_code_button'.tr(),
                        style: AppStyles.inter16Regular.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
