import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/exceptions.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/data/datasources/items_remote_data_source.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/domain/entities/item_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/domain/repositories/items_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ItemsRepository)
class ItemsRepositoryImpl implements ItemsRepository {
  final ItemsRemoteDataSource _remoteDataSource;

  ItemsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ItemEntity>>> getItems() async {
    return _handleRepoCall(() => _remoteDataSource.getItems());
  }

  @override
  Future<Either<Failure, ItemEntity>> toggleItemStatus(
    int itemId,
    bool publish,
  ) async {
    return _handleRepoCall(
      () => publish
          ? _remoteDataSource.publishItem(itemId)
          : _remoteDataSource.pauseItem(itemId),
    );
  }

  Future<Either<Failure, T>> _handleRepoCall<T>(
    Future<T> Function() call,
  ) async {
    try {
      final result = await call();
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on ParseException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
