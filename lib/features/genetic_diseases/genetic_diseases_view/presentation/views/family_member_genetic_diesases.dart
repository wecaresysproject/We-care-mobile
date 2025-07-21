import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/logic/genetics_diseases_view_cubit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/logic/genetics_diseases_view_state.dart';

class FamilyMemberGeneticDiseases extends StatelessWidget {
  const FamilyMemberGeneticDiseases({
    super.key,
    required this.familyMemberCode,
    required this.familyMemberName,
  });
  final String familyMemberCode;
  final String familyMemberName;

  void shareDetails(BuildContext context, GeneticsDiseasesViewState state) {
    if (state.familyMemberGeneticDiseases == null ||
        state.familyMemberGeneticDiseases!.geneticDiseases == null ||
        state.familyMemberGeneticDiseases!.geneticDiseases!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("لا توجد بيانات لمشاركتها")),
      );
      return;
    }

    final List<String> detailsList = state
        .familyMemberGeneticDiseases!.geneticDiseases!
        .map((disease) =>
            'المرض الوراثي: ${disease.geneticDisease}\nنوع الوراثة: ${disease.inheritanceType}\nحالة المرض: ${disease.diseaseStatus}')
        .toList();

    final String shareContent = '''
تفاصيل الأمراض الوراثية للعضو: $familyMemberName (${getFamilyMemberCode(familyMemberCode)})

${detailsList.join("\n\n")}
''';

    Share.share(shareContent);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GeneticsDiseasesViewCubit>(
      create: (BuildContext context) => getIt<GeneticsDiseasesViewCubit>()
        ..getFamilyMembersGeneticDiseases(
          familyMemberCode: familyMemberCode,
          familyMemberName: familyMemberName,
        ),
      child: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () async {
          await BlocProvider.of<GeneticsDiseasesViewCubit>(context)
              .getFamilyMembersGeneticDiseases(
            familyMemberCode: familyMemberCode,
            familyMemberName: familyMemberName,
          );
          if (context.mounted) {
            showSuccess("تم تحديث البيانات بنجاح");
          }
        },
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
            ),
            body: BlocConsumer<GeneticsDiseasesViewCubit,
                GeneticsDiseasesViewState>(
              listener: (context, state) {
                if (state.requestStatus == RequestStatus.success &&
                    state.isDeleteRequest) {
                  Navigator.pop(context);
                  showSuccess(state.message!);
                }
                if (state.requestStatus == RequestStatus.failure &&
                    state.isDeleteRequest) {
                  showError(state.message!);
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppBarWithCenteredTitle(
                          title: familyMemberName,
                          shareFunction: () => shareDetails(context, state),
                          editFunction: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              Routes.familyMemeberGeneticDiseaseDataEntryView,
                              arguments: {
                                "familyMemberGeneticDiseases":
                                    state.familyMemberGeneticDiseases,
                                'memberCode': familyMemberCode,
                                'memberName': familyMemberName
                              },
                            );
                            if (result == true && context.mounted) {
                              await context
                                  .read<GeneticsDiseasesViewCubit>()
                                  .getFamilyMembersGeneticDiseases(
                                    familyMemberCode: familyMemberCode,
                                    familyMemberName: familyMemberName,
                                  );
                            }
                          },
                          deleteFunction: () async =>
                              await BlocProvider.of<GeneticsDiseasesViewCubit>(
                                      context)
                                  .deleteFamilyMemberbyNameAndCode(
                            name: familyMemberName,
                            code: familyMemberCode,
                          ),
                        ),
                        verticalSpacing(24),
                        Text(
                          "“عند الضغط على المرض الوراثى تظهر جميع التفاصيل ”",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: AppTextStyles.font22MainBlueWeight700.copyWith(
                            color: AppColorsManager.textColor,
                            fontFamily: "Rubik",
                            fontSize: 20.sp,
                            fontWeight: FontWeightHelper.medium,
                          ),
                        ),
                        verticalSpacing(20),
                        Center(
                          child: Text(
                            "$familyMemberName : ${getFamilyMemberCode(familyMemberCode)}",
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: AppTextStyles.font20blackWeight600.copyWith(
                              color: AppColorsManager.mainDarkBlue,
                              fontWeight: FontWeightHelper.medium,
                            ),
                          ),
                        ),
                        verticalSpacing(20),
                        GeneticDiseaseTable(
                          familyMemberCode: familyMemberCode,
                          familyMemberName: familyMemberName,
                        )
                      ],
                    ),
                  ),
                );
              },
            )),
      ),
    );
  }
}

class GeneticDiseaseTable extends StatelessWidget {
  const GeneticDiseaseTable({
    super.key,
    required this.familyMemberCode,
    required this.familyMemberName,
  });
  final String familyMemberCode;
  final String familyMemberName;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeneticsDiseasesViewCubit, GeneticsDiseasesViewState>(
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.loading) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColorsManager.mainDarkBlue,
            ),
          );
        } else if (state.requestStatus == RequestStatus.failure) {
          return Center(
            child: Text(
              state.message ?? 'حدث خطأ ما',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.sp,
              ),
            ),
          );
        }
        if (state.familyMemberGeneticDiseases == null ||
            state.familyMemberGeneticDiseases!.geneticDiseases == null ||
            state.familyMemberGeneticDiseases!.geneticDiseases!.isEmpty) {
          return Center(
            child: Text(
              'لا توجد أمراض وراثية مسجلة لهذا العضو',
              style: TextStyle(
                color: AppColorsManager.mainDarkBlue,
                fontSize: 16.sp,
              ),
            ),
          );
        }

        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                headingRowColor:
                    WidgetStateProperty.all(const Color(0xFF014C8A)),
                headingTextStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                columnSpacing: 8.w,
                dataRowHeight: 80.h,
                horizontalMargin: 10.w,
                showBottomBorder: true,
                border: TableBorder.all(
                  borderRadius: BorderRadius.circular(16.r),
                  color: const Color(0xff909090),
                  width: 0.3,
                ),
                columns: [
                  _buildDataColumn("المرض الوراثي", flex: 3),
                  _buildDataColumn("نوع الوراثة", flex: 2),
                  _buildDataColumn("حالة المرض", flex: 2),
                ],
                rows: state.familyMemberGeneticDiseases!.geneticDiseases!
                    .map((data) {
                  return DataRow(
                    cells: [
                      _buildDataCellCenter(
                        data.geneticDisease,
                        context,
                        isActive: true,
                        maxWidth: 120.w,
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            Routes.familyMemberGeneticDiseaseDetailsView,
                            arguments: {
                              'disease': data.geneticDisease,
                              'familyMemberCode': familyMemberCode,
                              'familyMemberName': familyMemberName,
                            },
                          );
                          if (context.mounted) {
                            await context
                                .read<GeneticsDiseasesViewCubit>()
                                .getFamilyMembersGeneticDiseases(
                                    familyMemberCode: familyMemberCode,
                                    familyMemberName: familyMemberName);
                          }
                        },
                      ),
                      _buildDataCellCenter(
                        data.inheritanceType,
                        context,
                        isActive: false,
                        maxWidth: 120.w,
                      ),
                      _buildDataCellCenter(
                        data.diseaseStatus,
                        context,
                        isActive: false,
                        maxWidth: 90.w,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
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
              fontSize: 14.sp, // Reduced from 16.sp
            ),
          ),
        ),
      ),
    );
  }

  DataCell _buildDataCellCenter(String text, BuildContext context,
      {int maxLines = 2,
      required bool isActive,
      VoidCallback? onTap,
      double? maxWidth}) {
    return DataCell(
      Container(
        width: maxWidth,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
        child: Center(
          child: Text(
            text,
            maxLines: maxLines,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isActive ? AppColorsManager.mainDarkBlue : Colors.black87,
              fontSize: 13.sp, // Reduced from 14.sp
              fontWeight: FontWeight.w500,
              decoration:
                  isActive ? TextDecoration.underline : TextDecoration.none,
              height: 1.3, // Better line height
            ),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}

String getFamilyMemberCode(String familyMemberCode) {
  switch (familyMemberCode) {
    case 'Dad':
      return 'الأب';
    case 'Mom':
      return 'الأم';
    case 'Bro':
      return 'الأخ';
    case 'Sis':
      return 'الأخت';
    case 'GrandpaFather':
      return 'الجد';
    case 'GrandmaFather':
      return 'الجدة';
    case 'GrandpaMother':
      return 'الجد';
    case 'GrandmaMother':
      return 'الجدة';
    case 'MotherSideAunt':
      return 'الخاله';
    case 'MotherSideUncle':
      return 'الخال';
    case 'FatherSideAunt':
      return 'العمة';
    case 'FatherSideUncle':
      return 'العم ';
    default:
      return familyMemberCode; // Return the code as is if no match found
  }
}
