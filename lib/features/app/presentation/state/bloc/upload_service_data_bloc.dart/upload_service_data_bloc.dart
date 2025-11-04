import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:barber_pannel/features/app/domain/usecase/upload_mobile_usecase.dart';
import 'package:barber_pannel/service/cloudinary/cloudinary_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../../domain/usecase/update_barber_newdata_usecase.dart';
import '../../cubit/gender_option_cubit/gender_option_cubit.dart';

part 'upload_service_data_event.dart';
part 'upload_service_data_state.dart';

class UploadServiceDataBloc extends Bloc<UploadServiceDataEvent, UploadServiceDataState> {
  final UpdateBarberNewdataUsecase usecase;
  final AuthLocalDatasource localDB;
  final UploadMobileUsecase uploadMobileUsecase;
  final CloudinaryService cloudinary;
  Uint8List? imageBytes;
  String imagePath = '';
  String genderOption = '';

  UploadServiceDataBloc({required this.cloudinary, required this.localDB, required this.usecase, required this.uploadMobileUsecase}) : super(UploadServiceDataInitial()) {
    on<UploadServiceDataRequest>((event, emit) {
      imagePath = event.imagePath;
      imageBytes = event.imageBytes;
      genderOption = event.gender.name;
      emit(UploadServiceDataDialogBox(gender: genderOption));
    });

    on<UploadServiceDataConfirmation>((event, emit) async  {
      emit(UploadServiceDataLoading());

      try {
        String? imageUrl = imagePath;
        if(imageUrl.isEmpty || !imageUrl.startsWith('http')) {
          final String? response;
          if (kIsWeb) {
            if (imageBytes == null) {
              emit(UploadServiceDataError(error: 'No image data available for web upload'));
              return;
            }
            response = await cloudinary.uploadWebImage(imageBytes!);
          } else {
            if (imagePath.isEmpty) {
              emit(UploadServiceDataError(error: 'No image path available for mobile upload'));
              return;
            }
            response = await uploadMobileUsecase.call(imagePath);
          }
          
          if(response == null) {
            emit(UploadServiceDataError(error: 'Image upload failed'));
            return;
          }
          imageUrl = response;
        }
        final String? barberID = await localDB.get();
        if(barberID == null) {
          emit(UploadServiceDataError(error: 'Token expired. Please login again.'));
          return;
        }
        final bool response = await usecase.call(uid: barberID, imageUrl: imageUrl, gender: genderOption);
        if(response) {
          emit(UploadServiceDataSuccess());
        } else {
          emit(UploadServiceDataError(error: 'Failed to upload new data'));
        }
      } catch (e) {
        emit(UploadServiceDataError(error: e.toString()));
      }
    });
  }
}
