import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/prescription/Presentation_view/logic/prescription_view_cubit.dart';
import 'package:we_care/features/prescription/Presentation_view/logic/prescription_view_state.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/medical_test_card.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_grid_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

class PrescriptionView extends StatelessWidget {
  const PrescriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PrescriptionViewCubit>(
      create: (context) => getIt<PrescriptionViewCubit>()
        ..getPrescriptionFilters()
        ..getUserPrescriptionList(),
      child: BlocBuilder<PrescriptionViewCubit, PrescriptionViewState>(
        builder: (context, state) {
          if (state.requestStatus == RequestStatus.loading) {
            return Scaffold(
                backgroundColor: Colors.white,
                body: const Center(child: CircularProgressIndicator()));
          }
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 0.h,
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                children: [
                  ViewAppBar(),
                  DataViewFiltersRow(
                    filters: [
                      FilterConfig(
                          title: 'التاريخ',
                          options: state.yearsFilter,
                          isYearFilter: true),
                      FilterConfig(
                        title: 'التخصص',
                        options: state.specificationsFilter,
                      ),
                      FilterConfig(
                        title: 'الطبيب',
                        options: state.doctorNameFilter,
                      ),
                    ],
                    onApply: (selectedFilters) {
                      // Handle apply button action
                    },
                  ),
                  verticalSpacing(16),
                  MedicalItemGridView(
                    items: state.userPrescriptions,
                    onTap: (id) async {
                      await context.pushNamed(Routes.prescriptionDetailsView,
                          arguments: {'id': id});
                    },
                    titleBuilder: (item) =>
                        item.doctorName, // Extract the title dynamically
                    infoRowBuilder: (item) => [
                      {"title": "التخصص:", "value": item.doctorSpecialty},
                      {"title": "التاريخ:", "value": item.preDescriptionDate},
                      {"title": "المرض:", "value": item.disease},
                    ],
                  ),
                  verticalSpacing(16),
                  XRayDataViewFooterRow(),
                ],
              ),
            ),
          );
        },
      ),
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

List<PrescriptionData> prescriptionMockData = [
  PrescriptionData(
    id: '1',
    title: "د/ مصطفى محمود",
    specialty: "أنف وأذن وحنجرة",
    date: "25/1/2025",
    condition: "التهاب جيوب أنفية",
  ),
  PrescriptionData(
    id: '2',
    title: "د/ أحمد علي",
    specialty: "باطنة",
    date: "10/2/2025",
    condition: "ارتفاع ضغط الدم",
  ),
  PrescriptionData(
    id: '3',
    title: "د/ سارة حسن",
    specialty: "جلدية",
    date: "5/3/2025",
    condition: "أكزيما حادة",
  ),
  PrescriptionData(
    id: '4',
    title: "د/ رشا محمود",
    specialty: "قلب وأوعية دموية",
    date: "15/4/2025",
    condition: "صداع مزمن",
  ),
  PrescriptionData(
    id: '5',
    title: "د/ محمد خالد",
    specialty: "قلب وأوعية دموية",
    date: "20/5/2025",
    condition: "صداع مزمن",
  ),
  PrescriptionData(
    id: '6',
    title: "د/ مصطفى حسن",
    specialty: "قلب وأوعية دموية",
    date: "25/6/2025",
    condition: "صداع مزمن",
  ),
];
