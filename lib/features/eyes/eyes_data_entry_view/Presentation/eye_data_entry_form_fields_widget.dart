import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/Database/dummy_data.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/select_image_container_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/show_image_picker_selection_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/word_limit_text_field_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/views/eye_procedures_and_syptoms_data_entry.dart';

class EyeDataEntryFormFields extends StatelessWidget {
  const EyeDataEntryFormFields({super.key, required this.selectedSyptoms});
  final List<SymptomItem> selectedSyptoms;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 70.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "تاريخ بداية الأعراض",
            style: AppTextStyles.font18blackWight500,
          ),
          verticalSpacing(10),

          DateTimePickerContainer(
            // containerBorderColor: state.xRayDateSelection == null
            //     ? AppColorsManager.warningColor
            //     : AppColorsManager.textfieldOutsideBorderColor,
            placeholderText: "يوم / شهر / سنة",
            onDateSelected: (pickedDate) {
              // context.read<XRayDataEntryCubit>().updateXRayDate(pickedDate);
              log("xxx: pickedDate: $pickedDate"); //! 2024-02-14
            },
          ),

          /// size between each categogry
          verticalSpacing(16),
          Text(
            "الاعراض",
            style: AppTextStyles.font18blackWight500,
          ),
          verticalSpacing(10),
          ...selectedSyptoms.map(
            (symptom) => buildCustomContainer(
              symptom: symptom,
            ),
          ),
          verticalSpacing(10),

          UserSelectionContainer(
            // containerBorderColor: state.syptomTypeSelection == null
            //     ? AppColorsManager.warningColor
            //     : AppColorsManager.textfieldOutsideBorderColor,
            categoryLabel: "مدة الأعراض",
            // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
            containerHintText: "اختر مدة الأعراض",
            options: [
              "يوم",
              "يومين",
              "ثلاث ايام",
              "اربع ايام",
              "خمسة ايام",
              "ستة ايام",
              "اسبوع",
              "عشر ايام",
              "اسبوعين",
              "ثلاث اسابيع",
              "شهر",
              "اكثر من شهر",
            ],

            onOptionSelected: (value) {
              // log("xxx:Selected: $value");
              // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
            },
            // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
            bottomSheetTitle: "اختر مدة الأعراض",
            searchHintText: "اختر مدة الأعراض",
          ),
          verticalSpacing(16),
          Text(
            "الإجراء الطبى",
            style: AppTextStyles.font18blackWight500,
          ),
          verticalSpacing(10),
          ...selectedSyptoms.map(
            (symptom) => buildCustomContainer(
              symptom: symptom,
            ),
          ),
          verticalSpacing(10),
          Text(
            "تاريخ الإجراء الطبي",
            style: AppTextStyles.font18blackWight500,
          ),
          verticalSpacing(10),

          DateTimePickerContainer(
            // containerBorderColor: state.xRayDateSelection == null
            //     ? AppColorsManager.warningColor
            //     : AppColorsManager.textfieldOutsideBorderColor,
            placeholderText: "يوم / شهر / سنة",
            onDateSelected: (pickedDate) {
              // context.read<XRayDataEntryCubit>().updateXRayDate(pickedDate);
              log("xxx: pickedDate: $pickedDate"); //! 2024-02-14
            },
          ),
          verticalSpacing(16),
          Text(
            "التقرير الطبي",
            style: AppTextStyles.font18blackWight500,
          ),
          verticalSpacing(10),
          SelectImageContainer(
            imagePath: "assets/images/t_shape_icon.png",
            label: "اكتب التقرير",
            onTap: () {},
          ),

          verticalSpacing(8),
          // BlocListener<XRayDataEntryCubit, XRayDataEntryState>(
          //   listenWhen: (previous, current) =>
          //       previous.xRayReportRequestStatus !=
          //       current.xRayReportRequestStatus,
          //   listener: (context, state) async {
          //     if (state.xRayReportRequestStatus ==
          //         UploadReportRequestStatus.success) {
          //       await showSuccess(state.message);
          //     }
          //     if (state.xRayReportRequestStatus ==
          //         UploadReportRequestStatus.failure) {
          //       await showError(state.message);
          //     }
          //   },
          //   child:
          SelectImageContainer(
            imagePath: "assets/images/photo_icon.png",
            label: " ارفق صورة للتقرير",
            onTap: () async {
              await showImagePicker(
                context,
                onImagePicked: (isImagePicked) async {
                  // final picker = getIt.get<ImagePickerService>();
                  // if (isImagePicked && picker.isImagePickedAccepted) {
                  //   await context
                  //       .read<XRayDataEntryCubit>()
                  //       .uploadXrayReportPicked(
                  //         imagePath: picker.pickedImage!.path,
                  //       );
                  // }
                },
              );
            },
          ),

          verticalSpacing(16),
          Text(
            "صورة الفحوصات الطبية",
            style: AppTextStyles.font18blackWight500,
          ),
          verticalSpacing(10),

          SelectImageContainer(
            imagePath: "assets/images/photo_icon.png",
            label: " ارفق صورة",
            onTap: () async {
              await showImagePicker(
                context,
                onImagePicked: (isImagePicked) async {
                  // final picker = getIt.get<ImagePickerService>();
                  // if (isImagePicked && picker.isImagePickedAccepted) {
                  //   await context
                  //       .read<XRayDataEntryCubit>()
                  //       .uploadXrayReportPicked(
                  //         imagePath: picker.pickedImage!.path,
                  //       );
                  // }
                },
              );
            },
          ),
          verticalSpacing(16),

          /// طبيب اسم

          UserSelectionContainer(
            allowManualEntry: true,
            categoryLabel: "اسم الطبيب",
            containerHintText: "اختر اسم طبيب المعالج",
            options: [
              "د / محمد محمد",
              "د / كريم محمد",
              "د / رشا محمد",
              "د / رشا مصطفى",
            ],
            onOptionSelected: (value) {
              log("xxx:Selected: $value");
            },
            bottomSheetTitle: 'اختر اسم طبيب',
            searchHintText: "ابحث عن اسم طبيب",
          ),

          verticalSpacing(16),

          /// المركز / المستشفى
          //   //! write by ur hand
          UserSelectionContainer(
            allowManualEntry: true,
            categoryLabel: "المركز / المستشفى",
            containerHintText: "اختر اسم المستشفى/المركز",
            options: hosptitalsNames,
            onOptionSelected: (value) {
              log("xxx:Selected: $value");
            },
            bottomSheetTitle: 'اختر اسم المستشفى/المركز',
            searchHintText: "ابحث عن اسم المستشفى/المركز",
          ),

          verticalSpacing(16),

          ///الدولة
          UserSelectionContainer(
            options: [],
            categoryLabel: "الدولة",
            bottomSheetTitle: "اختر اسم الدولة",
            onOptionSelected: (selectedCountry) {
              // context
              //     .read<XRayDataEntryCubit>()
              //     .updateSelectedCountry(selectedCountry);
            },
            containerHintText: "اختر اسم الدولة",
            searchHintText: "ابحث عن اسم الدولة",
          ),

          verticalSpacing(16),
          Text(
            "ملاحظات اضافية",
            style: AppTextStyles.font18blackWight500,
          ),
          verticalSpacing(10),

          WordLimitTextField(
            controller: TextEditingController(),
          ),

          /// send button
          verticalSpacing(32),
          submitXrayDataEntryButtonBlocConsumer(context),
        ],
      ),
    );
  }
}

Widget submitXrayDataEntryButtonBlocConsumer(BuildContext context) {
  return AppCustomButton(
    isLoading: false,
    title: context.translate.send,
    onPressed: () async {
      // if (state.isFormValidated) {
      //   if (state.isEditMode) {
      //     await context
      //         .read<XRayDataEntryCubit>()
      //         .submitEditsOnXRayDocument(S.of(context));
      //   } else {
      //     await context.read<XRayDataEntryCubit>().postRadiologyDataEntry(
      //           context.translate,
      //         );
      //   }
      //   log("xxx:Save Data Entry");
      // } else {
      //   log("form not validated");
      // }
    },
    isEnabled: false,
  );
}

Widget buildCustomContainer({required SymptomItem symptom}) {
  return Container(
    width: double.infinity,
    // height: 30,
    padding: EdgeInsets.only(right: 16.w, top: 4.h, bottom: 4.h),
    margin: EdgeInsets.only(bottom: 10.h),
    decoration: BoxDecoration(
      // color: AppColorsManager.mainDarkBlue,
      borderRadius: BorderRadius.circular(
        8.r,
      ),
      border: Border.all(
        color: Color(0xff555555),
        width: .5,
      ),
    ),
    child: Expanded(
      child: Text(
        symptom.title,
        style: AppTextStyles.font14blackWeight400,
        textAlign: TextAlign.right,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textDirection: TextDirection.ltr,
      ),
    ),
  );
}
