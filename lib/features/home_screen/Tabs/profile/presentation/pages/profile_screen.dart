import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/routes/navigation_helper.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/presentation/manager/profile_cubit.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/widgets/custom_button.dart';
import 'package:home_plate_vendor/features/auth/presentation/pages/login/login_screen.dart';
import 'package:home_plate_vendor/features/addresses/presentation/pages/addresses_list_screen.dart';
import 'package:home_plate_vendor/features/sub_categories/presentation/pages/sub_categories_screen.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/presentation/pages/wallet_screen.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/presentation/pages/profile_edit_screen.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/presentation/pages/terms_and_conditions_screen.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/presentation/widgets/language_bottom_sheet.dart';
import 'package:home_plate_vendor/features/support/presentation/pages/support_screen.dart';
import 'package:home_plate_vendor/core/di/di.dart';
import 'package:home_plate_vendor/core/cache/cache_helper.dart';
import 'package:home_plate_vendor/core/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/vendor_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/presentation/widgets/profile_skeleton.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late ProfileCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ProfileCubit>();
  }

  void _fetchProfile() {
    final vendorId = sl<CacheHelper>().getData(key: 'vendor_id');
    if (vendorId != null) {
      final int id = vendorId is int
          ? vendorId
          : int.tryParse(vendorId.toString()) ?? 0;
      if (id > 0) {
        _cubit.getVendorProfile(id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state.status == ProfileStatus.failure) {
                final errorMsg = state.errorMessage ?? 'error_something_went_wrong';
                return _buildErrorState(errorMsg.tr());
              }
              if (state.status == ProfileStatus.loading ||
                  state.status == ProfileStatus.initial) {
                return const ProfileSkeleton();
              }
              if (state.status == ProfileStatus.success && state.vendor != null) {
                return _buildProfileContent(state.vendor!);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  // ── Profile content ────────────────────────────────────────────────────────
  Widget _buildProfileContent(VendorEntity vendor) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildHeaderCard(vendor),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                _buildSectionLabel('section_restaurant'.tr()),
                _buildGroupCard([
                  _MenuItem(
                    icon: Icons.category_outlined,
                    iconColor: const Color(0xffEF5350),
                    titleKey: 'sub_categories',
                    onTap: () => context.slideTo(const SubCategoriesScreen()),
                  ),
                  _MenuItem(
                    icon: Icons.location_on_outlined,
                    iconColor: const Color(0xff42A5F5),
                    titleKey: 'address_menu',
                    onTap: () => context.slideTo(const AddressesListScreen()),
                  ),
                ]),
                SizedBox(height: 16.h),
                _buildSectionLabel('section_finance'.tr()),
                _buildGroupCard([
                  _MenuItem(
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: AppColors.primary,
                    titleKey: 'wallet_menu',
                    onTap: () => context.slideTo(const WalletScreen()),
                  ),
                  _MenuItem(
                    icon: Icons.credit_card_outlined,
                    iconColor: const Color(0xff26C6DA),
                    titleKey: 'bank_account_menu',
                    onTap: () {},
                  ),
                ]),
                SizedBox(height: 16.h),
                _buildSectionLabel('section_settings'.tr()),
                _buildGroupCard([
                  _MenuItem(
                    icon: Icons.language_outlined,
                    iconColor: const Color(0xffFFCA28),
                    titleKey: 'language_menu',
                    onTap: () => showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (_) => const LanguageBottomSheet(),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.description_outlined,
                    iconColor: const Color(0xff5C6BC0),
                    titleKey: 'terms_conditions_menu',
                    onTap: () => context.slideTo(const TermsAndConditionsScreen()),
                  ),
                  _MenuItem(
                    icon: Icons.help_outline,
                    iconColor: const Color(0xffAB47BC),
                    titleKey: 'help_center_menu',
                    onTap: () => context.slideTo(const SupportScreen()),
                  ),
                ]),
                SizedBox(height: 24.h),
                _buildLogoutButton(),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Header card with gradient ──────────────────────────────────────────────
  Widget _buildHeaderCard(VendorEntity vendor) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: CircleAvatar(
                  radius: 36.r,
                  backgroundColor: Colors.white,
                  child: vendor.mainPhoto.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(36.r),
                          child: CachedNetworkImage(
                            imageUrl: vendor.mainPhoto,
                            fit: BoxFit.cover,
                            width: 72.r,
                            height: 72.r,
                            placeholder: (_, __) => const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            errorWidget: (_, __, ___) => Icon(
                              Icons.person,
                              size: 36.sp,
                              color: Colors.grey[400],
                            ),
                          ),
                        )
                      : Icon(Icons.person, size: 36.sp, color: Colors.grey[400]),
                ),
              ),
              SizedBox(width: 14.w),
              // Name + restaurant
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendor.fullName,
                      style: AppStyles.inter18MediumBlack.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    if (vendor.restaurantName.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.storefront_outlined,
                            size: 14.sp,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              vendor.restaurantName,
                              style: AppStyles.inter12Regular.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 4.h),
                    Text(
                      vendor.email,
                      style: AppStyles.inter12Regular.copyWith(
                        color: Colors.white.withOpacity(0.85),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Edit button
              GestureDetector(
                onTap: () => context.slideTo(const ProfileEditScreen()),
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          // Status badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: vendor.isActive
                  ? Colors.green.shade400
                  : Colors.orange.shade400,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  vendor.isActive ? Icons.check_circle : Icons.access_time,
                  color: Colors.white,
                  size: 14.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  vendor.isActive
                      ? 'status_active'.tr()
                      : 'status_inactive'.tr(),
                  style: AppStyles.inter12Regular.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Section label ──────────────────────────────────────────────────────────
  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          text,
          style: AppStyles.inter12Regular.copyWith(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }

  // ── White rounded card containing menu items ──────────────────────────────
  Widget _buildGroupCard(List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _buildMenuItem(items[i]),
            if (i < items.length - 1)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Divider(
                  height: 1,
                  color: Colors.grey.shade200,
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuItem(_MenuItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.iconColor.withOpacity(0.12),
                ),
                child: Icon(item.icon, color: item.iconColor, size: 20.sp),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  item.titleKey.tr(),
                  style: AppStyles.inter14Regular.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey.shade400,
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Logout button (outlined red) ───────────────────────────────────────────
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: OutlinedButton.icon(
        onPressed: _showLogoutBottomSheet,
        icon: Icon(Icons.logout_rounded, color: AppColors.error, size: 20.sp),
        label: Text(
          'logout_button'.tr(),
          style: AppStyles.inter16Regular.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.error.withOpacity(0.06),
          side: BorderSide(color: AppColors.error.withOpacity(0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      ),
    );
  }

  // ── Error state ────────────────────────────────────────────────────────────
  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 56.sp, color: AppColors.error),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppStyles.inter16Regular,
            ),
            SizedBox(height: 24.h),
            SizedBox(
              height: 48.h,
              child: CustomElevatedButton(
                text: 'try_again_button'.tr(),
                onButtonClicked: _fetchProfile,
                textStyle: AppStyles.inter16RegularWhite,
                backGroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Logout bottom sheet ────────────────────────────────────────────────────
  void _showLogoutBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'logout_dialog_title'.tr(),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'logout_dialog_message'.tr(),
              style: AppStyles.inter16Regular,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    text: 'no_button'.tr(),
                    onButtonClicked: () => Navigator.of(context).pop(),
                    textStyle: AppStyles.inter16RegularWhite,
                    backGroundColor: AppColors.primary,
                  ),
                ),
                SizedBox(width: 40.w),
                Expanded(
                  child: CustomElevatedButton(
                    text: 'yes_button'.tr(),
                    onButtonClicked: () {
                      Navigator.of(context).pop();
                      sl<CacheHelper>().removeData(
                        key: AppConstants.accessTokenKey,
                      );
                      context.slideReplace(const LoginScreen());
                    },
                    textStyle: AppStyles.inter16RegularWhite,
                    backGroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

// ── Simple data class for menu items ─────────────────────────────────────────
class _MenuItem {
  final IconData icon;
  final Color iconColor;
  final String titleKey;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.titleKey,
    required this.onTap,
  });
}
