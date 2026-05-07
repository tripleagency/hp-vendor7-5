import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/services/location_service.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/widgets/custom_button.dart';

/// صفحة اختيار الموقع من الخريطة
/// Location Map Picker Screen
class LocationMapPickerScreen extends StatefulWidget {
  final LocationData? initialLocation;

  const LocationMapPickerScreen({
    super.key,
    this.initialLocation,
  });

  @override
  State<LocationMapPickerScreen> createState() =>
      _LocationMapPickerScreenState();
}

class _LocationMapPickerScreenState extends State<LocationMapPickerScreen> {
  late MapController mapController;
  LocationData? selectedLocation;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    selectedLocation = widget.initialLocation;
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    if (widget.initialLocation != null) {
      _moveToLocation(
        widget.initialLocation!.latitude,
        widget.initialLocation!.longitude,
      );
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => isLoading = true);
    try {
      LocationData location =
          await LocationService.getCurrentLocationAsAddress();
      setState(() => selectedLocation = location);
      _moveToLocation(location.latitude, location.longitude);
    } catch (e) {
      _showErrorDialog('location_fetch_error'.tr());
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _moveToLocation(double lat, double lng) {
    mapController.move(LatLng(lat, lng), 16);
  }

  Future<void> _onMapTap(LatLng latlng) async {
    setState(() => isLoading = true);
    try {
      // تحويل الإحداثيات المختارة لعنوان
      String address = await LocationService.getAddressFromCoordinates(
        latlng.latitude,
        latlng.longitude,
      );

      setState(() {
        selectedLocation = LocationData(
          latitude: latlng.latitude,
          longitude: latlng.longitude,
          address: address,
        );
      });

      _moveToLocation(latlng.latitude, latlng.longitude);
    } catch (e) {
      _showErrorDialog('location_conversion_error'.tr());
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('location_error_title'.tr()),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ok_button'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'location_map_picker_title'.tr(),
          style: AppStyles.inter20RegularBlack,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // الخريطة
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: selectedLocation != null
                  ? LatLng(selectedLocation!.latitude, selectedLocation!.longitude)
                  : LatLng(30.0444, 31.2357), // Cairo coordinates
              initialZoom: 16,
              onTap: (tapPosition, latlng) => _onMapTap(latlng),
            ),
            children: [
              // Cartodb Tiles (يتبع سياسة الاستخدام بشكل صحيح)
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/positron/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c'],
                maxNativeZoom: 19,
              ),
              // Marker للموقع المختار
              if (selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        selectedLocation!.latitude,
                        selectedLocation!.longitude,
                      ),
                      width: 80,
                      height: 80,
                      child: Column(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Loading Indicator
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            ),

          // تفاصيل الموقع في الأسفل
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildLocationDetailsCard(),
          ),

          // زر الموقع الحالي
          Positioned(
            bottom: 300.h,
            right: 16.w,
            child: FloatingActionButton.small(
              backgroundColor: AppColors.primary,
              onPressed: _getCurrentLocation,
              child: Icon(Icons.my_location, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            if (selectedLocation != null) ...[
              // العنوان
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'selected_location_label'.tr(),
                          style: AppStyles.inter12Regular.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          selectedLocation!.address,
                          style: AppStyles.inter14Regular.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // الإحداثيات
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'location_latitude_label'.tr(),
                          style: AppStyles.inter12Regular.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          selectedLocation!.latitude.toStringAsFixed(6),
                          style: AppStyles.inter12Regular.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    VerticalDivider(
                      color: Colors.grey[300],
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'location_longitude_label'.tr(),
                          style: AppStyles.inter12Regular.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          selectedLocation!.longitude.toStringAsFixed(6),
                          style: AppStyles.inter12Regular.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // زر التأكيد
              CustomElevatedButton(
                text: 'confirm_location_button'.tr(),
                backGroundColor: AppColors.primary,
                textStyle: AppStyles.inter16Regular.copyWith(
                  color: Colors.white,
                ),
                onButtonClicked: () {
                  Navigator.pop(context, selectedLocation);
                },
              ),
            ] else ...[
              // حالة عدم اختيار موقع
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app,
                      color: Colors.grey[400],
                      size: 48.sp,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'tap_to_select_location'.tr(),
                      style: AppStyles.inter14Regular.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
