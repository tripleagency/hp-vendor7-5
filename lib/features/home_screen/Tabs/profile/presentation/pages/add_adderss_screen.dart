import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/services/location_service.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/validators.dart';
import 'package:home_plate_vendor/core/widgets/custom_button.dart';
import 'package:home_plate_vendor/core/widgets/custom_text_field.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/presentation/pages/location_map_picker_screen.dart';
import 'package:latlong2/latlong.dart';

class AddAdderssScreen extends StatefulWidget {
  final Map<String, String>? existingAddress;
  final int? index;

  const AddAdderssScreen({super.key, this.existingAddress, this.index});

  @override
  State<AddAdderssScreen> createState() => _AddAdderssScreenState();
}

class _AddAdderssScreenState extends State<AddAdderssScreen> {
  final _formKey = GlobalKey<FormState>();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _townCityController = TextEditingController();
  final _reginStateController = TextEditingController();
  final _titleController = TextEditingController();

  LocationData? _selectedLocation;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingAddress != null) {
      _titleController.text = widget.existingAddress!['title'] ?? '';
      final fullAddress = widget.existingAddress!['address'] ?? '';
      final parts = fullAddress.split(',');
      if (parts.isNotEmpty) _address1Controller.text = parts[0].trim();
      if (parts.length > 1) _townCityController.text = parts[1].trim();
      if (parts.length > 2) _reginStateController.text = parts[2].trim();

      // إعادة بناء الموقع لو كان موجود مسبقاً
      final lat = double.tryParse(widget.existingAddress!['latitude'] ?? '');
      final lng = double.tryParse(widget.existingAddress!['longitude'] ?? '');
      final addr = widget.existingAddress!['location_address'];
      if (lat != null && lng != null) {
        _selectedLocation = LocationData(
          latitude: lat,
          longitude: lng,
          address: addr ?? '',
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _townCityController.dispose();
    _reginStateController.dispose();
    super.dispose();
  }

  /// فتح Map Picker لاختيار الموقع من الخريطة
  Future<void> _openMapPicker() async {
    final result = await Navigator.push<LocationData>(
      context,
      MaterialPageRoute(
        builder: (_) => LocationMapPickerScreen(
          initialLocation: _selectedLocation,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedLocation = result;
        // ملء الحقول تلقائياً لو فاضية
        if (_address1Controller.text.trim().isEmpty) {
          _address1Controller.text = result.address;
        }
      });
    }
  }

  /// الحصول على الموقع الحالي مباشرة
  Future<void> _useCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      final loc = await LocationService.getCurrentLocationAsAddress();
      if (mounted) {
        setState(() {
          _selectedLocation = loc;
          if (_address1Controller.text.trim().isEmpty) {
            _address1Controller.text = loc.address;
          }
        });
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('location_error_failed'.tr())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingAddress != null;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text(
          isEditing ? 'edit_address_title'.tr() : 'add_new_address_title'.tr(),
          style: AppStyles.inter18MediumBlack.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          children: [
            _buildSectionHeader(
              icon: Icons.location_city_outlined,
              title: 'address_details_section'.tr(),
            ),
            SizedBox(height: 12.h),
            _buildSectionCard(
              children: [
                _buildLabeledField(
                  label: 'title_field_label'.tr(),
                  controller: _titleController,
                  hint: 'address_title_hint'.tr(),
                  icon: Icons.bookmark_outline,
                  validator: Validators.name,
                ),
                _divider(),
                _buildLabeledField(
                  label: 'address_line1_label'.tr(),
                  controller: _address1Controller,
                  hint: 'address_line1_hint'.tr(),
                  icon: Icons.home_outlined,
                  validator: Validators.address,
                ),
                _divider(),
                _buildLabeledField(
                  label: 'address_line2_label'.tr(),
                  controller: _address2Controller,
                  hint: 'address_line2_hint'.tr(),
                  icon: Icons.apartment_outlined,
                  validator: Validators.address,
                ),
                _divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildLabeledField(
                        label: 'town_city_label'.tr(),
                        controller: _townCityController,
                        hint: 'town_city_hint'.tr(),
                        icon: Icons.location_on_outlined,
                        validator: Validators.city,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _buildLabeledField(
                        label: 'region_state_label'.tr(),
                        controller: _reginStateController,
                        hint: 'region_state_hint'.tr(),
                        icon: Icons.public_outlined,
                        validator: Validators.region,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 20.h),

            Row(
              children: [
                _buildSectionHeader(
                  icon: Icons.map_outlined,
                  title: 'location_section'.tr(),
                ),
                const Spacer(),
                if (_selectedLocation != null)
                  TextButton.icon(
                    onPressed: _openMapPicker,
                    icon: Icon(Icons.edit_outlined,
                        size: 16.sp, color: AppColors.primary),
                    label: Text(
                      'change'.tr(),
                      style: AppStyles.inter12Regular
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12.h),
            _buildMapSection(),

            SizedBox(height: 32.h),

            CustomElevatedButton(
              text: isEditing ? 'update_button'.tr() : 'save_button'.tr(),
              backGroundColor: AppColors.primary,
              textStyle: AppStyles.inter20Regularwhite,
              onButtonClicked: () {
                if (_formKey.currentState!.validate()) {
                  final newAddress = <String, String>{
                    'title': _titleController.text,
                    'address':
                        '${_address1Controller.text}, ${_townCityController.text}, ${_reginStateController.text}',
                    if (_selectedLocation != null) ...{
                      'latitude': _selectedLocation!.latitude.toString(),
                      'longitude': _selectedLocation!.longitude.toString(),
                      'location_address': _selectedLocation!.address,
                    },
                  };
                  Navigator.pop(context, newAddress);
                }
              },
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  // ============================================================
  //                       UI Helpers
  // ============================================================

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Row(
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
        Text(
          title,
          style: AppStyles.inter16MediumBlack.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      padding: EdgeInsets.all(14.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildLabeledField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14.sp, color: AppColors.textSecondary),
            SizedBox(width: 6.w),
            Text(
              label,
              style: AppStyles.inter12Regular.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        CustomTextField(
          controller: controller,
          validator: validator,
          hintText: hint,
          borderColor: AppColors.border,
          filledColor: AppColors.bg,
        ),
      ],
    );
  }

  Widget _divider() => Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: const Divider(height: 1, color: AppColors.divider),
      );

  // ============================================================
  //                       Map Section
  // ============================================================

  Widget _buildMapSection() {
    if (_selectedLocation == null) {
      return _buildEmptyMapPicker();
    }
    return _buildSelectedMapPreview();
  }

  Widget _buildEmptyMapPicker() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      padding: EdgeInsets.all(20.r),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_location_alt_outlined,
              color: AppColors.primary,
              size: 28.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'pick_location_title'.tr(),
            style: AppStyles.inter16MediumBlack.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'pick_location_subtitle'.tr(),
            style: AppStyles.inter12Regular
                .copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isLoadingLocation ? null : _useCurrentLocation,
                  icon: _isLoadingLocation
                      ? SizedBox(
                          width: 16.w,
                          height: 16.h,
                          child: const CircularProgressIndicator(
                              strokeWidth: 2),
                        )
                      : Icon(Icons.my_location,
                          size: 16.sp, color: AppColors.primary),
                  label: Text(
                    'use_current_location'.tr(),
                    style: AppStyles.inter12Regular
                        .copyWith(color: AppColors.primary),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _openMapPicker,
                  icon: Icon(Icons.map_outlined,
                      size: 16.sp, color: AppColors.white),
                  label: Text(
                    'pick_from_map'.tr(),
                    style: AppStyles.inter12Regular
                        .copyWith(color: AppColors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedMapPreview() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14.r),
              topRight: Radius.circular(14.r),
            ),
            child: GestureDetector(
              onTap: _openMapPicker,
              child: SizedBox(
                height: 160.h,
                width: double.infinity,
                child: Stack(
                  children: [
                    AbsorbPointer(
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                            _selectedLocation!.latitude,
                            _selectedLocation!.longitude,
                          ),
                          initialZoom: 15,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.none,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.basemaps.cartocdn.com/positron/{z}/{x}/{y}{r}.png',
                            subdomains: const ['a', 'b', 'c'],
                            maxNativeZoom: 19,
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(
                                  _selectedLocation!.latitude,
                                  _selectedLocation!.longitude,
                                ),
                                width: 40,
                                height: 40,
                                child: Icon(
                                  Icons.location_on,
                                  color: AppColors.primary,
                                  size: 36.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 8.h,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.touch_app,
                                size: 12.sp, color: AppColors.white),
                            SizedBox(width: 4.w),
                            Text(
                              'tap_to_change'.tr(),
                              style: AppStyles.inter12Regular.copyWith(
                                color: AppColors.white,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on,
                        color: AppColors.primary, size: 18.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        _selectedLocation!.address.isEmpty
                            ? 'selected_location_label'.tr()
                            : _selectedLocation!.address,
                        style: AppStyles.inter14Regular.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    _buildCoordinatePill(
                      icon: Icons.north,
                      label: 'lat',
                      value: _selectedLocation!.latitude.toStringAsFixed(5),
                    ),
                    SizedBox(width: 8.w),
                    _buildCoordinatePill(
                      icon: Icons.east,
                      label: 'lng',
                      value: _selectedLocation!.longitude.toStringAsFixed(5),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoordinatePill({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: AppColors.textSecondary),
          SizedBox(width: 4.w),
          Text(
            '$label:',
            style: AppStyles.inter12Regular
                .copyWith(color: AppColors.textSecondary, fontSize: 10.sp),
          ),
          SizedBox(width: 4.w),
          Text(
            value,
            style: AppStyles.inter12Regular.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}
