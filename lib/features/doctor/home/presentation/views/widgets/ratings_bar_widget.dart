import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/generated/l10n.dart';

class RatingsBarWidget extends StatelessWidget {
  const RatingsBarWidget({
    super.key,
    required this.ratingsCount,
    required this.averageRating,
  });

  static const _maxStars = 5;

  final int ratingsCount;

  /// 0–5 — rounded to whole stars for display.
  final double averageRating;

  @override
  Widget build(BuildContext context) {
    final filledStars = averageRating.round().clamp(0, _maxStars);
    Widget star({required bool filled}) => SvgPicture.asset(
          'assets/svgs/doctor_icon_star.svg',
          width: 20.w,
          height: 22.h,
          colorFilter: filled
              ? null
              : const ColorFilter.mode(
                  AppColorsManager.unselectedNavIconColor,
                  BlendMode.srcIn,
                ),
        );

    return _RatingsBarFrame(
      children: [
        // الشاشة LTR إجبارى، فالنجوم المليانة تبدأ من اليمين زى القراءة العربى.
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = _maxStars; i > 0; i--) star(filled: i <= filledStars),
          ],
        ),
        SizedBox(width: 20.w),
        Text('$ratingsCount', style: AppTextStyles.font18MainBlueWeight500),
        SizedBox(width: 20.w),
        Text(
          S.of(context).ratersLabel,
          style: AppTextStyles.font18MainBlueWeight500,
        ),
      ],
    );
  }
}

/// Failure state that keeps the bar's look and its "المقيمين" label, so it's
/// clear which section failed.
class RatingsBarErrorWidget extends StatelessWidget {
  const RatingsBarErrorWidget({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRetry,
      child: _RatingsBarFrame(
        children: [
          Icon(
            Icons.refresh,
            size: 22.r,
            color: AppColorsManager.mainDarkBlue,
          ),
          SizedBox(width: 6.w),
          Text(
            'تعذر التحميل',
            style: AppTextStyles.font13homeLabelWeight500,
          ),
          SizedBox(width: 20.w),
          Text(
            S.of(context).ratersLabel,
            style: AppTextStyles.font18MainBlueWeight500,
          ),
        ],
      ),
    );
  }
}

class _RatingsBarFrame extends StatelessWidget {
  const _RatingsBarFrame({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          gradient: LinearGradient(
            colors: [
              AppColorsManager.ratingsBarGradientStart,
              AppColorsManager.ratingsBarGradientEnd,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              offset: const Offset(0, 2),
              blurRadius: 1.5,
            ),
          ],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}
