import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/area_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/domain/usecases/update_profile_params.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/presentation/manager/profile_cubit.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/validators.dart';
import 'package:home_plate_vendor/core/widgets/custom_button.dart';
import 'package:home_plate_vendor/core/widgets/custom_text_field.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/city_entity.dart';
import 'package:home_plate_vendor/features/general/domain/entities/country_entity.dart';
import 'package:home_plate_vendor/features/general/presentation/manager/general_cubit.dart';
import 'package:home_plate_vendor/features/general/presentation/widgets/city_dropdown_widget.dart';
import 'package:home_plate_vendor/features/general/presentation/widgets/area_dropdown_widget.dart';
import 'package:home_plate_vendor/features/general/presentation/widgets/country_dropdown_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:home_plate_vendor/core/utils/app_assets.dart';
import 'package:home_plate_vendor/core/utils/toast_helper.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  // Form key
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _restaurantNameController = TextEditingController();
  final _restaurantInfoController = TextEditingController();
  final _deliveryAddressController = TextEditingController();
  final _locationController = TextEditingController();

  // Working Time Controllers
  final _fromTimeController = TextEditingController();
  final _toTimeController = TextEditingController();

  // State variables
  CountryEntity? _selectedCountry;
  CityEntity? _selectedCity;
  AreaEntity? _selectedArea;
  double? _selectedLat;
  double? _selectedLng;
  String _selectedDay = 'monday';

  // Extra controllers
  final _deliveryPriceController = TextEditingController();
  final _deliveryTimeController = TextEditingController();

  File? _mainPhoto;
  final List<File?> _kitchenPhotos = [null, null, null];

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Fetch countries/cities/areas from API if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final generalCubit = context.read<GeneralCubit>();
      if (generalCubit.state.countries.isEmpty) generalCubit.fetchCountries();
      if (generalCubit.state.cities.isEmpty) generalCubit.fetchCities();
      if (generalCubit.state.areas.isEmpty) generalCubit.fetchAreas();
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _restaurantNameController.dispose();
    _restaurantInfoController.dispose();
    _deliveryAddressController.dispose();
    _locationController.dispose();
    _fromTimeController.dispose();
    _toTimeController.dispose();
    _deliveryPriceController.dispose();
    _deliveryTimeController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final profileCubit = context.read<ProfileCubit>();
    final vendor = profileCubit.state.vendor;
    if (vendor == null) return;

    _fullNameController.text = vendor.fullName;
    _emailController.text = vendor.email;
    _phoneController.text = vendor.phone;
    _restaurantNameController.text = vendor.restaurantName;
    _restaurantInfoController.text = vendor.restaurantInfo;
    _deliveryAddressController.text = vendor.deliveryAddress;
    _locationController.text = vendor.location;

    _selectedCity = vendor.city;
    _selectedArea = vendor.area;

    if (vendor.workingTime.isNotEmpty) {
      _selectedDay = vendor.workingTime['day'] ?? 'monday';
      _fromTimeController.text = vendor.workingTime['from'] ?? '';
      _toTimeController.text = vendor.workingTime['to'] ?? '';
    }
  }

  Future<void> _pickImage(ImageSource source, {int? kitchenIndex}) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'crop_image'.tr(),
              toolbarColor: AppColors.primary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: false,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
              ],
            ),
            IOSUiSettings(
              title: 'crop_image'.tr(),
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
              ],
            ),
          ],
        );

        if (croppedFile != null) {
          setState(() {
            if (kitchenIndex == null) {
              _mainPhoto = File(croppedFile.path);
            } else {
              _kitchenPhotos[kitchenIndex] = File(croppedFile.path);
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showError(context, 'error_picking_image'.tr());
      }
    }
  }

  void _showImageSourceDialog({int? kitchenIndex}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'select_image_source'.tr(),
              style: AppStyles.inter18RegularBlack,
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageSourceOption(
                  icon: Icons.camera_alt,
                  label: 'camera'.tr(),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera, kitchenIndex: kitchenIndex);
                  },
                ),
                _buildImageSourceOption(
                  icon: Icons.photo_library,
                  label: 'gallery'.tr(),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery, kitchenIndex: kitchenIndex);
                  },
                ),
              ],
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 120.w,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40.sp, color: AppColors.primary),
            SizedBox(height: 8.h),
            Text(label, style: AppStyles.inter14Regular),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primary,
            colorScheme: ColorScheme.light(primary: AppColors.primary),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final now = DateTime.now();
      final dt = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      final format = DateFormat('hh:mm a');
      controller.text = format.format(dt);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('profile_title'.tr(), style: AppStyles.inter20RegularBlack),
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.success) {
            ToastHelper.showSuccess(
              context,
              'vendor_updated_successfully'.tr(),
            );
            Navigator.pop(context);
          } else if (state.status == ProfileStatus.failure) {
            final errorMsg = state.errorMessage ?? 'error_updating_profile';
            ToastHelper.showError(context, errorMsg.tr());
          }
        },
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  return Skeletonizer(
                    enabled:
                        state.status == ProfileStatus.loading &&
                        state.vendor == null,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24.h),
                          Center(child: _buildMainPhotoSection()),
                          SizedBox(height: 32.h),

                          _buildSectionHeader('general_information'.tr()),
                          SizedBox(height: 16.h),
                          CustomTextField(
                            controller: _fullNameController,
                            hintText: 'full_name_label'.tr(),
                            validator: Validators.name,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z\s]'),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          CustomTextField(
                            controller: _emailController,
                            hintText: 'email_hint'.tr(),
                            keyBoardType: TextInputType.emailAddress,
                            validator: Validators.email,
                          ),
                          SizedBox(height: 12.h),
                          CustomTextField(
                            controller: _phoneController,
                            hintText: 'phone_number'.tr(),
                            keyBoardType: TextInputType.phone,
                            validator: Validators.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),

                          SizedBox(height: 24.h),
                          _buildSectionHeader('restaurant_information'.tr()),
                          SizedBox(height: 16.h),
                          CustomTextField(
                            controller: _restaurantNameController,
                            hintText: 'restaurant_name_label'.tr(),
                            validator: Validators.required,
                          ),
                          SizedBox(height: 12.h),
                          CustomTextField(
                            controller: _restaurantInfoController,
                            hintText: 'restaurant_info_label'.tr(),
                            maxLines: 3,
                            validator: Validators.required,
                          ),
                          SizedBox(height: 12.h),
                          BlocBuilder<GeneralCubit, GeneralState>(
                            builder: (context, state) {
                              final filteredCities = _selectedCountry == null
                                  ? state.cities
                                  : state.cities
                                        .where(
                                          (c) =>
                                              c.countryId ==
                                              _selectedCountry!.id.toString(),
                                        )
                                        .toList();
                              return Column(
                                children: [
                                  CountryDropdownWidget(
                                    countries: state.countries,
                                    selectedCountry: _selectedCountry,
                                    isLoading: state.isLoadingCountries,
                                    onChanged: (country) {
                                      setState(() {
                                        _selectedCountry = country;
                                        _selectedCity = null;
                                        _selectedArea = null;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 12.h),
                                  CityDropdownWidget(
                                    cities: filteredCities,
                                    selectedCity: _selectedCity,
                                    isLoading: state.isLoadingCities,
                                    onChanged: (city) {
                                      setState(() {
                                        _selectedCity = city;
                                        _selectedArea = null;
                                      });
                                    },
                                    validator: (_) => _selectedCity == null
                                        ? 'please_select_city'.tr()
                                        : null,
                                  ),
                                  SizedBox(height: 12.h),
                                  AreaDropdownWidget(
                                    areas: state.areas
                                        .where(
                                          (a) =>
                                              a.cityId ==
                                              _selectedCity?.id.toString(),
                                        )
                                        .toList(),
                                    selectedArea: _selectedArea,
                                    isLoading: state.isLoadingAreas,
                                    onChanged: (area) =>
                                        setState(() => _selectedArea = area),
                                    validator: (_) => _selectedArea == null
                                        ? 'please_select_area'.tr()
                                        : null,
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 12.h),
                          CustomTextField(
                            controller: _deliveryAddressController,
                            hintText: 'delivery_address_label'.tr(),
                            validator: Validators.required,
                          ),
                          SizedBox(height: 12.h),
                          CustomTextField(
                            controller: _locationController,
                            hintText: 'location_label'.tr(),
                            validator: Validators.required,
                          ),
                          SizedBox(height: 12.h),
                          CustomTextField(
                            controller: _deliveryPriceController,
                            hintText: 'delivery_price_label'.tr(),
                            keyBoardType: TextInputType.number,
                          ),
                          SizedBox(height: 12.h),
                          CustomTextField(
                            controller: _deliveryTimeController,
                            hintText: 'delivery_time_hint'.tr(),
                          ),

                          SizedBox(height: 24.h),
                          _buildSectionHeader('working_hours'.tr()),
                          SizedBox(height: 16.h),
                          _buildWorkingHoursEditor(),

                          SizedBox(height: 24.h),
                          _buildSectionHeader('kitchen_photos'.tr()),
                          SizedBox(height: 16.h),
                          _buildKitchenPhotosGrid(),

                          SizedBox(height: 40.h),
                          SizedBox(
                            width: double.infinity,
                            height: 56.h,
                            child: CustomElevatedButton(
                              text: 'save_button'.tr(),
                              onButtonClicked: _saveProfile,
                              textStyle: AppStyles.inter16RegularWhite,
                              backGroundColor: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state.status == ProfileStatus.loading &&
                    state.vendor != null) {
                  return Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        title,
        style: AppStyles.inter16RegularWhite.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMainPhotoSection() {
    final profileCubit = context.read<ProfileCubit>();
    final vendor = profileCubit.state.vendor;

    return InkWell(
      onTap: () => _showImageSourceDialog(),
      borderRadius: BorderRadius.circular(60.r),
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60.r,
            backgroundColor: AppColors.bg,
            backgroundImage: _mainPhoto != null ? FileImage(_mainPhoto!) : null,
            child:
                (_mainPhoto == null &&
                    (vendor?.mainPhoto != null && vendor!.mainPhoto.isNotEmpty))
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(60.r),
                    child: CachedNetworkImage(
                      imageUrl: vendor.mainPhoto,
                      fit: BoxFit.cover,
                      width: 120.r,
                      height: 120.r,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  )
                : (_mainPhoto == null &&
                      (vendor?.mainPhoto == null || vendor!.mainPhoto.isEmpty))
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(60.r),
                    child: Image.asset(AppAssets.profilePic, fit: BoxFit.cover),
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(Icons.camera_alt, color: Colors.white, size: 18.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingHoursEditor() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _selectedDay,
          decoration: InputDecoration(
            labelText: 'day'.tr(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          items:
              [
                'saturday',
                'sunday',
                'monday',
                'tuesday',
                'wednesday',
                'thursday',
                'friday',
              ].map((day) {
                return DropdownMenuItem(value: day, child: Text(day.tr()));
              }).toList(),
          onChanged: (val) => setState(() => _selectedDay = val!),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _fromTimeController,
                hintText: 'from_time_label'.tr(),
                readOnly: true,
                onTap: () => _selectTime(context, _fromTimeController),
                suffixIcon: Icon(Icons.access_time, size: 20.sp),
                validator: Validators.required,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomTextField(
                controller: _toTimeController,
                hintText: 'to_time_label'.tr(),
                readOnly: true,
                onTap: () => _selectTime(context, _toTimeController),
                suffixIcon: Icon(Icons.access_time, size: 20.sp),
                validator: Validators.required,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKitchenPhotosGrid() {
    final profileCubit = context.read<ProfileCubit>();
    final vendor = profileCubit.state.vendor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(3, (index) {
        String? remotePhoto;
        if (vendor != null && vendor.kitchenPhotos.length > index) {
          remotePhoto = vendor.kitchenPhotos[index];
        }

        return InkWell(
          onTap: () => _showImageSourceDialog(kitchenIndex: index),
          child: Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.gray.withOpacity(0.5)),
            ),
            child: _kitchenPhotos[index] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.file(
                      _kitchenPhotos[index]!,
                      fit: BoxFit.cover,
                    ),
                  )
                : (remotePhoto != null && remotePhoto.isNotEmpty)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CachedNetworkImage(
                      imageUrl: remotePhoto,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  )
                : Icon(Icons.add_a_photo, color: AppColors.gray, size: 30.sp),
          ),
        );
      }),
    );
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    final profileCubit = context.read<ProfileCubit>();
    final vendor = profileCubit.state.vendor;
    if (vendor == null) return;

    final params = UpdateProfileParams(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      restaurantName: _restaurantNameController.text.trim(),
      restaurantInfo: _restaurantInfoController.text.trim(),
      countryId: _selectedCountry?.id.toString(),
      cityId: _selectedCity?.id.toString() ?? '',
      areaId: _selectedArea?.id.toString() ?? '',
      deliveryAddress: _deliveryAddressController.text.trim(),
      location: _locationController.text.trim(),
      lat: _selectedLat,
      lng: _selectedLng,
      deliveryPrice: _deliveryPriceController.text.trim().isEmpty
          ? null
          : _deliveryPriceController.text.trim(),
      deliveryTime: _deliveryTimeController.text.trim().isEmpty
          ? null
          : _deliveryTimeController.text.trim(),
      mainPhoto: _mainPhoto,
      kitchenPhotos: _kitchenPhotos,
      workingTime: {
        'day': _selectedDay,
        'from': _fromTimeController.text,
        'to': _toTimeController.text,
      },
    );

    profileCubit.updateVendorProfile(vendor.id, params);
  }
}
