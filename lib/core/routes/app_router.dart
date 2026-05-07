import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/di/di.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/login_usecase.dart';
import 'package:home_plate_vendor/features/auth/presentation/manager/login_cubit/login_cubit.dart';
import 'package:home_plate_vendor/features/auth/presentation/pages/login/login_screen.dart';
import 'package:home_plate_vendor/features/home_screen/presentation/views/home_screen.dart';
import 'package:home_plate_vendor/features/on_boarding/presentation/introduction_screen.dart';
import 'package:home_plate_vendor/features/on_boarding/presentation/language_selection_screen.dart';
import 'routes.dart';

/// Application Router
class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.languageSelection:
        return _buildRoute(const LanguageSelectionScreen(), settings);
      case Routes.onboarding:
        return _buildRoute(const OnboardingScreen(), settings);
      case Routes.login:
        return _buildRoute(
          BlocProvider(
            create: (_) => LoginCubit(loginUseCase: sl<LoginUseCase>()),
            child: const LoginScreen(),
          ),
          settings,
        );
      case Routes.home:
        return _buildRoute(const HomeScreen(), settings);
      default:
        return _buildRoute(
          Scaffold(
            body: Center(
              child: Text('error_no_route'.tr(namedArgs: {'routeName': settings.name ?? 'unknown'})),
            ),
          ),
          settings,
        );
    }
  }

  static PageRouteBuilder _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static void navigateTo(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static void navigateAndReplace(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  static void navigateAndRemoveUntil(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
