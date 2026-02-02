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

///
final formatter = NumberFormat.decimalPattern('ar');

/// Validates that the date coming from the API is usable by the UI.
/// Filters out placeholder or invalid values such as "--/--/----"
/// to avoid parsing errors and unnecessary UI states.
bool isValidDay(String date) {
  if (date.trim().isEmpty) return false;
  if (date.contains('--')) return false;
  if (date == '--/--/----') return false;
  return true;
}

/// Safely parses API dates in the format dd/MM/yyyy.
/// Returns null for invalid or placeholder dates to prevent crashes
/// and keep the UI logic stable.
DateTime? safeParseApiDate(String rawDate) {
  if (!isValidDay(rawDate)) return null;

  try {
    final cleaned = rawDate.trim().replaceAll('-', '/');
    final parts = cleaned.split('/');

    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) return null;

    return DateTime(year, month, day);
  } catch (_) {
    return null;
  }
}

/// Determines whether a given day is a future day.
/// Used to control UI behavior for future entries across
/// Nutrition, Vitamins & Supplements, and Physical Activity modules,
/// preventing data entry before the actual day starts.
bool isFutureDay(String dateString) {
  final parsedDate = safeParseApiDate(dateString);
  if (parsedDate == null) return false;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return parsedDate.isAfter(today);
}

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

String sanitizeDosageForPdf(String? input) {
  if (input == null || input.trim().isEmpty) {
    return "لا يوجد";
  }

  String text = input;

  // ----------------------------
  // 1️⃣ Replace Unicode Fractions
  // ----------------------------
  const fractionMap = {
    '½': ' 1/2',
    '¼': ' 1/4',
    '¾': ' 3/4',
    '⅓': ' 1/3',
    '⅔': ' 2/3',
    '⅛': ' 1/8',
    '⅜': ' 3/8',
    '⅝': ' 5/8',
    '⅞': ' 7/8',
  };

  fractionMap.forEach((key, value) {
    text = text.replaceAll(key, value);
  });

  // ----------------------------------
  // 2️⃣ Normalize Arabic Numbers → EN
  // ----------------------------------
  const arabicNumbers = {
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
  };

  arabicNumbers.forEach((key, value) {
    text = text.replaceAll(key, value);
  });

  // ----------------------------------
  // 3️⃣ Fix common mixed patterns
  // ----------------------------------
  text = text
      .replaceAll(RegExp(r'\s+'), ' ') // multiple spaces
      .replaceAll(' / ', '/') // spacing around fractions
      .trim();

  // ----------------------------------
  // 4️⃣ Final PDF-safe fallback
  // ----------------------------------
  if (text.isEmpty) {
    return "لا يوجد";
  }

  return text;
}
