import 'package:flutter/material.dart';

enum AnimationType { slide, fade, scale, slideFromBottom }

class PageTransitions {
  static PageRouteBuilder<T> slideTransition<T extends Object?>({
    required Widget page,
    RouteSettings? settings,
    AnimationType animationType = AnimationType.slide,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (animationType) {
          case AnimationType.slide:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: curve)),
              child: child,
            );

          case AnimationType.slideFromBottom:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: curve)),
              child: child,
            );

          case AnimationType.fade:
            return FadeTransition(opacity: animation, child: child);

          case AnimationType.scale:
            return ScaleTransition(
              scale: Tween<double>(
                begin: 0.8,
                end: 1.0,
              ).animate(CurvedAnimation(parent: animation, curve: curve)),
              child: FadeTransition(opacity: animation, child: child),
            );
        }
      },
    );
  }

  // Helper method for easy navigation with slide animation
  static Future<T?> navigateWithSlide<T extends Object?>(
    BuildContext context,
    Widget page, {
    AnimationType animationType = AnimationType.slide,
    bool replace = false,
  }) {
    final route = slideTransition<T>(page: page, animationType: animationType);

    if (replace) {
      return Navigator.pushReplacement(context, route);
    } else {
      return Navigator.push(context, route);
    }
  }

  // Helper method for navigation with custom settings
  static Future<T?> navigateWithSlideNamed<T extends Object?>(
    BuildContext context,
    Widget page,
    String routeName, {
    AnimationType animationType = AnimationType.slide,
    Object? arguments,
  }) {
    final route = slideTransition<T>(
      page: page,
      settings: RouteSettings(name: routeName, arguments: arguments),
      animationType: animationType,
    );

    return Navigator.push(context, route);
  }

  // Helper method to push and remove until
  static Future<T?> navigateAndRemoveUntil<T extends Object?>(
    BuildContext context,
    Widget page, {
    AnimationType animationType = AnimationType.slide,
  }) {
    final route = slideTransition<T>(page: page, animationType: animationType);

    return Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }
}

extension NavigationExtension on BuildContext {
  Future<T?> slideToPage<T extends Object?>(
    Widget page, {
    AnimationType animationType = AnimationType.slide,
    bool replace = false,
  }) {
    return PageTransitions.navigateWithSlide<T>(
      this,
      page,
      animationType: animationType,
      replace: replace,
    );
  }
}
