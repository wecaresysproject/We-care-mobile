import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// Circular patient/doctor photo — falls back to a generic person icon when
/// there is no photo URL or it fails to load.
class PatientAvatarWidget extends StatelessWidget {
  const PatientAvatarWidget(
      {super.key, required this.photoUrl, this.size = 48});

  final String? photoUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final placeholder = CircleAvatar(
      radius: (size / 2).r,
      backgroundColor: AppColorsManager.shimmerBase,
      child: Icon(
        Icons.person,
        size: (size * 0.55).r,
        color: AppColorsManager.unselectedNavIconColor,
      ),
    );
    final url = photoUrl;
    if (url == null || url.isEmpty) return placeholder;

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url,
        width: size.r,
        height: size.r,
        fit: BoxFit.cover,
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, error) => placeholder,
      ),
    );
  }
}
