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
    return BlocProvider<GeneticDiseasesDataEntryCubit>(
      create: (context) =>
          getIt<GeneticDiseasesDataEntryCubit>()..getFamilyMembersNumbers(),
      child: Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            BlocBuilder<GeneticDiseasesDataEntryCubit,
                GeneticDiseasesDataEntryState>(
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
                        hintText: state.noOfBrothers,
                        controller: context
                            .read<GeneticDiseasesDataEntryCubit>()
                            .noOfBrothers,
                        question: "كم أخ لديك ؟",
                        onChanged: (value) {
                          context
                              .read<GeneticDiseasesDataEntryCubit>()
                              .onNumberOfBrothersChanged(value);
                        },
                      ),
                      verticalSpacing(24),
                      FamilyQuestionField(
                        hintText: state.noOfSisters,
                        controller: context
                            .read<GeneticDiseasesDataEntryCubit>()
                            .noOfSisters,
                        question: "كم أخت لديك ؟",
                        onChanged: (value) {
                          context
                              .read<GeneticDiseasesDataEntryCubit>()
                              .onNumberOfSistersChanged(value);
                        },
                      ),
                      verticalSpacing(24),
                      FamilyQuestionField(
                        hintText: state.noOfUncles,
                        controller: context
                            .read<GeneticDiseasesDataEntryCubit>()
                            .noOfUncles,
                        question: "كم عم لديك ؟",
                        onChanged: (value) {
                          context
                              .read<GeneticDiseasesDataEntryCubit>()
                              .onNumberOfUnclesChanged(value);
                        },
                      ),
                      verticalSpacing(24),
                      FamilyQuestionField(
                        hintText: state.noOfAunts,
                        controller: context
                            .read<GeneticDiseasesDataEntryCubit>()
                            .noOfAunts,
                        question: "كم عمة لديك ؟",
                        onChanged: (value) {
                          context
                              .read<GeneticDiseasesDataEntryCubit>()
                              .onNumberOfAuntsChanged(value);
                        },
                      ),
                      verticalSpacing(32),
                      FamilyQuestionField(
                        hintText: state.noOfMaternalUncles,
                        controller: context
                            .read<GeneticDiseasesDataEntryCubit>()
                            .noOfMaternalUncles,
                        question: "كم خال لديك ؟",
                        onChanged: (value) {
                          context
                              .read<GeneticDiseasesDataEntryCubit>()
                              .onNumberOfMaternalUnclesChanged(value);
                        },
                      ),
                      verticalSpacing(32),
                      FamilyQuestionField(
                        hintText: state.noOfMaternalAunts,
                        controller: context
                            .read<GeneticDiseasesDataEntryCubit>()
                            .noOfMaternalAunts,
                        question: "كم خالة لديك ؟",
                        onChanged: (value) {
                          context
                              .read<GeneticDiseasesDataEntryCubit>()
                              .onNumberOfMaternalAuntsChanged(value);
                        },
                      ),
                      verticalSpacing(112),
                      BlocConsumer<GeneticDiseasesDataEntryCubit,
                          GeneticDiseasesDataEntryState>(
                        listenWhen: (previous, current) =>
                            previous.submitFamilyMemebersNumberStatus ==
                                RequestStatus.failure ||
                            current.submitFamilyMemebersNumberStatus ==
                                RequestStatus.success,
                        listener: (context, state) async {
                          if (state.submitFamilyMemebersNumberStatus ==
                              RequestStatus.success) {
                            await showSuccess(state.message);
                            if (!context.mounted) return;
                            await context.pushNamed(
                              Routes.familyTreeViewFromDataEntry,
                            );
                          } else {
                            await showError(state.message);
                          }
                        },
                        builder: (context, state) {
                          return AppCustomButton(
                            isLoading: state.submitFamilyMemebersNumberStatus ==
                                RequestStatus.loading,
                            title: "ارسال",
                            onPressed: () async {
                              await context
                                  .read<GeneticDiseasesDataEntryCubit>()
                                  .editNoOfFamilyMembers();
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
