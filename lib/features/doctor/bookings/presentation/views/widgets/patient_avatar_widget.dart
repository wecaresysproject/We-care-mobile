import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// Circular patient/doctor photo — falls back to a generic person icon when
/// no photo URL exists yet (mock data has no per-patient photos pending a
/// real backend).
class PatientAvatarWidget extends StatelessWidget {
  const PatientAvatarWidget(
      {super.key, required this.photoUrl, this.size = 48});

  final String? photoUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (photoUrl == null) {
      return CircleAvatar(
        radius: (size / 2).r,
        backgroundColor: AppColorsManager.shimmerBase,
        child: Icon(
          Icons.person,
          size: (size * 0.55).r,
          color: AppColorsManager.unselectedNavIconColor,
        ),
      );
    }
    return CircleAvatar(
      radius: (size / 2).r,
      backgroundImage: AssetImage(photoUrl!),
    );
  }
}
