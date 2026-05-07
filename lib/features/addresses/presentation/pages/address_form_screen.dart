import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_plate_vendor/core/services/location_service.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/utils/app_assets.dart';
import 'package:home_plate_vendor/core/utils/toast_helper.dart';
import 'package:home_plate_vendor/core/utils/validators.dart';
import 'package:home_plate_vendor/core/widgets/custom_button.dart';
import 'package:home_plate_vendor/core/widgets/custom_text_field.dart';
import 'package:home_plate_vendor/features/addresses/domain/entities/address_entity.dart';
import 'package:home_plate_vendor/features/addresses/presentation/manager/addresses_cubit.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/presentation/pages/location_map_picker_screen.dart';

class AddressFormScreen extends StatefulWidget {
  final AddressEntity? existing;

  const AddressFormScreen({super.key, this.existing});

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _line1Controller;
  late final TextEditingController _line2Controller;
  late final TextEditingController _townCityController;
  late final TextEditingController _regionStateController;
  double? _lat;
  double? _lng;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _titleController = TextEditingController(text: e?.title ?? '');
    _line1Controller = TextEditingController(text: e?.addressLine1 ?? '');
    _line2Controller = TextEditingController(text: e?.addressLine2 ?? '');
    _townCityController = TextEditingController(text: e?.townCity ?? '');
    _regionStateController = TextEditingController(text: e?.regionState ?? '');
    _lat = e?.lat;
    _lng = e?.lng;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _line1Controller.dispose();
    _line2Controller.dispose();
    _townCityController.dispose();
    _regionStateController.dispose();
    super.dispose();
  }

  Future<void> _pickLocation() async {
    final selected = await Navigator.of(context).push<LocationData>(
      MaterialPageRoute(
        builder: (_) => LocationMapPickerScreen(
          initialLocation: (_lat != null && _lng != null)
              ? LocationData(
                  latitude: _lat!,
                  longitude: _lng!,
                  address: _line1Controller.text,
                )
              : null,
        ),
      ),
    );
    if (selected != null) {
      setState(() {
        _lat = selected.latitude;
        _lng = selected.longitude;
        if (_line1Controller.text.isEmpty) {
          _line1Controller.text = selected.address;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_lat == null || _lng == null) {
      ToastHelper.showError(context, 'please_pick_location_on_map'.tr());
      return;
    }
    final cubit = context.read<AddressesCubit>();
    final ok = await cubit.save(
      id: widget.existing?.id,
      title: _titleController.text.trim(),
      addressLine1: _line1Controller.text.trim(),
      addressLine2: _line2Controller.text.trim().isEmpty
          ? null
          : _line2Controller.text.trim(),
      townCity: _townCityController.text.trim(),
      regionState: _regionStateController.text.trim(),
      lat: _lat!,
      lng: _lng!,
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
          isEdit ? 'edit_address'.tr() : 'add_address'.tr(),
          style: AppStyles.inter18MediumBlack.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<AddressesCubit, AddressesState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    hintText: 'branch_title_hint'.tr(),
                    controller: _titleController,
                    validator: (v) => Validators.required(
                      v,
                      fieldName: 'branch_title_hint'.tr(),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    hintText: 'address_line_1'.tr(),
                    controller: _line1Controller,
                    validator: (v) => Validators.required(
                      v,
                      fieldName: 'address_line_1'.tr(),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    hintText: 'address_line_2'.tr(),
                    controller: _line2Controller,
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    hintText: 'town_city'.tr(),
                    controller: _townCityController,
                    validator: (v) => Validators.required(
                      v,
                      fieldName: 'town_city'.tr(),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    hintText: 'region_state'.tr(),
                    controller: _regionStateController,
                    validator: (v) => Validators.required(
                      v,
                      fieldName: 'region_state'.tr(),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: _pickLocation,
                    child: Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.map_outlined,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              _lat == null || _lng == null
                                  ? 'tap_to_select_location'.tr()
                                  : 'lat: ${_lat!.toStringAsFixed(5)}, lng: ${_lng!.toStringAsFixed(5)}',
                              style: AppStyles.inter12Regular,
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
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
