import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/add_new_item_button_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/Presentation/views/widgets/genetic_disease_template_widget.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/create_new_gentic_disease_cubit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/genetic_diseases_data_entry_cubit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/genetic_diseases_data_entry_state.dart';

class FamilyMemeberGeneticDiseaseDataEntryView extends StatelessWidget {
  const FamilyMemeberGeneticDiseaseDataEntryView({
    super.key,
    // this.medicineToEdit,
  });
  // final MedicineModel? medicineToEdit;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PersonalGeneticDiseasesDataEntryCubit>(
          create: (context) {
            final cubit = getIt<PersonalGeneticDiseasesDataEntryCubit>();
            // if (medicineToEdit != null) {
            //   cubit.loadMedicinesDataEnteredForEditing(medicineToEdit!);
            // } else {
            //   cubit.initialDataEntryRequests();
            // }
            cubit.fetchAllAddedGeneticDiseases();
            return cubit;
          },
        ),
        BlocProvider<CreateNewGenticDiseaseCubit>(
          create: (context) => getIt<CreateNewGenticDiseaseCubit>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 50.h),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBarWidget(
                      haveBackArrow: true,
                    ),
                    verticalSpacing(24),
                    Text(
                      "الاسم",
                      style: AppTextStyles.font18blackWight500,
                    ),
                    verticalSpacing(12),
                    CustomTextField(
                      hintText: 'اكتب اسم الشخص المصاب',
                      validator: (context) {
                        return null;
                      },
                    ),
                    verticalSpacing(20),
                    GeneticDiseaseTemplateListBlocBuilder(),
                    verticalSpacing(20),
                    buildAddNewGeneticDiseaseButtonBlocBuilder(context),
                    verticalSpacing(40),
                    submitGeneticDiseasesButtonBlocConsumer(context),
                  ],
                ),
              ),
            ),
            // // Floating button at bottom-left
            // Positioned(
            //   bottom: MediaQuery.of(context).size.height * 0.1,
            //   left: 16.w,
            //   child: SmartAssistantButton(
            //     title: 'مساعد ذكي',
            //     subtitle: 'ابن سهل البلخي',
            //     imagePath: "assets/images/genetic_dissease_module.png",
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class GeneticDiseaseTemplateListBlocBuilder extends StatelessWidget {
  const GeneticDiseaseTemplateListBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalGeneticDiseasesDataEntryCubit,
        PersonalGeneticDiseasesDataEntryState>(
      buildWhen: (previous, current) =>
          previous.geneticDiseases != current.geneticDiseases,
      builder: (context, state) {
        if (state.geneticDiseases.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListView.builder(
          itemCount: state.geneticDiseases.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final disease = state.geneticDiseases[index];
            return GestureDetector(
              onTap: () async {
                final bool? result = await context.pushNamed(
                  Routes.createNewGeneticDiseaseView,
                  arguments: {
                    'id': index,
                    'geneticDisease': disease,
                  },
                );
                if (result != null && context.mounted) {
                  await context
                      .read<PersonalGeneticDiseasesDataEntryCubit>()
                      .fetchAllAddedGeneticDiseases();
                }
              },
              child: GeneticDiseaseTemplateContainer(
                geneticDisease: disease,
                onDelete: () async {
                  final cubit =
                      context.read<PersonalGeneticDiseasesDataEntryCubit>();
                  await cubit.removeAddedGeneticDisease(index);
                  await cubit.fetchAllAddedGeneticDiseases();
                },
              ).paddingBottom(16),
            );
          },
        );
      },
    );
  }
}

Widget submitGeneticDiseasesButtonBlocConsumer(BuildContext context) {
  return AppCustomButton(
    isLoading: false,
    title: context.translate.send,
    onPressed: () async {},
    isEnabled: true,
  );
}

Widget buildAddNewGeneticDiseaseButtonBlocBuilder(BuildContext context) {
  return BlocBuilder<PersonalGeneticDiseasesDataEntryCubit,
      PersonalGeneticDiseasesDataEntryState>(
    builder: (context, state) {
      return Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AddNewItemButton(
              text: state.geneticDiseases.isEmpty
                  ? "أضف مرض وراثى"
                  : "أضف مرض وراثى اخر ان وجد",
              onPressed: () async {
                final bool? result = await context.pushNamed(
                  Routes.createNewGeneticDiseaseView,
                );

                if (result != null && context.mounted) {
                  await context
                      .read<PersonalGeneticDiseasesDataEntryCubit>()
                      .fetchAllAddedGeneticDiseases();

                  if (!context.mounted) return;

                  // ///to rebuild submitted button if user added new complain.
                  context
                      .read<PersonalGeneticDiseasesDataEntryCubit>()
                      .validateRequiredFields();
                }
              },
            ),
            Positioned(
              top: -2, // move it up (negative means up)
              left: -120,
              child: Lottie.asset(
                'assets/images/hand_animation.json',
                width: 120, // adjust sizes
                height: 120,
                addRepaintBoundary: true,
                repeat: true,
                alignment: Alignment.center,
              ),
            ),
          ],
        ),
      );
    },
  );
}
