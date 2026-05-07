import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/exceptions.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/features/add_item/data/datasources/add_item_remote_datasource.dart';
import 'package:home_plate_vendor/features/add_item/domain/repositories/i_add_item_repository.dart';
import 'package:home_plate_vendor/features/add_item/domain/usecases/add_item_params.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IAddItemRepository)
class AddItemRepositoryImpl implements IAddItemRepository {
  final AddItemRemoteDataSource _remoteDataSource;

  AddItemRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, String>> addItem(AddItemParams params) async {
    return _execute(() => _remoteDataSource.addItem(params));
  }

  @override
  Future<Either<Failure, String>> updateItem(
    int itemId,
    AddItemParams params,
  ) async {
    return _execute(() => _remoteDataSource.updateItem(itemId, params));
  }

  @override
  Future<Either<Failure, void>> deleteItem(int itemId) async {
    return _execute(() => _remoteDataSource.deleteItem(itemId));
  }

  Future<Either<Failure, T>> _execute<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } on ParseException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
