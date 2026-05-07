import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/toast_helper.dart';
import 'package:home_plate_vendor/core/widgets/widgets.dart';
import 'package:home_plate_vendor/core/routes/navigation_helper.dart';
import 'package:home_plate_vendor/features/home_screen/presentation/views/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_plate_vendor/core/di/di.dart';
import 'package:home_plate_vendor/features/add_item/presentation/manager/add_item_cubit.dart';
import 'package:home_plate_vendor/features/add_item/domain/usecases/add_item_params.dart';
import 'package:home_plate_vendor/features/general/presentation/manager/general_cubit.dart';
import 'package:home_plate_vendor/features/general/domain/entities/category_entity.dart';
import 'package:home_plate_vendor/features/add_item/presentation/widgets/add_item_image_section.dart';
import 'package:home_plate_vendor/features/add_item/presentation/widgets/add_item_form_fields.dart';
import 'package:home_plate_vendor/features/add_item/presentation/widgets/add_item_sizes_section.dart';
import 'package:home_plate_vendor/features/add_item/presentation/widgets/add_item_addons_section.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/domain/entities/item_entity.dart';
import 'package:home_plate_vendor/features/sub_categories/domain/entities/sub_category_entity.dart';
import 'package:home_plate_vendor/features/sub_categories/presentation/manager/sub_categories_cubit.dart';

class CreateRecipeScreen extends StatefulWidget {
  /// Optional: pass an existing item to enter Edit mode (prefills the form).
  final ItemEntity? existingItem;

  const CreateRecipeScreen({super.key, this.existingItem});

  bool get isEditMode => existingItem != null;

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nameArController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _descriptionArController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _prepTimeController = TextEditingController();
  final TextEditingController _ordersPerDayController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  CategoryEntity? _selectedCategory;
  SubCategoryEntity? _selectedSubCategory;
  String? _selectedTimeUnit;

  final List<String> _timeUnits = ['minutes', 'hours', 'days'];

  File? _coverImage;
  final List<File?> _kitchenImages = [null, null, null];

  final List<SizeRow> _sizeRows = [];
  final List<AddonRow> _addonRows = [];

  @override
  void initState() {
    super.initState();
    // Fetch categories if not already loaded
    final generalCubit = context.read<GeneralCubit>();
    if (generalCubit.state.categories.isEmpty) {
      generalCubit.fetchCategories();
    }
    // Prefill form fields when editing an existing item
    final existing = widget.existingItem;
    if (existing != null) {
      _nameController.text = existing.name;
      _nameArController.text = existing.nameAr;
      _descriptionController.text = existing.description;
      _descriptionArController.text = existing.descriptionAr;
      _priceController.text = existing.price;
      _discountController.text = existing.discount ?? '';
      _prepTimeController.text = existing.prepTimeValue;
      _selectedTimeUnit = existing.prepTimeUnit;
      _ordersPerDayController.text = existing.maxOrdersPerDay;
      _stockController.text = existing.stock;
      // Try to resolve to a matching loaded category by id; fall back to
      // the embedded one (the build-time dropdown will resolve again).
      if (existing.category != null) {
        CategoryEntity match = existing.category!;
        for (final c in generalCubit.state.categories) {
          if (c.id == existing.category!.id) {
            match = c;
            break;
          }
        }
        _selectedCategory = match;
      }
      // Sizes
      for (final s in existing.sizes) {
        final row = SizeRow();
        row.sizeController.text = s.size;
        row.priceController.text = s.price;
        _sizeRows.add(row);
      }
      // Addons
      for (final a in existing.addons) {
        final row = AddonRow();
        row.nameController.text = a.name;
        row.priceController.text = a.price;
        _addonRows.add(row);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameArController.dispose();
    _descriptionController.dispose();
    _descriptionArController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _prepTimeController.dispose();
    _ordersPerDayController.dispose();
    _stockController.dispose();
    for (final r in _sizeRows) {
      r.dispose();
    }
    for (final r in _addonRows) {
      r.dispose();
    }
    super.dispose();
  }

  void _addSizeRow() {
    setState(() => _sizeRows.add(SizeRow()));
  }

  void _removeSizeRow(int index) {
    setState(() {
      _sizeRows[index].dispose();
      _sizeRows.removeAt(index);
    });
  }

  void _addAddonRow() {
    setState(() => _addonRows.add(AddonRow()));
  }

  void _removeAddonRow(int index) {
    setState(() {
      _addonRows[index].dispose();
      _addonRows.removeAt(index);
    });
  }

  /// Section wrapper مع header و card
  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
    Widget? trailing,
    String? subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.h, left: 4.w, right: 4.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: AppColors.primary, size: 18.sp),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppStyles.inter16MediumBlack.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                      ),
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(
                          subtitle,
                          style: AppStyles.inter12Regular.copyWith(
                            color: AppColors.textLight,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _addButton(VoidCallback onTap, String label) {
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        backgroundColor: AppColors.primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      icon: Icon(Icons.add, size: 16.sp, color: AppColors.primary),
      label: Text(
        label,
        style: AppStyles.inter12Regular.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AddItemCubit>()),
        BlocProvider(create: (context) => sl<GeneralCubit>()),
        BlocProvider(
          create: (context) {
            final c = sl<SubCategoriesCubit>();
            if (c.state.items.isEmpty) c.fetch();
            return c;
          },
        ),
      ],
      child: BlocConsumer<AddItemCubit, AddItemState>(
        listener: (context, addItemState) {
          if (addItemState is AddItemSuccess) {
            context.slideTo(
              CustomSuccessScreen(
                title: widget.isEditMode
                    ? 'recipe_updated_success_title'.tr()
                    : 'recipe_created_success_title'.tr(),
                subtitle: addItemState.message,
                onButtonPressed: () {
                  context.pushAndRemoveUntil(const HomeScreen());
                },
              ),
            );
          } else if (addItemState is AddItemError) {
            ToastHelper.showError(context, addItemState.message.tr());
          }
        },
        builder: (context, addItemState) {
          final errors = addItemState is AddItemError
              ? addItemState.errors
              : null;
          return Scaffold(
            backgroundColor: AppColors.bg,
            appBar: AppBar(
              backgroundColor: AppColors.bg,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                widget.isEditMode
                    ? 'edit_recipe_title'.tr()
                    : 'create_recipe_title'.tr(),
                style: AppStyles.inter18MediumBlack.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      icon: Icons.photo_library_outlined,
                      title: 'recipe_photos_section'.tr(),
                      child: AddItemImageSection(
                        coverImage: _coverImage,
                        kitchenImages: _kitchenImages,
                        onCoverImageSelected: (file) =>
                            setState(() => _coverImage = file),
                        onKitchenImageSelected: (index, file) =>
                            setState(() => _kitchenImages[index] = file),
                        onCoverImageRemoved: () =>
                            setState(() => _coverImage = null),
                        onKitchenImageRemoved: (index) =>
                            setState(() => _kitchenImages[index] = null),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    _buildSection(
                      icon: Icons.restaurant_menu_outlined,
                      title: 'recipe_details_section'.tr(),
                      child: AddItemFormFields(
                        formKey: _formKey,
                        nameController: _nameController,
                        nameArController: _nameArController,
                        descriptionController: _descriptionController,
                        descriptionArController: _descriptionArController,
                        priceController: _priceController,
                        discountController: _discountController,
                        prepTimeController: _prepTimeController,
                        ordersPerDayController: _ordersPerDayController,
                        stockController: _stockController,
                        selectedCategory: _selectedCategory,
                        selectedTimeUnit: _selectedTimeUnit,
                        timeUnits: _timeUnits,
                        errors: errors,
                        onCategoryChanged: (val) =>
                            setState(() => _selectedCategory = val),
                        onTimeUnitChanged: (val) =>
                            setState(() => _selectedTimeUnit = val),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // ── Sub-Category dropdown ───────────────────────────
                    _buildSection(
                      icon: Icons.category_outlined,
                      title: 'sub_category_section_title'.tr(),
                      child: BlocBuilder<SubCategoriesCubit, SubCategoriesState>(
                        builder: (context, subState) {
                          final isAr = context.locale.languageCode == 'ar';
                          // Resolve the selected sub-category to a list item by id
                          // to avoid Dropdown duplicate-value assertions in edit mode.
                          SubCategoryEntity? resolvedSub;
                          if (_selectedSubCategory != null) {
                            resolvedSub = _selectedSubCategory;
                            for (final s in subState.items) {
                              if (s.id == _selectedSubCategory!.id) {
                                resolvedSub = s;
                                break;
                              }
                            }
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DropdownButtonFormField<SubCategoryEntity>(
                                value: resolvedSub,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  hintText: subState.isLoading
                                      ? 'loading'.tr()
                                      : 'select_sub_category'.tr(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 14.h,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                items: subState.items
                                    .map(
                                      (s) => DropdownMenuItem(
                                        value: s,
                                        child: Text(isAr ? s.nameAr : s.nameEn),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) =>
                                    setState(() => _selectedSubCategory = val),
                                validator: (val) => val == null
                                    ? 'please_select_sub_category'.tr()
                                    : null,
                              ),
                              SizedBox(height: 10.h),
                              // Note: tell user how to add sub-categories
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 10.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.25),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.info_outline_rounded,
                                      size: 16.sp,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        'sub_category_note'.tr(),
                                        style: AppStyles.inter12Regular.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w500,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 16.h),

                    _buildSection(
                      icon: Icons.format_size,
                      title: 'sizes_section_title'.tr(),
                      subtitle: 'sizes_hint'.tr(),
                      trailing: _addButton(
                          _addSizeRow, 'add_size_button'.tr()),
                      child: AddItemSizesSection(
                        rows: _sizeRows,
                        onAdd: _addSizeRow,
                        onRemove: _removeSizeRow,
                        errors: errors,
                        showHeader: false,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    _buildSection(
                      icon: Icons.add_circle_outline,
                      title: 'addons_section_title'.tr(),
                      subtitle: 'addons_hint'.tr(),
                      trailing: _addButton(
                          _addAddonRow, 'add_addon_button'.tr()),
                      child: AddItemAddonsSection(
                        rows: _addonRows,
                        onAdd: _addAddonRow,
                        onRemove: _removeAddonRow,
                        errors: errors,
                        showHeader: false,
                      ),
                    ),

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border(
                    top: BorderSide(color: AppColors.divider, width: 1),
                  ),
                ),
                child: CustomElevatedButton(
                  text: widget.isEditMode
                      ? 'update_recipe_button'.tr()
                      : 'submit_recipe_button'.tr(),
                  isLoading: addItemState is AddItemLoading,
                  textStyle: AppStyles.inter16RegularWhite.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                  backGroundColor: AppColors.primary,
                  onButtonClicked: () {
                    if (_formKey.currentState!.validate()) {
                      // In edit mode, the cover photo is optional (server keeps existing).
                      if (!widget.isEditMode && _coverImage == null) {
                        ToastHelper.showError(
                            context, 'select_cover_photo_error'.tr());
                        return;
                      }
                      if (_selectedCategory == null) {
                        ToastHelper.showError(
                            context, 'select_dish_type_error'.tr());
                        return;
                      }
                      if (_selectedSubCategory == null) {
                        ToastHelper.showError(
                            context, 'please_select_sub_category'.tr());
                        return;
                      }

                      // Cover photo is required for create. In edit mode it's
                      // optional — only send updated photos if any were picked.
                      final List<File> photos = [];
                      if (_coverImage != null) photos.add(_coverImage!);
                      for (var img in _kitchenImages) {
                        if (img != null) photos.add(img);
                      }

                      final sizes = _sizeRows
                          .where((r) =>
                              r.sizeController.text.trim().isNotEmpty)
                          .map((r) => SizeParam(
                                size: r.sizeController.text.trim(),
                                price: r.priceController.text.trim().isEmpty
                                    ? '0'
                                    : r.priceController.text.trim(),
                              ))
                          .toList();

                      final addons = _addonRows
                          .where((r) =>
                              r.nameController.text.trim().isNotEmpty)
                          .map((r) => AddonParam(
                                name: r.nameController.text.trim(),
                                price: r.priceController.text.trim().isEmpty
                                    ? '0'
                                    : r.priceController.text.trim(),
                              ))
                          .toList();

                      final params = AddItemParams(
                        categoryId: _selectedCategory!.id.toString(),
                        subcategoryId:
                            _selectedSubCategory!.id.toString(),
                        name: _nameController.text.trim(),
                        nameAr: _nameArController.text.trim(),
                        description: _descriptionController.text.trim(),
                        descriptionAr:
                            _descriptionArController.text.trim(),
                        price: _priceController.text,
                        discount: _discountController.text,
                        prepTimeValue: _prepTimeController.text,
                        prepTimeUnit: _selectedTimeUnit ?? 'minutes',
                        stock: _stockController.text,
                        maxOrdersPerDay: _ordersPerDayController.text,
                        photos: photos,
                        sizes: sizes,
                        addons: addons,
                      );
                      if (widget.isEditMode) {
                        context
                            .read<AddItemCubit>()
                            .updateItem(widget.existingItem!.id, params);
                      } else {
                        context.read<AddItemCubit>().addItem(params);
                      }
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
