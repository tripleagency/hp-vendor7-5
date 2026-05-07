import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';

class DashedUploadBox extends StatelessWidget {
  final double height;
  final double width;
  final String text;
  final String? subText;
  final VoidCallback onTap;
  final File? file;

  const DashedUploadBox({
    super.key,
    required this.height,
    required this.width,
    required this.text,
    this.subText,
    required this.onTap,
    this.file,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: AppColors.textLight,
          strokeWidth: 1.0,
          gap: 5.0,
        ),
        child: Container(
          height: height,
          width: width,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
          alignment: Alignment.center,
          child: file != null
              ? Image.file(
                  file!,
                  height: height,
                  width: width,
                  fit: BoxFit.cover,
                )
              : Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 30.sp,
                        color: AppColors.textLight,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        text,
                        style: AppStyles.inter12semiBoldBlack.copyWith(
                          fontSize: 10.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (subText != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          subText!,
                          style: AppStyles.inter10RegularBlack.copyWith(
                            color: AppColors.textLight,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(12.r),
      ),
    );

    Path dashPath = Path();
    double dashWidth = 5.0;
    double distance = 0.0;
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + gap;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
