import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:we_care/core/global/app_strings.dart';

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
