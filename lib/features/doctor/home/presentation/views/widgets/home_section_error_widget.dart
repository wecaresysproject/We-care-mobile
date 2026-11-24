import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// Inline failure state for a single home section — the rest of the screen
/// keeps working while this section offers its own retry.
class HomeSectionErrorWidget extends StatelessWidget {
  const HomeSectionErrorWidget({
    super.key,
    required this.onRetry,
    this.height,
    this.compact = false,
    this.sectionName,
  });

  final VoidCallback onRetry;
  final double? height;

  /// Named in the message ("تعذر تحميل التعليقات") so it's clear which
  /// section failed.
  final String? sectionName;

  /// Icon-only retry, for tight slots like the header.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return IconButton(
        onPressed: onRetry,
        tooltip: 'إعادة المحاولة',
        icon: const Icon(Icons.refresh, color: AppColorsManager.mainDarkBlue),
      );
    }
    return Container(
      width: double.infinity,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColorsManager.homeSectionSurface,
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            sectionName != null
                ? 'تعذر تحميل $sectionName'
                : 'تعذر تحميل البيانات',
            textAlign: TextAlign.center,
            style: AppTextStyles.font13homeLabelWeight500,
          ),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}

/// Picks what a home section shows: its data once loaded (kept visible while
/// a refresh runs or fails), otherwise the error or the shimmer.
class HomeSectionStateWidget<T> extends StatelessWidget {
  const HomeSectionStateWidget({
    super.key,
    required this.data,
    required this.isFailure,
    required this.shimmer,
    required this.error,
    required this.builder,
  });

  final T? data;
  final bool isFailure;
  final Widget shimmer;
  final Widget error;
  final Widget Function(T data) builder;

  @override
  Widget build(BuildContext context) {
    final current = data;
    if (current != null) return builder(current);
    return isFailure ? error : shimmer;
  }
}
