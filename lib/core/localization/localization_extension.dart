import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Extension to provide convenient access to localization features
extension LocalizationExtension on BuildContext {
  /// Quick access to translations
  /// Usage: context.tr('login_title')
  String tr(String key, {List<String>? args, Map<String, String>? namedArgs}) {
    return key.tr(args: args, namedArgs: namedArgs);
  }

  /// Access with plural support
  /// Usage: context.plural('items', 5)
  String plural(String key, int count) {
    return key.plural(count);
  }

  /// Access with gender support
  /// Usage: context.gender('user_greeting', gender: 'male')
  String gender(String key, {required String gender}) {
    return key.tr(gender: gender);
  }
}
