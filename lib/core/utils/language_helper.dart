import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// Helper class for language management
class LanguageHelper {
  /// Changes the app language to the specified locale
  /// 
  /// [context] - The build context
  /// [locale] - The target locale (e.g., Locale('ar') for Arabic, Locale('en') for English)
  /// 
  /// Example:
  /// ```dart
  /// await LanguageHelper.changeLanguage(context, Locale('ar'));
  /// ```
  static Future<void> changeLanguage(
    BuildContext context,
    Locale locale,
  ) async {
    await context.setLocale(locale);
  }

  /// Gets the current locale
  static Locale getCurrentLocale(BuildContext context) {
    return context.locale;
  }

  /// Checks if current language is Arabic
  static bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }

  /// Checks if current language is English
  static bool isEnglish(BuildContext context) {
    return context.locale.languageCode == 'en';
  }

  /// Toggles between Arabic and English
  static Future<void> toggleLanguage(BuildContext context) async {
    final currentLocale = context.locale;
    final newLocale = currentLocale.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');

    await changeLanguage(context, newLocale);
  }

  /// Gets the language name based on the locale code
  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      default:
        return languageCode;
    }
  }
}
