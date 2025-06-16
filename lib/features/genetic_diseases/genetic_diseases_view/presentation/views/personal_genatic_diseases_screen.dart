import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/genetic_diseases/data/models/personal_genetic_diseases_response_model.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/logic/genetics_diseases_view_cubit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/logic/genetics_diseases_view_state.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_grid_view.dart';

class PersonalGenaticDiseasesScreen extends StatefulWidget {
  const PersonalGenaticDiseasesScreen({super.key});

  @override
  State<PersonalGenaticDiseasesScreen> createState() =>
      _PersonalGenaticDiseasesScreenState();
}

class _PersonalGenaticDiseasesScreenState
    extends State<PersonalGenaticDiseasesScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GeneticsDiseasesViewCubit>()
        ..getPersonalGeneticDiseases()
        ..getCurrentPersonalGeneticDiseases(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DetailsViewAppBar(
                    title: 'الامراض الوراثية',
                    showActionButtons: false,
                  ),
                  verticalSpacing(20),
                ],
              ),
            ),
            // Tab Bar using single TabController instance
            Expanded(
              child: Column(
                children: [
                  TabBar(
                    tabs: const [
                      Tab(
                        text: 'الأمراض المتوقعة',
                      ),
                      Tab(
                        text: 'الأمراض الحالية',
                      ),
                    ],
                    controller: _tabController,
                    indicatorColor: AppColorsManager.mainDarkBlue,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Expected Personal Genetic Diseases Tab
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.h, left: 16.w, right: 16.w),
                          child: const ExpectedPersonalGenaticDiseases(),
                        ),
                        // Current Personal Genetic Diseases Tab
                        Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: const CurrentPersonalGeneticDiseases(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrentPersonalGeneticDiseases extends StatelessWidget {
  const CurrentPersonalGeneticDiseases({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          BlocBuilder<GeneticsDiseasesViewCubit, GeneticsDiseasesViewState>(
            builder: (context, state) {
              if (state.requestStatus == RequestStatus.loading) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: AppColorsManager.mainDarkBlue,
                ));
              } else if (state.requestStatus == RequestStatus.failure) {
                return Center(
                  child: Text(
                    state.message ?? "حدث خطأ ما",
                    style: AppTextStyles.font18blackWight500.copyWith(
                      color: AppColorsManager.textColor,
                    ),
                  ),
                );
              }
              if (state.currentPersonalGeneticDiseases == null ||
                  state.currentPersonalGeneticDiseases!.isEmpty) {
                return Center(
                  child: Text("لا توجد بيانات متاحة",
                      style: AppTextStyles.font22MainBlueWeight700),
                );
              }
              return MedicalItemGridView(
                items: state.currentPersonalGeneticDiseases ?? [],
                onTap: (id) async {
                  await Navigator.pushNamed(
                    context,
                    Routes.currentPersonalGeneticDiseasesDetailsView,
                    arguments: id,
                  );
                  // Refresh the data after returning from details view
                  context.mounted
                      ? await context
                          .read<GeneticsDiseasesViewCubit>()
                          .getCurrentPersonalGeneticDiseases()
                      : null;
                },
                titleBuilder: (item) => '${item.geneticDisease}',
                infoRowBuilder: (item) => [
                  {"title": "تاريخ التشخيص :", "value": item.date},
                  {"title": "حالة المرض :", "value": item.diseaseStatus},
                  {"title": "الدولة :", "value": item.country},
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ExpectedPersonalGenaticDiseases extends StatelessWidget {
  const ExpectedPersonalGenaticDiseases({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeneticsDiseasesViewCubit, GeneticsDiseasesViewState>(
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.requestStatus == RequestStatus.failure) {
          return Center(
            child: Text(
              state.message ?? "حدث خطأ ما",
              style: AppTextStyles.font18blackWight500.copyWith(
                color: AppColorsManager.textColor,
              ),
            ),
          );
        }
        if (state.expextedPersonalGeneticDiseases == null &&state.requestStatus == RequestStatus.success) {
          return Center(
            child: Text("لا توجد بيانات متاحة",
                style: AppTextStyles.font22MainBlueWeight700),
          );
        }
        return Column(
          children: [
            verticalSpacing(24),
            Text(
              "عند الضغط على المرض الوراثى تظهر \nجميع التفاصيل",
              textAlign: TextAlign.center,
              maxLines: 2,
              style: AppTextStyles.font22MainBlueWeight700.copyWith(
                color: AppColorsManager.textColor,
                fontFamily: "Rubik",
                fontSize: 20.sp,
                fontWeight: FontWeightHelper.medium,
              ),
            ),
            verticalSpacing(16),
            ExpectedPersonalGeneticDiseaseTable(
              personalGeneticDiseases: state.expextedPersonalGeneticDiseases!,
            ),
          ],
        );
      },
    );
  }
}

class ExpectedPersonalGeneticDiseaseTable extends StatelessWidget {
  const ExpectedPersonalGeneticDiseaseTable({
    super.key,
    required this.personalGeneticDiseases,
  });

  final List<PersonalGenaticDisease> personalGeneticDiseases;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            headingRowColor: MaterialStateProperty.all(const Color(0xFF014C8A)),
            headingTextStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            columnSpacing: 8.w,
            dataRowHeight: 80.h,
            horizontalMargin: 8.w,
            showBottomBorder: true,
            border: TableBorder.all(
              borderRadius: BorderRadius.circular(16.r),
              color: const Color(0xff909090),
              width: 0.3,
            ),
            columns: [
              _buildDataColumn("نوع المرض", flex: 2),
              _buildDataColumn(" احتمالية الاصابة", flex: 2),
              _buildDataColumn("التوصية", flex: 3),
            ],
            rows: personalGeneticDiseases.map((data) {
              return DataRow(
                cells: [
                  _buildDataCellCenter(data.geneticDisease, context,
                      isActive: true, maxWidth: 80.w),
                  _buildDataCellCenter(data.riskLevel, context,
                      isActive: false, maxWidth: 80.w),
                  _buildRecommendationCell(data.recommendation, context),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  DataColumn _buildDataColumn(String title, {int flex = 1}) {
    return DataColumn(
      headingRowAlignment: MainAxisAlignment.center,
      label: Expanded(
        flex: flex,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 13.sp,
            ),
          ),
        ),
      ),
    );
  }

  DataCell _buildDataCellCenter(String text, BuildContext context,
      {int maxLines = 2, required bool isActive, double? maxWidth}) {
    return DataCell(
      Container(
        width: maxWidth,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        child: Center(
          child: Text(
            text,
            maxLines: maxLines,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isActive ? AppColorsManager.mainDarkBlue : Colors.black87,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              decoration:
                  isActive ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ),
      ),
      onTap: isActive
          ? () {
              Navigator.pushNamed(
                context,
                Routes.personalGeneticDiseasesDetailsView,
                arguments: text,
              );
            }
          : null,
    );
  }

  DataCell _buildRecommendationCell(
      String recommendation, BuildContext context) {
    return DataCell(
      Container(
        constraints: BoxConstraints(
          maxWidth: 200.w,
          minHeight: 60.h,
        ),
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
        child: Text(
          recommendation,
          maxLines: 4,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
        ),
      ),
    );
  }
}

// Alternative solution using a custom table widget
class AlternativeGeneticDiseaseTable extends StatelessWidget {
  const AlternativeGeneticDiseaseTable({
    super.key,
    required this.personalGeneticDiseases,
  });

  final List<PersonalGenaticDisease> personalGeneticDiseases;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff909090), width: 0.3),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF014C8A),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildHeaderCell("نوع المرض"),
                ),
                Expanded(
                  flex: 2,
                  child: _buildHeaderCell("نطاق احتمالية\nالاصابة"),
                ),
                Expanded(
                  flex: 3,
                  child: _buildHeaderCell("التوصية"),
                ),
              ],
            ),
          ),
          // Data rows
          ...personalGeneticDiseases.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            final isLast = index == personalGeneticDiseases.length - 1;

            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: isLast
                      ? BorderSide.none
                      : const BorderSide(color: Color(0xff909090), width: 0.3),
                ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildDataCell(
                        data.geneticDisease,
                        context,
                        isActive: true,
                        onTap: () => Navigator.pushNamed(
                          context,
                          Routes.personalGeneticDiseasesDetailsView,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: _buildDataCell(data.riskLevel, context),
                    ),
                    Expanded(
                      flex: 3,
                      child: _buildDataCell(data.recommendation, context,
                          maxLines: 4),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      child: Text(
        title,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontSize: 13.sp,
        ),
      ),
    );
  }

  Widget _buildDataCell(
    String text,
    BuildContext context, {
    bool isActive = false,
    int maxLines = 3,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(color: Color(0xff909090), width: 0.3),
          ),
        ),
        child: Center(
          child: Text(
            text,
            maxLines: maxLines,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isActive ? AppColorsManager.mainDarkBlue : Colors.black87,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              decoration:
                  isActive ? TextDecoration.underline : TextDecoration.none,
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }
}
