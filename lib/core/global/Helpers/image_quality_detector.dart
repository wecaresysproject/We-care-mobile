import 'dart:io';
import 'dart:typed_data';

import 'package:blur_detection/blur_detect/blur_algorithm.dart';
import 'package:blur_detection/blur_detect/compression.dart';
import 'package:image/image.dart';
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
      imageQuality: 50, //no compression
    ); //TODO: check  imageQuality: 100 later
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path); // Convert XFile to File

      if (await isImageShaky(imageFile)) {
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
      imageQuality: 50,
      //no compression
    ); //TODO: check  imageQuality: 100 later

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path); // Convert XFile to File

      if (await isImageShaky(imageFile)) {
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
  // Future<bool> _isImageBlurred(File file) async {
  //   return await BlurDetectionService.isImageBlurred(file);
  // }

  Future<bool> isImageShaky(File file) async {
    // Step 1: Copy the file
    String copiedFilePath = '${file.path}_copy.jpg';
    File copiedFile = await file.copy(copiedFilePath);

    // Step 2: Compress the copied image
    File compressedFile =
        await ImgCompression.imageCompression(picture: copiedFile);
    final imageBytes = await compressedFile.readAsBytes();
    final image = decodeImage(Uint8List.fromList(imageBytes));
    if (image == null) return false;

    final varianceOfLaplacian = VarianceOfLaplacian().compute(image);
    final tenengrad = TenengradFocusMeasureMetric().compute(image);
    final brenner = EnhancedBrennerFocusMeasureMetric().compute(image);

    // These thresholds are motion-blur specific
    bool isShaky =
        varianceOfLaplacian < 150 && tenengrad < 0.3 && brenner < 0.03;

    return isShaky;
  }
}
