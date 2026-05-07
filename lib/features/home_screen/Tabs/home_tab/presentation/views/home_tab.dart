import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/di/di.dart';
import 'package:home_plate_vendor/core/widgets/app_error_state.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/home_tab/presentation/pages/filtered_orders_screen.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/home_tab/presentation/widgets/header_home.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/home_tab/presentation/widgets/add_item_button.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/home_tab/presentation/widgets/orders_filter_header.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/home_tab/presentation/widgets/order_stats_card.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/home_tab/presentation/widgets/home_tab_skeleton_loading.dart';
import 'package:home_plate_vendor/features/add_item/presentation/pages/create_recipe_screen.dart';
import 'package:home_plate_vendor/core/routes/navigation_helper.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/home_tab/presentation/widgets/account_status_view.dart';
import 'package:home_plate_vendor/core/utils/app_assets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/presentation/manager/profile_cubit.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/entities/order_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/presentation/manager/orders_cubit/orders_cubit.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrdersCubit>()..getOrders(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              const HeaderHome(),
              Expanded(
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    return _buildBody(state, context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(ProfileState profileState, BuildContext context) {
    // Wait for profile to load before checking vendor status
    if (profileState.status == ProfileStatus.initial ||
        profileState.status == ProfileStatus.loading) {
      return const HomeTabSkeletonLoading();
    }

    if (profileState.status == ProfileStatus.failure) {
      return AppErrorState(
        message: profileState.errorMessage ?? 'error_generic_message'.tr(),
        onRetry: () {
          // Re-fetch profile — caller should handle vendorId
          context.read<OrdersCubit>().getOrders();
        },
      );
    }

    // Profile loaded — check vendor account status
    // Order matters: pending/rejected are checked before isActive because a
    // brand-new vendor is normally inactive AND pending review at the same time.
    final vendor = profileState.vendor;
    final vendorStatus = vendor?.status;
    final isActive = vendor?.isActive ?? false;

    if (vendorStatus == 'pending') {
      return const AccountStatusView(status: AccountStatus.waiting);
    } else if (vendorStatus == 'rejected') {
      return AccountStatusView(
        status: AccountStatus.rejection,
        reason: vendor?.rejectionReason,
      );
    } else if (!isActive) {
      // Was approved at some point then deactivated/suspended.
      return const AccountStatusView(status: AccountStatus.suspended);
    }

    // Normal Dashboard with loading/error/success states
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, ordersState) {
        switch (ordersState.status) {
          case OrdersStatus.initial:
          case OrdersStatus.loading:
            return const HomeTabSkeletonLoading();
          case OrdersStatus.failure:
            return AppErrorState(
              message: ordersState.errorMessage ?? 'error_generic_message'.tr(),
              onRetry: () => context.read<OrdersCubit>().getOrders(),
            );
          case OrdersStatus.success:
            return _buildDashboard(context, ordersState);
        }
      },
    );
  }

  Widget _buildDashboard(BuildContext context, OrdersState ordersState) {
    final orders = ordersState.orders;
    int countByStatuses(List<OrderStatus> statuses) =>
        orders.where((o) => statuses.contains(o.status)).length;

    return RefreshIndicator(
      color: AppColors.orderGreen,
      onRefresh: () => context.read<OrdersCubit>().getOrders(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            sliver: SliverToBoxAdapter(
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  return Text(
                    'track_your_name'.tr(
                      namedArgs: {'name': state.vendor?.fullName ?? ''},
                    ),
                    style: AppStyles.inter20RegularBlack,
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverToBoxAdapter(
              child: AddItemButton(
                onPressed: () {
                  context.slideTo(const CreateRecipeScreen());
                },
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            sliver: SliverToBoxAdapter(child: OrdersFilterHeader()),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverGrid(
              delegate: SliverChildListDelegate([
                OrderStatsCard(
                  title: 'new_order'.tr(),
                  count: countByStatuses([
                    OrderStatus.pendingVendorPreparation,
                  ]).toString(),
                  icon: AppAssets.newOrderSvg,
                  iconColor: const Color(0xFFFFB300),
                  iconBgColor: const Color(0xFFFFF8E1),
                  onTap: () {
                    context.slideTo(
                      FilteredOrdersScreen(
                        title: 'new_orders_title'.tr(),
                        filterStatuses: [
                          OrderStatus.pendingVendorPreparation,
                        ],
                      ),
                    );
                  },
                ),
                OrderStatsCard(
                  title: 'orders_in_progress'.tr(),
                  count: countByStatuses([
                    OrderStatus.searchingDelivery,
                    OrderStatus.deliveryAssigned,
                    OrderStatus.readyForPickup,
                    OrderStatus.handoverPendingConfirmation,
                    OrderStatus.pickedUp,
                    OrderStatus.outForDelivery,
                  ]).toString(),
                  icon: AppAssets.cookingSvg,
                  iconColor: const Color(0xFF1E88E5),
                  iconBgColor: const Color(0xFFE3F2FD),
                  onTap: () {
                    context.slideTo(
                      FilteredOrdersScreen(
                        title: 'orders_in_progress_title'.tr(),
                        filterStatuses: [
                          OrderStatus.searchingDelivery,
                          OrderStatus.deliveryAssigned,
                          OrderStatus.readyForPickup,
                          OrderStatus.handoverPendingConfirmation,
                          OrderStatus.pickedUp,
                          OrderStatus.outForDelivery,
                        ],
                      ),
                    );
                  },
                ),
                OrderStatsCard(
                  title: 'orders_delivered'.tr(),
                  count: countByStatuses([
                    OrderStatus.delivered,
                  ]).toString(),
                  icon: AppAssets.deliveredSvg,
                  iconColor: const Color(0xFF43A047),
                  iconBgColor: const Color(0xFFE8F5E9),
                  onTap: () {
                    context.slideTo(
                      FilteredOrdersScreen(
                        title: 'delivered_orders_title'.tr(),
                        filterStatuses: [OrderStatus.delivered],
                      ),
                    );
                  },
                ),
                OrderStatsCard(
                  title: 'canceled_order'.tr(),
                  count: countByStatuses([
                    OrderStatus.cancelled,
                  ]).toString(),
                  icon: AppAssets.canceledSvg,
                  iconColor: const Color(0xFFE53935),
                  iconBgColor: const Color(0xFFFFEBEE),
                  onTap: () {
                    context.slideTo(
                      FilteredOrdersScreen(
                        title: 'canceled_orders_title'.tr(),
                        filterStatuses: [OrderStatus.cancelled],
                      ),
                    );
                  },
                ),
              ]),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 1.15,
              ),
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(bottom: 24.h)),
        ],
      ),
    );
  }
}
