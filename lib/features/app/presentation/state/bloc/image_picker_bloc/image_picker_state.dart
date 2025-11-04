part of 'image_picker_bloc.dart';

@immutable
abstract class ImagePickerState {}

final class ImagePickerInitial extends ImagePickerState {}
final class ImagePickerLoading extends ImagePickerState {}
final class ImagePickerLoaded extends ImagePickerState {
  final String? imagePath;
  final Uint8List? imageBytes;
  ImagePickerLoaded({this.imagePath, this.imageBytes});
}
final class ImagePickerError extends ImagePickerState {
  final String error;
  ImagePickerError({required this.error});
}