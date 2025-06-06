import 'dart:io';

import 'package:pickleball_app/core/config/cloudinary/cloudinary_config.dart';
import 'package:pickleball_app/core/constants/app_constants.dart';
import 'package:pickleball_app/core/constants/app_global.dart';

class CloudinaryService {
  Future<String?> uploadImage(File file) async {
    try {
      final response = await globalApiService.postMultipart(
        '${AppConstants.cloudinaryUrl}/${CloudinaryConfig.cloudName}/image/upload',
        {'upload_preset': CloudinaryConfig.uploadPreset},
        file,
      );
      return response['secure_url'];
    } catch (error) {
      print('Failed to upload image: $error');
      return null;
    }
  }
}
