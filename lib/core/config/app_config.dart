/// Application Configuration
class AppConfig {
  AppConfig._();

  static const String appName = 'Home Plate Vendor';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';

  // Developer Info
  static const String developerName = 'Sayed Ali';
  static const String developerGithub = 'https://github.com/Sayed0Ali';
  static const String developerLinkedIn =
      'https://www.linkedin.com/in/abdalluh-essam';
  static const String developerEmail = 'contact@abdalluh-essam.com';

  // Environment
  static const bool isProduction = true;
  static const bool enableLogging = true;

  // API Configuration
  static String get baseUrl => 'https://home-plate.online';
}
