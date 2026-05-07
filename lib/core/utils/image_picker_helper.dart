import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();
  static bool _isPickerActive = false;

  static Future<File?> pickImage() async {
    if (_isPickerActive) return null;
    _isPickerActive = true;

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      debugPrint("ImagePicker Error: $e");
    } finally {
      _isPickerActive = false;
    }
    return null;
  }
}
