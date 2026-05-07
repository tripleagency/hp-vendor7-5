import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/presentation/manager/profile_cubit.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';

import 'package:home_plate_vendor/core/routes/navigation_helper.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/features/notifications/presentation/pages/notifications_screen.dart';

class HeaderHome extends StatelessWidget {
  const HeaderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final vendor = state.vendor;
        final localImage = state.localProfileImage;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.grey[200],
                backgroundImage: localImage != null
                    ? FileImage(localImage)
                    : (vendor?.mainPhoto != null && vendor!.mainPhoto.isNotEmpty
                              ? NetworkImage(vendor.mainPhoto)
                              : null)
                          as ImageProvider?,
                child:
                    localImage == null &&
                        (vendor?.mainPhoto == null || vendor!.mainPhoto.isEmpty)
                    ? Icon(Icons.person, color: Colors.grey[400], size: 24.sp)
                    : null,
              ),
              SizedBox(width: 12.w),
              Text(
                vendor?.fullName ?? '',
                style: AppStyles.inter16Regularblack,
              ),

              const Spacer(),

              InkWell(
                onTap: () {
                  context.slideTo(const NotificationsScreen());
                },
                borderRadius: BorderRadius.circular(24.w),
                child: Container(
                  height: 48.w,
                  width: 48.w,
                  margin: EdgeInsets.only(right: 8.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gray, width: 1.5),
                  ),
                  child: Center(
                    child: badges.Badge(
                      position: badges.BadgePosition.topEnd(top: 0, end: 0),
                      showBadge: true,
                      badgeStyle: const badges.BadgeStyle(
                        badgeColor: Colors.red,
                        padding: EdgeInsets.all(3),
                      ),
                      child: Icon(Icons.notifications_none, size: 24.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
