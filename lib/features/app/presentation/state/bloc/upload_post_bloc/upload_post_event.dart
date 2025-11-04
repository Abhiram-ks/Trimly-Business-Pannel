part of 'upload_post_bloc.dart';

@immutable
abstract class UploadPostEvent {}

final class UploadPostEventRequest extends UploadPostEvent {
  final String imagePath;
  final String description;
  final Uint8List? imageBytes;

  UploadPostEventRequest({required this.imagePath, required this.description, this.imageBytes});
}

final class UploadPostConfirmEvent extends UploadPostEvent {}