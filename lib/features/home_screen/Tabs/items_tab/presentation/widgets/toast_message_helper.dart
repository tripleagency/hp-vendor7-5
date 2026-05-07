import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class ToastMessageHelper {
  static void showSuccessMessage(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    Flushbar(
      message: message,
      duration: duration,
      backgroundColor: const Color(0xFF1BAC4B),
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
      icon: const Icon(
        Icons.check_circle,
        color: Colors.white,
      ),
    ).show(context);
  }

  static void showErrorMessage(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    Flushbar(
      message: message,
      duration: duration,
      backgroundColor: const Color(0xFFEF5350),
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
      icon: const Icon(
        Icons.error_outline,
        color: Colors.white,
      ),
    ).show(context);
  }

  static void showLoadingMessage(
    BuildContext context, {
    required String message,
  }) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 5),
      backgroundColor: const Color(0xFF42A5F5),
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
      icon: const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 2,
        ),
      ),
    ).show(context);
  }
}
