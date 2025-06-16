import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/add_new_item_button_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_member_genatics_diseases_response_model.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/Presentation/views/widgets/genetic_disease_template_widget.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/create_new_gentic_disease_cubit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/genetic_diseases_data_entry_cubit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/genetic_diseases_data_entry_state.dart';

class FamilyMemeberGeneticDiseaseDataEntryView extends StatelessWidget {
  const FamilyMemeberGeneticDiseaseDataEntryView({
    super.key,
    required this.familyCodes,
    required this.memberName,
    this.editModel,
  });
  final FamilyMemberGeneticsDiseasesResponseModel? editModel;
  final String familyCodes;
  final String memberName;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GeneticDiseasesDataEntryCubit>(
          create: (context) {
            final cubit = getIt<GeneticDiseasesDataEntryCubit>();
            if (editModel != null) {
              cubit.loadGeneticDiseasesDataEnteredForEditing(
                editModel!,
              );
            } else {
              cubit.initialDataEntryRequests();
            }
            return cubit;
          },
        ),
        BlocProvider<CreateNewGenticDiseaseCubit>(
          create: (context) => getIt<CreateNewGenticDiseaseCubit>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
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
                Builder(builder: (context) {
                  return CustomTextField(
                    hintText: memberName,
                    onChanged: (p0) {
                      BlocProvider.of<GeneticDiseasesDataEntryCubit>(context)
                          .onFamilyMemberChanges(p0);
                    },
                    validator: (context) {
                      return null;
                    },
                  );
                }),
                verticalSpacing(20),
                GeneticDiseaseTemplateListBlocBuilder(),
                verticalSpacing(20),
                buildAddNewGeneticDiseaseButtonBlocBuilder(context),
                verticalSpacing(40),
                submitMemberGeneticDiseasesButtonBlocConsumer(
                  context,
                  familyCodes,
                  memberName,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GeneticDiseaseTemplateListBlocBuilder extends StatelessWidget {
  const GeneticDiseaseTemplateListBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeneticDiseasesDataEntryCubit,
        GeneticDiseasesDataEntryState>(
      buildWhen: (previous, current) =>
          previous.geneticDiseases != current.geneticDiseases,
      builder: (context, state) {
        if (state.geneticDiseases.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListView.builder(
          itemCount: state.geneticDiseases.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
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
                      .read<GeneticDiseasesDataEntryCubit>()
                      .fetchAllAddedGeneticDiseases();
                }
              },
              child: GeneticDiseaseTemplateContainer(
                geneticDisease: disease,
                onDelete: () async {
                  final cubit = context.read<GeneticDiseasesDataEntryCubit>();
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

Widget submitMemberGeneticDiseasesButtonBlocConsumer(
  BuildContext context,
  String code,
  String memberName,
) {
  return BlocConsumer<GeneticDiseasesDataEntryCubit,
      GeneticDiseasesDataEntryState>(
    listenWhen: (prev, curr) =>
        curr.submitMemberGeneticDiseaseDetailsStatus == RequestStatus.failure ||
        curr.submitMemberGeneticDiseaseDetailsStatus == RequestStatus.success,
    buildWhen: (prev, curr) =>
        prev.isFormValidated != curr.isFormValidated ||
        prev.submitMemberGeneticDiseaseDetailsStatus !=
            curr.submitMemberGeneticDiseaseDetailsStatus,
    listener: (context, state) async {
      if (state.submitMemberGeneticDiseaseDetailsStatus ==
          RequestStatus.success) {
        await showSuccess(state.message);
        if (!context.mounted) return;
        context.pop(result: true);
      } else {
        await showError(state.message);
      }
    },
    builder: (context, state) {
      return AppCustomButton(
        isLoading: state.submitMemberGeneticDiseaseDetailsStatus ==
            RequestStatus.loading,
        title: state.isEditMode ? "تحديت البيانات" : context.translate.send,
        onPressed: () async {
          await context
              .read<GeneticDiseasesDataEntryCubit>()
              .editGenticDiseaseForFamilyMember(
                memberCode: code,
                oldMembername: memberName,
              );
        },
        isEnabled: true,
      );
    },
  );
}

Widget buildAddNewGeneticDiseaseButtonBlocBuilder(BuildContext context) {
  return BlocBuilder<GeneticDiseasesDataEntryCubit,
      GeneticDiseasesDataEntryState>(
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
                      .read<GeneticDiseasesDataEntryCubit>()
                      .fetchAllAddedGeneticDiseases();

                  if (!context.mounted) return;

                  ///to rebuild submitted button if user added new complain.
                  context
                      .read<GeneticDiseasesDataEntryCubit>()
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
