import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/routes/navigation_helper.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/app_assets.dart';
import 'package:home_plate_vendor/core/utils/validators.dart';
import 'package:home_plate_vendor/core/widgets/custom_button.dart';
import 'package:home_plate_vendor/core/widgets/custom_text_field.dart';
import 'package:home_plate_vendor/core/widgets/custom_image_upload.dart';
import 'package:home_plate_vendor/core/widgets/custom_terms_conditions_checkbox.dart';
import 'package:home_plate_vendor/core/utils/toast_helper.dart';
import 'package:home_plate_vendor/features/auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:home_plate_vendor/features/auth/presentation/pages/restaurant_info/registration_step2_restaurant_info_screen.dart';

class RegistrationStep1UserInfoScreen extends StatefulWidget {
  const RegistrationStep1UserInfoScreen({super.key});

  @override
  State<RegistrationStep1UserInfoScreen> createState() =>
      _RegistrationStep1UserInfoScreenState();
}

class _RegistrationStep1UserInfoScreenState
    extends State<RegistrationStep1UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _phoneController;

  bool _isAgreed = false;
  File? _idFront;
  File? _idBack;

  @override
  void initState() {
    super.initState();
    // Pre-fill from cubit (preserves data on back navigation)
    final data = context.read<RegisterCubit>().formData;
    _nameController = TextEditingController(text: data.fullName);
    _emailController = TextEditingController(text: data.email);
    _passwordController = TextEditingController(text: data.password);
    _phoneController = TextEditingController(text: data.phone);
    _idFront = data.idFront;
    _idBack = data.idBack;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_idFront == null || _idBack == null) {
      ToastHelper.showError(context, 'error_upload_id_photos'.tr());
      return;
    }

    // Save step 1 data to cubit (no API call)
    context.read<RegisterCubit>().saveStep1(
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      idFront: _idFront!,
      idBack: _idBack!,
    );

    // Navigate to step 2 (passing the existing cubit instance via BlocProvider.value)
    context.slideFromBottom(
      BlocProvider.value(
        value: context.read<RegisterCubit>(),
        child: const RegistrationStep2RestaurantInfoScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: SvgPicture.asset(
          AppAssets.logo,
          height: 36.h,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),

                // ── Step indicator ──────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Container(
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  'step_1_of_2'.tr(),
                  style: AppStyles.inter12Regular.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 18.h),

                // ── Title ──────────────────────────────────────────────
                Text(
                  'create_account_title'.tr(),
                  style: AppStyles.inter30Regular.copyWith(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'create_account_subtitle'.tr(),
                  style: AppStyles.inter14Regular.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 28.h),

                // ── Personal Info Section ──────────────────────────────
                _SectionHeader(
                  icon: Icons.person_outline_rounded,
                  title: 'section_personal_info'.tr(),
                ),
                SizedBox(height: 12.h),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'full_name_label'.tr(),
                  keyBoardType: TextInputType.name,
                  validator: Validators.name,
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: AppColors.primary,
                    size: 22.sp,
                  ),
                ),
                SizedBox(height: 14.h),
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
                SizedBox(height: 14.h),
                CustomTextField(
                  controller: _emailController,
                  validator: Validators.email,
                  hintText: 'email_optional_label'.tr(),
                  keyBoardType: TextInputType.emailAddress,
                  prefixIcon: Icon(
                    Icons.mail_outline,
                    color: AppColors.primary,
                    size: 22.sp,
                  ),
                ),
                SizedBox(height: 14.h),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'password_label'.tr(),
                  validator: Validators.password,
                  isPassword: true,
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.primary,
                    size: 22.sp,
                  ),
                ),
                SizedBox(height: 28.h),

                // ── ID Upload Section ──────────────────────────────────
                _SectionHeader(
                  icon: Icons.badge_outlined,
                  title: 'section_id_verification'.tr(),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomImageUpload(
                        text: 'upload_id_front'.tr(),
                        height: 100.h,
                        width: double.infinity,
                        file: _idFront,
                        onImageSelected: (file) {
                          setState(() => _idFront = file);
                        },
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomImageUpload(
                        text: 'upload_id_back'.tr(),
                        height: 100.h,
                        width: double.infinity,
                        file: _idBack,
                        onImageSelected: (file) {
                          setState(() => _idBack = file);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // ── Terms ──────────────────────────────────────────────
                CustomTermsConditionsCheckbox(
                  value: _isAgreed,
                  onChanged: (value) {
                    setState(() {
                      _isAgreed = value ?? false;
                    });
                  },
                ),
                SizedBox(height: 32.h),

                // ── Next Button ────────────────────────────────────────
                BlocBuilder<RegisterCubit, RegisterState>(
                  builder: (context, state) {
                    return CustomElevatedButton(
                      text: 'next_to_restaurant_info'.tr(),
                      backGroundColor: _isAgreed
                          ? AppColors.primary
                          : Colors.grey[400],
                      textStyle: AppStyles.inter20Regularwhite,
                      onButtonClicked: _isAgreed ? _onNext : null,
                    );
                  },
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Reusable section header — icon + title used to group form sections.
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18.sp),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: AppStyles.inter16Regular.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
