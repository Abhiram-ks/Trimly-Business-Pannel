
import 'package:barber_pannel/features/app/domain/usecase/upload_post_usecase.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:barber_pannel/service/cloudinary/cloudinary_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../../domain/usecase/upload_mobile_usecase.dart';

part 'upload_post_event.dart';
part 'upload_post_state.dart';


class UploadPostBloc extends Bloc<UploadPostEvent, UploadPostState> {
  String imagePath = '';
  String description = '';
  Uint8List? imageBytes;

  final AuthLocalDatasource localDB;
  final CloudinaryService cloudService;
  final UploadPostUseCase uploadPostUseCase;
  final UploadMobileUsecase uploadMobileUsecase;

  UploadPostBloc({
    required this.localDB,
    required this.cloudService,
    required this.uploadPostUseCase,
    required this.uploadMobileUsecase,
  }) : super(UploadPostInitial()) {
    on<UploadPostEventRequest>((event, emit) {
      imagePath = event.imagePath;
      description = event.description;
      imageBytes = event.imageBytes;
      emit(UploadPostAlert());
    });

    on<UploadPostConfirmEvent>((event, emit) async {
      
      emit(UploadPostLoading());
      try {
        String? response;
        final barberId = await localDB.get();
        if (barberId == null) {
          emit(UploadPostError(error: 'Barber ID not found'));
          return;
        }

        if (kIsWeb && imageBytes != null) {
          response = await cloudService.uploadWebImage(imageBytes!);
        } else {
          response = await uploadMobileUsecase.call(imagePath);
        }

        if (response == null) {
          emit(UploadPostError(error: 'Failed to upload image'));
          return;
        }

        final success = await uploadPostUseCase(
          barberId: barberId,
          imageUrl: response,
          description: description,
        );

        if (success) {
          emit(UploadPostSuccess());
        } else {
          emit(UploadPostError(error: 'Failed to upload post'));
        }
      } catch (e) {
        emit(UploadPostError(error: e.toString()));
      }
    });
  }
}
