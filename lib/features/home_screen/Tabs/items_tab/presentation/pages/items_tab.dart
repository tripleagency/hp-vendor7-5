import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_plate_vendor/core/di/di.dart';
import 'package:home_plate_vendor/core/routes/navigation_helper.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/features/add_item/presentation/pages/create_recipe_screen.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/presentation/manager/items_cubit/items_cubit.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/presentation/widgets/item_card.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/presentation/widgets/items_skeleton_loading.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/presentation/widgets/my_empty_state_recipes.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/presentation/widgets/toast_message_helper.dart';
import 'package:home_plate_vendor/features/home_screen/presentation/manager/home_cubit.dart';

class ItemsTab extends StatelessWidget {
  const ItemsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ItemsCubit>()..getItems(),
      child: const _ItemsTabView(),
    );
  }
}

class _ItemsTabView extends StatelessWidget {
  const _ItemsTabView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => context.slideTo(const CreateRecipeScreen()),
        icon: const Icon(Icons.add),
        label: Text(
          'add_recipe_button'.tr(),
          style: AppStyles.inter14RegularWhite.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () {
            context.read<HomeCubit>().changeBottomNavIndex(0);
          },
        ),
        title: Text(
          'my_recipes_title'.tr(),
          style: AppStyles.inter20RegularBlack,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        actions: [
          BlocBuilder<ItemsCubit, ItemsState>(
            builder: (context, state) {
              if (state.status == ItemsStatus.success &&
                  state.items.isNotEmpty) {
                return IconButton(
                  icon: Icon(Icons.search, color: AppColors.black),
                  onPressed: () {},
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocListener<ItemsCubit, ItemsState>(
        listener: (context, state) {
          if (state.successMessage != null && state.successMessage!.isNotEmpty) {
            ToastMessageHelper.showSuccessMessage(
              context,
              message: state.successMessage!,
            );
          }
          if (state.failureMessage != null && state.failureMessage!.isNotEmpty) {
            ToastMessageHelper.showErrorMessage(
              context,
              message: state.failureMessage!,
            );
          }
        },
        child: BlocBuilder<ItemsCubit, ItemsState>(
          builder: (context, state) {
            switch (state.status) {
              case ItemsStatus.initial:
              case ItemsStatus.loading:
                return const ItemsSkeletonLoading();
              case ItemsStatus.failure:
                return _buildErrorState(context, (state.errorMessage ?? 'error_generic_message').tr());
              case ItemsStatus.success:
                if (state.items.isEmpty) {
                  return const MyEmptyStateRecipes();
                }
                return _buildListState(context, state);
            }
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red[300]),
            SizedBox(height: 16.h),
            Text(
              message,
              style: AppStyles.inter16Regularblack,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                context.read<ItemsCubit>().getItems();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1BAC4B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 32.w,
                  vertical: 12.h,
                ),
              ),
              child: Text(
                'retry'.tr(),
                style: AppStyles.inter16RegularWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListState(BuildContext context, ItemsState state) {
    return RefreshIndicator(
      color: const Color(0xFF1BAC4B),
      onRefresh: () => context.read<ItemsCubit>().getItems(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'recent_add_label'.tr(),
              style: AppStyles.inter16MediumBlack,
            ),
            SizedBox(height: 16.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.items.length,
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final item = state.items[index];
                return ItemCard(
                  item: item,
                  onToggle: (value) {
                    context.read<ItemsCubit>().toggleItemStatus(
                      item.id,
                      value,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
