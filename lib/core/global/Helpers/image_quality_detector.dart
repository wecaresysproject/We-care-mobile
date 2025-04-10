import 'dart:io';

import 'package:blur_detection/blur_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/generated/l10n.dart';

class ImagePickerService {
  final ImagePicker _picker = getIt<ImagePicker>();

  /// Stores the last successfully picked image
  File? _pickedImage;

  /// Getter to access the picked image outside the class
  File? get pickedImage => _pickedImage;

  /// Checks if the image is accepted and not blurred
  bool isImagePickedAccepted = false;

  /// Picks an image from the camera and checks for blur
  Future<bool> pickImageFromCamera(S localozation) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      requestFullMetadata: false,
    ); //TODO: check  imageQuality: 100 later
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path); // Convert XFile to File

      if (await _isImageBlurred(imageFile)) {
        await showError(localozation.image_not_clear);
        isImagePickedAccepted = false;
        _pickedImage = null; // Clear picked image if blurred
        return false;
      }

      isImagePickedAccepted = true;
      _pickedImage = imageFile; // Store valid image
      return true;
    } else {
      isImagePickedAccepted = false;
      _pickedImage = null;
      return false;
    }
  }

  /// Picks an image from the gallery and checks for blur
  Future<bool> pickImageFromGallery(S localozation) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      requestFullMetadata: false,
    ); //TODO: check  imageQuality: 100 later

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path); // Convert XFile to File

      if (await _isImageBlurred(imageFile)) {
        await showError(localozation.image_not_clear);
        isImagePickedAccepted = false;
        _pickedImage = null; // Clear picked image if blurred
        return false;
      }

      isImagePickedAccepted = true;
      _pickedImage = imageFile; // Store valid image
      return true;
    } else {
      isImagePickedAccepted = false;
      _pickedImage = null;
      return false;
    }
  }

  /// Checks if the image is blurred
  Future<bool> _isImageBlurred(File file) async {
    return await BlurDetectionService.isImageBlurred(file);
  }
}
