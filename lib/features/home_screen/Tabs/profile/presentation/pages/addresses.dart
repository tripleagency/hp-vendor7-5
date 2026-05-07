import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/routes/navigation_helper.dart';
import 'package:home_plate_vendor/core/temp_provider/address_provider.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/toast_helper.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/presentation/pages/add_adderss_screen.dart';
import 'package:provider/provider.dart';

class Addresses extends StatelessWidget {
  const Addresses({super.key});

  Future<void> _onAddNewAddress(BuildContext context) async {
    try {
      final newAddress = await context.slideTo<Map<String, String>>(
        const AddAdderssScreen(),
      );

      if (newAddress != null && context.mounted) {
        context.read<AddressProvider>().addAddress(newAddress);
      }
    } catch (e) {
      if (context.mounted) {
        ToastHelper.showError(context, 'add_address_error'.tr());
      }
    }
  }

  Future<void> _onEditAddress(
    BuildContext context,
    int index,
    Map<String, String> existing,
  ) async {
    final result = await context.slideTo<Map<String, String>>(
      AddAdderssScreen(existingAddress: existing, index: index),
    );

    if (result != null && context.mounted) {
      context.read<AddressProvider>().updateAddress(index, result);
    }
  }

  void _onDeleteAddress(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: AppColors.error, size: 22.sp),
            SizedBox(width: 8.w),
            Text(
              'delete_address_title'.tr(),
              style: AppStyles.inter16MediumBlack.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Text(
          'delete_address_message'.tr(),
          style: AppStyles.inter14Regular.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'cancel_button'.tr(),
              style: AppStyles.inter14Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AddressProvider>().removeAddress(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'delete_button'.tr(),
              style: AppStyles.inter14Regular.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final addresses = context.watch<AddressProvider>().addresses;
    final isEmpty = addresses.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'address_title'.tr(),
          style: AppStyles.inter18MediumBlack.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isEmpty
          ? _buildEmptyState(context)
          : _buildList(context, addresses),
      floatingActionButton: isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _onAddNewAddress(context),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add, color: AppColors.white),
              label: Text(
                'add_address_button'.tr(),
                style: AppStyles.inter14Regular.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  // ============================================================
  //                       Empty State
  // ============================================================

  Widget _buildEmptyState(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        children: [
          SizedBox(height: 32.h),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 130.w,
                height: 130.h,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 95.w,
                height: 95.h,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 68.w,
                height: 68.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  size: 32.sp,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Text(
            'address_empty_title'.tr(),
            style: AppStyles.inter18MediumBlack.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 17.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'address_empty_subtitle'.tr(),
            style: AppStyles.inter14Regular.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
              fontSize: 13.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _onAddNewAddress(context),
              icon: const Icon(Icons.add_location_alt_outlined,
                  color: AppColors.white),
              label: Text(
                'add_address_button'.tr(),
                style: AppStyles.inter14Regular.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    size: 18.sp, color: AppColors.primary),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    'address_help_hint'.tr(),
                    style: AppStyles.inter12Regular.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  //                       List
  // ============================================================

  Widget _buildList(
    BuildContext context,
    List<Map<String, String>> addresses,
  ) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
      itemCount: addresses.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return _AddressCard(
          address: addresses[index],
          onEdit: () => _onEditAddress(context, index, addresses[index]),
          onDelete: () => _onDeleteAddress(context, index),
        );
      },
    );
  }
}

// ============================================================
//                       Address Card
// ============================================================

class _AddressCard extends StatelessWidget {
  final Map<String, String> address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AddressCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
  });

  bool _isArabic(String text) {
    final arabic = RegExp(r'[\u0600-\u06FF]');
    return arabic.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    final title = address['title'] ?? '';
    final addressText = address['address'] ?? '';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 8.w, 8.h),
            child: Row(
              children: [
                Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.bookmark_rounded,
                    size: 18.sp,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    title,
                    style: AppStyles.inter16MediumBlack.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: AppColors.divider),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16.sp,
                  color: AppColors.textLight,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Directionality(
                    textDirection: _isArabic(addressText)
                        ? ui.TextDirection.rtl
                        : ui.TextDirection.ltr,
                    child: Text(
                      addressText,
                      style: AppStyles.inter14Regular.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                        fontSize: 13.sp,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: AppColors.divider),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onEdit,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(14.r),
                bottomRight: Radius.circular(14.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_outlined,
                        size: 14.sp, color: AppColors.primary),
                    SizedBox(width: 6.w),
                    Text(
                      'edit_button'.tr(),
                      style: AppStyles.inter14Regular.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
