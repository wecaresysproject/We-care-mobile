import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
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
                      DetailsViewAppBar(
                        title: familyMemberName,
                        shareFunction: () => shareDetails(context, state),
                        editFunction: () async {
                          final result = await context.pushNamed(
                            Routes.familyMemeberGeneticDiseaseDataEntryView,
                            arguments: {
                              "familyMemberGeneticDiseases":
                                  state.familyMemberGeneticDiseases,
                              'memberCode': familyMemberCode,
                              'memberName': familyMemberName
                            },
                          );

                          if (result == true) {
                            if (!context.mounted) return;
                            await context
                                .read<GeneticsDiseasesViewCubit>()
                                .getFamilyMembersGeneticDiseases(
                                  familyMemberCode: familyMemberCode,
                                  familyMemberName: familyMemberName,
                                );
                          }
                        },

                        // deleteFunction: () => getIt<GeneticsDiseasesViewCubit>().deleteFamilyMemberbyNameAndCode(
                        //   name: familyMemberName,
                        //   code: familyMemberCode,
                        // ),
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
                      GeneticDiseaseTable()
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}

class GeneticDiseaseTable extends StatelessWidget {
  const GeneticDiseaseTable({super.key});

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
          scrollDirection: Axis.vertical,
          child: DataTable(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            headingRowColor: WidgetStateProperty.all(
                const Color(0xFF014C8A)), // Header Background Color
            headingTextStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold), // Header Text
            columnSpacing: 9.5.w,
            dataRowHeight: 70.h,
            horizontalMargin: 10.w,
            showBottomBorder: true,
            border: TableBorder.all(
              borderRadius: BorderRadius.circular(16.r),
              color: const Color(0xff909090),
              width: 0.3,
            ),
            columns: [
              _buildDataColumn("المرض الوراثي"),
              _buildDataColumn("نوع الوراثة"),
              _buildDataColumn("حالة المرض"),
            ],
            rows:
                state.familyMemberGeneticDiseases!.geneticDiseases!.map((data) {
              return DataRow(
                cells: [
                  _buildDataCellCenter(data.geneticDisease, context,
                      isActive: true),
                  _buildDataCellCenter(data.inheritanceType, context,
                      isActive: false),
                  _buildDataCellCenter(data.diseaseStatus, context,
                      isActive: false),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  DataColumn _buildDataColumn(String title) {
    return DataColumn(
      headingRowAlignment: MainAxisAlignment.center,
      label: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  DataCell _buildDataCellCenter(String text, BuildContext context,
      {int maxLines = 3, required bool isActive}) {
    return DataCell(
      Center(
        child: Text(
          text,
          maxLines: maxLines,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? AppColorsManager.mainDarkBlue : Colors.black87,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            decoration:
                isActive ? TextDecoration.underline : TextDecoration.none,
          ),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.familyMemberGeneticDiseaseDetailsView,
          arguments: {
            'disease': text,
          },
        );
      },
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
