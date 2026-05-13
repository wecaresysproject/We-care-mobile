import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';
import 'package:we_care/features/vaccine/data/models/get_user_vaccines_response_model.dart';
import 'package:we_care/features/vaccine/vaccine_view/logic/vaccine_view_cubit.dart';
import 'package:we_care/features/vaccine/vaccine_view/logic/vaccne_view_state.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';

class VaccineView extends StatelessWidget {
  const VaccineView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VaccineViewCubit>(
      create: (context) => getIt<VaccineViewCubit>()..initialRequests(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              BlocBuilder<VaccineViewCubit, VaccineViewState>(
                buildWhen: (previous, current) =>
                    previous.moduleGuidanceData != current.moduleGuidanceData,
                builder: (context, state) {
                  final guidance = state.moduleGuidanceData;
                  final hasVideo = guidance?.videoLink?.isNotEmpty == true;
                  final hasText =
                      guidance?.moduleGuidanceText?.isNotEmpty == true;

                  return SharedAppBar(
                    trailingActions: [
                      CircleIconButton(
                        icon: Icons.play_arrow,
                        color: hasVideo
                            ? AppColorsManager.mainDarkBlue
                            : Colors.grey,
                        onTap: hasVideo
                            ? () => launchYouTubeVideo(guidance!.videoLink)
                            : null,
                      ),
                      SizedBox(width: 12.w),
                      CircleIconButton(
                        icon: Icons.menu_book_outlined,
                        color: hasText
                            ? AppColorsManager.mainDarkBlue
                            : Colors.grey,
                        onTap: hasText
                            ? () {
                                ModuleGuidanceAlertDialog.show(
                                  context,
                                  title: 'التطعيمات',
                                  description: guidance!.moduleGuidanceText!,
                                );
                              }
                            : null,
                      ),
                    ],
                  );
                },
              ),
              VaccineViewFiltersRow(),
              verticalSpacing(32),
              VaccinesTableBlocBuilder(),
            ],
          ),
        ),
      ),
    );
  }
}

class VaccinesTableBlocBuilder extends StatelessWidget {
  const VaccinesTableBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VaccineViewCubit, VaccineViewState>(
      buildWhen: (previous, current) =>
          previous.userVaccines != current.userVaccines ||
          previous.requestStatus != current.requestStatus ||
          previous.isDeleteRequest != current.isDeleteRequest,
      builder: (context, state) {
        switch (state.requestStatus) {
          case RequestStatus.initial:
          case RequestStatus.loading:
            return const Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          case RequestStatus.failure:
            return Text(
              state.message,
              textAlign: TextAlign.center,
              style: AppTextStyles.font16DarkGreyWeight400,
            );
          case RequestStatus.success:
            if (state.userVaccines.isEmpty) {
              return Expanded(
                child: Center(
                  child: Text('لا يوجد بيانات',
                      style: AppTextStyles.font22MainBlueWeight700),
                ),
              );
            }
            return Expanded(
              flex: 12,
              child: buildTable(context, state.userVaccines,
                  state.moduleGuidanceData ?? ModuleGuidanceDataModel()),
            );
        }
      },
    );
  }
}

Widget buildTable(
  BuildContext context,
  List<UserVaccineModel> vaccinesData,
  ModuleGuidanceDataModel? moduleGuidanceData,
) {
  final ScrollController verticalController = ScrollController();
  final ScrollController horizontalController = ScrollController();
  return SingleChildScrollView(
    controller: verticalController,
    scrollDirection: Axis.vertical,
    child: SingleChildScrollView(
      controller: horizontalController,
      scrollDirection: Axis.horizontal,
      child: DataTable(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        headingRowColor: WidgetStateProperty.all(
            Color(0xFF014C8A)), // Header Background Color
        headingTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold), // Header Text
        columnSpacing: 22.w,
        dataRowHeight: 70.h,
        horizontalMargin: 10.w,
        showBottomBorder: true,
        border: TableBorder.all(
          borderRadius: BorderRadius.circular(16.r),
          color: Color(0xff909090),
          width: .3,
        ),
        columns: [
          _buildDataColumn("تاريخ التطعيم"),
          _buildDataColumn("اسم اللقاح"),
          _buildDataColumn("الرمز المختصر"),
          _buildDataColumn("فئة اللقاح"),
          _buildDataColumn("العمر النموذجي"),
          _buildDataColumn("وصف عمل اللقاح"),
          _buildDataColumn("الزامي/اختياري"),
          _buildDataColumn("المرض المستهدف"),
          _buildDataColumn("الجرعة"),
          _buildDataColumn("طريقة التطعيم"),
          _buildDataColumn("جهة تلقي التطعيم"),
          _buildDataColumn("الدولة"),
          _buildDataColumn("معلومات إضافية"),
        ],
        rows: vaccinesData.map((data) {
          return DataRow(cells: [
            _buildDataCell(data.date ?? "-"),
            _buildDataCell(data.vaccineName ?? "-"),
            _buildDataCell(data.abbreviationCode ?? "-"),
            _buildDataCell(data.vaccineCategory ?? "-"),
            _buildDataCell(data.perfectAge ?? "-"),
            _buildDataCell(data.vaccineActionDescription ?? "-"),
            _buildDataCell(data.priorityTake ?? "-"),
            _buildDataCell(data.targetDisease ?? "-"),
            _buildDataCell(data.dose ?? "-"),
            _buildDataCell(data.wayToTakeVaccine ?? "-"),
            _buildDataCell(data.vaccinationProvider ?? "-"),
            _buildDataCell(data.country ?? "-"),
            _buildDataCell(data.additionalInfo ?? "-"),
          ]);
        }).toList(),
      ),
    ),
  );
}

DataColumn _buildDataColumn(String label) {
  return DataColumn(
    headingRowAlignment: MainAxisAlignment.center,
    label: Center(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppTextStyles.font16DarkGreyWeight400.copyWith(
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontSize: 16.sp,
        ),
      ),
    ),
  );
}

DataCell _buildDataCell(String value) {
  return DataCell(
    Center(
      child: Text(
        value,
        maxLines: 3,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

class VaccineViewFiltersRow extends StatelessWidget {
  const VaccineViewFiltersRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VaccineViewCubit, VaccineViewState>(
      buildWhen: (previous, current) =>
          current.userSubmissionDates != previous.userSubmissionDates,
      builder: (context, state) {
        return DataViewFiltersRow(
          onApply: (selectedFilters) {
            final String? selectedDate = selectedFilters['السنة من'];
            final String? selectedDateTo = selectedFilters['السنة الى'];
            context.read<VaccineViewCubit>().emitUserVaccinesData(
                  dateFrom: selectedDate,
                  dateTo: selectedDateTo,
                );
          },
          filters: [
            FilterConfig(
              title: 'السنة من',
              options: state.userSubmissionDates,
              isYearFilter: true,
            ),
            FilterConfig(
              title: 'السنة الى',
              options: state.userSubmissionDates,
              isYearFilter: true,
            ),
          ],
        );
      },
    );
  }
}
