import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/routes/navigation_helper.dart';
import 'package:home_plate_vendor/core/temp_provider/address_provider.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/app_assets.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/presentation/pages/add_adderss_screen.dart';
import 'package:provider/provider.dart';

class AddAddressCard extends StatelessWidget {
  const AddAddressCard({super.key});
  Future<void> _navigateToAddAddress(BuildContext context) async {
    final newAddress = await context.slideTo(AddAdderssScreen());

    if (newAddress != null && newAddress is Map<String, String>) {
      context.read<AddressProvider>().addAddress(newAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = context.watch<AddressProvider>();
    final addresses = addressProvider.addresses;
    return addresses.isEmpty
        ? _buildAddAddressButton(context)
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              return Container(
                height: 90.h,
                margin: EdgeInsets.only(bottom: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: Image.asset(
                              AppAssets.map,
                              width: 90.w,

                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                addresses[index]['title']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                addresses[index]['address']!,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        TextButton(
                          onPressed: () async {
                            // افتح صفحة تعديل العنوان
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddAdderssScreen(
                                  existingAddress: addresses[index],
                                  index: index,
                                ),
                              ),
                            );

                            if (result != null &&
                                result is Map<String, String>) {
                              context.read<AddressProvider>().updateAddress(
                                index,
                                result,
                              );
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'change_button'.tr(),
                                style: TextStyle(color: Colors.orange),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.orange,
                                size: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.orange,
                          size: 14.sp,
                        ),
                        onPressed: () {
                          context.read<AddressProvider>().removeAddress(index);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }

  Widget _buildAddAddressButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToAddAddress(context),
      child: Container(
        height: 90.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_circle_outline_outlined,
                color: AppColors.white,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Text('add_address_button'.tr(), style: AppStyles.inter16RegularWhite),
            ],
          ),
        ),
      ),
    );
  }
}
