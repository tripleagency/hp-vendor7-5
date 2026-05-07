import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';

class AppEmptyState extends StatelessWidget {
  final String imagePath;
  final String message;

  const AppEmptyState({
    super.key,
    required this.imagePath,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 24.h),
            Image.asset(
              imagePath,
              width: 358.w,
              height: 358.h,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 358.w,
                  height: 358.h,
                  color: Colors.grey[100],
                  child: Icon(
                    Icons.inbox_outlined,
                    color: Colors.grey[400],
                    size: 60.sp,
                  ),
                );
              },
            ),
            SizedBox(height: 32.h),
            Text(
              message,
              style: AppStyles.inter20RegularBlack,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
