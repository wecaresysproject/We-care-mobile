import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/genetic_diseases/data/models/new_genetic_disease_model.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/create_new_gentic_disease_cubit.dart';

class CreateNewGeneticDiseaseView extends StatelessWidget {
  const CreateNewGeneticDiseaseView({
    super.key,
    required this.complaintId,
    this.editingGeneticDiseaseDetails,
  });

  final NewGeneticDiseaseModel? editingGeneticDiseaseDetails;
  final int? complaintId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateNewGenticDiseaseCubit>(
      create: (context) {
        final cubit = getIt<CreateNewGenticDiseaseCubit>();
        if (editingGeneticDiseaseDetails != null) {
          cubit.loadGeneticDiseaseDetailsViewForEditing(
            editingGeneticDiseaseDetails!,
          );
        } else {
          cubit.getAllRequestsForAddingNewGeneticDiseaseView();
        }
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.h,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBarWidget(
                haveBackArrow: true,
              ),
              verticalSpacing(24),
              BlocBuilder<CreateNewGenticDiseaseCubit,
                  CreateNewGeneticDiseaseState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserSelectionContainer(
                        containerBorderColor:
                            state.selectedDiseaseCategory == null
                                ? AppColorsManager.warningColor
                                : AppColorsManager.textfieldOutsideBorderColor,
                        options: state.diseasesClassfications,
                        categoryLabel: "فئة المرض",
                        bottomSheetTitle: "اختر الفئة",
                        onOptionSelected: (val) {
                          context
                              .read<CreateNewGenticDiseaseCubit>()
                              .updateSelectionOfGeneticDiseaseCategory(val);
                        },
                        containerHintText:
                            state.selectedDiseaseCategory ?? "اختر الفئة",
                        searchHintText: "ابحث عن الفئة",
                      ),
                      verticalSpacing(16),
                      UserSelectionContainer(
                        containerBorderColor:
                            state.selectedGeneticDisease == null
                                ? AppColorsManager.warningColor
                                : AppColorsManager.textfieldOutsideBorderColor,
                        options: [
                          "مرض السكري",
                          "مرض القلب",
                          "مرض السرطان",
                          "مرض الزهايمر",
                          "مرض باركنسون",
                          "مرض التصلب المتعدد",
                          "مرض التوحد",
                          "مرض الهيموفيليا",
                          "مرض الثلاسيميا",
                          "مرض الصرع",
                        ],
                        categoryLabel: "المرض الوراثى",
                        bottomSheetTitle: "اختر المرض الوراثى",
                        onOptionSelected: (val) {
                          context
                              .read<CreateNewGenticDiseaseCubit>()
                              .updateSelectionOfGeneticDisease(val);
                        },
                        containerHintText: state.selectedGeneticDisease ??
                            "اختر المرض الوراثى",
                        searchHintText: "ابحث عن المرض الوراثى",
                      ),
                      verticalSpacing(16),
                      UserSelectionContainer(
                        containerBorderColor:
                            state.selectedAppearanceAgeStage == null
                                ? AppColorsManager.warningColor
                                : AppColorsManager.textfieldOutsideBorderColor,
                        options: [
                          "الطفولة المبكرة (0-5 سنوات)",
                          "الطفولة المتوسطة (6-12 سنة)",
                          "المراهقة (13-19 سنة)",
                          "البلوغ (20-39 سنة)",
                          "الشيخوخة المبكرة (40-59 سنة)",
                          "الشيخوخة المتأخرة (60 سنة وما فوق)",
                        ],
                        categoryLabel: "المرحلة العمرية للظهور",
                        bottomSheetTitle: "اختر المرحلة العمرية للظهور",
                        onOptionSelected: (val) {
                          context
                              .read<CreateNewGenticDiseaseCubit>()
                              .updateSelectionOfAppearanceAgeStage(val);
                        },
                        containerHintText: state.selectedAppearanceAgeStage ??
                            "اختر المرحلة العمرية للظهور",
                        searchHintText: "ابحث عن المرحلة العمرية للظهور",
                      ),
                      verticalSpacing(16),
                      UserSelectionContainer(
                        containerBorderColor:
                            state.selectedPatientStatus == null
                                ? AppColorsManager.warningColor
                                : AppColorsManager.textfieldOutsideBorderColor,
                        options: state.diseasesStatuses,
                        categoryLabel: "حالة المرض",
                        bottomSheetTitle: "اختر حالة المرض",
                        onOptionSelected: (val) {
                          context
                              .read<CreateNewGenticDiseaseCubit>()
                              .updateSelectionOfDiseaseStatus(val);
                        },
                        containerHintText:
                            state.selectedPatientStatus ?? "اختر حالة المرض",
                        searchHintText: "ابحث عن حالة المرض",
                      ),
                      verticalSpacing(48),
                      buildAddNewGeneticDiseaseBlocListener(state, context),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAddNewGeneticDiseaseBlocListener(
      CreateNewGeneticDiseaseState state, BuildContext context) {
    return BlocListener<CreateNewGenticDiseaseCubit,
        CreateNewGeneticDiseaseState>(
      listener: (context, state) async {
        if (state.isNewDiseaseAddedSuccefully) {
          await showSuccess("تم اضافة المرض الوراثي بنجاح");
          if (!context.mounted) return;
          context.pop(result: true);
        }
        if (state.isEditingGeneticDiseaseSuccess) {
          await showSuccess("تم تعديل  تفاصيل المرض الوراثي بنجاح");
          if (!context.mounted) return;
          context.pop(result: true);
        }
      },
      child: AppCustomButton(
        title: state.isEditingGeneticDisease
            ? "تَعديلُ المرض الوراثي"
            : "اضافة المرض الوراثي",
        onPressed: () async {
          if (state.isFormsValidated) {
            state.isEditingGeneticDisease
                ? await context
                    .read<CreateNewGenticDiseaseCubit>()
                    .updateGeneticDisease(
                      complaintId!,
                      editingGeneticDiseaseDetails!,
                    )
                : await context
                    .read<CreateNewGenticDiseaseCubit>()
                    .saveNewGeneticDisease();
          }
        },
        isEnabled: state.isFormsValidated,
      ),
    );
  }
}
