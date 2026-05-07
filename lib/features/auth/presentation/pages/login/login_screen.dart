import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/di/di.dart';
import 'package:home_plate_vendor/core/routes/navigation_helper.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/app_assets.dart';
import 'package:home_plate_vendor/core/utils/validators.dart';
import 'package:home_plate_vendor/core/widgets/custom_button.dart';
import 'package:home_plate_vendor/core/widgets/custom_text_field.dart';
import 'package:home_plate_vendor/features/auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:home_plate_vendor/features/auth/presentation/pages/forgot_password/forgot_password_screen.dart';
import 'package:home_plate_vendor/features/auth/presentation/pages/register/registration_step1_user_info_screen.dart';
import 'package:home_plate_vendor/features/home_screen/presentation/views/home_screen.dart';
import 'package:home_plate_vendor/features/auth/presentation/manager/login_cubit/login_cubit.dart';
import 'package:home_plate_vendor/core/utils/toast_helper.dart';
import 'package:provider/provider.dart' as provider;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginCubit>(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            // Navigate to Home
            context.slideReplace(const HomeScreen());
            ToastHelper.showSuccess(context, state.response.message);
          } else if (state is LoginFailure) {
            ToastHelper.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is LoginLoading;
          return Scaffold(
            backgroundColor: AppColors.white,
            resizeToAvoidBottomInset: true,
            body: Stack(
              children: [
                // Decorative top blob
                Positioned(
                  top: -80.h,
                  right: -60.w,
                  child: Container(
                    width: 240.w,
                    height: 240.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.10),
                    ),
                  ),
                ),
                Positioned(
                  top: 40.h,
                  left: -40.w,
                  child: Container(
                    width: 140.w,
                    height: 140.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.06),
                    ),
                  ),
                ),

                SafeArea(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 32.h),

                          // ── Brand header ───────────────────────────────
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.15),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: SvgPicture.asset(
                                AppAssets.logo,
                                height: 60.h,
                                width: 90.w,
                              ),
                            ),
                          ),
                          SizedBox(height: 40.h),

                          // ── Welcome text ───────────────────────────────
                          Text(
                            'login_title'.tr(),
                            style: AppStyles.inter30Regular.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'login_subtitle'.tr(),
                            style: AppStyles.inter14Regular.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 32.h),

                          // ── Phone field ────────────────────────────────
                          Padding(
                            padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
                            child: Text(
                              'phone_number_label'.tr(),
                              style: AppStyles.inter14Regular.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          CustomTextField(
                            controller: _phoneController,
                            hintText: 'phone_number_label'.tr(),
                            validator: Validators.phone,
                            keyBoardType: TextInputType.phone,
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              color: AppColors.primary,
                              size: 22.sp,
                            ),
                          ),
                          SizedBox(height: 18.h),

                          // ── Password field ─────────────────────────────
                          Padding(
                            padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
                            child: Text(
                              'password_label'.tr(),
                              style: AppStyles.inter14Regular.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          CustomTextField(
                            controller: _passwordController,
                            validator: Validators.password,
                            hintText: 'password_label'.tr(),
                            isPassword: true,
                            prefixIcon: Icon(
                              Icons.lock_outline_rounded,
                              color: AppColors.primary,
                              size: 22.sp,
                            ),
                          ),
                          SizedBox(height: 12.h),

                          // ── Forgot password (right-aligned) ────────────
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8.r),
                              onTap: () {
                                context.slideFromBottom(
                                  const ForgotPasswordScreen(),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 6.h,
                                ),
                                child: Text(
                                  'forgot_password_link'.tr(),
                                  style: AppStyles.inter14Regular.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),

                          // ── Login button ───────────────────────────────
                          CustomElevatedButton(
                            text: isLoading ? '' : 'login_button'.tr(),
                            backGroundColor: AppColors.primary,
                            textStyle: AppStyles.inter20Regularwhite,
                            isLoading: isLoading,
                            onButtonClicked: isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      context.read<LoginCubit>().login(
                                        phone: _phoneController.text,
                                        password: _passwordController.text,
                                      );
                                    }
                                  },
                          ),
                          SizedBox(height: 32.h),

                          // ── Divider ────────────────────────────────────
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey[300],
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                child: Text(
                                  'or_text'.tr(),
                                  style: AppStyles.inter12Regular.copyWith(
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey[300],
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),

                          // ── Sign up CTA ────────────────────────────────
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                context.slideFromBottom(
                                  BlocProvider(
                                    create: (_) => sl<RegisterCubit>(),
                                    child:
                                        const RegistrationStep1UserInfoScreen(),
                                  ),
                                );
                              },
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: AppStyles.inter14Regular.copyWith(
                                    color: Colors.grey[700],
                                  ),
                                  children: [
                                    TextSpan(text: 'no_account_text'.tr()),
                                    const TextSpan(text: '  '),
                                    TextSpan(
                                      text: 'create_account_button'.tr(),
                                      style: AppStyles.inter14Regular.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
