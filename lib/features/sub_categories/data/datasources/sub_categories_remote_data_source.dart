import 'package:home_plate_vendor/core/api/dio_consumer.dart';
import 'package:home_plate_vendor/core/api/server_strings.dart';
import 'package:home_plate_vendor/features/sub_categories/data/models/sub_category_model.dart';
import 'package:injectable/injectable.dart';

abstract class SubCategoriesRemoteDataSource {
  Future<List<SubCategoryModel>> getSubCategories();
  Future<SubCategoryModel> createSubCategory({
    required String nameEn,
    required String nameAr,
    required int categoryId,
  });
  Future<SubCategoryModel> updateSubCategory({
    required int id,
    required String nameEn,
    required String nameAr,
    required int categoryId,
  });
  Future<void> deleteSubCategory(int id);
}

@LazySingleton(as: SubCategoriesRemoteDataSource)
class SubCategoriesRemoteDataSourceImpl
    implements SubCategoriesRemoteDataSource {
  final DioConsumer _api;

  SubCategoriesRemoteDataSourceImpl(this._api);

  @override
  Future<List<SubCategoryModel>> getSubCategories() async {
    final response = await _api.get(ServerStrings.vendorSubCategories);
    final List<dynamic> data = response['data'] as List<dynamic>;
    return data
        .map(
          (e) => SubCategoryModel.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
  }

  @override
  Future<SubCategoryModel> createSubCategory({
    required String nameEn,
    required String nameAr,
    required int categoryId,
  }) async {
    final response = await _api.post(
      ServerStrings.vendorSubCategories,
      body: {
        'name_en': nameEn,
        'name_ar': nameAr,
        'category_id': categoryId,
      },
    );
    return SubCategoryModel.fromJson(
      Map<String, dynamic>.from(response['data'] as Map),
    );
  }

  @override
  Future<SubCategoryModel> updateSubCategory({
    required int id,
    required String nameEn,
    required String nameAr,
    required int categoryId,
  }) async {
    final response = await _api.put(
      ServerStrings.updateSubCategory(id),
      body: {
        'name_en': nameEn,
        'name_ar': nameAr,
        'category_id': categoryId,
      },
    );
    return SubCategoryModel.fromJson(
      Map<String, dynamic>.from(response['data'] as Map),
    );
  }

  @override
  Future<void> deleteSubCategory(int id) async {
    await _api.delete(ServerStrings.deleteSubCategory(id));
  }
}
