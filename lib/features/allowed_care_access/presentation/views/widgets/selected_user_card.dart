import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/allowed_care_access/data/models/search_phone_number_response.dart';

class SelectedUserCard extends StatelessWidget {
  final SearchPhoneNumberUser user;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectedUserCard({
    super.key,
    required this.user,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF4F8FF)
              : Colors.white, // Light blue tint if selected
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? const Color(0xFFE5EEFF) : Colors.grey.shade200,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            _UserAvatar(user: user),
            SizedBox(width: 10.w),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: AppTextStyles.font14BlueWeight700.copyWith(
                      fontSize: 16.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    user.phoneNumber,
                    style: AppTextStyles.font14blackWeight400.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: 13.sp,
                    ),
                    textDirection: TextDirection.ltr,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50), // Green background
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// صورة المستخدم، ومن غيرها أول حرف من اسمه.
class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.user});

  final SearchPhoneNumberUser user;

  @override
  Widget build(BuildContext context) {
    final image = user.profileImage?.trim() ?? '';
    final initial = Container(
      color: const Color(0xFFE5EEFF),
      alignment: Alignment.center,
      child: Text(
        user.fullName.trim().isEmpty ? '?' : user.fullName.trim()[0],
        style: AppTextStyles.font14BlueWeight700.copyWith(fontSize: 16.sp),
      ),
    );
    return ClipOval(
      child: SizedBox(
        width: 42.w,
        height: 42.w,
        child: image.isEmpty
            ? initial
            : CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                placeholder: (_, __) => initial,
                errorWidget: (_, __, ___) => initial,
              ),
      ),
    );
  }
}
