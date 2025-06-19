import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class EyesGlassesDetailsView extends StatelessWidget {
  const EyesGlassesDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.h),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
        child: Column(
          spacing: 16.h,
          children: [
            DetailsViewAppBar(
              title: 'بيانات النظارات',
              showActionButtons: true,
            ),
            Image.asset('assets/images/glass.png'),
            Row(children: [
              DetailsViewInfoTile(
                title: "تاريخ الفحص",
                value: "1 / 3 / 2025",
                icon: 'assets/images/data_search_icon.png',
              ),
              Spacer(),
              DetailsViewInfoTile(
                  title: "المركز/المستشفى",
                  value: "المستشفى",
                  icon: 'assets/images/date_icon.png'),
            ]),
            Row(children: [
              DetailsViewInfoTile(
                title: "الطبيب",
                value: "د / أحمد أسامة",
                icon: 'assets/images/doctor_name.png',
              ),
              Spacer(),
              DetailsViewInfoTile(
                  title: "محل النظارات",
                  value: "محل النظارات",
                  icon: 'assets/images/hospital_icon.png'),
            ]),
            Row(
              children: [
                DetailsViewInfoTile(
                  title: "حماية من ضوء \nازرق",
                  value: "نعم",
                  icon: 'assets/images/blue_light.png',
                  isSmallContainers: true,
                ),
                Spacer(),
                DetailsViewInfoTile(
                    title: "مقاومة الخدش",
                    value: "لا",
                    isSmallContainers: true,
                    icon: 'assets/images/scratch_protection.png'),
                Spacer(),
                DetailsViewInfoTile(
                  title: "مضاد للانعكاس",
                  value: "نعم",
                  isSmallContainers: true,
                  icon: 'assets/images/reflection.png',
                ),
              ],
            ),
            Row(
              children: [
                DetailsViewInfoTile(
                  title: "طبقة مضادة\n لبصمات",
                  value: "نعم",
                  isSmallContainers: true,
                  icon: 'assets/images/fingerprint.png',
                ),
                Spacer(),
                DetailsViewInfoTile(
                    title: "طبقة مضادة\n لضباب",
                    value: "لا",
                    isSmallContainers: true,
                    icon: 'assets/images/fog.png'),
                Spacer(),
                DetailsViewInfoTile(
                  title: "حماية من أشعة \nفوق بنفسجية",
                  value: "نعم",
                  isSmallContainers: true,
                  icon: 'assets/images/uv.png',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LensDetailsCard(
                  lensSide: "العدسة اليمنى",
                  icon: 'assets/images/right_lense.png',
                  lensData: {
                    "قصر/طول النظر": "+1.25",
                    "الاستجماتزم": "-1.25",
                    "محور الاستجماتزم": "-1.25",
                    "الإضافة البؤرية": "-1.25",
                    "تباعُد الحدقتين": "-1.25",
                    "معامل الانكسار": "-1.25",
                    "قطر العدسة": "-1.25",
                    "المركز والحواف": "-1.25",
                    "سطح العدسة": "-1.25",
                    "سُمك العدسة": "-1.25",
                    "نوع العدسة": "-1.25",
                  },
                ),
                SizedBox(width: 12.w),
                LensDetailsCard(
                  lensSide: "العدسة اليسرى",
                  icon: 'assets/images/left_lense.png',
                  lensData: {
                    "قصر/طول النظر": "+1.25",
                    "الاستجماتزم": "-1.25",
                    "محور الاستجماتزم": "-1.25",
                    "الإضافة البؤرية": "-1.25",
                    "تباعُد الحدقتين": "-1.25",
                    "معامل الانكسار": "-1.25",
                    "قطر العدسة": "-1.25",
                    "المركز والحواف": "-1.25",
                    "سطح العدسة": "-1.25",
                    "سُمك العدسة": "-1.25",
                    "نوع العدسة": "-1.25",
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
