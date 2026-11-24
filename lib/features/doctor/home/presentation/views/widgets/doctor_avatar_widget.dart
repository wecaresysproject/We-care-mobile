import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// The doctor's photo in the home header. With no photo (or while it loads /
/// fails) it shows the first letter of the doctor's name on a blue gradient
/// instead of a grey person silhouette.
class DoctorAvatarWidget extends StatelessWidget {
  const DoctorAvatarWidget({
    super.key,
    required this.name,
    required this.photoUrl,
    this.width = 56,
    this.height = 44,
    this.radius = 16,
  });

  final String name;
  final String? photoUrl;
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final url = photoUrl;
    final fallback = _InitialAvatar(name: name, radius: radius);
    return SizedBox(
      width: width.w,
      height: height.h,
      child: url == null || url.isEmpty
          ? fallback
          : ClipRRect(
              borderRadius: BorderRadius.circular(radius.r),
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                imageBuilder: (context, image) => Stack(
                  fit: StackFit.expand,
                  children: [
                    Image(image: image, fit: BoxFit.cover),
                    const ColoredBox(
                      color: AppColorsManager.doctorPhotoOverlay,
                    ),
                  ],
                ),
                placeholder: (context, url) => fallback,
                errorWidget: (context, url, error) => fallback,
              ),
            ),
    );
  }
}

class _InitialAvatar extends StatelessWidget {
  const _InitialAvatar({required this.name, required this.radius});

  final String name;
  final double radius;

  /// First letter of the name, skipping the "د/" / "د." title prefix.
  String? get _initial {
    var clean = name.trim();
    for (final prefix in const ['د/', 'د.', 'د ']) {
      if (clean.startsWith(prefix)) {
        clean = clean.substring(prefix.length).trim();
        break;
      }
    }
    if (clean.isEmpty) return null;
    return String.fromCharCode(clean.runes.first);
  }

  @override
  Widget build(BuildContext context) {
    final initial = _initial;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff3D9BE9), AppColorsManager.homeHeadingDarkBlue],
        ),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColorsManager.homePrimaryBlue.withValues(alpha: 0.30),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: initial == null
            ? Icon(
                Icons.medical_services_rounded,
                size: 22.r,
                color: Colors.white,
              )
            //* Cairo's Arabic glyphs sit low in their line box; nudge the
            //* letter up so it reads optically centered.
            : Transform.translate(
                offset: Offset(0, -3.h),
                child: Text(
                  initial,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeightHelper.bold,
                    fontFamily: AppStrings.cairoFontFamily,
                    color: Colors.white,
                    height: 1,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                ),
              ),
      ),
    );
  }
}
