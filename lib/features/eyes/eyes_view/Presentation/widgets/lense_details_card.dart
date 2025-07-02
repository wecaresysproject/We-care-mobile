
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class LensDetailsCard extends StatelessWidget {
  final String lensSide; // "العدسة اليمنى" or "العدسة اليسرى"
  final String icon;
  final Map<String, String> lensData;

  const LensDetailsCard({
    super.key,
    required this.lensSide,
    required this.icon,
    required this.lensData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.topLeft,
          colors: [
            Color(0xFFEDF4FF),
            Color(0xFFEFF5FB),
            Color(0xff6EA1CB).withOpacity(0.45),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              lensSide == "العدسة اليسرى"
                  ? Image.asset(icon, height: 24.h, width: 24.w)
                  : SizedBox.shrink(),
              Text(
                lensSide,
                style: AppTextStyles.font14BlueWeight700,
              ),
              lensSide == "العدسة اليمنى"
                  ? Image.asset(icon, height: 24.h, width: 24.w)
                  : SizedBox.shrink(),
            ],
          ),
          SizedBox(height: 16.h),
          // All attributes
          ...lensData.entries.map((entry) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailsViewInfoTile(
                      title: entry.key,
                      value: entry.value,
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
