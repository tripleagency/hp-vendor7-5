part of 'general_cubit.dart';

class GeneralState extends Equatable {
  final List<CountryEntity> countries;
  final List<CityEntity> cities;
  final List<AreaEntity> areas;
  final List<CategoryEntity> categories;
  final bool isLoadingCountries;
  final bool isLoadingCities;
  final bool isLoadingAreas;
  final bool isLoadingCategories;
  final String? errorMessage;

  const GeneralState({
    this.countries = const [],
    this.cities = const [],
    this.areas = const [],
    this.categories = const [],
    this.isLoadingCountries = false,
    this.isLoadingCities = false,
    this.isLoadingAreas = false,
    this.isLoadingCategories = false,
    this.errorMessage,
  });

  bool get isLoading =>
      isLoadingCountries ||
      isLoadingCities ||
      isLoadingAreas ||
      isLoadingCategories;

  GeneralState copyWith({
    List<CountryEntity>? countries,
    List<CityEntity>? cities,
    List<AreaEntity>? areas,
    List<CategoryEntity>? categories,
    bool? isLoadingCountries,
    bool? isLoadingCities,
    bool? isLoadingAreas,
    bool? isLoadingCategories,
    String? errorMessage,
    bool clearError = false,
  }) {
    return GeneralState(
      countries: countries ?? this.countries,
      cities: cities ?? this.cities,
      areas: areas ?? this.areas,
      categories: categories ?? this.categories,
      isLoadingCountries: isLoadingCountries ?? this.isLoadingCountries,
      isLoadingCities: isLoadingCities ?? this.isLoadingCities,
      isLoadingAreas: isLoadingAreas ?? this.isLoadingAreas,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    countries,
    cities,
    areas,
    categories,
    isLoadingCountries,
    isLoadingCities,
    isLoadingAreas,
    isLoadingCategories,
    errorMessage,
  ];
}
