part of 'sub_categories_cubit.dart';

class SubCategoriesState extends Equatable {
  final List<SubCategoryEntity> items;
  final bool isLoading;
  final bool isSaving;
  final bool isDeleting;
  final String? errorMessage;

  const SubCategoriesState({
    this.items = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.isDeleting = false,
    this.errorMessage,
  });

  SubCategoriesState copyWith({
    List<SubCategoryEntity>? items,
    bool? isLoading,
    bool? isSaving,
    bool? isDeleting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SubCategoriesState(
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
