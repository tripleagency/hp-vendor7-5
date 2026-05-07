import 'package:home_plate_vendor/core/api/dio_consumer.dart';
import 'package:home_plate_vendor/core/api/server_strings.dart';
import 'package:home_plate_vendor/features/addresses/data/models/address_model.dart';
import 'package:injectable/injectable.dart';

abstract class AddressesRemoteDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> createAddress({
    required String title,
    required String addressLine1,
    String? addressLine2,
    required String townCity,
    required String regionState,
    required double lat,
    required double lng,
  });
  Future<AddressModel> updateAddress({
    required int id,
    required String title,
    required String addressLine1,
    String? addressLine2,
    required String townCity,
    required String regionState,
    required double lat,
    required double lng,
  });
  Future<void> deleteAddress(int id);
}

@LazySingleton(as: AddressesRemoteDataSource)
class AddressesRemoteDataSourceImpl implements AddressesRemoteDataSource {
  final DioConsumer _api;

  AddressesRemoteDataSourceImpl(this._api);

  @override
  Future<List<AddressModel>> getAddresses() async {
    final response = await _api.get(ServerStrings.vendorAddresses);
    final List<dynamic> data = response['data'] as List<dynamic>;
    return data
        .map((e) => AddressModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<AddressModel> createAddress({
    required String title,
    required String addressLine1,
    String? addressLine2,
    required String townCity,
    required String regionState,
    required double lat,
    required double lng,
  }) async {
    final response = await _api.post(
      ServerStrings.vendorAddresses,
      body: {
        'title': title,
        'address_line_1': addressLine1,
        if (addressLine2 != null && addressLine2.isNotEmpty)
          'address_line_2': addressLine2,
        'town_city': townCity,
        'region_state': regionState,
        'lat': lat,
        'lng': lng,
      },
    );
    return AddressModel.fromJson(
      Map<String, dynamic>.from(response['data'] as Map),
    );
  }

  @override
  Future<AddressModel> updateAddress({
    required int id,
    required String title,
    required String addressLine1,
    String? addressLine2,
    required String townCity,
    required String regionState,
    required double lat,
    required double lng,
  }) async {
    final response = await _api.put(
      ServerStrings.updateAddress(id),
      body: {
        'title': title,
        'address_line_1': addressLine1,
        if (addressLine2 != null && addressLine2.isNotEmpty)
          'address_line_2': addressLine2,
        'town_city': townCity,
        'region_state': regionState,
        'lat': lat,
        'lng': lng,
      },
    );
    return AddressModel.fromJson(
      Map<String, dynamic>.from(response['data'] as Map),
    );
  }

  @override
  Future<void> deleteAddress(int id) async {
    await _api.delete(ServerStrings.deleteAddress(id));
  }
}
