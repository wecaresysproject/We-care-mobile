import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_image_with_title.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';

class EssentialDataView extends StatelessWidget {
  const EssentialDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.h,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          spacing: 16.h,
          children: [
            // App Bar with actions
            AppBarWithCenteredTitle(
              title: 'البيانات الاساسية',
              editFunction: () {
                // Handle edit action
              },
              shareFunction: () {
                // Handle share action
              },
              deleteFunction: () {
                // Handle delete action
              },
            ),

            DetailsViewInfoTile(
              title: "الاسم الرباعي",
              value: "علي احمد احمد محمد",
              icon: 'assets/images/notes_icon.png',
              isExpanded: true,
            ),

            // National ID and Birth Date Row
            Row(
              children: [
                    Expanded(
                  child: DetailsViewInfoTile(
                    title: "تاريخ الميلاد",
                    value: "3/5/2000",
                    icon: 'assets/images/date_icon.png',
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: DetailsViewInfoTile(
                    title: "الرقم الوطني",
                    value: "31207185401843",
                    icon: 'assets/images/id_icon.png',
                  ),
                ),            
              ],
            ),

            // Email
            DetailsViewInfoTile(
              title: "البريد الإلكتروني",
              value: "Zazz@domain.com",
              icon: 'assets/images/email_icon.png',
              isExpanded: true,
            ),

            // ID Photo
            DetailsViewImageWithTitleTile(
              image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoZiTtEidbOnNbPc8lR118c8hGlFylcDig-A&s', // Replace with actual image URL
              title: "صورة شخصية (4×6)",
              isShareEnabled: true,
            ),

            // Country and State Row
            Row(
              children: [
                Expanded(
                  child: DetailsViewInfoTile(
                    title: "دولة",
                    value: "مصر",
                    icon: 'assets/images/country_icon.png',
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: DetailsViewInfoTile(
                    title: "مدينة",
                    value: "نص مثال",
                    icon: 'assets/images/city_icon.png',
                  ),
                ),
              ],
            ),

            // Region/City
            DetailsViewInfoTile(
              title: "المنطقة/مدينة",
              value: "نص مثال",
              icon: 'assets/images/city_icon.png',
              isExpanded: true,
            ),

            // Blood Type and Working Hours Row
            Row(
              children: [
                Expanded(
                  child: DetailsViewInfoTile(
                    title: "فصيلة الدم",
                    value: "نص مثال",
                    icon: 'assets/images/blood_icon.png',
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: DetailsViewInfoTile(
                    title: "ساعات العمل",
                    value: "نص مثال",
                    icon: 'assets/images/times_icon.png',
                  ),
                ),
              ],
            ),

            // Insurance Company and Start Date Row
            Row(
              children: [
                Expanded(
                  child: DetailsViewInfoTile(
                    title: "شركة التأمين",
                    value: "نص مثال",
                    icon: 'assets/images/doctor_name.png',
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: DetailsViewInfoTile(
                    title: "انتهاء التغطية",
                    value: "25/10/2026",
                    icon: 'assets/images/date_icon.png',
                  ),
                ),
    
              ],
            ),

            // Additional Conditions
            DetailsViewInfoTile(
              title: "شروط إضافية",
              value: "نص مثال",
              icon: 'assets/images/notes_icon.png',
              isExpanded: true,
            ),

            // Insurance Photo
            DetailsViewImageWithTitleTile(
              image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoZiTtEidbOnNbPc8lR118c8hGlFylcDig-A&s', // Replace with actual image URL
              title: "صورة بطاقة التأمين",
              isShareEnabled: true,
            ),

            // Blood Type Section
            DetailsViewInfoTile(
              title: "نوع العجز",
              value: "نص مثال",
              icon: 'assets/images/disability_icon.png',
              isExpanded: true,
            ),

                        DetailsViewInfoTile(
                          title: "العجز إن وجد",
                          value: "نص مثال",
                          icon: 'assets/images/disability_icon.png',
                          isExpanded: true,
                        ),

            Row(
              children: [
                Expanded(
                  child: DetailsViewInfoTile(
                    title: "عدد الأطفال",
                    value: "4",
                    icon: 'assets/images/family_icon.png',
                  ),
                ),
            Expanded(
              child: DetailsViewInfoTile(
                title: "الحالة الاجتماعية",
                value: "نص مثال",
                icon: 'assets/images/social_icon.png',
              ),
            ),
              ],
            ),

            // Emergency Contacts Row
            Row(
              children: [
                Expanded(
                  child: DetailsViewInfoTile(
                    title: "هاتف الطوارئ 1",
                    value: "نص مثال",
                    icon: 'assets/images/phone_icon.png',
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: DetailsViewInfoTile(
                    title: "هاتف الطوارئ 2",
                    value: "نص مثال",
                    icon: 'assets/images/phone_icon.png',
                  ),
                ),
              ],
            ),


            // Address
            DetailsViewInfoTile(
              title: "طبيب الاسرة",
              value: "نص مثال",
              icon: 'assets/images/doctor_icon.png',
              isExpanded: true,
            ),
          ],
        ),
      ),
    );
  }
}