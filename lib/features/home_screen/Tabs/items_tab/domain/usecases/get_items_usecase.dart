import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/core/usecases/usecase.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/domain/entities/item_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/domain/repositories/items_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetItemsUseCase implements UseCase<List<ItemEntity>, NoParams> {
  final ItemsRepository _repository;

  GetItemsUseCase(this._repository);

  @override
  Future<Either<Failure, List<ItemEntity>>> call(NoParams params) async {
    return await _repository.getItems();
  }
}
