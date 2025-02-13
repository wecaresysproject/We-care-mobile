import 'dart:io';

import 'package:blur_detection/blur_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';

class ImagePickerService {
  final ImagePicker _picker = getIt<ImagePicker>();

  /// Stores the last successfully picked image
  File? _pickedImage;

  /// Getter to access the picked image outside the class
  File? get pickedImage => _pickedImage;

  /// Checks if the image is accepted and not blurred
  bool isImagePickedAccepted = false;

  /// Picks an image from the camera and checks for blur
  Future<bool> pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    ); //TODO: check  imageQuality: 100 later

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path); // Convert XFile to File

      if (await _isImageBlurred(imageFile)) {
        await showError("الصورة غير واضحة، يرجى إعادة المحاولة");
        isImagePickedAccepted = false;
        _pickedImage = null; // Clear picked image if blurred
        return false;
      }

      await showSuccess("تم ارفاق الصورة بنجاح");
      isImagePickedAccepted = true;
      _pickedImage = imageFile; // Store valid image
      return true;
    } else {
      await showError("لم يتم ارفاق الصورة");
      isImagePickedAccepted = false;
      _pickedImage = null;
      return false;
    }
  }

  /// Picks an image from the gallery and checks for blur
  Future<bool> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    ); //TODO: check  imageQuality: 100 later

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path); // Convert XFile to File

      if (await _isImageBlurred(imageFile)) {
        await showError("الصورة غير واضحة، يرجىإعادة المحاولة");
        isImagePickedAccepted = false;
        _pickedImage = null; // Clear picked image if blurred
        return false;
      }

      await showSuccess("تم ارفاق الصورة بنجاح");
      isImagePickedAccepted = true;
      _pickedImage = imageFile; // Store valid image
      return true;
    } else {
      await showError("لم يتم ارفاق الصورة");
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
