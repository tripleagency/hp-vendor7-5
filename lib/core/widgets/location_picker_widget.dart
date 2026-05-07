import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/services/location_service.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/toast_helper.dart';
import 'package:home_plate_vendor/core/widgets/custom_button.dart';

typedef LocationCallback = void Function(LocationData);

/// عنصر واجهة لاختيار الموقع الجغرافي
/// يسمح للمستخدم بالحصول على موقعه الحالي وتحويله لعنوان
class LocationPickerWidget extends StatefulWidget {
  final LocationCallback onLocationSelected;
  final LocationData? initialLocation;
  final bool showCoordinates;

  const LocationPickerWidget({
    super.key,
    required this.onLocationSelected,
    this.initialLocation,
    this.showCoordinates = false,
  });

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  LocationData? selectedLocation;
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.initialLocation;
  }

  /// الحصول على الموقع الحالي من الجهاز
  Future<void> _fetchLocation() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      LocationData locationData =
          await LocationService.getCurrentLocationAsAddress();

      setState(() {
        selectedLocation = locationData;
        isLoading = false;
      });

      widget.onLocationSelected(locationData);

      if (mounted) {
        ToastHelper.showSuccess(context, 'location_loaded'.tr());
      }
    } on LocationException catch (e) {
      // ترجمة رسالة الخطأ
      final translatedMessage = e.message.tr();
      setState(() {
        errorMessage = translatedMessage;
        isLoading = false;
      });

      if (mounted) {
        _showErrorDialog(translatedMessage);
      }
    } catch (e) {
      setState(() {
        errorMessage = 'location_error_failed'.tr();
        isLoading = false;
      });

      if (mounted) {
        _showErrorDialog('location_error_failed'.tr());
      }
    }
  }

  /// عرض نافذة الخطأ
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان القسم
        Text(
          'location_label'.tr(),
          style: AppStyles.inter16Regular.copyWith(color: Colors.grey),
        ),
        SizedBox(height: 12.h),

        // خريطة عرض المعلومات
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!, width: 1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: selectedLocation != null
              ? _buildLocationCard()
              : _buildEmptyState(),
        ),

        SizedBox(height: 16.h),

        // زر الحصول على الموقع
        CustomElevatedButton(
          text: isLoading
              ? 'location_getting'.tr()
              : 'get_location_button'.tr(),
          backGroundColor: AppColors.primary,
          textStyle: AppStyles.inter16Regular.copyWith(
            color: Colors.white,
          ),
          onButtonClicked: isLoading ? null : _fetchLocation,
        ),

        SizedBox(height: 12.h),

        // زر فتح الخريطة - معطل حالياً
        /*
        OutlinedButton.icon(
          onPressed: _openMapPicker,
          icon: Icon(Icons.map, color: AppColors.primary),
          label: Text('اختر من الخريطة'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary),
            padding: EdgeInsets.symmetric(vertical: 12.h),
          ),
        ),
        */

        // رسالة الخطأ
        if (errorMessage != null) ...[
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 20.sp),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    errorMessage!,
                    style: AppStyles.inter12Regular.copyWith(
                      color: Colors.red[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  /// بطاقة عرض الموقع المحدد
  Widget _buildLocationCard() {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppColors.primary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  selectedLocation!.address,
                  style: AppStyles.inter14Regular.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // الإحداثيات (إذا كانت مفعلة)
          if (widget.showCoordinates) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'location_latitude_label'.tr(),
                    style: AppStyles.inter12Regular.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    selectedLocation!.latitude.toStringAsFixed(6),
                    style: AppStyles.inter12Regular.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'location_longitude_label'.tr(),
                    style: AppStyles.inter12Regular.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    selectedLocation!.longitude.toStringAsFixed(6),
                    style: AppStyles.inter12Regular.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// حالة عدم وجود موقع محدد
  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_outlined,
              color: Colors.grey[400],
              size: 48.sp,
            ),
            SizedBox(height: 12.h),
            Text(
              'no_location_selected'.tr(),
              style: AppStyles.inter14Regular.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
