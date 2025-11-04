import 'dart:io';
import '../../../../service/cloudinary/cloudinary_service.dart';

class UploadMobileUsecase {
  final CloudinaryService cloudinary;
  UploadMobileUsecase({required this.cloudinary});

  Future<String?> call(String imagePath) async {
    return await cloudinary.uploadImage(File(imagePath));
  }
}