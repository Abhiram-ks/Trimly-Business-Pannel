
import 'package:barber_pannel/features/app/domain/usecase/update_barber_usecase.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:barber_pannel/service/cloudinary/cloudinary_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../../domain/usecase/upload_mobile_usecase.dart';
part 'update_profile_event.dart';
part 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final CloudinaryService cloudinaryService;
  final AuthLocalDatasource localDB;
  final UpdateBarberUseCase updateBarberUseCase;
  final UploadMobileUsecase uploadMobileUsecase;

  String barberName = '';
  String ventureName = '';
  String phoneNumber = '';
  String address = '';
  String image = '';
  int age = 0;
  Uint8List? imageBytes;

  UpdateProfileBloc({
    required this.cloudinaryService,
    required this.localDB,
    required this.uploadMobileUsecase,
    required this.updateBarberUseCase,
  }) : super(UpdateProfileInitial()) {
    on<UpdateProfileRequest>((event, emit) {
      barberName = event.barberName;
      ventureName = event.ventureName;
      phoneNumber = event.phoneNumber;
      address = event.address;
      image = event.image;
      age = event.year;
      imageBytes = event.imageBytes;

      emit(UpdateProfileAlertBox());
    });

    on<ConfirmUpdateRequest>((event, emit) async {
      emit(UpdateProfileLoading());

      try {
        final barberId = await localDB.get();
        if (barberId == null || barberId.isEmpty) {
          emit(
            UpdateProfileError(
              message: 'Barber ID not found. Please login again.',
            ),
          );
          return;
        }

        String? imageUrl;

        if (image.isNotEmpty || imageBytes != null) {
          String? response;
          if (kIsWeb && imageBytes != null) {

            response = await cloudinaryService.uploadWebImage(imageBytes!);
            if (response == null || response.isEmpty) {
              emit(
                UpdateProfileError(message: 'Failed to upload profile image'),
              );
              return;
            }
            imageUrl = response;
          } else if (!image.startsWith('http')) {
            response = await uploadMobileUsecase.call(image);
            if (response == null || response.isEmpty) {
              emit(
                UpdateProfileError(message: 'Failed to upload profile image'),
              );
              return;
            }
            imageUrl = response;
          } else {
            imageUrl = image;
          }


        } else if (image.isNotEmpty) {
          imageUrl = image;
        }

        final bool success = await updateBarberUseCase(
          uid: barberId,
          barberName: barberName.isNotEmpty ? barberName : null,
          ventureName: ventureName.isNotEmpty ? ventureName : null,
          phoneNumber: phoneNumber.isNotEmpty ? phoneNumber : null,
          address: address.isNotEmpty ? address : null,
          image: imageUrl,
          age: age > 0 ? age : null,
        );

        if (success) {
          emit(UpdateProfileSuccess());
        } else {
          emit(UpdateProfileError(message: 'Failed to update profile'));
        }
      } on Exception catch (e) {
        emit(UpdateProfileError(message: e.toString()));
      } catch (e) {
        emit(
          UpdateProfileError(
            message: 'An unexpected error occurred: ${e.toString()}',
          ),
        );
      }
    });
  }
}
