
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/eyes/eyes_view/Presentation/glasses_details_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_grid_view.dart';

class EyeGlassData {
  final String id ;
  final String date;
  final String doctor;
  final String hospital;
  final String leftEye;
  final String rightEye;
  final String store;
  final String notes;

  EyeGlassData({
    this.id = "",
    required this.date,
    required this.doctor,
    required this.hospital,
    required this.leftEye,
    required this.rightEye,
    required this.store,
    required this.notes,
  });
}

class EyeGlassesView extends StatelessWidget {
  const EyeGlassesView({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyData = List.generate(
      4,
      (index) => EyeGlassData(
        date: "1 / 3 / 2025",
        doctor: "د / أحمد أسامة",
        hospital: "الطبيب / المستشفى",
        leftEye: "-1.25",
        rightEye: "-1.25",
        store: "محل النظارات",
        notes: "هذا النص مثال",
      ),
    );

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.h),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          children: [
           DetailsViewAppBar(
              title: "بيانات النظارات",
              showActionButtons: false,
            ),
            verticalSpacing(12),
            Expanded(
              child: MedicalItemGridView(
                items: dummyData,
                onTap: (item) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EyesGlassesDetailsView(),
                    ),
                  );
                },
                titleBuilder: (item) => item.date,
                infoRowBuilder: (item) => [
                  {
                    "title": "الطبيب / المستشفى:",
                    "value": item.doctor,
                  },
                  {
                    "title": "قصر/طول النظر:",
                    "value": "${item.rightEye} / ${item.leftEye}",
                  },
                  {
                    "title": "محل النظارات:",
                    "value": item.store,
                  },
                  {
                    "title": "ملاحظات:",
                    "value": item.notes,
                  },
                ],
              ),
            ),
            verticalSpacing(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
  
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(158.w, 32.h),
                    backgroundColor: AppColorsManager.mainDarkBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("عرض المزيد",
                          style: AppTextStyles.font14whiteWeight600),
                      horizontalSpacing(8.w),
                      Icon(Icons.expand_more, color: Colors.white, size: 20.sp),
                    ],
                  ),
                ),
                Container(
                  width: 47.w,
                  height: 28.h,
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11.r),
                    border: Border.all(
                      color: AppColorsManager.mainDarkBlue,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "+4",
                      style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                        color: AppColorsManager.mainDarkBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}