import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'terms_conditions_title'.tr(),
          style: AppStyles.inter18MediumBlack.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header card ────────────────────────────────────────
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.85),
                  ],
                ),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.gavel_rounded,
                      color: AppColors.white,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'terms_header_title'.tr(),
                          style: AppStyles.inter16MediumBlack.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'terms_last_updated'.tr(),
                          style: AppStyles.inter12Regular.copyWith(
                            color: AppColors.white.withValues(alpha: 0.85),
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // ── Sections ───────────────────────────────────────────
            _Section(
              icon: Icons.handshake_outlined,
              title: 'terms_section_acceptance_title'.tr(),
              body: 'terms_section_acceptance_body'.tr(),
            ),
            _Section(
              icon: Icons.storefront_outlined,
              title: 'terms_section_vendor_title'.tr(),
              body: 'terms_section_vendor_body'.tr(),
            ),
            _Section(
              icon: Icons.restaurant_menu_outlined,
              title: 'terms_section_orders_title'.tr(),
              body: 'terms_section_orders_body'.tr(),
            ),
            _Section(
              icon: Icons.account_balance_wallet_outlined,
              title: 'terms_section_payments_title'.tr(),
              body: 'terms_section_payments_body'.tr(),
            ),
            _Section(
              icon: Icons.lock_outline_rounded,
              title: 'terms_section_privacy_title'.tr(),
              body: 'terms_section_privacy_body'.tr(),
            ),
            _Section(
              icon: Icons.report_gmailerrorred_outlined,
              title: 'terms_section_termination_title'.tr(),
              body: 'terms_section_termination_body'.tr(),
            ),

            // ── Contact card ───────────────────────────────────────
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  Icon(Icons.support_agent_rounded,
                      color: AppColors.primary, size: 22.sp),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'terms_contact_title'.tr(),
                          style: AppStyles.inter14Regular.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'terms_contact_body'.tr(),
                          style: AppStyles.inter12Regular.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _Section({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: AppColors.primary, size: 18.sp),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.inter14Regular.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            body,
            style: AppStyles.inter14Regular.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
