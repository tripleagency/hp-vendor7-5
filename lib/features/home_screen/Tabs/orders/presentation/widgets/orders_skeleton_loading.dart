import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/presentation/widgets/order_skeleton_card.dart';

class OrdersSkeletonLoading extends StatelessWidget {
  const OrdersSkeletonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) => const OrderSkeletonCard(),
      ),
    );
  }
}
