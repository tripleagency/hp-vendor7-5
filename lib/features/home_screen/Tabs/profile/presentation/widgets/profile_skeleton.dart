import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade50,
        duration: const Duration(milliseconds: 1000),
      ),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 16.h),

              // ── Header: avatar + name/email + edit button ─────────────────
              Row(
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: Colors.grey.shade300,
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Bone(width: 160.w, height: 18.h),
                        SizedBox(height: 6.h),
                        _Bone(width: 120.w, height: 13.h),
                      ],
                    ),
                  ),
                  _Bone(width: 70.w, height: 34.h, borderRadius: 8.r),
                ],
              ),

              SizedBox(height: 18.h),
              Divider(color: AppColors.gray, height: 1),
              SizedBox(height: 10.h),

              // ── 7 menu rows ───────────────────────────────────────────────
              ...List.generate(7, (_) => _SkeletonMenuRow()),

              SizedBox(height: 50.h),

              // ── Logout button ─────────────────────────────────────────────
              _Bone(width: double.infinity, height: 51.h, borderRadius: 8.r),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// A single skeleton menu row (icon circle + label + chevron)
// ─────────────────────────────────────────────────────────────────────────────
class _SkeletonMenuRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          // Circular icon placeholder
          _Bone(width: 48.w, height: 48.w, isCircle: true),
          SizedBox(width: 16.w),
          // Label placeholder
          Expanded(
            child: _Bone(width: double.infinity, height: 15.h),
          ),
          SizedBox(width: 12.w),
          // Chevron placeholder
          _Bone(width: 20.w, height: 20.w, borderRadius: 4.r),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable rectangular bone with optional circle shape
// ─────────────────────────────────────────────────────────────────────────────
class _Bone extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final bool isCircle;

  const _Bone({
    required this.width,
    required this.height,
    this.borderRadius = 6,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Bone(
      width: width,
      height: height,
      borderRadius: isCircle
          ? BorderRadius.circular(height / 2)
          : BorderRadius.circular(borderRadius),
    );
  }
}
