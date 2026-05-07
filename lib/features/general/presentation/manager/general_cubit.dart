import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_plate_vendor/core/usecases/usecase.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/area_entity.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/city_entity.dart';
import 'package:home_plate_vendor/features/general/domain/entities/country_entity.dart';
import 'package:home_plate_vendor/features/general/domain/entities/category_entity.dart';
import 'package:home_plate_vendor/features/general/domain/usecases/get_areas_usecase.dart';
import 'package:home_plate_vendor/features/general/domain/usecases/get_cities_usecase.dart';
import 'package:home_plate_vendor/features/general/domain/usecases/get_countries_usecase.dart';
import 'package:home_plate_vendor/features/general/domain/usecases/get_categories_usecase.dart';
import 'package:injectable/injectable.dart';

part 'general_state.dart';

@lazySingleton
class GeneralCubit extends Cubit<GeneralState> {
  final GetCountriesUseCase _getCountriesUseCase;
  final GetCitiesUseCase _getCitiesUseCase;
  final GetAreasUseCase _getAreasUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  GeneralCubit({
    required GetCountriesUseCase getCountriesUseCase,
    required GetCitiesUseCase getCitiesUseCase,
    required GetAreasUseCase getAreasUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
  }) : _getCountriesUseCase = getCountriesUseCase,
       _getCitiesUseCase = getCitiesUseCase,
       _getAreasUseCase = getAreasUseCase,
       _getCategoriesUseCase = getCategoriesUseCase,
       super(const GeneralState());

  // ── Public API ────────────────────────────────────────────────────────────

  Future<void> fetchCountries() async {
    if (state.isLoadingCountries) return; // prevent duplicate calls
    emit(state.copyWith(isLoadingCountries: true, clearError: true));
    final result = await _getCountriesUseCase(const NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingCountries: false,
          errorMessage: failure.message,
        ),
      ),
      (countries) =>
          emit(state.copyWith(isLoadingCountries: false, countries: countries)),
    );
  }

  Future<void> fetchCities() async {
    if (state.isLoadingCities) return;
    emit(state.copyWith(isLoadingCities: true, clearError: true));
    final result = await _getCitiesUseCase(const NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingCities: false, errorMessage: failure.message),
      ),
      (cities) => emit(state.copyWith(isLoadingCities: false, cities: cities)),
    );
  }

  Future<void> fetchAreas() async {
    if (state.isLoadingAreas) return;
    emit(state.copyWith(isLoadingAreas: true, clearError: true));
    final result = await _getAreasUseCase(const NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingAreas: false, errorMessage: failure.message),
      ),
      (areas) => emit(state.copyWith(isLoadingAreas: false, areas: areas)),
    );
  }

  Future<void> fetchCategories() async {
    if (state.isLoadingCategories) return;
    emit(state.copyWith(isLoadingCategories: true, clearError: true));
    final result = await _getCategoriesUseCase(const NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingCategories: false,
          errorMessage: failure.message,
        ),
      ),
      (categories) => emit(
        state.copyWith(isLoadingCategories: false, categories: categories),
      ),
    );
  }

  /// Fetch all necessary general data
  Future<void> fetchAll() async {
    await Future.wait([
      fetchCountries(),
      fetchCities(),
      fetchAreas(),
      fetchCategories(),
    ]);
  }
}
