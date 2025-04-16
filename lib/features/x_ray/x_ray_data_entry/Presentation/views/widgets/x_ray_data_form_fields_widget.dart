import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/Helpers/image_quality_detector.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/select_image_container_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/show_image_picker_selection_widget.dart';
import 'package:we_care/core/global/SharedWidgets/word_limit_text_field_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/x_ray/x_ray_data_entry/logic/cubit/x_ray_data_entry_cubit.dart';
import 'package:we_care/generated/l10n.dart';

import '../../../../../../core/global/SharedWidgets/user_selection_container_shared_widget.dart';

class XRayDataEntryFormFields extends StatefulWidget {
  const XRayDataEntryFormFields({super.key});

  @override
  State<XRayDataEntryFormFields> createState() =>
      _XRayDataEntryFormFieldsState();
}

class _XRayDataEntryFormFieldsState extends State<XRayDataEntryFormFields> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<XRayDataEntryCubit, XRayDataEntryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "تاريخ الأشعة",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            DateTimePickerContainer(
              containerBorderColor: state.xRayDateSelection == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              placeholderText: state.xRayDateSelection ??
                  (isArabic() ? "يوم / شهر / سنة" : "Day / Month / Year"),
              onDateSelected: (pickedDate) {
                context.read<XRayDataEntryCubit>().updateXRayDate(pickedDate);
                log("xxx: pickedDate: $pickedDate"); //! 2024-02-14
              },
            ),

            /// size between each categogry
            verticalSpacing(16),

            UserSelectionContainer(
              containerBorderColor: state.xRayBodyPartSelection == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "منطقة الأشعة",
              containerHintText:
                  state.xRayBodyPartSelection ?? "اختر العضو الخاص بالأشعة",
              isEditMode: state.isEditMode,
              options: state.bodyPartNames,
              onOptionSelected: (selectedbodyPartName) async {
                await context
                    .read<XRayDataEntryCubit>()
                    .updateXRayBodyPart(selectedbodyPartName);
              },
              bottomSheetTitle: 'اختر العضو الخاص بالأشعة',
            ),

            verticalSpacing(16),
            UserSelectionContainer(
              containerBorderColor: state.xRayTypeSelection == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "النوع",
              isEditMode: state.isEditMode,
              containerHintText: state.xRayTypeSelection ?? "اختر نوع الأشعة",
              options: state.radiologyTypesBasedOnBodyPartNameSelected,
              onOptionSelected: (value) async {
                context.read<XRayDataEntryCubit>().updateXRayType(value);
              },
              bottomSheetTitle: 'اختر نوع الأشعة',
            ),

            verticalSpacing(16),
            UserSelectionContainer(
              categoryLabel:
                  "نوعية الاحتياج للأشعة", // Another Dropdown Example
              containerHintText:
                  state.selectedPupose ?? "اختر نوعية احتياجك للأشعة",
              options: state.puposesOfSelectedXRayType,
              isEditMode: state.isEditMode,
              onOptionSelected: (selectedPupose) {
                log("xxx:Selected: $selectedPupose");
                context
                    .read<XRayDataEntryCubit>()
                    .updateXRaySelectedPupose(selectedPupose);
              },
              bottomSheetTitle: "اختر نوعية احتياجك للأشعة",
            ),

            verticalSpacing(16),
            Text(
              "الصورة",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            BlocListener<XRayDataEntryCubit, XRayDataEntryState>(
              listenWhen: (prev, curr) =>
                  prev.xRayImageRequestStatus != curr.xRayImageRequestStatus,
              listener: (context, state) async {
                if (state.xRayImageRequestStatus ==
                    UploadImageRequestStatus.success) {
                  await showSuccess(state.message);
                }
                if (state.xRayImageRequestStatus ==
                    UploadImageRequestStatus.failure) {
                  await showError(state.message);
                }
              },
              child: SelectImageContainer(
                containerBorderColor: ((state.isXRayPictureSelected == null) ||
                            (state.isXRayPictureSelected == false)) &&
                        state.xRayPictureUploadedUrl.isEmpty
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                imagePath: "assets/images/photo_icon.png",
                label: "ارفق صورة",
                onTap: () async {
                  await showImagePicker(
                    context,
                    onImagePicked: (isImagePicked) async {
                      final picker = getIt.get<ImagePickerService>();
                      if (isImagePicked && picker.isImagePickedAccepted) {
                        context
                            .read<XRayDataEntryCubit>()
                            .updateXRayPicture(isImagePicked);

                        await context
                            .read<XRayDataEntryCubit>()
                            .uploadXrayImagePicked(
                              imagePath: picker.pickedImage!.path,
                            );
                      }
                    },
                  );
                },
              ),
            ),

            // verticalSpacing(8),
            // if (state.xRayPictureUploadedUrl.isNotEmpty)
            //   imageWithMenuItem(
            //     state.xRayPictureUploadedUrl,
            //     context,
            //   ),

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
            BlocListener<XRayDataEntryCubit, XRayDataEntryState>(
              listenWhen: (previous, current) =>
                  previous.xRayReportRequestStatus !=
                  current.xRayReportRequestStatus,
              listener: (context, state) async {
                if (state.xRayReportRequestStatus ==
                    UploadReportRequestStatus.success) {
                  await showSuccess(state.message);
                }
                if (state.xRayReportRequestStatus ==
                    UploadReportRequestStatus.failure) {
                  await showError(state.message);
                }
              },
              child: SelectImageContainer(
                imagePath: "assets/images/photo_icon.png",
                label: " ارفق صورة للتقرير",
                onTap: () async {
                  await showImagePicker(
                    context,
                    onImagePicked: (isImagePicked) async {
                      final picker = getIt.get<ImagePickerService>();
                      if (isImagePicked && picker.isImagePickedAccepted) {
                        await context
                            .read<XRayDataEntryCubit>()
                            .uploadXrayReportPicked(
                              imagePath: picker.pickedImage!.path,
                            );
                      }
                    },
                  );
                },
              ),
            ),
            verticalSpacing(16),

            // //! الأعراض المستدعية للاجراء"

            UserSelectionContainer(
              allowManualEntry: true,
              options: [
                "فحص الدم",
                "فحص البول",
                "فحص القلب",
                "أشعة سينية",
              ],
              categoryLabel: "الأعراض المستدعية للاجراء",
              bottomSheetTitle: "اختر الأعراض المستدعية",
              onOptionSelected: (value) {
                log("xxx:Selected: $value");
              },
              containerHintText: "اختر الأعراض المستدعية",
            ),

            verticalSpacing(16),

            /// طبيب الأشعة

            UserSelectionContainer(
              allowManualEntry: true,
              categoryLabel: "طبيب الأشعة",
              containerHintText: "اختر اسم طبيب الأشعة",
              options: [
                "د / محمد محمد",
                "د / كريم محمد",
                "د / رشا محمد",
                "د / رشا مصطفى",
              ],
              onOptionSelected: (value) {
                log("xxx:Selected: $value");
              },
              bottomSheetTitle: 'اختر اسم طبيب الأشعة',
            ),

            verticalSpacing(16),

            /// المركز / المستشفى
            //   //! write by ur hand
            UserSelectionContainer(
              allowManualEntry: true,
              categoryLabel: "المركز / المستشفى",
              containerHintText: "اختر اسم المستشفى/المركز",
              options: [
                "مستشفى القلب",
                "مستشفى العين الدولى",
                "مستشفى 57357",
              ],
              onOptionSelected: (value) {
                log("xxx:Selected: $value");
              },
              bottomSheetTitle: 'اختر اسم المستشفى/المركز',
            ),

            verticalSpacing(16),

            /// الطبيب المعالج

            UserSelectionContainer(
              allowManualEntry: true,
              options: [
                "د / محمد محمد",
                "د / كريم محمد",
                "د / رشا محمد",
                "د / رشا مصطفى",
              ],
              categoryLabel: "الطبيب المعالج",
              bottomSheetTitle: "اختر اسم الطبيب المعالج ",
              onOptionSelected: (value) {},
              containerHintText: "اختر اسم الطبيب المعالج (جراح/باطنة)",
            ),

            verticalSpacing(16),

            ///الدولة
            UserSelectionContainer(
              options: state.countriesNames,
              categoryLabel: "الدولة",
              bottomSheetTitle: "اختر اسم الدولة",
              onOptionSelected: (selectedCountry) {
                context
                    .read<XRayDataEntryCubit>()
                    .updateSelectedCountry(selectedCountry);
              },
              containerHintText: "اختر اسم الدولة",
            ),

            verticalSpacing(16),
            Text(
              "ملاحظات شخصية",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            WordLimitTextField(
              controller:
                  context.read<XRayDataEntryCubit>().personalNotesController,
            ),

            ///TODO: handle this button in main view and remove it from here
            /// send button
            verticalSpacing(32),
            submitXrayDataEntryButtonBlocConsumer(),
            verticalSpacing(71),
          ],
        );
      },
    );
  }

  Widget submitXrayDataEntryButtonBlocConsumer() {
    return BlocConsumer<XRayDataEntryCubit, XRayDataEntryState>(
      listenWhen: (prev, curr) =>
          curr.xRayDataEntryStatus == RequestStatus.failure ||
          curr.xRayDataEntryStatus == RequestStatus.success,
      buildWhen: (prev, curr) =>
          prev.isFormValidated != curr.isFormValidated ||
          prev.xRayDataEntryStatus != curr.xRayDataEntryStatus,
      listener: (context, state) async {
        if (state.xRayDataEntryStatus == RequestStatus.success) {
          await showSuccess(state.message);
          if (!context.mounted) return;
          //* in order to catch it again to rebuild details view
          context.pop(result: true);
        } else {
          await showError(state.message);
        }
      },
      builder: (context, state) {
        return AppCustomButton(
          isLoading: state.xRayDataEntryStatus == RequestStatus.loading,
          title: context.translate.send,
          onPressed: () async {
            if (state.isFormValidated) {
              if (state.isEditMode) {
                await context
                    .read<XRayDataEntryCubit>()
                    .submitEditsOnXRayDocument(S.of(context));
              } else {
                await context.read<XRayDataEntryCubit>().postRadiologyDataEntry(
                      context.translate,
                    );
              }
              log("xxx:Save Data Entry");
            } else {
              log("form not validated");
            }
          },
          isEnabled: state.isFormValidated ? true : false,
        );
      },
    );
  }
}

// Widget imageWithMenuItem(String imageUrl, BuildContext context) {
//   return Container(
//     height: 100.h,
//     padding: EdgeInsets.all(8.r),
//     decoration: BoxDecoration(
//       color: Colors.grey[200],
//       borderRadius: BorderRadius.circular(12.r),
//     ),
//     child: Row(
//       children: [
//         IconButton(
//           onPressed: () {},
//           padding: EdgeInsets.zero,
//           alignment: Alignment.topCenter,
//           icon: Icon(
//             Icons.delete,
//             size: 28.sp,
//             color: AppColorsManager.warningColor,
//           ),
//         ),
//         Spacer(),
//         // Image on the left with tap action
//         GestureDetector(
//           onTap: () {
//             showImagePreview(context, imageUrl);
//           },
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(8.r),
//             child: CachedNetworkImage(
//               imageUrl: imageUrl,
//               width: 80.w,
//               height: 80.w,
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// // Preview Dialog Function
// void showImagePreview(BuildContext context, String imageUrl) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) {
//       Future.delayed(Duration(seconds: 1), () {
//         if (!context.mounted) return;

//         Navigator.of(context).pop();
//       });

//       return Dialog(
//         backgroundColor: Colors.transparent,
//         child: CachedNetworkImage(
//           imageUrl: imageUrl,
//           fit: BoxFit.contain,
//         ),
//       );
//     },
//   );
// }
