import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_plate_vendor/core/di/di.dart';
import 'package:home_plate_vendor/core/routes/navigation_helper.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/toast_helper.dart';
import 'package:home_plate_vendor/features/addresses/domain/entities/address_entity.dart';
import 'package:home_plate_vendor/features/addresses/presentation/manager/addresses_cubit.dart';
import 'package:home_plate_vendor/features/addresses/presentation/pages/address_form_screen.dart';

class AddressesListScreen extends StatelessWidget {
  const AddressesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<AddressesCubit>()..fetch(),
      child: const _AddressesListView(),
    );
  }
}

class _AddressesListView extends StatelessWidget {
  const _AddressesListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'addresses'.tr(),
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
      body: BlocConsumer<AddressesCubit, AddressesState>(
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
                  'no_addresses'.tr(),
                  style: AppStyles.inter14Regular.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<AddressesCubit>().fetch(),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemCount: state.items.length,
              separatorBuilder: (_, __) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                final item = state.items[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.location_on_outlined,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      item.title.isEmpty
                          ? 'branch_label'.tr()
                          : item.title,
                      style: AppStyles.inter14Regular.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      [
                        item.addressLine1,
                        if (item.townCity.isNotEmpty) item.townCity,
                        if (item.regionState.isNotEmpty) item.regionState,
                      ].join(' • '),
                      style: AppStyles.inter12Regular.copyWith(
                        color: Colors.grey,
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
    AddressEntity? existing,
  ) async {
    final cubit = context.read<AddressesCubit>();
    final saved = await context.slideFromBottom(
      BlocProvider.value(
        value: cubit,
        child: AddressFormScreen(existing: existing),
      ),
    );
    if (saved == true) {
      ToastHelper.showSuccess(context, 'saved_successfully'.tr());
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    AddressEntity item,
  ) async {
    final cubit = context.read<AddressesCubit>();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('confirm_delete'.tr()),
        content: Text(
          'delete_address_msg'.tr(
            namedArgs: {'name': item.title.isEmpty ? '#${item.id}' : item.title},
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
