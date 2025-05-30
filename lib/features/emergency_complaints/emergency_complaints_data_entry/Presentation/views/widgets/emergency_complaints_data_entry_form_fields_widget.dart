import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/add_new_item_button_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/SharedWidgets/word_limit_text_field_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_data_entry/Presentation/views/widgets/first_question_details_widget.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_data_entry/Presentation/views/widgets/medical_complains_list_view_widget.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_data_entry/Presentation/views/widgets/second_question_details_widget.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_data_entry/Presentation/views/widgets/thirst_question_details_widget.dart';

import '../../../logic/cubit/emergency_complaints_data_entry_cubit.dart';

class EmergencyComplaintDataEntryFormFields extends StatelessWidget {
  const EmergencyComplaintDataEntryFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmergencyComplaintsDataEntryCubit,
        EmergencyComplaintsDataEntryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "تاريخ ظهور الشكوى",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            DateTimePickerContainer(
              containerBorderColor: state.complaintAppearanceDate == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              placeholderText:
                  state.complaintAppearanceDate ?? "يوم / شهر / سنة",
              onDateSelected: (pickedDate) {
                context
                    .read<EmergencyComplaintsDataEntryCubit>()
                    .updateDateOfComplaint(pickedDate);
                log("xxx: pickedDate: $pickedDate"); //! 2024-02-14
              },
            ),

            state.medicalComplaints.isNotEmpty
                ? verticalSpacing(16)
                : SizedBox.shrink(),

            MedicalComplaintsListBlocBuilder(),

            verticalSpacing(16),

            buildAddNewComplainButtonBlocBuilder(context),

            verticalSpacing(16),
            FirstQuestionDetails(),
            verticalSpacing(16),

            SecondQuestionDetails(),
            verticalSpacing(16),
            ThirdQuestionDetails(),
            verticalSpacing(16),

            Text(
              "ملاحظات شخصية",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            WordLimitTextField(
              controller: context
                  .read<EmergencyComplaintsDataEntryCubit>()
                  .personalInfoController,
              hintText: "اكتب باختصار اى معلومات مهمة اخرى",

              // hintText: state.prescribtionEditedModel?.preDescriptionNotes ??
              //     "اكتب باختصار اى معلومات مهمة اخرى",
            ),

            ///TODO: handle this button in main view and remove it from here
            /// final section
            verticalSpacing(32),
            submitEmergencyDataEnteredBlocConsumer(),
            verticalSpacing(71),
          ],
        );
      },
    );
  }

  Widget buildAddNewComplainButtonBlocBuilder(BuildContext context) {
    return BlocBuilder<EmergencyComplaintsDataEntryCubit,
        EmergencyComplaintsDataEntryState>(
      buildWhen: (previous, current) =>
          current.medicalComplaints.length != previous.medicalComplaints.length,
      builder: (context, state) {
        return Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AddNewItemButton(
                text: state.medicalComplaints.isEmpty
                    ? "اضف الاعراض المرضية"
                    : 'أضف أعراض مرضية أخرى ان وجد',
                onPressed: () async {
                  final bool? result = await context.pushNamed(
                    Routes.addNewComplaintDetails,
                  );

                  if (result != null && context.mounted) {
                    await context
                        .read<EmergencyComplaintsDataEntryCubit>()
                        .fetchAllAddedComplaints();

                    if (!context.mounted) return;

                    ///to rebuild submitted button if user added new complain.
                    context
                        .read<EmergencyComplaintsDataEntryCubit>()
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

  Widget submitEmergencyDataEnteredBlocConsumer() {
    return BlocConsumer<EmergencyComplaintsDataEntryCubit,
        EmergencyComplaintsDataEntryState>(
      listenWhen: (prev, curr) =>
          curr.emergencyComplaintsDataEntryStatus == RequestStatus.failure ||
          curr.emergencyComplaintsDataEntryStatus == RequestStatus.success,
      buildWhen: (prev, curr) =>
          prev.isFormValidated != curr.isFormValidated ||
          prev.emergencyComplaintsDataEntryStatus !=
              curr.emergencyComplaintsDataEntryStatus,
      listener: (context, state) async {
        if (state.emergencyComplaintsDataEntryStatus == RequestStatus.success) {
          await showSuccess(state.message);
          if (!context.mounted) return;
          context.pop();
        } else {
          await showError(state.message);
        }
      },
      builder: (context, state) {
        return AppCustomButton(
          isLoading:
              state.emergencyComplaintsDataEntryStatus == RequestStatus.loading,
          title: state.isEditMode ? "تحديت البيانات" : context.translate.send,
          onPressed: () async {
            if (state.isFormValidated) {
              state.isEditMode
                  ? await context
                      .read<EmergencyComplaintsDataEntryCubit>()
                      .updateSpecifcEmergencyDocumentDataDetails(
                          context.translate)
                  : await context
                      .read<EmergencyComplaintsDataEntryCubit>()
                      .postEmergencyDataEntry(
                        context.translate,
                      );
            }
          },
          isEnabled: state.isFormValidated ? true : false,
        );
      },
    );
  }
}

//TODO: refactor it by removing and used shared one from the 'العرض'
class SymptomContainer extends StatelessWidget {
  const SymptomContainer({
    super.key,
    required this.isMainSymptom,
    required this.medicalComplaint,
    required this.onDelete,
  });

  final bool isMainSymptom;

  final MedicalComplaint medicalComplaint;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: isMainSymptom
          ? EdgeInsets.all(8)
          : EdgeInsets.only(left: 8, right: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppColorsManager.mainDarkBlue, width: 1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          if (isMainSymptom) // Conditionally render the main symptom title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "العرض المرضي الرئيسي",
                    style: AppTextStyles.font18blackWight500.copyWith(
                      color: AppColorsManager.mainDarkBlue,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ).paddingBottom(
                    16,
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  alignment: Alignment.topCenter,
                  icon: Icon(
                    Icons.delete,
                    size: 28.sp,
                    color: AppColorsManager.warningColor,
                  ),
                )
              ],
            ),
          DetailsViewInfoTile(
            title: "الأعراض المرضية - المنطقة",
            value: medicalComplaint.symptomsRegion.substring(2).trim(),
            isExpanded: true,
            icon: 'assets/images/symptoms_icon.png',
          ),
          verticalSpacing(16),
          DetailsViewInfoTile(
            title: "الأعراض المرضية - الشكوى",
            value: medicalComplaint.sypmptomsComplaintIssue,
            isExpanded: true,
            icon: 'assets/images/symptoms_icon.png',
          ),
          verticalSpacing(16),
          Row(
            children: [
              DetailsViewInfoTile(
                title: "طبيعة الشكوى",
                value: medicalComplaint.natureOfComplaint,
                icon: 'assets/images/file_icon.png',
              ),
              Spacer(),
              DetailsViewInfoTile(
                title: "حدة الشكوى",
                value: medicalComplaint.severityOfComplaint,
                icon: 'assets/images/heart_rate_search_icon.png',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
