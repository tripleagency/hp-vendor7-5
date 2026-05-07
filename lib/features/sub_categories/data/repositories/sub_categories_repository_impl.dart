import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/exceptions.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/features/sub_categories/data/datasources/sub_categories_remote_data_source.dart';
import 'package:home_plate_vendor/features/sub_categories/domain/entities/sub_category_entity.dart';
import 'package:home_plate_vendor/features/sub_categories/domain/repositories/sub_categories_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SubCategoriesRepository)
class SubCategoriesRepositoryImpl implements SubCategoriesRepository {
  final SubCategoriesRemoteDataSource remoteDataSource;

  const SubCategoriesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SubCategoryEntity>>> getSubCategories() {
    return _handle(() async => await remoteDataSource.getSubCategories());
  }

  @override
  Future<Either<Failure, SubCategoryEntity>> createSubCategory({
    required String nameEn,
    required String nameAr,
    required int categoryId,
  }) {
    return _handle(
      () async => await remoteDataSource.createSubCategory(
        nameEn: nameEn,
        nameAr: nameAr,
        categoryId: categoryId,
      ),
    );
  }

  @override
  Future<Either<Failure, SubCategoryEntity>> updateSubCategory({
    required int id,
    required String nameEn,
    required String nameAr,
    required int categoryId,
  }) {
    return _handle(
      () async => await remoteDataSource.updateSubCategory(
        id: id,
        nameEn: nameEn,
        nameAr: nameAr,
        categoryId: categoryId,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deleteSubCategory(int id) {
    return _handle(() async => await remoteDataSource.deleteSubCategory(id));
  }

  Future<Either<Failure, T>> _handle<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on ParseException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
