part of 'update_profile_bloc.dart';

@immutable
abstract class UpdateProfileEvent {}

final class UpdateProfileRequest extends UpdateProfileEvent {
  final String image;
  final Uint8List? imageBytes;
  final String barberName;
  final String ventureName;
  final String phoneNumber;
  final String address;
  final int year;

  UpdateProfileRequest({
    this.image = '',
    this.imageBytes,
    this.barberName = '',
    this.ventureName = '',
    this.phoneNumber = '',
    this.address = '',
    this.year = 0,
  });
}

final class ConfirmUpdateRequest extends UpdateProfileEvent {}
