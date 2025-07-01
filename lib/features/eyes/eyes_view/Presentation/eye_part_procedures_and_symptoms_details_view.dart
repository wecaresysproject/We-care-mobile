import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/logic/cubit/eyes_data_entry_cubit.dart';
import 'package:we_care/features/eyes/eyes_view/Presentation/eye_parts_proscedure_and_symptoms_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';

class EyePartProceduresAndSymptomsView extends StatelessWidget {
  const EyePartProceduresAndSymptomsView({super.key, required this.eyePart});
  final String eyePart;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EyesDataEntryCubit>(
      create: (context) => getIt<EyesDataEntryCubit>()
        ..getEyePartSyptomsAndProcedures(
          selectedEyePart: eyePart,
        ),
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: SingleChildScrollView(
              child: Column(
                spacing: 16.h,
                children: [
                  DetailsViewAppBar(
                    title: eyePart,
                    showActionButtons: false,
                  ),
                  DataViewFiltersRow(filters: [
                    FilterConfig(
                        title: '  السنة     ', options: ['2023', '2022']),
                    FilterConfig(
                      title: '  الفئة      ',
                      options: [
                        'الاعراض',
                        'الاجراءات',
                      ],
                    )
                  ], onApply: (selectedFilters) {}),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return MedicalItemCardHorizontal(
                          onArrowTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EyePartsProcedureAndSymptomsDetailsView(
                                  title: eyePart,
                                ),
                              ),
                            );
                          },
                          date: '1 / 3 / 2023',
                          procedures: [
                            'الاجراءات',
                            'الاجراءات',
                            'الاجراءات',
                          ],
                          symptoms: [
                            'الاعراض',
                            'الاعراض',
                            'الاعراض',
                          ],
                        );
                      }),
                  FooterRow(),
                  verticalSpacing(16),
                ],
              ),
            ),
          )),
    );
  }
}

class MedicalItemCardHorizontal extends StatelessWidget {
  final String date;
  final List<String>? procedures;
  final List<String>? symptoms;
  final VoidCallback? onArrowTap;

  const MedicalItemCardHorizontal({
    super.key,
    required this.date,
    this.procedures,
    this.symptoms,
    this.onArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onArrowTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: const [Color(0xFFECF5FF), Color(0xFFFBFDFF)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(0, 1),
              blurRadius: 3,
            )
          ],
          border: Border.all(color: Colors.grey.shade400, width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Date Header
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 32.w,
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColorsManager.mainDarkBlue),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  date,
                  style: AppTextStyles.font14BlueWeight700
                      .copyWith(fontSize: 14.sp),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 10.h),

            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// الإجراءات الطبية
                    if (procedures != null && procedures!.isNotEmpty) ...[
                      Text(
                        'الإجراءات الطبية :',
                        textAlign: TextAlign.start,
                        style: AppTextStyles.font14BlueWeight700
                            .copyWith(fontSize: 14.sp),
                      ),
                      ...procedures!.asMap().entries.map((entry) => Padding(
                            padding: EdgeInsets.only(right: 12.w, top: 2.h),
                            child: Text(
                              '${entry.key + 1}/ ${entry.value}',
                              style: AppTextStyles.font14blackWeight400,
                            ),
                          )),
                      SizedBox(height: 8.h),
                    ],

                    /// الأعراض المرضية
                    if (symptoms != null && symptoms!.isNotEmpty) ...[
                      Text(
                        'الأعراض المرضية :',
                        style: AppTextStyles.font14BlueWeight700
                            .copyWith(fontSize: 14.sp),
                      ),
                      ...symptoms!.asMap().entries.map((entry) => Padding(
                            padding: EdgeInsets.only(right: 12.w, top: 2.h),
                            child: Text(
                              '${entry.key + 1}/ ${entry.value}',
                              style: AppTextStyles.font14blackWeight400,
                            ),
                          )),
                    ],
                  ],
                ),

                const Spacer(),

                /// Arrow Icon
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: onArrowTap,
                    icon: Image.asset(
                      'assets/images/side_arrow_filled.png',
                      width: 24.w,
                      height: 24.h,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FooterRow extends StatelessWidget {
  const FooterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
              Text("عرض المزيد", style: AppTextStyles.font14whiteWeight600),
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
    );
  }
}
