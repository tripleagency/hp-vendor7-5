import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_plate_vendor/core/di/di.dart';
import 'package:home_plate_vendor/core/routes/navigation_helper.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/toast_helper.dart';
import 'package:home_plate_vendor/features/general/presentation/manager/general_cubit.dart';
import 'package:home_plate_vendor/features/sub_categories/domain/entities/sub_category_entity.dart';
import 'package:home_plate_vendor/features/sub_categories/presentation/manager/sub_categories_cubit.dart';
import 'package:home_plate_vendor/features/sub_categories/presentation/pages/sub_category_form_screen.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<SubCategoriesCubit>()..fetch()),
        BlocProvider.value(value: sl<GeneralCubit>()),
      ],
      child: const _SubCategoriesView(),
    );
  }
}

class _SubCategoriesView extends StatelessWidget {
  const _SubCategoriesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'sub_categories'.tr(),
          style: AppStyles.inter18MediumBlack.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _openForm(context, null),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocConsumer<SubCategoriesCubit, SubCategoriesState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ToastHelper.showError(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.items.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Text(
                  'no_sub_categories'.tr(),
                  style: AppStyles.inter14Regular.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final isAr = context.locale.languageCode == 'ar';
          return RefreshIndicator(
            onRefresh: () => context.read<SubCategoriesCubit>().fetch(),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemCount: state.items.length,
              separatorBuilder: (_, __) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                final item = state.items[index];
                final name = isAr ? item.nameAr : item.nameEn;
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ListTile(
                    title: Text(
                      name,
                      style: AppStyles.inter14Regular.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit_outlined,
                            color: AppColors.primary,
                          ),
                          onPressed: () => _openForm(context, item),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => _confirmDelete(context, item),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _openForm(
    BuildContext context,
    SubCategoryEntity? existing,
  ) async {
    final cubit = context.read<SubCategoriesCubit>();
    final saved = await context.slideFromBottom(
      BlocProvider.value(
        value: cubit,
        child: BlocProvider.value(
          value: context.read<GeneralCubit>(),
          child: SubCategoryFormScreen(existing: existing),
        ),
      ),
    );
    if (saved == true) {
      ToastHelper.showSuccess(context, 'saved_successfully'.tr());
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    SubCategoryEntity item,
  ) async {
    final cubit = context.read<SubCategoriesCubit>();
    final isAr = context.locale.languageCode == 'ar';
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('confirm_delete'.tr()),
        content: Text(
          'delete_sub_category_msg'.tr(
            namedArgs: {'name': isAr ? item.nameAr : item.nameEn},
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'delete'.tr(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      final ok = await cubit.delete(item.id);
      if (ok && context.mounted) {
        ToastHelper.showSuccess(context, 'deleted_successfully'.tr());
      }
    }
  }
}
