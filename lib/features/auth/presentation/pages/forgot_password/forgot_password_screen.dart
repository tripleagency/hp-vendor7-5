import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_plate_vendor/core/di/di.dart';
import 'package:home_plate_vendor/core/routes/navigation_helper.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/app_assets.dart';
import 'package:home_plate_vendor/core/utils/toast_helper.dart';
import 'package:home_plate_vendor/core/utils/validators.dart';
import 'package:home_plate_vendor/core/widgets/custom_button.dart';
import 'package:home_plate_vendor/core/widgets/custom_text_field.dart';
import 'package:home_plate_vendor/features/auth/presentation/manager/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:home_plate_vendor/features/auth/presentation/manager/forgot_password_cubit/forgot_password_state.dart';
import 'package:home_plate_vendor/features/auth/presentation/pages/forgot_password/otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ForgotPasswordCubit>(),
      child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            context.slideFromBottom(
              OtpVerificationScreen(phone: _phoneController.text),
            );
          } else if (state is ForgotPasswordFailure) {
            ToastHelper.showError(context, state.message.tr());
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
                child: Form(
                  key: _formKey,
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
                        'forgot_password_title'.tr(),
                        style: AppStyles.inter30Regular,
                      ),
                      SizedBox(height: 32.h),
                      CustomTextField(
                        controller: _phoneController,
                        hintText: 'phone_number_label'.tr(),
                        validator: Validators.phone,
                        keyBoardType: TextInputType.phone,
                      ),
                      SizedBox(height: 32.h),
                      BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                        builder: (context, state) {
                          return CustomElevatedButton(
                            text: 'next_button'.tr(),
                            backGroundColor: AppColors.primary,
                            textStyle: AppStyles.inter20Regularwhite,
                            isLoading: state is ForgotPasswordLoading,
                            onButtonClicked: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                context
                                    .read<ForgotPasswordCubit>()
                                    .forgotPassword(_phoneController.text);
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
