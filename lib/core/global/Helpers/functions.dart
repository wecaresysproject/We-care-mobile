import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:bidi/bidi.dart' as bidi;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/networking/dio_serices.dart';

///
final formatter = NumberFormat.decimalPattern('ar');

/// Formats any numeric value for UI display by:
/// - Removing all fractions (rounding to the nearest integer)
/// - Removing percentage symbols (if value was a percentage)
/// - Applying thousands separator for better readability
///
/// Examples:
/// formatNumber(34.5)    -> "35"
/// formatNumber(62.3)    -> "62"
/// formatNumber(10500.7) -> "10,501"
/// formatNumber(null)    -> "0"
String formatNumber(num? value) {
  return formatter.format((value ?? 0).round());
}

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

// 📥 Helper function to download any file using a fresh Dio instance to avoid global interceptors/headers
Future<String?> downloadFile(
    String url, Directory tempDir, String fileName) async {
  try {
    final filePath = '${tempDir.path}/$fileName';
    // Use a fresh Dio instance to avoid global headers (like Authorization)
    // which some servers might reject for static file paths.
    await Dio().download(url, filePath);
    return filePath;
  } catch (e) {
    AppLogger.error("⚠️ Failed to download file: $url - Error: $e");
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

/// Readable replacements for characters that would otherwise be expanded into
/// their raw Unicode decomposition by [sanitizeTextForPdf]. '½' decomposes to
/// "1⁄2" using U+2044 FRACTION SLASH, which Cairo has no glyph for, so we spell
/// these out instead. The leading space keeps "2½ حبة" readable as "2 1/2 حبة".
const _pdfPrettyReplacements = {
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

/// Makes [input] safe to render inside a generated PDF.
///
/// `package:pdf` shapes RTL text through `package:bidi`, which keeps two
/// parallel arrays while normalizing — one indexed by decomposed code point,
/// one by original code point. Any character whose Unicode *compatibility*
/// decomposition expands to more than one code point desynchronizes them and
/// throws `RangeError (length)`, aborting the whole export. Around 930 code
/// points do this, including Unicode fractions (½), Arabic presentation forms
/// (ﻻ, ﷺ), ℃, …, ™, №, roman numerals and fullwidth forms.
///
/// Pre-expanding those characters keeps the arrays aligned. Canonical
/// decompositions (é, آ) recompose correctly inside bidi and are left as-is,
/// since expanding them would strand combining marks the font may not cover.
String sanitizeTextForPdf(String? input) {
  if (input == null || input.isEmpty) return '';

  // Fast path. No code point below U+0080 can trip bidi (asserted in
  // pdf_text_sanitizer_test.dart), and most of a report — dates, codes,
  // numbers, image URLs — is pure ASCII. Skipping the rewrite and the
  // verification pass here keeps this cheap enough to call on every cell.
  var isAscii = true;
  for (var i = 0; i < input.length; i++) {
    if (input.codeUnitAt(i) > 0x7F) {
      isAscii = false;
      break;
    }
  }
  if (isAscii) return input;

  String text = input;
  _pdfPrettyReplacements.forEach((key, value) {
    text = text.replaceAll(key, value);
  });

  final buffer = StringBuffer();
  for (final rune in text.runes) {
    _expandForBidi(rune, buffer, 0);
  }
  final expanded = buffer.toString();

  // Verifying the whole string is not enough: `package:pdf` cuts a text span at
  // every rune the font has no glyph for (`_preProcessSpans`) and runs bidi on
  // each fragment separately, so a rune that only survives thanks to its
  // neighbours can still abort the export once it lands at a fragment edge.
  final fragmentSafe = _dropFragmentUnsafeRunes(expanded);

  // A handful of exotic code points (combining Greek marks, CJK vertical forms)
  // still trip bidi after expansion — drop them rather than fail the export.
  return _isBidiSafe(fragmentSafe)
      ? fragmentSafe
      : _dropBidiUnsafeRunes(fragmentSafe);
}

/// Per-rune verdicts, cached — a report reuses the same few hundred runes over
/// and over, and each verdict costs three bidi passes.
final Map<int, bool> _fragmentSafeRunes = {};

/// Whether [rune] survives bidi alone and at either edge of a fragment.
bool _isRuneFragmentSafe(int rune) => _fragmentSafeRunes.putIfAbsent(rune, () {
      final ch = String.fromCharCode(rune);
      return _isBidiSafe(ch) && _isBidiSafe('ا$ch') && _isBidiSafe('$chا');
    });

String _dropFragmentUnsafeRunes(String text) {
  var needsFilter = false;
  for (final rune in text.runes) {
    if (!_isRuneFragmentSafe(rune)) {
      needsFilter = true;
      break;
    }
  }
  if (!needsFilter) return text;

  final kept = StringBuffer();
  for (final rune in text.runes) {
    if (_isRuneFragmentSafe(rune)) kept.writeCharCode(rune);
  }
  return kept.toString();
}

void _expandForBidi(int rune, StringBuffer out, int depth) {
  final mapping = bidi.getDecompositionMapping(rune);
  if (depth > 8 ||
      mapping == null ||
      mapping.length < 2 ||
      bidi.getDecompositionType(rune) == null) {
    out.writeCharCode(rune);
    return;
  }
  for (final part in mapping) {
    _expandForBidi(part, out, depth + 1);
  }
}

bool _isBidiSafe(String text) {
  try {
    bidi.logicalToVisual(text);
    return true;
  } catch (_) {
    return false;
  }
}

/// Safety net for anything expansion did not settle. Each rune is probed on its
/// own rather than against the accumulated prefix, so a long paragraph costs one
/// bidi pass per rune instead of one per prefix. The result is verified once
/// more, and falls back to ASCII — which bidi always accepts — rather than let a
/// single glyph abort the export.
String _dropBidiUnsafeRunes(String text) {
  final kept = StringBuffer();
  for (final rune in text.runes) {
    final ch = String.fromCharCode(rune);
    if (_isBidiSafe(ch) && _isBidiSafe('ا$ch') && _isBidiSafe('$chا')) {
      kept.writeCharCode(rune);
    }
  }

  final result = kept.toString();
  if (_isBidiSafe(result)) return result;

  return String.fromCharCodes(result.codeUnits.where((unit) => unit < 0x80));
}

String sanitizeDosageForPdf(String? input) {
  if (input == null || input.trim().isEmpty) {
    return "لا يوجد";
  }

  // ----------------------------
  // 1️⃣ Replace Unicode Fractions
  //    (and anything else bidi chokes on)
  // ----------------------------
  String text = sanitizeTextForPdf(input);

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

Future<void> launchYouTubeVideo(String? url) async {
  await launchExternalUrl(url);
}

/// Opens [url] in the browser or its matching app. No-op for empty/invalid urls.
Future<void> launchExternalUrl(String? url) async {
  if (url == null || url.trim().isEmpty) {
    AppLogger.error("URL is null or empty");
    return;
  }

  final Uri uri = Uri.parse(url);
  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      AppLogger.error("Could not launch URL: $url");
    }
  } catch (e) {
    AppLogger.error("Error launching URL: $e");
  }
}

mixin SafeEmitMixin<T> on Cubit<T> {
  void safeEmit(T state) {
    if (!isClosed) {
      emit(state);
    }
  }
}

//* output dd/MM/yyyy from yyyy-MM-ddTHH:mm:ss.SSSSSSZ
String formatRequestDate(String? dateString) {
  if (dateString == null || dateString.isEmpty) {
    return 'غير معروف';
  }

  return DateFormat('dd/MM/yyyy').format(DateTime.parse(dateString).toLocal());
}
