import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_plate_vendor/core/utils/image_picker_helper.dart';
import 'dashed_upload_box.dart';

class CustomImageUpload extends StatefulWidget {
  final File? file;
  final String text;
  final String? subText;
  final double height;
  final double width;
  final ValueChanged<File?> onImageSelected;
  final VoidCallback? onRemove;

  const CustomImageUpload({
    super.key,
    this.file,
    required this.text,
    this.subText,
    required this.height,
    required this.width,
    required this.onImageSelected,
    this.onRemove,
  });

  @override
  State<CustomImageUpload> createState() => _CustomImageUploadState();
}

class _CustomImageUploadState extends State<CustomImageUpload> {
  bool _isPicking = false;

  Future<void> _handleTap() async {
    if (_isPicking) return;
    setState(() => _isPicking = true);

    try {
      final File? pickedFile = await ImagePickerHelper.pickImage();
      if (pickedFile != null) {
        widget.onImageSelected(pickedFile);
      }
    } finally {
      if (mounted) {
        setState(() => _isPicking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DashedUploadBox(
          height: widget.height,
          width: widget.width,
          text: widget.text,
          subText: widget.subText,
          file: widget.file,
          onTap: _handleTap,
        ),
        if (widget.file != null && widget.onRemove != null)
          Positioned(
            top: 4.r,
            right: 4.r,
            child: GestureDetector(
              onTap: widget.onRemove,
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, size: 16.r, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
