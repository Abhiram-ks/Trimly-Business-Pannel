part of 'upload_service_data_bloc.dart';

@immutable
abstract class UploadServiceDataEvent {}

final class UploadServiceDataRequest extends UploadServiceDataEvent {
    final String imagePath;
    final Uint8List? imageBytes;
    final GenderOption gender;

  UploadServiceDataRequest({required this.imagePath, required this.gender, this.imageBytes});
}


final class UploadServiceDataConfirmation extends UploadServiceDataEvent {}