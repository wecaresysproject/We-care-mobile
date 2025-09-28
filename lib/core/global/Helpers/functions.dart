import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/networking/dio_serices.dart';

Widget verticalSpacing(double height) => SizedBox(
      height: height.h,
    );

Widget horizontalSpacing(double width) => SizedBox(
      width: width.w,
    );

String trimWord(String input, String wordToTrim) {
  return input.replaceAll(wordToTrim, "").trim();
}

bool isArabic() {
  return Intl.getCurrentLocale() == AppStrings.arabicLang;
}

/// Function to count words in the text
int countWords(String text) {
  List<String> words = text.trim().split(RegExp(r'\s+'));
  return words.isEmpty || words.first == "" ? 0 : words.length;
}

// 📥 Helper function to download images using Dio
Future<String?> downloadImage(
    String imageUrl, Directory tempDir, String fileName) async {
  try {
    final filePath = '${tempDir.path}/$fileName';
    await DioServices.getDio().download(imageUrl, filePath);
    return filePath;
  } catch (e) {
    AppLogger.error("⚠️ Failed to download image: $imageUrl - Error: $e");
    return null;
  }
}

/// Function to normalize Arabic text used in search feature
String normalizeArabic(String input) {
  return input
      .replaceAll(RegExp(r'[أإآا]'), 'ا') // كل الألفات → ا
      .replaceAll('ة', 'ه') // التاء المربوطة → ه
      .replaceAll('ى', 'ي') // الألف المقصورة → ي
      .toLowerCase()
      .trim();
}

String extractFirstMedicineName(String input) {
  return input.split(' ').first;
}

//TODO: change it in seperate services class later

final _audioPlayer =
    getIt<AudioPlayer>(); // You can also make this global or as a singleton

Future<void> playSound({required String assetPath}) async {
  await _audioPlayer.stop(); // Optional: stop previous if overlapping
  await _audioPlayer.play(AssetSource(assetPath));
}

// Future<void> stopSound() async {
//   await _audioPlayer.stop();
// }
Future<void> stopSound() async {
  if (_audioPlayer.state == PlayerState.playing) {
    await _audioPlayer.stop();
  }
}
