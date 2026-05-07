import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/core/usecases/usecase.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/domain/entities/item_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/domain/repositories/items_repository.dart';
import 'package:injectable/injectable.dart';

class ToggleItemStatusParams {
  final int itemId;
  final bool publish;

  const ToggleItemStatusParams({
    required this.itemId,
    required this.publish,
  });
}

@lazySingleton
class ToggleItemStatusUseCase
    implements UseCase<ItemEntity, ToggleItemStatusParams> {
  final ItemsRepository _repository;

  ToggleItemStatusUseCase(this._repository);

  @override
  Future<Either<Failure, ItemEntity>> call(
    ToggleItemStatusParams params,
  ) async {
    return await _repository.toggleItemStatus(params.itemId, params.publish);
  }
}
