import 'package:dio/dio.dart';
import 'package:home_plate_vendor/core/api/dio_consumer.dart';
import 'package:home_plate_vendor/core/api/server_strings.dart';
import 'package:home_plate_vendor/features/add_item/domain/usecases/add_item_params.dart';
import 'package:injectable/injectable.dart';

abstract class AddItemRemoteDataSource {
  Future<String> addItem(AddItemParams params);
  Future<String> updateItem(int itemId, AddItemParams params);
  Future<void> deleteItem(int itemId);
}

@LazySingleton(as: AddItemRemoteDataSource)
class AddItemRemoteDataSourceImpl implements AddItemRemoteDataSource {
  final DioConsumer _api;

  AddItemRemoteDataSourceImpl(this._api);

  Future<FormData> _buildFormData(AddItemParams params) async {
    final Map<String, dynamic> data = params.toJson();

    // Handle multiple photos (only if any are provided)
    if (params.photos.isNotEmpty) {
      final List<MultipartFile> photoFiles = [];
      for (var photo in params.photos) {
        photoFiles.add(await MultipartFile.fromFile(photo.path));
      }
      data['photos[]'] = photoFiles;
    }

    // Sizes (Laravel multipart syntax: sizes[0][size], sizes[0][price])
    for (int i = 0; i < params.sizes.length; i++) {
      final s = params.sizes[i];
      data['sizes[$i][size]'] = s.size;
      data['sizes[$i][price]'] = s.price;
    }

    // Addons (Laravel multipart syntax: addons[0][name], addons[0][price])
    for (int i = 0; i < params.addons.length; i++) {
      final a = params.addons[i];
      data['addons[$i][name]'] = a.name;
      data['addons[$i][price]'] = a.price;
    }

    return FormData.fromMap(data);
  }

  @override
  Future<String> addItem(AddItemParams params) async {
    final formData = await _buildFormData(params);
    final response = await _api.postFormData(
      ServerStrings.vendorAddItem,
      formData: formData,
    );
    return response['message'] ?? 'Item created successfully';
  }

  @override
  Future<String> updateItem(int itemId, AddItemParams params) async {
    final formData = await _buildFormData(params);
    // Laravel form-data update typically uses POST + _method=PUT spoof.
    formData.fields.add(const MapEntry('_method', 'PUT'));
    final response = await _api.postFormData(
      ServerStrings.updateItem(itemId),
      formData: formData,
    );
    return response['message'] ?? 'Item updated successfully';
  }

  @override
  Future<void> deleteItem(int itemId) async {
    await _api.delete(ServerStrings.deleteItem(itemId));
  }
}
