import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/dental_module/dental_view/logic/dental_view_cubit.dart';
import 'package:we_care/features/dental_module/dental_view/logic/dental_view_state.dart';
import 'package:we_care/features/dental_module/dental_view/views/tooth_operation_details_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_grid_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

class ToothOperationsView extends StatelessWidget {
  const ToothOperationsView({super.key, required this.selectedTooth});
  final int selectedTooth;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<DentalViewCubit>()
        ..getDocumentsByToothNumber(toothNumber: selectedTooth.toString()),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.h,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            children: [
              ViewAppBar(),
              verticalSpacing(16),
              BlocBuilder<DentalViewCubit, DentalViewState>(
                buildWhen: (previous, current) =>
                    previous.selectedToothList != current.selectedToothList,
                builder: (context, state) {
                  if (state.requestStatus == RequestStatus.loading) {
                    return Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state.requestStatus == RequestStatus.failure) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          state.message ?? "حدث خطأ",
                          style: AppTextStyles.font16DarkGreyWeight400,
                        ),
                      ),
                    );
                  } else if (state.selectedToothList == null ||
                      state.selectedToothList!.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          "لا توجد بيانات",
                          style: AppTextStyles.font22MainBlueWeight700,
                        ),
                      ),
                    );
                  }
                  return MedicalItemGridView(
                    items: state.selectedToothList!,
                    onTap: (id) async {
                      final result = Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DentalOperationDetailsView(
                              documentId: id,
                            ),
                          )).then(
                        (value) async {
                          await context
                              .read<DentalViewCubit>()
                              .getDocumentsByToothNumber(
                                  toothNumber: selectedTooth.toString());
                        },
                      );
                    },
                    titleBuilder: (item) => 'السن ${item.teethNumber}',
                    infoRowBuilder: (item) => [
                      {"title": "السن:", "value": item.teethNumber},
                      {
                        "title": "تاريخ الأعراض:",
                        "value": item.symptomStartDate
                      },
                      {
                        "title": "الإجراء الطبي:",
                        "value": item.primaryProcedure
                      },
                      {"title": "نوع الألم:", "value": item.painNature},
                    ],
                  );
                },
              ),
              verticalSpacing(16),
              ToothOperationsFooterRow(),
            ],
          ),
        ),
      ),
    );
  }
}

class ToothOperationsFooterRow extends StatelessWidget {
  const ToothOperationsFooterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Load More Button
            ElevatedButton(
              onPressed: () {},
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
                  Text(
                    "عرض المزيد",
                    style: AppTextStyles.font14whiteWeight600.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  horizontalSpacing(8.w),
                  Icon(
                    Icons.expand_more,
                    color: Colors.white,
                    size: 20.sp,
                  ),
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
                  color: Color(0xFF014C8A),
                  width: 2,
                ),
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
        ),
      ],
    );
  }
}

class DentalRecord {
  final String tooth;
  final DateTime date;
  final String procedure;
  final String painLevel;
  final String id;

  DentalRecord({
    required this.tooth,
    required this.date,
    required this.procedure,
    required this.painLevel,
    required this.id,
  });
}

// Example mock list of dental records:
List<DentalRecord> mockDentalRecords = [
  DentalRecord(
    tooth: 'السن 12',
    date: DateTime(2025, 1, 25),
    procedure: 'علاج العصب',
    painLevel: 'متوسط',
    id: '1',
  ),
  DentalRecord(
    tooth: 'السن 14',
    date: DateTime(2025, 2, 10),
    procedure: 'خلع',
    painLevel: 'شديد',
    id: '2',
  ),
  DentalRecord(
    tooth: 'السن 11',
    date: DateTime(2025, 3, 5),
    procedure: 'تنظيف',
    painLevel: 'خفيف',
    id: '3',
  ),
  DentalRecord(
    tooth: 'السن 18',
    date: DateTime(2025, 4, 1),
    procedure: 'حشو تجميلي',
    painLevel: 'متوسط',
    id: '4',
  ),
  DentalRecord(
    tooth: 'السن 13',
    date: DateTime(2025, 5, 15),
    procedure: 'تثبيت تاج',
    painLevel: 'خفيف',
    id: '5',
  ),
];
