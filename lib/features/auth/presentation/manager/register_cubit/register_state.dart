part of 'register_cubit.dart';

/// Holds all form data across both registration steps (never lost on back nav)
class RegisterFormData {
  // Step 1
  final String fullName;
  final String phone;
  final String email;
  final String password;
  final File? idFront;
  final File? idBack;

  // Step 2
  final String restaurantName;
  final String restaurantInfo;
  final int? countryId;
  final int? cityId;
  final int? areaId;
  final String deliveryAddress;
  final String location;
  final double? lat;
  final double? lng;
  final String deliveryPrice;
  final String deliveryTime;
  final File? mainPhoto;
  final List<File?> kitchenPhotos;
  final List<WorkingTimeEntity> workingTimes;
  final List<int> categoryIds;

  const RegisterFormData({
    this.fullName = '',
    this.phone = '',
    this.email = '',
    this.password = '',
    this.idFront,
    this.idBack,
    this.restaurantName = '',
    this.restaurantInfo = '',
    this.countryId,
    this.cityId,
    this.areaId,
    this.deliveryAddress = '',
    this.location = '',
    this.lat,
    this.lng,
    this.deliveryPrice = '',
    this.deliveryTime = '',
    this.mainPhoto,
    this.kitchenPhotos = const [null, null, null],
    this.workingTimes = const [],
    this.categoryIds = const [],
  });

  RegisterFormData copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? password,
    File? idFront,
    File? idBack,
    String? restaurantName,
    String? restaurantInfo,
    int? countryId,
    int? cityId,
    int? areaId,
    String? deliveryAddress,
    String? location,
    double? lat,
    double? lng,
    String? deliveryPrice,
    String? deliveryTime,
    File? mainPhoto,
    List<File?>? kitchenPhotos,
    List<WorkingTimeEntity>? workingTimes,
    List<int>? categoryIds,
  }) {
    return RegisterFormData(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      idFront: idFront ?? this.idFront,
      idBack: idBack ?? this.idBack,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantInfo: restaurantInfo ?? this.restaurantInfo,
      countryId: countryId ?? this.countryId,
      cityId: cityId ?? this.cityId,
      areaId: areaId ?? this.areaId,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      location: location ?? this.location,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      deliveryPrice: deliveryPrice ?? this.deliveryPrice,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      mainPhoto: mainPhoto ?? this.mainPhoto,
      kitchenPhotos: kitchenPhotos ?? this.kitchenPhotos,
      workingTimes: workingTimes ?? this.workingTimes,
      categoryIds: categoryIds ?? this.categoryIds,
    );
  }
}

// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

abstract class RegisterState extends Equatable {
  final RegisterFormData formData;
  const RegisterState({required this.formData});

  @override
  List<Object?> get props => [formData];
}

/// Initial / idle — form data is accessible
class RegisterInitial extends RegisterState {
  const RegisterInitial({RegisterFormData formData = const RegisterFormData()})
    : super(formData: formData);
}

/// API call in progress
class RegisterLoading extends RegisterState {
  const RegisterLoading({required super.formData});
}

/// API call succeeded
class RegisterSuccess extends RegisterState {
  final RegisterResponseEntity response;
  const RegisterSuccess({required this.response, required super.formData});

  @override
  List<Object?> get props => [response, formData];
}

/// API call failed
class RegisterFailure extends RegisterState {
  final String message;
  const RegisterFailure({required this.message, required super.formData});

  @override
  List<Object?> get props => [message, formData];
}
