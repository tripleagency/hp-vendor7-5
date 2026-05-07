import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/utils/constants.dart';

/// Form Validators
/// Provides validation functions for common form fields
class Validators {
  // Private constructor to prevent instantiation
  Validators._();

  /// Validates if field is not empty
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? 'error_field_required_name'.tr(namedArgs: {'fieldName': fieldName})
          : 'error_field_required'.tr();
    }
    return null;
  }

  /// Validates email format (returns null if empty to allow optional usage)
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (!AppConstants.emailRegex.hasMatch(value)) {
      return 'error_invalid_email'.tr();
    }

    return null;
  }

  /// Validates password strength
  static String? password(String? value, {int? minLength}) {
    final length = minLength ?? AppConstants.minPasswordLength;
    if (value == null || value.isEmpty) {
      return 'error_password_required'.tr();
    }

    if (value.length < length) {
      return 'error_password_min_length'.tr(
        namedArgs: {'minLength': length.toString()},
      );
    }

    return null;
  }

  /// Validates if passwords match
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'error_confirm_password_required'.tr();
    }

    if (value != password) {
      return 'error_passwords_mismatch'.tr();
    }

    return null;
  }

  /// Validates phone number
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'error_phone_required'.tr();
    }

    if (!AppConstants.phoneRegex.hasMatch(
      value.replaceAll(RegExp(r'[\s-]'), ''),
    )) {
      return 'error_invalid_phone'.tr();
    }

    return null;
  }

  /// Validates name field
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'error_name_required'.tr();
    }

    if (value.trim().length < 2) {
      return 'error_name_min_length'.tr();
    }

    final nameRegex = RegExp(r"^[a-zA-Z\s]+$");
    if (!nameRegex.hasMatch(value.trim())) {
      return 'error_name_invalid'.tr();
    }

    return null;
  }

  /// Validates address field
  static String? address(String? value) {
    if (value == null || value.isEmpty) {
      return 'error_address_required'.tr();
    }

    if (value.trim().length < 5) {
      return 'error_address_min_length'.tr();
    }

    return null;
  }

  /// Validates city field
  static String? city(String? value) {
    if (value == null || value.isEmpty) {
      return 'error_city_required'.tr();
    }

    if (value.trim().length < 2) {
      return 'error_city_min_length'.tr();
    }

    return null;
  }

  /// Validates region field
  static String? region(String? value) {
    if (value == null || value.isEmpty) {
      return 'error_region_required'.tr();
    }

    if (value.trim().length < 2) {
      return 'error_region_min_length'.tr();
    }

    return null;
  }

  /// Validates minimum length
  static String? minLength(String? value, int length, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null
          ? 'error_field_required_name'.tr(namedArgs: {'fieldName': fieldName})
          : 'error_field_required'.tr();
    }

    if (value.length < length) {
      return 'error_min_length'.tr(
        namedArgs: {
          'fieldName': fieldName ?? 'This field',
          'length': length.toString(),
        },
      );
    }

    return null;
  }

  /// Validates maximum length
  static String? maxLength(String? value, int length, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length > length) {
      return 'error_max_length'.tr(
        namedArgs: {
          'fieldName': fieldName ?? 'This field',
          'length': length.toString(),
        },
      );
    }

    return null;
  }

  /// Validates numeric input
  static String? numeric(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null
          ? 'error_field_required_name'.tr(namedArgs: {'fieldName': fieldName})
          : 'error_field_required'.tr();
    }

    if (double.tryParse(value) == null) {
      return 'error_must_be_numeric'.tr(
        namedArgs: {'fieldName': fieldName ?? 'This field'},
      );
    }

    return null;
  }

  /// Validates URL format
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'error_url_required'.tr();
    }

    if (!AppConstants.urlRegex.hasMatch(value)) {
      return 'error_invalid_url'.tr();
    }

    return null;
  }

  /// Validates credit card number
  static String? creditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'error_credit_card_required'.tr();
    }

    final cardNumber = value.replaceAll(RegExp(r'[\s-]'), '');

    if (cardNumber.length < 13 || cardNumber.length > 19) {
      return 'error_invalid_credit_card'.tr();
    }

    // Luhn algorithm
    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    if (sum % 10 != 0) {
      return 'error_invalid_credit_card'.tr();
    }

    return null;
  }

  /// Validates date format (dd/MM/yyyy)
  static String? date(String? value) {
    if (value == null || value.isEmpty) {
      return 'error_date_required'.tr();
    }

    final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');

    if (!dateRegex.hasMatch(value)) {
      return 'error_date_format'.tr();
    }

    final parts = value.split('/');
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return 'error_invalid_date'.tr();
    }

    if (month < 1 || month > 12) {
      return 'error_invalid_month'.tr();
    }

    if (day < 1 || day > 31) {
      return 'error_invalid_day'.tr();
    }

    return null;
  }

  /// Combines multiple validators
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }
}
