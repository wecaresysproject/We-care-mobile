import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/emergency_%20complaints/emergency_complaints_view/views/emergency_complaints_details_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_grid_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

class EmergencyComplaintsView extends StatelessWidget {
  const EmergencyComplaintsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.h,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          children: [
            ViewAppBar(),
            EmergencyComplaintsFiltersRow(),
            verticalSpacing(16),
            EmergencyComplaintsViewListBuilder(),
            verticalSpacing(16),
            XRayDataViewFooterRow(),
          ],
        ),
      ),
    );
  }
}

class EmergencyComplaintsViewListBuilder extends StatelessWidget {
  const EmergencyComplaintsViewListBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MedicalItemGridView(
      items: complaints,
      onTap: (id) async {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return EmergencyComplaintsDetailsView();
        }));
      },
      titleBuilder: (item) => item.complaintArea,
      isExpendingTileTitle: true,
      infoRowBuilder: (item) => [
        {"title": "التاريخ:", "value": item.date},
        {"title": "العرض الرئيسي:", "value": item.symptom},
      ],
    );
  }
}

class EmergencyComplaintsFiltersRow extends StatelessWidget {
  const EmergencyComplaintsFiltersRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DataViewFiltersRow(
      filters: [
        FilterConfig(title: 'السنة', options: [], isYearFilter: true),
        FilterConfig(
          title: 'مكان الشكوى',
          options: [],
        ),
      ],
      onApply: (selectedFilters) async {},
    );
  }
}

class XRayDataViewFooterRow extends StatelessWidget {
  const XRayDataViewFooterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(158, 32),
            backgroundColor: AppColorsManager.mainDarkBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            padding: EdgeInsets.zero, // No default padding
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "عرض المزيد",
                style: AppTextStyles.font14whiteWeight600,
              ),
              horizontalSpacing(8),
              Icon(
                Icons.expand_more,
                color: Colors.white,
                weight: 100,
                size: 24.sp,
              ),
            ],
          ),
        ),
        Container(
          width: 47.w,
          height: 28.h,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11.r),
            border: Border.all(color: Color(0xFF014C8A), width: 2),
          ),
          child: Center(
            child: Text(
              "+10",
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

final List<EmergencyComplaint> complaints = [
  EmergencyComplaint(
      id: "1", complaintArea: "الرأس", date: "25/1/2025", symptom: "صداع نصفي"),
  EmergencyComplaint(
      id: "2",
      complaintArea: "الرأس",
      date: "25/1/2025",
      symptom: "صعوبة في التنفس"),
  EmergencyComplaint(
      id: "3", complaintArea: "الرأس", date: "25/1/2025", symptom: "تنميل"),
  EmergencyComplaint(
      id: "4",
      complaintArea: "الظهر",
      date: "25/1/2025",
      symptom: "انخفاض درجة الحرارة"),
];

class EmergencyComplaint {
  final String id;
  final String complaintArea;
  final String date;
  final String symptom;

  EmergencyComplaint({
    required this.id,
    required this.complaintArea,
    required this.date,
    required this.symptom,
  });
}
