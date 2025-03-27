import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/surgeries/surgeries_view/logic/surgeries_view_cubit.dart';
import 'package:we_care/features/surgeries/surgeries_view/logic/surgeries_view_state.dart';
import 'package:we_care/features/surgeries/surgeries_view/views/surgery_details_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_grid_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

class SurgeriesView extends StatelessWidget {
  const SurgeriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SurgeriesViewCubit>(
      create: (context) => getIt<SurgeriesViewCubit>()
        ..getUserSurgeriesList()
        ..getSurgeriesFilters(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.h,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            children: [
              ViewAppBar(),
              BlocBuilder<SurgeriesViewCubit, SurgeriesViewState>(
                buildWhen: (previous, current) =>
                    previous.yearsFilter != current.yearsFilter ||
                    previous.surgeryNameFilter != current.surgeryNameFilter,
                builder: (context, state) {
                  return DataViewFiltersRow(
                    filters: [
                      FilterConfig(
                          title: 'السنة',
                          options: state.yearsFilter,
                          isYearFilter: true),
                      FilterConfig(
                        title: 'اسم العملية',
                        options: state.surgeryNameFilter,
                      ),
                    ],
                    onApply: (selectedFilters) {
                      print("Selected Filters: $selectedFilters");
                      if (selectedFilters['السنة'] == null) {
                        BlocProvider.of<SurgeriesViewCubit>(context)
                            .getFilteredSurgeryList(
                                surgeryName: selectedFilters['اسم العملية']);
                      }
                      BlocProvider.of<SurgeriesViewCubit>(context)
                          .getFilteredSurgeryList(
                              year: selectedFilters['السنة'],
                              surgeryName: selectedFilters['اسم العملية']);
                    },
                  );
                },
              ),
              verticalSpacing(16),
              BlocBuilder<SurgeriesViewCubit, SurgeriesViewState>(
                buildWhen: (previous, current) =>
                    previous.userSurgeries != current.userSurgeries,
                builder: (context, state) {
                  if (state.requestStatus == RequestStatus.loading) {
                    return Expanded(
                        child:
                            const Center(child: CircularProgressIndicator()));
                  } else if (state.userSurgeries.isEmpty &&
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
                    items: state.userSurgeries,
                    onTap: (id) async {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return SurgeryDetailsView(
                          documentId: id,
                        );
                      }));
                    },
                    titleBuilder: (item) => item.surgeryName,
                    infoRowBuilder: (item) => [
                      {"title": "التاريخ:", "value": item.surgeryDate},
                      {"title": "منطقة العملية:", "value": item.surgeryRegion},
                      {"title": "حالة العملية:", "value": item.surgeryStatus},
                      {"title": "ملاحظات:", "value": item.additionalNotes},
                    ],
                  );
                },
              ),
              verticalSpacing(16),
              XRayDataViewFooterRow(),
            ],
          ),
        ),
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

// Example usage with doctors' names and specialties
final surgeriesNamesFilters = FilterConfig(
  title: 'اسم العملية',
  options: [
    'القلب المفتوح',
    'تثبيت كسر',
    'زراعة الكلي',
    'القلب المفتوح',
    'تثبيت كسر',
    'زراعة الكلي',
    'القلب المفتوح',
    'تثبيت كسر',
    'زراعة الكلي',
  ],
);
final List<Surgery> surgeryMockData = [
  Surgery(
    id: "1",
    name: "القلب المفتوح",
    date: "25/1/2025",
    bodyPart: "قلب وأوعية دموية",
    status: "تمت بنجاح",
    notes: "هذه العملية أجريت لاستبدال صمام القلب التالف.",
  ),
  Surgery(
    id: "2",
    name: "استئصال الزائدة الدودية",
    date: "10/3/2024",
    bodyPart: "الزائدة الدودية",
    status: "تمت بنجاح",
    notes: "تمت إزالة الزائدة بسبب التهاب حاد.",
  ),
  Surgery(
    id: "3",
    name: "جراحة الليزر للعيون",
    date: "5/6/2023",
    bodyPart: "العين",
    status: "ناجحة",
    notes: "تم تصحيح ضعف النظر باستخدام تقنية الليزر.",
  ),
  Surgery(
    id: "4",
    name: "جراحة استبدال الركبة",
    date: "20/9/2022",
    bodyPart: "الركبة",
    status: "تمت بنجاح",
    notes: "تم استبدال مفصل الركبة بمفصل صناعي.",
  ),
  Surgery(
    id: "5",
    name: "جراحة إزالة الحصى من الكلى",
    date: "12/11/2021",
    bodyPart: "الكلى",
    status: "ناجحة",
    notes: "تمت إزالة حصوات الكلى باستخدام المنظار.",
  ),
  Surgery(
    id: "6",
    name: "جراحة تجميل الأنف",
    date: "15/2/2020",
    bodyPart: "الأنف",
    status: "ناجحة",
    notes: "أجريت الجراحة لأسباب تجميلية وتحسين التنفس.",
  ),
  Surgery(
    id: "7",
    name: "عملية استئصال المرارة",
    date: "8/8/2023",
    bodyPart: "المرارة",
    status: "تمت بنجاح",
    notes: "تمت إزالة المرارة بالمنظار بسبب الحصوات.",
  ),
  Surgery(
    id: "8",
    name: "جراحة الدماغ لاستئصال ورم",
    date: "30/4/2024",
    bodyPart: "الدماغ",
    status: "حرجة ولكن مستقرة",
    notes: "تم استئصال الورم بنجاح مع متابعة الحالة.",
  ),
  Surgery(
    id: "9",
    name: "جراحة العمود الفقري",
    date: "18/7/2022",
    bodyPart: "الظهر",
    status: "ناجحة",
    notes: "تم تصحيح انحناء العمود الفقري.",
  ),
  Surgery(
    id: "10",
    name: "عملية زراعة الكبد",
    date: "1/12/2023",
    bodyPart: "الكبد",
    status: "تحت المراقبة",
    notes: "تمت زراعة كبد جديد بنجاح مع متابعة دورية.",
  ),
];

class Surgery {
  final String id;
  final String name;
  final String date;
  final String bodyPart;
  final String status;
  final String notes;

  Surgery({
    required this.id,
    required this.name,
    required this.date,
    required this.bodyPart,
    required this.status,
    required this.notes,
  });

  // Factory method to create a Surgery from a JSON object (useful for APIs)
  factory Surgery.fromJson(Map<String, dynamic> json) {
    return Surgery(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      bodyPart: json['bodyPart'],
      status: json['status'],
      notes: json['notes'],
    );
  }

  //
}
