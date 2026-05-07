import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/validators.dart';
import 'package:home_plate_vendor/core/widgets/custom_button.dart';
import 'package:home_plate_vendor/core/widgets/custom_text_field.dart';
import 'package:home_plate_vendor/features/general/domain/entities/category_entity.dart';
import 'package:home_plate_vendor/features/general/presentation/manager/general_cubit.dart';
import 'package:home_plate_vendor/features/sub_categories/domain/entities/sub_category_entity.dart';
import 'package:home_plate_vendor/features/sub_categories/presentation/manager/sub_categories_cubit.dart';

class SubCategoryFormScreen extends StatefulWidget {
  final SubCategoryEntity? existing;

  const SubCategoryFormScreen({super.key, this.existing});

  @override
  State<SubCategoryFormScreen> createState() => _SubCategoryFormScreenState();
}

class _SubCategoryFormScreenState extends State<SubCategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameEnController;
  late final TextEditingController _nameArController;
  CategoryEntity? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _nameEnController = TextEditingController(
      text: widget.existing?.nameEn ?? '',
    );
    _nameArController = TextEditingController(
      text: widget.existing?.nameAr ?? '',
    );

    final generalCubit = context.read<GeneralCubit>();
    if (generalCubit.state.categories.isEmpty) {
      generalCubit.fetchCategories();
    } else if (widget.existing != null) {
      _selectedCategory = generalCubit.state.categories
          .where((c) => c.id == widget.existing!.categoryId)
          .firstOrNull;
    }
  }

  @override
  void dispose() {
    _nameEnController.dispose();
    _nameArController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedCategory == null) return;
    final cubit = context.read<SubCategoriesCubit>();
    final ok = await cubit.save(
      id: widget.existing?.id,
      nameEn: _nameEnController.text.trim(),
      nameAr: _nameArController.text.trim(),
      categoryId: _selectedCategory!.id,
    );
    if (ok && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          isEdit ? 'edit_sub_category'.tr() : 'add_sub_category'.tr(),
          style: AppStyles.inter18MediumBlack.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<SubCategoriesCubit, SubCategoriesState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'name_en'.tr(),
                    style: AppStyles.inter14Regular.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  CustomTextField(
                    hintText: 'name_en_hint'.tr(),
                    controller: _nameEnController,
                    validator: (v) => Validators.required(
                      v,
                      fieldName: 'name_en'.tr(),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'name_ar'.tr(),
                    style: AppStyles.inter14Regular.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  CustomTextField(
                    hintText: 'name_ar_hint'.tr(),
                    controller: _nameArController,
                    validator: (v) => Validators.required(
                      v,
                      fieldName: 'name_ar'.tr(),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'parent_category'.tr(),
                    style: AppStyles.inter14Regular.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  BlocBuilder<GeneralCubit, GeneralState>(
                    builder: (context, generalState) {
                      // sync from existing once categories load
                      if (_selectedCategory == null &&
                          widget.existing != null &&
                          generalState.categories.isNotEmpty) {
                        _selectedCategory = generalState.categories
                            .where((c) => c.id == widget.existing!.categoryId)
                            .firstOrNull;
                      }
                      final isAr = context.locale.languageCode == 'ar';
                      return DropdownButtonFormField<CategoryEntity>(
                        value: _selectedCategory,
                        isExpanded: true,
                        decoration: InputDecoration(
                          hintText: generalState.isLoadingCategories
                              ? 'loading'.tr()
                              : 'select_category'.tr(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        items: generalState.categories
                            .map(
                              (c) => DropdownMenuItem(
                                value: c,
                                child: Text(isAr ? c.nameAr : c.nameEn),
                              ),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _selectedCategory = val),
                        validator: (val) => val == null
                            ? 'please_select_category'.tr()
                            : null,
                      );
                    },
                  ),
                  SizedBox(height: 32.h),
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: CustomElevatedButton(
                      text: isEdit ? 'update'.tr() : 'add'.tr(),
                      onButtonClicked: state.isSaving ? null : _submit,
                      textStyle: AppStyles.inter16RegularWhite,
                      backGroundColor: AppColors.primary,
                      isLoading: state.isSaving,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
