import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/routes/navigation_helper.dart';

class ToastHelper {
  static void showSuccess(BuildContext context, String message) {
    _showFlushbar(
      context: context,
      message: message,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_outline,
    );
  }

  static void showError(BuildContext context, String message) {
    _showFlushbar(
      context: context,
      message: message,
      backgroundColor: AppColors.error,
      icon: Icons.error_outline,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _showFlushbar(
      context: context,
      message: message,
      backgroundColor: AppColors.info,
      icon: Icons.info_outline,
    );
  }

  static void _showFlushbar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    final contextToUse =
        NavigationHelper.navigatorKey.currentContext ?? context;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Flushbar(
        messageText: Text(message, style: AppStyles.inter16RegularWhite),
        icon: Icon(icon, size: 28.sp, color: Colors.white),
        duration: const Duration(seconds: 2),
        margin: EdgeInsets.all(12.w),
        borderRadius: BorderRadius.circular(12.r),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: backgroundColor.withOpacity(0.9),
        leftBarIndicatorColor: backgroundColor,
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0.0, 2.0),
            blurRadius: 3.0,
          ),
        ],
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        forwardAnimationCurve: Curves.easeOutBack,
      ).show(contextToUse);
    });
  }
}
