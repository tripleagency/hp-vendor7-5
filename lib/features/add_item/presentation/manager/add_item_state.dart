part of 'add_item_cubit.dart';

abstract class AddItemState extends Equatable {
  const AddItemState();

  @override
  List<Object?> get props => [];
}

class AddItemInitial extends AddItemState {}

class AddItemLoading extends AddItemState {}

class AddItemSuccess extends AddItemState {
  final String message;
  const AddItemSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AddItemError extends AddItemState {
  final String message;
  final Map<String, dynamic>? errors;

  const AddItemError(this.message, {this.errors});

  @override
  List<Object?> get props => [message, errors];
}
