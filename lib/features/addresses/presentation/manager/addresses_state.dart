part of 'addresses_cubit.dart';

class AddressesState extends Equatable {
  final List<AddressEntity> items;
  final bool isLoading;
  final bool isSaving;
  final bool isDeleting;
  final String? errorMessage;

  const AddressesState({
    this.items = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.isDeleting = false,
    this.errorMessage,
  });

  AddressesState copyWith({
    List<AddressEntity>? items,
    bool? isLoading,
    bool? isSaving,
    bool? isDeleting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AddressesState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isDeleting: isDeleting ?? this.isDeleting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    items,
    isLoading,
    isSaving,
    isDeleting,
    errorMessage,
  ];
}
