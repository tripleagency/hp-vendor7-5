import 'package:dio/dio.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/register_params.dart';

/// Converts RegisterParams → FormData multipart for Dio
class RegisterRequestModel {
  final RegisterParams params;

  const RegisterRequestModel({required this.params});

  Future<FormData> toFormData() async {
    final formData = FormData();

    // Text fields
    formData.fields.addAll([
      MapEntry('full_name', params.fullName),
      MapEntry('phone', params.phone),
      if (params.email != null) MapEntry('email', params.email!),
      MapEntry('password', params.password),
      MapEntry('password_confirmation', params.passwordConfirmation),
      MapEntry('restaurant_name', params.restaurantName),
      MapEntry('restaurant_info', params.restaurantInfo),
      MapEntry('country_id', params.countryId.toString()),
      MapEntry('city_id', params.cityId.toString()),
      MapEntry('area_id', params.areaId.toString()),
      MapEntry('delivery_address', params.deliveryAddress),
      MapEntry('location', params.location),
      MapEntry('lat', params.lat.toString()),
      MapEntry('lng', params.lng.toString()),
      MapEntry('delivery_price', params.deliveryPrice),
      MapEntry('delivery_time', params.deliveryTime),
    ]);

    // ID Photos
    formData.files.addAll([
      MapEntry(
        'id_front',
        await MultipartFile.fromFile(
          params.idFront.path,
          filename: 'id_front.jpg',
        ),
      ),
      MapEntry(
        'id_back',
        await MultipartFile.fromFile(
          params.idBack.path,
          filename: 'id_back.jpg',
        ),
      ),
      MapEntry(
        'main_photo',
        await MultipartFile.fromFile(
          params.mainPhoto.path,
          filename: 'main_photo.jpg',
        ),
      ),
    ]);

    // Kitchen photos
    for (int i = 0; i < params.kitchenPhotos.length; i++) {
      final photo = params.kitchenPhotos[i];
      if (photo != null) {
        formData.files.add(
          MapEntry(
            'kitchen_photo_${i + 1}',
            await MultipartFile.fromFile(
              photo.path,
              filename: 'kitchen_${i + 1}.jpg',
            ),
          ),
        );
      }
    }

    // Working times — send as an array of objects:
    //   working_time[0][day]=saturday & working_time[0][from]=10:00 AM ...
    // The backend validates the rule working_time.*.day / .from / .to.
    String sanitizeTime(String t) {
      // Replace ANY whitespace (non-breaking space, etc) with a regular space
      String cleaned = t.replaceAll(RegExp(r'\s+'), ' ').trim();
      if (cleaned.startsWith('0')) {
        return cleaned.substring(1); // "08:00 AM" -> "8:00 AM"
      }
      return cleaned;
    }

    for (int i = 0; i < params.workingTimes.length; i++) {
      final wt = params.workingTimes[i];
      formData.fields.addAll([
        MapEntry('working_time[$i][day]', wt.day.trim().toLowerCase()),
        MapEntry('working_time[$i][from]', sanitizeTime(wt.from)),
        MapEntry('working_time[$i][to]', sanitizeTime(wt.to)),
      ]);
    }

    // Category IDs (if any provided)
    for (int i = 0; i < params.categoryIds.length; i++) {
      formData.fields.add(
        MapEntry('category_ids[$i]', params.categoryIds[i].toString()),
      );
    }

    return formData;
  }
}
