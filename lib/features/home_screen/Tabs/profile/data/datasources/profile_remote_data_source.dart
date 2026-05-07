import 'package:home_plate_vendor/core/api/server_strings.dart';
import 'package:home_plate_vendor/core/api/dio_consumer.dart';
import 'package:home_plate_vendor/features/auth/data/models/responses/vendor_model.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/domain/usecases/update_profile_params.dart';
import 'package:injectable/injectable.dart';

abstract class ProfileRemoteDataSource {
  Future<VendorModel> getVendorProfile(int vendorId);
  Future<VendorModel> updateVendorProfile(
    int vendorId,
    UpdateProfileParams params,
  );
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioConsumer _apiConsumer;

  ProfileRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<VendorModel> getVendorProfile(int vendorId) async {
    final response = await _apiConsumer.get(
      '${ServerStrings.vendorProfile}$vendorId',
    );
    return VendorModel.fromJson(response['data']);
  }

  @override
  Future<VendorModel> updateVendorProfile(
    int vendorId,
    UpdateProfileParams params,
  ) async {
    final response = await _apiConsumer.postFormData(
      '${ServerStrings.vendorProfile}$vendorId',
      formData: await params.toFormData(),
    );
    return VendorModel.fromJson(response['data']);
  }
}
