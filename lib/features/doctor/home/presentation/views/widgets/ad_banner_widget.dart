import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// Home ads carousel — same look and behavior as the patient home's
/// `BannerCrausalWidget` (auto-playing, full-width rounded slides).
class AdBannerWidget extends StatelessWidget {
  const AdBannerWidget({super.key, required this.imageUrls});

  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 130.h,
        autoPlay: true,
        viewportFraction: 1,
        enlargeCenterPage: false,
      ),
      items: [
        for (final imageUrl in imageUrls)
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.fitWidth,
              width: double.infinity,
              placeholder: (context, url) => Skeletonizer(
                enabled: true,
                child: Container(
                  color: Colors.grey[300],
                  height: 130.h,
                  width: double.infinity,
                ),
              ),
              errorWidget: (context, url, error) => const Center(
                child: Icon(Icons.error_outline, color: Colors.red),
              ),
            ),
          ),
      ],
    );
  }
}

/// Failure state — same look as the patient home's ads error box, with a
/// fixed message naming the section (the raw server error, e.g. "Resource not
/// found", doesn't tell the doctor what failed).
class AdBannerErrorWidget extends StatelessWidget {
  const AdBannerErrorWidget({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.redAccent,
            size: 32,
          ),
          verticalSpacing(8),
          Text(
            "تعذر تحميل الإعلانات",
            textAlign: TextAlign.center,
            style: AppTextStyles.font14whiteWeight600.copyWith(
              color: AppColorsManager.textColor,
            ),
          ),
          verticalSpacing(12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh,
                size: 20,
                color: Colors.white,
              ),
              label: Text(
                "إعادة المحاولة",
                style: AppTextStyles.font14whiteWeight600,
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
