import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/widgets/widgets.dart';
import 'package:home_plate_vendor/core/utils/validators.dart';
import 'package:home_plate_vendor/features/general/presentation/manager/general_cubit.dart';
import 'package:home_plate_vendor/features/general/domain/entities/category_entity.dart';

class AddItemFormFields extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController discountController;
  final TextEditingController prepTimeController;
  final TextEditingController ordersPerDayController;
  final TextEditingController stockController;
  final CategoryEntity? selectedCategory;
  final String? selectedTimeUnit;
  final List<String> timeUnits;
  final ValueChanged<CategoryEntity?> onCategoryChanged;
  final ValueChanged<String?> onTimeUnitChanged;
  final Map<String, dynamic>? errors;

  const AddItemFormFields({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.priceController,
    required this.discountController,
    required this.prepTimeController,
    required this.ordersPerDayController,
    required this.stockController,
    required this.selectedCategory,
    required this.selectedTimeUnit,
    required this.timeUnits,
    required this.onCategoryChanged,
    required this.onTimeUnitChanged,
    this.errors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('dish_types_label'.tr()),
        SizedBox(height: 8.h),
        BlocBuilder<GeneralCubit, GeneralState>(
          builder: (context, generalState) {
            if (generalState.isLoadingCategories) {
              return Container(
                height: 50.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.textLight.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: const CircularProgressIndicator.adaptive(),
              );
            }
            if (generalState.errorMessage != null &&
                generalState.categories.isEmpty) {
              return GestureDetector(
                onTap: () => context.read<GeneralCubit>().fetchCategories(),
                child: Container(
                  height: 50.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.error),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'tap_to_retry'.tr(),
                    style: AppStyles.inter14RegularWhite.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              );
            }
            // Resolve the selected value to the SAME instance present in
            // generalState.categories (matched by id). Without this, edit
            // mode passes a different CategoryEntity instance and Dropdown
            // throws "There should be exactly one item with [value]".
            CategoryEntity? resolvedValue;
            if (selectedCategory != null) {
              resolvedValue = selectedCategory;
              for (final c in generalState.categories) {
                if (c.id == selectedCategory!.id) {
                  resolvedValue = c;
                  break;
                }
              }
            }
            return CustomDropdown<CategoryEntity>(
              hintText: 'choose_dish_types'.tr(),
              value: resolvedValue,
              errorText: errors?['category_id']?.toString(),
              items: generalState.categories.map((category) {
                return DropdownMenuItem<CategoryEntity>(
                  value: category,
                  child: Text(
                    context.locale.languageCode == 'ar'
                        ? category.nameAr
                        : category.nameEn,
                  ),
                );
              }).toList(),
              onChanged: onCategoryChanged,
              validator: (val) {
                if (val == null) {
                  return 'error_field_required_name'.tr(
                    namedArgs: {'fieldName': 'dish_types_label'.tr()},
                  );
                }
                return null;
              },
            );
          },
        ),
        SizedBox(height: 16.h),

        _buildLabel('food_name_label'.tr()),
        SizedBox(height: 8.h),
        CustomTextField(
          hintText: 'food_name_hint'.tr(),
          controller: nameController,
          errorText: errors?['name']?.toString(),
          validator: (val) =>
              Validators.required(val, fieldName: 'food_name_label'.tr()),
        ),
        SizedBox(height: 16.h),

        _buildLabel('description_label'.tr()),
        SizedBox(height: 8.h),
        CustomTextField(
          hintText: 'description_hint'.tr(),
          maxLines: 4,
          controller: descriptionController,
          errorText: errors?['description']?.toString(),
          validator: (val) =>
              Validators.required(val, fieldName: 'description_label'.tr()),
        ),
        SizedBox(height: 16.h),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('price_label'.tr()),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    hintText: '19.99 EGP',
                    keyBoardType: TextInputType.number,
                    controller: priceController,
                    errorText: errors?['price']?.toString(),
                    validator: (val) =>
                        Validators.numeric(val, fieldName: 'price_label'.tr()),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('discount_label'.tr()),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    hintText: '0.00 EGP',
                    keyBoardType: TextInputType.number,
                    controller: discountController,
                    errorText: errors?['discount']?.toString(),
                    validator: (val) {
                      if (val != null && val.isNotEmpty) {
                        return Validators.numeric(
                          val,
                          fieldName: 'discount_label'.tr(),
                        );
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('food_prep_time_label'.tr()),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    hintText: '30',
                    keyBoardType: TextInputType.number,
                    controller: prepTimeController,
                    errorText: errors?['prep_time_value']?.toString(),
                    validator: (val) => Validators.numeric(
                      val,
                      fieldName: 'food_prep_time_label'.tr(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('per_label'.tr()),
                  SizedBox(height: 8.h),
                  _buildDropdown(
                    'time_unit_minutes'.tr(),
                    selectedTimeUnit,
                    timeUnits,
                    onTimeUnitChanged,
                    validator: (val) =>
                        Validators.required(val, fieldName: 'per_label'.tr()),
                    isTimeUnit: true,
                    errorText: errors?['prep_time_unit']?.toString(),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        _buildLabel('stock_label'.tr()),
        SizedBox(height: 8.h),
        CustomTextField(
          hintText: '30',
          keyBoardType: TextInputType.number,
          controller: stockController,
          errorText: errors?['stock']?.toString(),
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 16.w, top: 14.h, left: 8.w),
            child: Text(
              'per_day_label'.tr(),
              style: AppStyles.inter16MediumBlack.copyWith(
                fontSize: 14.sp,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          validator: (val) =>
              Validators.numeric(val, fieldName: 'stock_label'.tr()),
        ),
        SizedBox(height: 16.h),

        _buildLabel('orders_per_day_label'.tr()),
        SizedBox(height: 8.h),
        CustomTextField(
          hintText: '30',
          keyBoardType: TextInputType.number,
          controller: ordersPerDayController,
          errorText: errors?['max_orders_per_day']?.toString(),
          validator: (val) =>
              Validators.numeric(val, fieldName: 'orders_per_day_label'.tr()),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppStyles.inter16MediumBlack.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
      ),
    );
  }

  Widget _buildDropdown(
    String hint,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged, {
    String? Function(String?)? validator,
    bool isTimeUnit = false,
    String? errorText,
  }) {
    return CustomDropdown<String>(
      hintText: hint,
      value: value,
      errorText: errorText,
      items: items.map<DropdownMenuItem<String>>((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(isTimeUnit ? 'time_unit_$item'.tr() : item.tr()),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
