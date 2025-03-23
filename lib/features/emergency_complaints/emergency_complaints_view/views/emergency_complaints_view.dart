import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/emergency_%20complaints/emergency_complaints_view/logic/emergency_complaint_view_state.dart';
import 'package:we_care/features/emergency_%20complaints/emergency_complaints_view/logic/emergency_complaints_view_cubit.dart';
import 'package:we_care/features/emergency_%20complaints/emergency_complaints_view/views/emergency_complaints_details_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_grid_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

class EmergencyComplaintsView extends StatelessWidget {
  const EmergencyComplaintsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EmergencyComplaintsViewCubit>()
        ..getUserEmergencyComplaintsList()
        ..getFilters(),
      child: Scaffold(
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
    return BlocBuilder<EmergencyComplaintsViewCubit,
        EmergencyComplaintViewState>(
      buildWhen: (previous, current) =>
          previous.emergencyComplaints != current.emergencyComplaints,
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.loading) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state.emergencyComplaints.isEmpty &&
            state.requestStatus == RequestStatus.success) {
          return Expanded(
            child: Center(
                child: Text(
              "لا يوجد بيانات",
              style: AppTextStyles.font22MainBlueWeight700,
            )),
          );
        }
        return MedicalItemGridView(
          items: state.emergencyComplaints,
          onTap: (id) async {
            final bool result =
                await Navigator.push(context, MaterialPageRoute(builder: (_) {
              return EmergencyComplaintsDetailsView(
                documentId: id,
              );
            }));
            if (result && context.mounted) {
              await context
                  .read<EmergencyComplaintsViewCubit>()
                  .getUserEmergencyComplaintsList();
              await context.read<EmergencyComplaintsViewCubit>().getFilters();
            }
          },
          titleBuilder: (item) =>
              item.mainSymptoms.first.complaintbodyPart.substring(2),
          isExpendingTileTitle: true,
          infoRowBuilder: (item) => [
            {"title": "التاريخ:", "value": item.data},
            {
              "title": "العرض الرئيسي:",
              "value": item.mainSymptoms.first.symptomsComplaint
            },
          ],
        );
      },
    );
  }
}

class EmergencyComplaintsFiltersRow extends StatelessWidget {
  const EmergencyComplaintsFiltersRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmergencyComplaintsViewCubit,
        EmergencyComplaintViewState>(
      buildWhen: (previous, current) =>
          previous.yearsFilter != current.yearsFilter ||
          previous.bodyPartFilter != current.bodyPartFilter,
      builder: (context, state) {
        return DataViewFiltersRow(
          filters: [
            FilterConfig(
                title: 'السنة', options: state.yearsFilter, isYearFilter: true),
            FilterConfig(
              title: 'مكان الشكوى',
              options: state.bodyPartFilter,
            ),
          ],
          onApply: (selectedFilters) async {
            print("Selected Filters: $selectedFilters");
            await context
                .read<EmergencyComplaintsViewCubit>()
                .getFilteredEmergencyComplaintList(
                    year: selectedFilters['السنة'],
                    placeOfComplaint: selectedFilters['مكان الشكوى']);
          },
        );
      },
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
