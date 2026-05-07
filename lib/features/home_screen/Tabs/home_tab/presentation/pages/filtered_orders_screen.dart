import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/app_assets.dart';
import 'package:home_plate_vendor/core/widgets/app_empty_state.dart';
import 'package:home_plate_vendor/core/widgets/app_error_state.dart';
import 'package:home_plate_vendor/core/di/di.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/entities/order_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/presentation/manager/orders_cubit/orders_cubit.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/presentation/widgets/order_card.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/presentation/widgets/orders_skeleton_loading.dart';

class FilteredOrdersScreen extends StatelessWidget {
  final String title;
  final List<OrderStatus> filterStatuses;

  const FilteredOrdersScreen({
    super.key,
    required this.title,
    required this.filterStatuses,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrdersCubit>()..getOrders(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          scrolledUnderElevation: 0,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            title,
            style: AppStyles.inter20RegularBlack.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            switch (state.status) {
              case OrdersStatus.initial:
              case OrdersStatus.loading:
                return const OrdersSkeletonLoading();
              case OrdersStatus.failure:
                return AppErrorState(
                  message: state.errorMessage ?? 'error_generic_message',
                  onRetry: () => context.read<OrdersCubit>().getOrders(),
                );
              case OrdersStatus.success:
                final filteredOrders = state.orders
                    .where((o) => filterStatuses.contains(o.status))
                    .toList();
                if (filteredOrders.isEmpty) {
                  return AppEmptyState(
                    imagePath: AppAssets.emptyOrder,
                    message: 'no_orders_empty_state'.tr(),
                  );
                }
                return RefreshIndicator(
                  color: const Color(0xFF1BAC4B),
                  onRefresh: () => context.read<OrdersCubit>().getOrders(),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      return OrderCard(order: filteredOrders[index]);
                    },
                  ),
                );
            }
          },
        ),
      ),
    );
  }

}
