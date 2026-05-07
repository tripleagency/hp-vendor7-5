import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'core/di/di.dart';
import 'core/routes/app_router.dart';
import 'core/routes/navigation_helper.dart';
import 'core/routes/routes.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/localization_manager.dart';
import 'core/utils/constants.dart';
import 'core/temp_provider/address_provider.dart';
import 'core/cache/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/general/presentation/manager/general_cubit.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/presentation/manager/profile_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize dependency injection
  await init();

  final cacheHelper = sl<CacheHelper>();
  final bool onboardingCompleted =
      cacheHelper.getData(key: AppConstants.onboardingKey) ?? false;
  final String? token = cacheHelper.getData(key: AppConstants.accessTokenKey);

  String initialRoute;

  if (onboardingCompleted) {
    if (token != null && token.isNotEmpty) {
      initialRoute = Routes.home;
    } else {
      initialRoute = Routes.login;
    }
  } else {
    initialRoute = Routes.languageSelection;
  }

  runApp(
    EasyLocalization(
      supportedLocales: LocalizationManager.supportedLocales,
      path: LocalizationManager.translationsPath,
      fallbackLocale: LocalizationManager.fallbackLocale,
      startLocale: LocalizationManager.fallbackLocale,
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: sl<GeneralCubit>()),
            BlocProvider.value(value: sl<ProfileCubit>()),
          ],
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: sl<AddressProvider>()),
            ],
            child: MaterialApp(
              navigatorKey: NavigationHelper.navigatorKey,
              title: 'app_name'.tr(),
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.light,
              initialRoute: initialRoute,
              onGenerateRoute: AppRouter.generateRoute,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
            ),
          ),
        );
      },
    );
  }
}
