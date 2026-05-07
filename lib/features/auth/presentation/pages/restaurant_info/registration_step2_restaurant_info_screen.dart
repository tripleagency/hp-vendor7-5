import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/widgets/custom_button.dart';
import 'package:home_plate_vendor/core/widgets/custom_text_field.dart';
import 'package:home_plate_vendor/core/widgets/custom_image_upload.dart';
import 'package:home_plate_vendor/core/utils/app_assets.dart';
import 'package:home_plate_vendor/core/utils/validators.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/area_entity.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/city_entity.dart';
import 'package:home_plate_vendor/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:home_plate_vendor/core/utils/toast_helper.dart';
import 'package:home_plate_vendor/core/routes/navigation_helper.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/verify_registration_usecase.dart';
import 'package:home_plate_vendor/core/di/di.dart';
import 'package:home_plate_vendor/features/auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:home_plate_vendor/features/auth/presentation/manager/verify_registration_cubit/verify_registration_cubit.dart';
import 'package:home_plate_vendor/features/auth/presentation/pages/register/verify_registration_screen.dart';
import 'package:home_plate_vendor/features/auth/presentation/widgets/working_hours_row.dart';
import 'package:home_plate_vendor/features/general/presentation/manager/general_cubit.dart';
import 'package:home_plate_vendor/features/general/presentation/widgets/area_dropdown_widget.dart';
import 'package:home_plate_vendor/features/general/presentation/widgets/city_dropdown_widget.dart';
import 'package:home_plate_vendor/features/general/presentation/widgets/country_dropdown_widget.dart';
import 'package:home_plate_vendor/features/general/domain/entities/category_entity.dart';
import 'package:home_plate_vendor/features/general/domain/entities/country_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/presentation/pages/location_map_picker_screen.dart';
import 'package:home_plate_vendor/core/services/location_service.dart';

class RegistrationStep2RestaurantInfoScreen extends StatefulWidget {
  const RegistrationStep2RestaurantInfoScreen({super.key});

  @override
  State<RegistrationStep2RestaurantInfoScreen> createState() =>
      _RegistrationStep2RestaurantInfoScreenState();
}

class _RegistrationStep2RestaurantInfoScreenState
    extends State<RegistrationStep2RestaurantInfoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ── Controllers ──────────────────────────────────────────────────────────
  late final TextEditingController _nameController;
  late final TextEditingController _infoController;
  late final TextEditingController _addressController;
  late final TextEditingController _locationController;
  late final TextEditingController _deliveryPriceController;
  late final TextEditingController _deliveryTimeController;

  // ── Coordinates (from map picker) ───────────────────────────────────────
  double? _selectedLat;
  double? _selectedLng;

  // ── Country / City / Area (from API via GeneralCubit) ───────────────────
  CountryEntity? _selectedCountry;
  CityEntity? _selectedCity;
  AreaEntity? _selectedArea;

  // ── Categories (multi-select) ──────────────────────────────────────────
  final Set<int> _selectedCategoryIds = <int>{};

  // ── Photos ────────────────────────────────────────────────────────────────
  File? _mainPhoto;
  List<File?> _kitchenPhotos = [null, null, null];

  // ── Working hours ─────────────────────────────────────────────────────────
  final List<String> _dayKeys = [
    'day_saturday',
    'day_sunday',
    'day_monday',
    'day_tuesday',
    'day_wednesday',
    'day_thursday',
    'day_friday',
  ];

  final List<String> _availableTimes = [
    '8:00 AM',
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
    '6:00 PM',
    '7:00 PM',
    '8:00 PM',
    '9:00 PM',
    '10:00 PM',
    '11:00 PM',
    '12:00 AM',
  ];

  final Map<String, bool> _selectedDays = {};
  final Map<String, String> _fromTimes = {};
  final Map<String, String> _toTimes = {};

  @override
  void initState() {
    super.initState();
    // Pre-fill from cubit (preserves data on back navigation)
    final data = context.read<RegisterCubit>().formData;

    _nameController = TextEditingController(text: data.restaurantName);
    _infoController = TextEditingController(text: data.restaurantInfo);
    _addressController = TextEditingController(text: data.deliveryAddress);
    _locationController = TextEditingController(text: data.location);
    _deliveryPriceController = TextEditingController(text: data.deliveryPrice);
    _deliveryTimeController = TextEditingController(text: data.deliveryTime);
    _selectedLat = data.lat;
    _selectedLng = data.lng;
    _mainPhoto = data.mainPhoto;
    _kitchenPhotos = List<File?>.from(data.kitchenPhotos);

    // Fetch countries, cities, areas & categories from API
    final generalCubit = context.read<GeneralCubit>();
    if (generalCubit.state.countries.isEmpty) generalCubit.fetchCountries();
    if (generalCubit.state.cities.isEmpty) generalCubit.fetchCities();
    if (generalCubit.state.areas.isEmpty) generalCubit.fetchAreas();
    if (generalCubit.state.categories.isEmpty) generalCubit.fetchCategories();

    // Restore previously selected categories
    _selectedCategoryIds.addAll(data.categoryIds);

    // Init working days
    for (final key in _dayKeys) {
      _selectedDays[key] = false;
    }
    // Restore saved working times
    for (final wt in data.workingTimes) {
      _selectedDays[wt.day] = true;
      _fromTimes[wt.day] = wt.from;
      _toTimes[wt.day] = wt.to;
    }
    // Default if none saved
    if (data.workingTimes.isEmpty) {
      _selectedDays['day_saturday'] = true;
      _fromTimes['day_saturday'] = '10:00 AM';
      _toTimes['day_saturday'] = '6:00 PM';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _infoController.dispose();
    _addressController.dispose();
    _locationController.dispose();
    _deliveryPriceController.dispose();
    _deliveryTimeController.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  List<WorkingTimeEntity> _buildWorkingTimes() {
    final List<WorkingTimeEntity> times = [];
    for (final key in _dayKeys) {
      if (_selectedDays[key] == true &&
          _fromTimes[key] != null &&
          _toTimes[key] != null) {
        times.add(
          WorkingTimeEntity(
            day: key.replaceFirst('day_', ''), // "saturday", "sunday", …
            from: _fromTimes[key]!,
            to: _toTimes[key]!,
          ),
        );
      }
    }
    return times;
  }

  Future<void> _onSubmit(RegisterCubit cubit) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_mainPhoto == null) {
      ToastHelper.showError(context, 'error_select_main_photo'.tr());
      return;
    }

    if (_selectedCountry == null ||
        _selectedCity == null ||
        _selectedArea == null) {
      ToastHelper.showError(context, 'error_field_required'.tr());
      return;
    }

    if (_selectedLat == null || _selectedLng == null) {
      ToastHelper.showError(context, 'please_pick_location_on_map'.tr());
      return;
    }

    if (_selectedCategoryIds.isEmpty) {
      ToastHelper.showError(context, 'please_select_category'.tr());
      return;
    }

    final workingTimes = _buildWorkingTimes();
    if (workingTimes.isEmpty) {
      ToastHelper.showError(context, 'error_select_working_day'.tr());
      return;
    }

    // Save step 2 into cubit then fire the API call
    cubit.saveStep2(
      restaurantName: _nameController.text.trim(),
      restaurantInfo: _infoController.text.trim(),
      countryId: _selectedCountry!.id,
      cityId: _selectedCity!.id,
      areaId: _selectedArea!.id,
      deliveryAddress: _addressController.text.trim(),
      location: _locationController.text.trim(),
      lat: _selectedLat!,
      lng: _selectedLng!,
      deliveryPrice: _deliveryPriceController.text.trim(),
      deliveryTime: _deliveryTimeController.text.trim(),
      mainPhoto: _mainPhoto!,
      kitchenPhotos: _kitchenPhotos,
      workingTimes: workingTimes,
      categoryIds: _selectedCategoryIds.toList(),
    );

    await cubit.submitRegistration();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFailure) {
          ToastHelper.showError(context, state.message);
        }
        if (state is RegisterSuccess) {
          // Navigate to OTP verification screen
          context.slideFromBottom(
            BlocProvider(
              create: (context) => VerifyRegistrationCubit(
                verifyRegistrationUseCase: sl<VerifyRegistrationUseCase>(),
              ),
              child: VerifyRegistrationScreen(
                phone: context.read<RegisterCubit>().formData.phone,
              ),
            ),
          );
          ToastHelper.showSuccess(context, state.response.message);
        }
      },
      builder: (context, state) {
        final cubit = context.read<RegisterCubit>();
        final isLoading = state is RegisterLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.black),
              onPressed: isLoading ? null : () => Navigator.pop(context),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0,
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'restaurant_info_title'.tr(),
                    style: AppStyles.inter26Regular.copyWith(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'restaurant_info_subtitle'.tr(),
                    style: AppStyles.inter14Regular.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 28.h),

                  // ── Main Photo ──────────────────────────────────────────
                  _SectionHeader(
                    icon: Icons.restaurant_menu_rounded,
                    title: 'section_main_photo'.tr(),
                  ),
                  SizedBox(height: 12.h),
                  Center(
                    child: CustomImageUpload(
                      text: 'main_photo_label'.tr(),
                      height: 120.h,
                      width: 120.w,
                      file: _mainPhoto,
                      onImageSelected: (file) {
                        setState(() => _mainPhoto = file);
                      },
                    ),
                  ),
                  SizedBox(height: 28.h),

                  // ── Basic Info ──────────────────────────────────────────
                  _SectionHeader(
                    icon: Icons.info_outline_rounded,
                    title: 'section_basic_info'.tr(),
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    controller: _nameController,
                    hintText: 'restaurant_name_label'.tr(),
                    validator: (val) => Validators.required(
                      val,
                      fieldName: 'restaurant_name_label'.tr(),
                    ),
                    prefixIcon: Icon(
                      Icons.storefront_outlined,
                      color: AppColors.primary,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // ── Restaurant Info ─────────────────────────────────────
                  CustomTextField(
                    controller: _infoController,
                    hintText: 'restaurant_info_label'.tr(),
                    maxLines: 3,
                    validator: (val) => Validators.required(
                      val,
                      fieldName: 'restaurant_info_label'.tr(),
                    ),
                  ),
                  SizedBox(height: 28.h),

                  // ── Address Section header ──────────────────────────────
                  _SectionHeader(
                    icon: Icons.location_city_rounded,
                    title: 'section_address'.tr(),
                  ),
                  SizedBox(height: 12.h),

                  // ── Country ─────────────────────────────────────────────
                  BlocBuilder<GeneralCubit, GeneralState>(
                    builder: (context, generalState) {
                      return CountryDropdownWidget(
                        countries: generalState.countries,
                        selectedCountry: _selectedCountry,
                        isLoading: generalState.isLoadingCountries,
                        onChanged: (country) {
                          setState(() {
                            _selectedCountry = country;
                            _selectedCity = null; // cascade reset
                            _selectedArea = null; // cascade reset
                          });
                        },
                        validator: (_) => _selectedCountry == null
                            ? 'please_select_country'.tr()
                            : null,
                      );
                    },
                  ),
                  SizedBox(height: 12.h),

                  // ── City (filtered by country) ──────────────────────────
                  BlocBuilder<GeneralCubit, GeneralState>(
                    builder: (context, generalState) {
                      final filteredCities = _selectedCountry == null
                          ? <CityEntity>[]
                          : generalState.cities
                                .where(
                                  (c) =>
                                      c.countryId ==
                                      _selectedCountry!.id.toString(),
                                )
                                .toList();
                      return CityDropdownWidget(
                        cities: filteredCities,
                        selectedCity: _selectedCity,
                        isLoading: generalState.isLoadingCities,
                        onChanged: (city) {
                          setState(() {
                            _selectedCity = city;
                            _selectedArea = null; // cascade reset
                          });
                        },
                        validator: (_) => _selectedCity == null
                            ? 'please_select_city'.tr()
                            : null,
                      );
                    },
                  ),
                  SizedBox(height: 12.h),

                  // ── Area ─────────────────────────────────────────────────
                  BlocBuilder<GeneralCubit, GeneralState>(
                    builder: (context, generalState) {
                      // Filter areas by selected city
                      final filteredAreas = _selectedCity == null
                          ? <AreaEntity>[]
                          : generalState.areas
                                .where(
                                  (a) =>
                                      a.cityId == _selectedCity!.id.toString(),
                                )
                                .toList();
                      return AreaDropdownWidget(
                        areas: filteredAreas,
                        selectedArea: _selectedArea,
                        isLoading: generalState.isLoadingAreas,
                        onChanged: (area) =>
                            setState(() => _selectedArea = area),
                        validator: (_) => _selectedArea == null
                            ? 'please_select_area'.tr()
                            : null,
                      );
                    },
                  ),
                  SizedBox(height: 12.h),

                  SizedBox(height: 16.h),
                  // ── Categories (multi-select) ──────────────────────────
                  _SectionHeader(
                    icon: Icons.category_outlined,
                    title: 'categories_label'.tr(),
                  ),
                  SizedBox(height: 12.h),
                  BlocBuilder<GeneralCubit, GeneralState>(
                    builder: (context, generalState) {
                      if (generalState.isLoadingCategories) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (generalState.categories.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Text(
                            'no_categories'.tr(),
                            style: AppStyles.inter14Regular.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }
                      final isAr =
                          context.locale.languageCode == 'ar';
                      return Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: generalState.categories.map((c) {
                          final selected =
                              _selectedCategoryIds.contains(c.id);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selected) {
                                  _selectedCategoryIds.remove(c.id);
                                } else {
                                  _selectedCategoryIds.add(c.id);
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.primary
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(24.r),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                  width: 1.2,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (selected) ...[
                                    Icon(
                                      Icons.check_circle,
                                      size: 16.sp,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 6.w),
                                  ],
                                  Text(
                                    isAr ? c.nameAr : c.nameEn,
                                    style: AppStyles.inter14Regular.copyWith(
                                      color: selected
                                          ? Colors.white
                                          : AppColors.black,
                                      fontWeight: selected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  SizedBox(height: 12.h),

                  SizedBox(height: 24.h),
                  // ── Delivery Section header ─────────────────────────────
                  _SectionHeader(
                    icon: Icons.local_shipping_outlined,
                    title: 'section_delivery'.tr(),
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    hintText: 'delivery_address_label'.tr(),
                    controller: _addressController,
                    validator: (val) => Validators.required(
                      val,
                      fieldName: 'delivery_address_label'.tr(),
                    ),
                    prefixIcon: Icon(
                      Icons.home_outlined,
                      color: AppColors.primary,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // ── Location (Map) ─────────────────────────
                  Padding(
                    padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
                    child: Text(
                      'location_label'.tr(),
                      style: AppStyles.inter14Regular.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  CustomTextField(
                    hintText: 'location_hint'.tr(),
                    controller: _locationController,
                    keyBoardType: TextInputType.url,
                    validator: (val) => Validators.required(
                      val,
                      fieldName: 'location_label'.tr(),
                    ),
                    prefixIcon: Icon(
                      Icons.place_outlined,
                      color: AppColors.primary,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // ── Delivery Price ─────────────────────────────────────
                  CustomTextField(
                    hintText: 'delivery_price_label'.tr(),
                    controller: _deliveryPriceController,
                    keyBoardType: TextInputType.number,
                    validator: (val) => Validators.required(
                      val,
                      fieldName: 'delivery_price_label'.tr(),
                    ),
                    prefixIcon: Icon(
                      Icons.attach_money_rounded,
                      color: AppColors.primary,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // ── Delivery Time ─────────────────────────────────────
                  CustomTextField(
                    hintText: 'delivery_time_hint'.tr(),
                    controller: _deliveryTimeController,
                    validator: (val) => Validators.required(
                      val,
                      fieldName: 'delivery_time_label'.tr(),
                    ),
                    prefixIcon: Icon(
                      Icons.timer_outlined,
                      color: AppColors.primary,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Map preview — tap to open the map picker
                  GestureDetector(
                    onTap: () async {
                      final selected = await Navigator.of(context).push<LocationData>(
                        MaterialPageRoute(
                          builder: (_) => const LocationMapPickerScreen(),
                        ),
                      );
                      if (selected != null) {
                        setState(() {
                          _locationController.text = selected.address;
                          _selectedLat = selected.latitude;
                          _selectedLng = selected.longitude;
                        });
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.asset(
                            AppAssets.map,
                            height: 144.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.map_outlined,
                                color: AppColors.primary,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'tap_to_select_location'.tr(),
                                style: AppStyles.inter12Regular.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28.h),

                  // ── Kitchen Photos ──────────────────────────────────────
                  _SectionHeader(
                    icon: Icons.photo_library_outlined,
                    title: 'section_kitchen_photos'.tr(),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(3, (i) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: i < 2 ? 8.w : 0),
                          child: CustomImageUpload(
                            text: 'add_kitchen_photo'.tr(),
                            height: 80.h,
                            width: double.infinity,
                            file: _kitchenPhotos[i],
                            onImageSelected: (file) {
                              setState(() => _kitchenPhotos[i] = file);
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 28.h),

                  // ── Working Hours ───────────────────────────────────────
                  _SectionHeader(
                    icon: Icons.schedule_rounded,
                    title: 'section_working_hours'.tr(),
                  ),
                  SizedBox(height: 12.h),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _dayKeys.length,
                    itemBuilder: (context, index) {
                      final dayKey = _dayKeys[index];
                      return WorkingHoursRow(
                        day: dayKey.tr(),
                        isSelected: _selectedDays[dayKey] ?? false,
                        fromTime: _fromTimes[dayKey],
                        toTime: _toTimes[dayKey],
                        times: _availableTimes,
                        onCheckboxChanged: (val) {
                          setState(() => _selectedDays[dayKey] = val ?? false);
                        },
                        onFromChanged: (val) {
                          setState(() => _fromTimes[dayKey] = val ?? '');
                        },
                        onToChanged: (val) {
                          setState(() => _toTimes[dayKey] = val ?? '');
                        },
                      );
                    },
                  ),
                  SizedBox(height: 24.h),

                  // ── Submit Button ───────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: CustomElevatedButton(
                      text: isLoading ? '' : 'complete_registration'.tr(),
                      onButtonClicked: isLoading
                          ? null
                          : () => _onSubmit(cubit),
                      textStyle: AppStyles.inter16RegularWhite,
                      backGroundColor: AppColors.primary,
                      isLoading: isLoading,
                    ),
                  ),
                  SizedBox(height: 60.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Reusable section header with an icon + title used to group form sections.
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18.sp),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: AppStyles.inter16Regular.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
