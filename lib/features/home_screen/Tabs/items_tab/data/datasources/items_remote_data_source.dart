import 'package:home_plate_vendor/core/api/dio_consumer.dart';
import 'package:home_plate_vendor/core/api/server_strings.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/data/models/item_model.dart';
import 'package:injectable/injectable.dart';

abstract class ItemsRemoteDataSource {
  Future<List<ItemModel>> getItems();
  Future<ItemModel> publishItem(int itemId);
  Future<ItemModel> pauseItem(int itemId);
}

@LazySingleton(as: ItemsRemoteDataSource)
class ItemsRemoteDataSourceImpl implements ItemsRemoteDataSource {
  final DioConsumer _apiConsumer;

  ItemsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<List<ItemModel>> getItems() async {
    final response = await _apiConsumer.get(ServerStrings.getItems);

    final List<dynamic> data = response['data'] ?? [];
    return data
        .map((item) => ItemModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  @override
  Future<ItemModel> publishItem(int itemId) async {
    final response = await _apiConsumer.post(
      ServerStrings.publishItem(itemId),
    );
    return ItemModel.fromJson(
      Map<String, dynamic>.from(response['data'] as Map),
    );
  }

  @override
  Future<ItemModel> pauseItem(int itemId) async {
    final response = await _apiConsumer.post(
      ServerStrings.pauseItem(itemId),
    );
    return ItemModel.fromJson(
      Map<String, dynamic>.from(response['data'] as Map),
    );
  }
}
