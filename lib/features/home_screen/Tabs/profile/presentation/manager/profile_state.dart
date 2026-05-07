part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final VendorEntity? vendor;
  final File? localProfileImage;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.vendor,
    this.localProfileImage,
    this.errorMessage,
  });

  factory ProfileState.initial() => const ProfileState();

  ProfileState copyWith({
    ProfileStatus? status,
    VendorEntity? vendor,
    File? localProfileImage,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      vendor: vendor ?? this.vendor,
      localProfileImage: localProfileImage ?? this.localProfileImage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, vendor, localProfileImage, errorMessage];
}
