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
import 'package:home_plate_vendor/core/utils/validators.dart';
import 'package:home_plate_vendor/core/widgets/custom_button.dart';
import 'package:home_plate_vendor/core/utils/toast_helper.dart';
import 'package:home_plate_vendor/core/widgets/custom_text_field.dart';
import 'package:home_plate_vendor/features/auth/presentation/manager/reset_password_cubit/reset_password_cubit.dart';
import 'package:home_plate_vendor/features/auth/presentation/manager/reset_password_cubit/reset_password_state.dart';
import 'package:home_plate_vendor/features/auth/presentation/pages/login/login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String phone;
  const ChangePasswordScreen({super.key, required this.phone});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ResetPasswordCubit>(),
      child: BlocListener<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            ToastHelper.showSuccess(context, state.message);
            context.slideFromBottom(const LoginScreen());
          } else if (state is ResetPasswordFailure) {
            ToastHelper.showError(context, state.message);
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
                        'change_password_title'.tr(),
                        style: AppStyles.inter30Regular,
                      ),
                      SizedBox(height: 32.h),
                      CustomTextField(
                        controller: _newPasswordController,
                        hintText: 'new_password_label'.tr(),
                        isPassword: true,
                        validator: (value) => Validators.password(value),
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        hintText: 'confirm_password_label'.tr(),
                        isPassword: true,
                        validator: (value) => Validators.confirmPassword(
                          value,
                          _newPasswordController.text,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                        builder: (context, state) {
                          return CustomElevatedButton(
                            text: 'next_button'.tr(),
                            backGroundColor: AppColors.primary,
                            textStyle: AppStyles.inter20Regularwhite,
                            isLoading: state is ResetPasswordLoading,
                            onButtonClicked: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                context
                                    .read<ResetPasswordCubit>()
                                    .resetPassword(
                                      phone: widget.phone,
                                      password: _newPasswordController.text,
                                      passwordConfirmation:
                                          _confirmPasswordController.text,
                                    );
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
