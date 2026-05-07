import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/core/usecases/usecase.dart';
import 'package:home_plate_vendor/features/add_item/domain/repositories/i_add_item_repository.dart';
import 'package:injectable/injectable.dart';
import 'add_item_params.dart';

@lazySingleton
class AddItemUseCase implements UseCase<String, AddItemParams> {
  final IAddItemRepository repository;

  AddItemUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(AddItemParams params) async {
    return await repository.addItem(params);
  }
}
