// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:home_plate_vendor/core/api/api_interceptors.dart' as _i312;
import 'package:home_plate_vendor/core/api/dio_consumer.dart' as _i1008;
import 'package:home_plate_vendor/core/cache/cache_helper.dart' as _i788;
import 'package:home_plate_vendor/core/di/external_module.dart' as _i458;
import 'package:home_plate_vendor/core/network/network_info.dart' as _i992;
import 'package:home_plate_vendor/core/temp_provider/address_provider.dart'
    as _i774;
import 'package:home_plate_vendor/features/add_item/data/datasources/add_item_remote_datasource.dart'
    as _i119;
import 'package:home_plate_vendor/features/add_item/data/repositories/add_item_repository_impl.dart'
    as _i524;
import 'package:home_plate_vendor/features/add_item/domain/repositories/i_add_item_repository.dart'
    as _i554;
import 'package:home_plate_vendor/features/add_item/domain/usecases/add_item_usecase.dart'
    as _i550;
import 'package:home_plate_vendor/features/add_item/presentation/manager/add_item_cubit.dart'
    as _i769;
import 'package:home_plate_vendor/features/addresses/data/datasources/addresses_remote_data_source.dart'
    as _i154;
import 'package:home_plate_vendor/features/addresses/data/repositories/addresses_repository_impl.dart'
    as _i474;
import 'package:home_plate_vendor/features/addresses/domain/repositories/addresses_repository.dart'
    as _i510;
import 'package:home_plate_vendor/features/addresses/presentation/manager/addresses_cubit.dart'
    as _i901;
import 'package:home_plate_vendor/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i216;
import 'package:home_plate_vendor/features/auth/data/repositories/auth_repository_impl.dart'
    as _i704;
import 'package:home_plate_vendor/features/auth/domain/repositories/i_auth_repository.dart'
    as _i636;
import 'package:home_plate_vendor/features/auth/domain/usecases/forgot_password_usecase.dart'
    as _i526;
import 'package:home_plate_vendor/features/auth/domain/usecases/login_usecase.dart'
    as _i1011;
import 'package:home_plate_vendor/features/auth/domain/usecases/register_usecase.dart'
    as _i858;
import 'package:home_plate_vendor/features/auth/domain/usecases/reset_password_usecase.dart'
    as _i121;
import 'package:home_plate_vendor/features/auth/domain/usecases/verify_forgot_password_otp_usecase.dart'
    as _i1020;
import 'package:home_plate_vendor/features/auth/domain/usecases/verify_registration_usecase.dart'
    as _i815;
import 'package:home_plate_vendor/features/auth/presentation/manager/forgot_password/verify_forgot_password_otp_cubit.dart'
    as _i935;
import 'package:home_plate_vendor/features/auth/presentation/manager/forgot_password_cubit/forgot_password_cubit.dart'
    as _i475;
import 'package:home_plate_vendor/features/auth/presentation/manager/login_cubit/login_cubit.dart'
    as _i514;
import 'package:home_plate_vendor/features/auth/presentation/manager/register_cubit/register_cubit.dart'
    as _i598;
import 'package:home_plate_vendor/features/auth/presentation/manager/reset_password_cubit/reset_password_cubit.dart'
    as _i98;
import 'package:home_plate_vendor/features/auth/presentation/manager/verify_registration_cubit/verify_registration_cubit.dart'
    as _i715;
import 'package:home_plate_vendor/features/general/data/datasources/general_remote_datasource.dart'
    as _i840;
import 'package:home_plate_vendor/features/general/data/repositories/general_repository_impl.dart'
    as _i726;
import 'package:home_plate_vendor/features/general/domain/repositories/i_general_repository.dart'
    as _i773;
import 'package:home_plate_vendor/features/general/domain/usecases/get_areas_usecase.dart'
    as _i991;
import 'package:home_plate_vendor/features/general/domain/usecases/get_categories_usecase.dart'
    as _i883;
import 'package:home_plate_vendor/features/general/domain/usecases/get_cities_usecase.dart'
    as _i757;
import 'package:home_plate_vendor/features/general/domain/usecases/get_countries_usecase.dart'
    as _i834;
import 'package:home_plate_vendor/features/general/presentation/manager/general_cubit.dart'
    as _i867;
import 'package:home_plate_vendor/features/home_screen/presentation/manager/home_cubit.dart'
    as _i608;
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/data/datasources/items_remote_data_source.dart'
    as _i640;
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/data/repositories/items_repository_impl.dart'
    as _i778;
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/domain/repositories/items_repository.dart'
    as _i608;
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/domain/usecases/get_items_usecase.dart'
    as _i35;
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/domain/usecases/toggle_item_status_usecase.dart'
    as _i807;
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/presentation/manager/items_cubit/items_cubit.dart'
    as _i346;
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/data/datasources/orders_remote_data_source.dart'
    as _i379;
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/data/repositories/orders_repository_impl.dart'
    as _i717;
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/repositories/orders_repository.dart'
    as _i770;
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/usecases/confirm_handover_usecase.dart'
    as _i787;
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/usecases/get_orders_usecase.dart'
    as _i342;
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/usecases/ready_for_pickup_usecase.dart'
    as _i239;
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/usecases/start_cooking_usecase.dart'
    as _i594;
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/presentation/manager/orders_cubit/orders_cubit.dart'
    as _i810;
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/data/datasources/profile_remote_data_source.dart'
    as _i370;
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/data/repositories/profile_repository_impl.dart'
    as _i641;
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/domain/repositories/profile_repository.dart'
    as _i1015;
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/domain/usecases/get_vendor_profile_usecase.dart'
    as _i96;
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/domain/usecases/update_profile_usecase.dart'
    as _i777;
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/presentation/manager/profile_cubit.dart'
    as _i912;
import 'package:home_plate_vendor/features/sub_categories/data/datasources/sub_categories_remote_data_source.dart'
    as _i432;
import 'package:home_plate_vendor/features/sub_categories/data/repositories/sub_categories_repository_impl.dart'
    as _i3;
import 'package:home_plate_vendor/features/sub_categories/domain/repositories/sub_categories_repository.dart'
    as _i547;
import 'package:home_plate_vendor/features/sub_categories/domain/usecases/get_sub_categories_usecase.dart'
    as _i1042;
import 'package:home_plate_vendor/features/sub_categories/domain/usecases/save_sub_category_usecase.dart'
    as _i499;
import 'package:home_plate_vendor/features/sub_categories/presentation/manager/sub_categories_cubit.dart'
    as _i1056;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final externalModule = _$ExternalModule();
    gh.factory<_i608.HomeCubit>(() => _i608.HomeCubit());
    gh.lazySingleton<_i312.ApiInterceptor>(() => _i312.ApiInterceptor());
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => externalModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i973.InternetConnectionChecker>(
      () => externalModule.connectionChecker,
    );
    gh.lazySingleton<_i774.AddressProvider>(() => _i774.AddressProvider());
    gh.lazySingleton<_i992.NetworkInfo>(
      () => _i992.NetworkInfoImpl(gh<_i973.InternetConnectionChecker>()),
    );
    gh.lazySingleton<_i788.CacheHelper>(
      () => _i788.CacheHelper(sharedPreferences: gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => externalModule.dio(gh<_i788.CacheHelper>()),
    );
    gh.lazySingleton<_i1008.DioConsumer>(
      () => _i1008.DioConsumer(client: gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i154.AddressesRemoteDataSource>(
      () => _i154.AddressesRemoteDataSourceImpl(gh<_i1008.DioConsumer>()),
    );
    gh.lazySingleton<_i119.AddItemRemoteDataSource>(
      () => _i119.AddItemRemoteDataSourceImpl(gh<_i1008.DioConsumer>()),
    );
    gh.lazySingleton<_i216.AuthRemoteDataSource>(
      () => _i216.AuthRemoteDataSourceImpl(api: gh<_i1008.DioConsumer>()),
    );
    gh.lazySingleton<_i510.AddressesRepository>(
      () => _i474.AddressesRepositoryImpl(
        remoteDataSource: gh<_i154.AddressesRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i636.IAuthRepository>(
      () => _i704.AuthRepositoryImpl(
        remoteDataSource: gh<_i216.AuthRemoteDataSource>(),
        cacheHelper: gh<_i788.CacheHelper>(),
      ),
    );
    gh.lazySingleton<_i370.ProfileRemoteDataSource>(
      () => _i370.ProfileRemoteDataSourceImpl(gh<_i1008.DioConsumer>()),
    );
    gh.lazySingleton<_i432.SubCategoriesRemoteDataSource>(
      () => _i432.SubCategoriesRemoteDataSourceImpl(gh<_i1008.DioConsumer>()),
    );
    gh.lazySingleton<_i554.IAddItemRepository>(
      () => _i524.AddItemRepositoryImpl(gh<_i119.AddItemRemoteDataSource>()),
    );
    gh.lazySingleton<_i840.GeneralRemoteDataSource>(
      () => _i840.GeneralRemoteDataSourceImpl(gh<_i1008.DioConsumer>()),
    );
    gh.lazySingleton<_i379.OrdersRemoteDataSource>(
      () => _i379.OrdersRemoteDataSourceImpl(gh<_i1008.DioConsumer>()),
    );
    gh.lazySingleton<_i773.IGeneralRepository>(
      () => _i726.GeneralRepositoryImpl(gh<_i840.GeneralRemoteDataSource>()),
    );
    gh.lazySingleton<_i640.ItemsRemoteDataSource>(
      () => _i640.ItemsRemoteDataSourceImpl(gh<_i1008.DioConsumer>()),
    );
    gh.lazySingleton<_i1020.VerifyForgotPasswordOtpUseCase>(
      () => _i1020.VerifyForgotPasswordOtpUseCase(
        authRepository: gh<_i636.IAuthRepository>(),
      ),
    );
    gh.lazySingleton<_i550.AddItemUseCase>(
      () => _i550.AddItemUseCase(gh<_i554.IAddItemRepository>()),
    );
    gh.lazySingleton<_i547.SubCategoriesRepository>(
      () => _i3.SubCategoriesRepositoryImpl(
        remoteDataSource: gh<_i432.SubCategoriesRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i1042.GetSubCategoriesUseCase>(
      () => _i1042.GetSubCategoriesUseCase(gh<_i547.SubCategoriesRepository>()),
    );
    gh.lazySingleton<_i499.SaveSubCategoryUseCase>(
      () => _i499.SaveSubCategoryUseCase(gh<_i547.SubCategoriesRepository>()),
    );
    gh.lazySingleton<_i499.DeleteSubCategoryUseCase>(
      () => _i499.DeleteSubCategoryUseCase(gh<_i547.SubCategoriesRepository>()),
    );
    gh.lazySingleton<_i1015.ProfileRepository>(
      () => _i641.ProfileRepositoryImpl(gh<_i370.ProfileRemoteDataSource>()),
    );
    gh.lazySingleton<_i901.AddressesCubit>(
      () => _i901.AddressesCubit(repository: gh<_i510.AddressesRepository>()),
    );
    gh.lazySingleton<_i770.OrdersRepository>(
      () => _i717.OrdersRepositoryImpl(gh<_i379.OrdersRemoteDataSource>()),
    );
    gh.factory<_i769.AddItemCubit>(
      () => _i769.AddItemCubit(
        gh<_i550.AddItemUseCase>(),
        gh<_i554.IAddItemRepository>(),
      ),
    );
    gh.lazySingleton<_i787.ConfirmHandoverUseCase>(
      () => _i787.ConfirmHandoverUseCase(gh<_i770.OrdersRepository>()),
    );
    gh.lazySingleton<_i342.GetOrdersUseCase>(
      () => _i342.GetOrdersUseCase(gh<_i770.OrdersRepository>()),
    );
    gh.lazySingleton<_i239.ReadyForPickupUseCase>(
      () => _i239.ReadyForPickupUseCase(gh<_i770.OrdersRepository>()),
    );
    gh.lazySingleton<_i594.StartCookingUseCase>(
      () => _i594.StartCookingUseCase(gh<_i770.OrdersRepository>()),
    );
    gh.factory<_i935.VerifyForgotPasswordOtpCubit>(
      () => _i935.VerifyForgotPasswordOtpCubit(
        verifyForgotPasswordOtpUseCase:
            gh<_i1020.VerifyForgotPasswordOtpUseCase>(),
      ),
    );
    gh.lazySingleton<_i526.ForgotPasswordUseCase>(
      () =>
          _i526.ForgotPasswordUseCase(repository: gh<_i636.IAuthRepository>()),
    );
    gh.lazySingleton<_i1011.LoginUseCase>(
      () => _i1011.LoginUseCase(repository: gh<_i636.IAuthRepository>()),
    );
    gh.lazySingleton<_i858.RegisterUseCase>(
      () => _i858.RegisterUseCase(repository: gh<_i636.IAuthRepository>()),
    );
    gh.lazySingleton<_i121.ResetPasswordUseCase>(
      () => _i121.ResetPasswordUseCase(repository: gh<_i636.IAuthRepository>()),
    );
    gh.lazySingleton<_i815.VerifyRegistrationUseCase>(
      () => _i815.VerifyRegistrationUseCase(
        repository: gh<_i636.IAuthRepository>(),
      ),
    );
    gh.factory<_i514.LoginCubit>(
      () => _i514.LoginCubit(loginUseCase: gh<_i1011.LoginUseCase>()),
    );
    gh.lazySingleton<_i991.GetAreasUseCase>(
      () => _i991.GetAreasUseCase(gh<_i773.IGeneralRepository>()),
    );
    gh.lazySingleton<_i883.GetCategoriesUseCase>(
      () => _i883.GetCategoriesUseCase(gh<_i773.IGeneralRepository>()),
    );
    gh.lazySingleton<_i757.GetCitiesUseCase>(
      () => _i757.GetCitiesUseCase(gh<_i773.IGeneralRepository>()),
    );
    gh.lazySingleton<_i834.GetCountriesUseCase>(
      () => _i834.GetCountriesUseCase(gh<_i773.IGeneralRepository>()),
    );
    gh.lazySingleton<_i608.ItemsRepository>(
      () => _i778.ItemsRepositoryImpl(gh<_i640.ItemsRemoteDataSource>()),
    );
    gh.lazySingleton<_i867.GeneralCubit>(
      () => _i867.GeneralCubit(
        getCountriesUseCase: gh<_i834.GetCountriesUseCase>(),
        getCitiesUseCase: gh<_i757.GetCitiesUseCase>(),
        getAreasUseCase: gh<_i991.GetAreasUseCase>(),
        getCategoriesUseCase: gh<_i883.GetCategoriesUseCase>(),
      ),
    );
    gh.factory<_i777.UpdateProfileUseCase>(
      () => _i777.UpdateProfileUseCase(gh<_i1015.ProfileRepository>()),
    );
    gh.lazySingleton<_i96.GetVendorProfileUseCase>(
      () => _i96.GetVendorProfileUseCase(gh<_i1015.ProfileRepository>()),
    );
    gh.factory<_i810.OrdersCubit>(
      () => _i810.OrdersCubit(
        gh<_i342.GetOrdersUseCase>(),
        gh<_i594.StartCookingUseCase>(),
        gh<_i239.ReadyForPickupUseCase>(),
        gh<_i787.ConfirmHandoverUseCase>(),
      ),
    );
    gh.factory<_i98.ResetPasswordCubit>(
      () => _i98.ResetPasswordCubit(
        resetPasswordUseCase: gh<_i121.ResetPasswordUseCase>(),
      ),
    );
    gh.factory<_i598.RegisterCubit>(
      () => _i598.RegisterCubit(registerUseCase: gh<_i858.RegisterUseCase>()),
    );
    gh.lazySingleton<_i1056.SubCategoriesCubit>(
      () => _i1056.SubCategoriesCubit(
        getUseCase: gh<_i1042.GetSubCategoriesUseCase>(),
        saveUseCase: gh<_i499.SaveSubCategoryUseCase>(),
        deleteUseCase: gh<_i499.DeleteSubCategoryUseCase>(),
      ),
    );
    gh.factory<_i475.ForgotPasswordCubit>(
      () => _i475.ForgotPasswordCubit(
        forgotPasswordUseCase: gh<_i526.ForgotPasswordUseCase>(),
      ),
    );
    gh.lazySingleton<_i912.ProfileCubit>(
      () => _i912.ProfileCubit(
        getVendorProfileUseCase: gh<_i96.GetVendorProfileUseCase>(),
        updateProfileUseCase: gh<_i777.UpdateProfileUseCase>(),
      ),
    );
    gh.factory<_i715.VerifyRegistrationCubit>(
      () => _i715.VerifyRegistrationCubit(
        verifyRegistrationUseCase: gh<_i815.VerifyRegistrationUseCase>(),
      ),
    );
    gh.lazySingleton<_i35.GetItemsUseCase>(
      () => _i35.GetItemsUseCase(gh<_i608.ItemsRepository>()),
    );
    gh.lazySingleton<_i807.ToggleItemStatusUseCase>(
      () => _i807.ToggleItemStatusUseCase(gh<_i608.ItemsRepository>()),
    );
    gh.factory<_i346.ItemsCubit>(
      () => _i346.ItemsCubit(
        gh<_i35.GetItemsUseCase>(),
        gh<_i807.ToggleItemStatusUseCase>(),
      ),
    );
    return this;
  }
}

class _$ExternalModule extends _i458.ExternalModule {}
