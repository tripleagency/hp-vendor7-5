import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:home_plate_vendor/core/widgets/custom_image_upload.dart';

class AddItemImageSection extends StatelessWidget {
  final File? coverImage;
  final List<File?> kitchenImages;
  final Function(File?) onCoverImageSelected;
  final Function(int, File?) onKitchenImageSelected;
  final VoidCallback onCoverImageRemoved;
  final Function(int) onKitchenImageRemoved;

  const AddItemImageSection({
    super.key,
    required this.coverImage,
    required this.kitchenImages,
    required this.onCoverImageSelected,
    required this.onKitchenImageSelected,
    required this.onCoverImageRemoved,
    required this.onKitchenImageRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cover Photo
        CustomImageUpload(
          height: 160.h,
          width: double.infinity,
          text: 'add_cover_photo'.tr(),
          subText: 'click_to_upload_cover_photo'.tr(),
          file: coverImage,
          onImageSelected: onCoverImageSelected,
          onRemove: onCoverImageRemoved,
        ),
        SizedBox(height: 16.h),

        // Kitchen Photos Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(3, (index) {
            return CustomImageUpload(
              height: 78.h,
              width: 94.w,
              text: 'add_recipe_photo_label'.tr(),
              file: kitchenImages[index],
              onImageSelected: (file) => onKitchenImageSelected(index, file),
              onRemove: () => onKitchenImageRemoved(index),
            );
          }),
        ),
      ],
    );
  }
}
