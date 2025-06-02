import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/smart_assistant_button_shared_widget.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/Presentation/views/widgets/familly_question_field_widget.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/genetic_diseases_data_entry_cubit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/genetic_diseases_data_entry_state.dart';

class NumberOfFamilyMembersView extends StatelessWidget {
  const NumberOfFamilyMembersView({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonalGeneticDiseasesDataEntryCubit>(
      create: (context) => getIt<PersonalGeneticDiseasesDataEntryCubit>(),
      child: Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            BlocBuilder<PersonalGeneticDiseasesDataEntryCubit,
                PersonalGeneticDiseasesDataEntryState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      CustomAppBarWidget(
                        haveBackArrow: true,
                      ),
                      verticalSpacing(32),
                      FamilyQuestionField(
                        hintText: state.noOfBrothers ?? '##',
                        controller: context
                            .read<PersonalGeneticDiseasesDataEntryCubit>()
                            .noOfBrothers,
                        question: "كم أخ لديك ؟",
                        onChanged: (value) {
                          context
                              .read<PersonalGeneticDiseasesDataEntryCubit>()
                              .onNumberOfBrothersChanged(value);
                        },
                      ),
                      verticalSpacing(24),
                      FamilyQuestionField(
                        hintText: state.noOfSisters ?? '##',
                        controller: context
                            .read<PersonalGeneticDiseasesDataEntryCubit>()
                            .noOfSisters,
                        question: "كم أخت لديك ؟",
                        onChanged: (value) {
                          context
                              .read<PersonalGeneticDiseasesDataEntryCubit>()
                              .onNumberOfSistersChanged(value);
                        },
                      ),
                      verticalSpacing(24),
                      FamilyQuestionField(
                        hintText: state.noOfUncles ?? '0',
                        controller: context
                            .read<PersonalGeneticDiseasesDataEntryCubit>()
                            .noOfUncles,
                        question: "كم عم لديك ؟",
                        onChanged: (value) {
                          context
                              .read<PersonalGeneticDiseasesDataEntryCubit>()
                              .onNumberOfUnclesChanged(value);
                        },
                      ),
                      verticalSpacing(24),
                      FamilyQuestionField(
                        hintText: state.noOfAunts ?? '0',
                        controller: context
                            .read<PersonalGeneticDiseasesDataEntryCubit>()
                            .noOfAunts,
                        question: "كم عمة لديك ؟",
                        onChanged: (value) {
                          context
                              .read<PersonalGeneticDiseasesDataEntryCubit>()
                              .onNumberOfAuntsChanged(value);
                        },
                      ),
                      verticalSpacing(32),
                      FamilyQuestionField(
                        hintText: state.noOfMaternalUncles ?? '0',
                        controller: context
                            .read<PersonalGeneticDiseasesDataEntryCubit>()
                            .noOfMaternalUncles,
                        question: "كم خال لديك ؟",
                        onChanged: (value) {
                          context
                              .read<PersonalGeneticDiseasesDataEntryCubit>()
                              .onNumberOfMaternalUnclesChanged(value);
                        },
                      ),
                      verticalSpacing(32),
                      FamilyQuestionField(
                        hintText: state.noOfMaternalAunts ?? '0',
                        controller: context
                            .read<PersonalGeneticDiseasesDataEntryCubit>()
                            .noOfMaternalAunts,
                        question: "كم خالة لديك ؟",
                        onChanged: (value) {
                          context
                              .read<PersonalGeneticDiseasesDataEntryCubit>()
                              .onNumberOfMaternalAuntsChanged(value);
                        },
                      ),
                      verticalSpacing(112),
                      BlocConsumer<PersonalGeneticDiseasesDataEntryCubit,
                          PersonalGeneticDiseasesDataEntryState>(
                        listenWhen: (previous, current) =>
                            previous.submitFamilyMemebersStatus ==
                                RequestStatus.failure ||
                            current.submitFamilyMemebersStatus ==
                                RequestStatus.success,
                        listener: (context, state) async {
                          if (state.submitFamilyMemebersStatus ==
                              RequestStatus.success) {
                            showSuccess(state.message);
                            await context.pushNamed(
                              Routes.familyTreeViewFromDataEntry,
                            );
                          } else {
                            await showError(state.message);
                          }
                        },
                        builder: (context, state) {
                          return AppCustomButton(
                            isLoading: state.submitFamilyMemebersStatus ==
                                RequestStatus.loading,
                            title: "ارسال",
                            onPressed: () async {
                              await context
                                  .read<PersonalGeneticDiseasesDataEntryCubit>()
                                  .uploadFamilyMemebersNumber();
                            },
                            isEnabled: true,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            // Floating button at bottom-left
            Positioned(
              bottom: 75.h,
              left: 16.w,
              child: SmartAssistantButton(
                title: 'مساعد ذكي',
                subtitle: 'ابن سهل البلخي',
                imagePath: "assets/images/genetic_dissease_module.png",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
