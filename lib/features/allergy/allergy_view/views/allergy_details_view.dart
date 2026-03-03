import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/Helpers/share_details_helper.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_images_with_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/allergy/allergy_view/logic/allergy_view_cubit.dart';
import 'package:we_care/features/allergy/data/models/allergy_details_data_model.dart';

class AllergyDetailsView extends StatelessWidget {
  const AllergyDetailsView({super.key, required this.documentId});
  final String documentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AllergyViewCubit>()..getSingleAllergyDetailsById(documentId),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.h,
        ),
        body: BlocConsumer<AllergyViewCubit, AllergyViewState>(
          listenWhen: (previous, current) =>
              previous.isDeleteRequest != current.isDeleteRequest,
          listener: (context, state) {
            if (state.requestStatus == RequestStatus.failure) {
              showError(state.responseMessage);
            }
            if (state.requestStatus == RequestStatus.success) {
              showSuccess(state.responseMessage);
              Navigator.pop(context, true);
            }
          },
          buildWhen: (previous, current) =>
              previous.selectedAllergyDetails != current.selectedAllergyDetails,
          builder: (context, state) {
            if (state.requestStatus == RequestStatus.loading ||
                state.selectedAllergyDetails == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
              child: Column(
                children: [
                  AppBarWithCenteredTitle(
                    title: 'الحساسية',
                    trailingActions: [
                      CircleIconButton(
                        size: 30.w,
                        icon: Icons.play_arrow,
                        color:
                            state.moduleGuidanceData?.videoLink?.isNotEmpty ==
                                    true
                                ? AppColorsManager.mainDarkBlue
                                : Colors.grey,
                        onTap:
                            state.moduleGuidanceData?.videoLink?.isNotEmpty ==
                                    true
                                ? () => launchYouTubeVideo(
                                    state.moduleGuidanceData!.videoLink)
                                : null,
                      ),
                      horizontalSpacing(8.w),
                      CircleIconButton(
                        size: 30.w,
                        icon: Icons.menu_book_outlined,
                        color: state.moduleGuidanceData?.moduleGuidanceText
                                    ?.isNotEmpty ==
                                true
                            ? AppColorsManager.mainDarkBlue
                            : Colors.grey,
                        onTap: state.moduleGuidanceData?.moduleGuidanceText
                                    ?.isNotEmpty ==
                                true
                            ? () {
                                ModuleGuidanceAlertDialog.show(
                                  context,
                                  title: "الحساسية",
                                  description: state
                                      .moduleGuidanceData!.moduleGuidanceText!,
                                );
                              }
                            : null,
                      ),
                    ],
                    deleteFunction: () async => await context
                        .read<AllergyViewCubit>()
                        .deleteAllergyById(documentId),
                    shareFunction: () async {
                      final allergy = state.selectedAllergyDetails!;

                      final details =
                          buildAllergyShareDetails(allergy, context);

                      if (details.isEmpty) {
                        showError('لا توجد بيانات متاحة للمشاركة');
                        return;
                      }

                      await shareDetails(
                        title: '⚕️ تفاصيل الحساسية',
                        details: details,
                        imageUrls: allergy.medicalReportImage.isEmpty == true
                            ? null
                            : allergy.medicalReportImage,
                        errorMessage: "❌ حدث خطأ أثناء مشاركة تفاصيل الحساسية",
                      );
                    },
                    editFunction: () async {
                      AppLogger.debug('test');
                      final result = await context.pushNamed(
                        Routes.allergyDataEntry,
                        arguments: {
                          'editModel': state.selectedAllergyDetails,
                        },
                      );
                      if (result != null && result) {
                        if (!context.mounted) return;
                        await context
                            .read<AllergyViewCubit>()
                            .getSingleAllergyDetailsById(documentId);
                      }
                    },
                  ),
                  verticalSpacing(16),
                  DetailsViewInfoTile(
                    title: "التاريخ",
                    value: state.selectedAllergyDetails!.allergyOccurrenceDate,
                    icon: 'assets/images/date_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    isExpanded: true,
                    title: "النوع",
                    value: state.selectedAllergyDetails!.allergyType,
                    icon: 'assets/images/qr_code_icon.png',
                  ),
                  DetailsViewInfoTile(
                      isExpanded: true,
                      title: "مسببات الحساسية",
                      value: state.selectedAllergyDetails!.allergyTriggers
                                  .isEmpty ||
                              state.selectedAllergyDetails!.allergyTriggers
                                      .first ==
                                  context.translate.no_data_entered
                          ? ""
                          : state.selectedAllergyDetails!.allergyTriggers
                              .asMap()
                              .entries
                              .map((e) => "${e.key + 1}. ${e.value}")
                              .join('\n'),
                      icon: 'assets/images/chat_question.png'),
                  DetailsViewInfoTile(
                    title: "الأعراض الجانبية المتوقعة",
                    value: state.selectedAllergyDetails!.expectedSideEffects!
                        .asMap()
                        .entries
                        .map((e) => "${e.key + 1}. ${e.value}")
                        .join('\n'),
                    icon: 'assets/images/symptoms_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "حدة الأعراض",
                    value: state.selectedAllergyDetails!.symptomSeverity!,
                    icon: 'assets/images/thunder_image.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "زمن بدء الأعراض بعد التعرض للمسبب",
                    value: state.selectedAllergyDetails!.timeToSymptomOnset!,
                    icon: 'assets/images/time_icon.png',
                    isExpanded: true,
                  ),
                  Row(children: [
                    DetailsViewInfoTile(
                      title: "استشارة طبيب",
                      value: state.selectedAllergyDetails?.isDoctorConsulted ==
                              null
                          ? context.translate.no_data_entered
                          : state.selectedAllergyDetails!.isDoctorConsulted!
                              ? 'نعم'
                              : 'لا',
                      icon: 'assets/images/doctor_icon.png',
                    ),
                    Spacer(),
                    DetailsViewInfoTile(
                      title: "اختبار حساسية",
                      value: state.selectedAllergyDetails!
                                  .isAllergyTestPerformed ==
                              null
                          ? context.translate.no_data_entered
                          : state.selectedAllergyDetails!
                                  .isAllergyTestPerformed!
                              ? 'نعم'
                              : 'لا',
                      icon: 'assets/images/data_search_icon.png',
                    ),
                  ]),
                  DetailsViewInfoTile(
                    title: "الأدوية",
                    value: state.selectedAllergyDetails!.medicationName!,
                    icon: 'assets/images/medicine_icon.png',
                    isExpanded: true,
                  ),
                  Row(
                    children: [
                      DetailsViewInfoTile(
                        title: "هل العلاجات فعالة",
                        value: state.selectedAllergyDetails!
                                    .isTreatmentsEffective ==
                                null
                            ? context.translate.no_data_entered
                            : state.selectedAllergyDetails!
                                    .isTreatmentsEffective!
                                ? 'نعم'
                                : 'لا',
                        icon: 'assets/images/surgery_icon.png',
                      ),
                      Spacer(),
                      DetailsViewInfoTile(
                        title: "وجود صدمة تحسسية",
                        value: state.selectedAllergyDetails!.proneToAllergies ??
                            context.translate.no_data_entered,
                        icon: 'assets/images/chat_question.png',
                      ),
                    ],
                  ),
                  DetailsViewInfoTile(
                    title: "التقرير الطبي",
                    value: state.selectedAllergyDetails!.writtenReport ?? "",
                    icon: 'assets/images/file_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewImagesWithTitleTile(
                    isShareEnabled: true,
                    images: state.selectedAllergyDetails!
                        .medicalReportImage, // Replace with actual image URL or asset
                    title: "التقرير الطبى/اختبار الحساسية",
                  ),
                  DetailsViewInfoTile(
                    title: "التاريخ العائلى",
                    value: state.selectedAllergyDetails!.familyHistory!,
                    icon: 'assets/images/icon_family.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "الاحتياطات",
                    value: state.selectedAllergyDetails!.precautions!,
                    icon: 'assets/images/file_icon.png',
                    isExpanded: true,
                  ),
                  Row(
                    children: [
                      DetailsViewInfoTile(
                        title: "تحذير طبى للمسببات",
                        value: state.selectedAllergyDetails!
                                .isMedicalWarningReceived ??
                            context.translate.no_data_entered,
                        icon: 'assets/images/circular_warning.png',
                      ),
                      Spacer(),
                      DetailsViewInfoTile(
                        title: "حمل حقنة الإبينفرين",
                        value: state
                                .selectedAllergyDetails!.carryEpinephrine.isNull
                            ? context.translate.no_data_entered
                            : state.selectedAllergyDetails!.carryEpinephrine!
                                ? 'نعم'
                                : 'لا',
                        icon: 'assets/images/Injection.png',
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Map<String, String> buildAllergyShareDetails(
    AllergyDetailsData allergy,
    BuildContext context,
  ) {
    final Map<String, String> details = {};

    void addIfValid(String key, String? value) {
      if (value == null) return;
      if (value.trim().isEmpty) return;
      if (value == context.translate.no_data_entered) return;

      details[key] = value;
    }

    void addListIfValid(String key, List<String>? values) {
      if (values == null || values.isEmpty) return;
      if (values.first == context.translate.no_data_entered) return;

      details[key] = values
          .asMap()
          .entries
          .map((e) => "${e.key + 1}. ${e.value}")
          .join('\n');
    }

    addIfValid('📅 التاريخ :', allergy.allergyOccurrenceDate);
    addIfValid('🦠 نوع الحساسية :', allergy.allergyType);

    addListIfValid('🤧 مسببات الحساسية :', allergy.allergyTriggers);
    addListIfValid('🤕 الأعراض الجانبية :', allergy.expectedSideEffects);

    addIfValid('⚡ حدة الأعراض :', allergy.symptomSeverity);
    addIfValid('⏱ زمن بدء الأعراض :', allergy.timeToSymptomOnset);

    addIfValid(
      '👨‍⚕️ استشارة طبيب :',
      allergy.isDoctorConsulted == null
          ? null
          : allergy.isDoctorConsulted!
              ? 'نعم'
              : 'لا',
    );

    addIfValid(
      '🧪 اختبار حساسية :',
      allergy.isAllergyTestPerformed == null
          ? null
          : allergy.isAllergyTestPerformed!
              ? 'نعم'
              : 'لا',
    );

    addIfValid('💊 الأدوية :', allergy.medicationName);

    addIfValid(
      '✅ فعالية العلاج :',
      allergy.isTreatmentsEffective == null
          ? null
          : allergy.isTreatmentsEffective!
              ? 'نعم'
              : 'لا',
    );

    addIfValid('⚠️ وجود صدمة تحسسية :', allergy.proneToAllergies);
    addIfValid('📄 التقرير الطبي :', allergy.writtenReport);
    addIfValid('👪 التاريخ العائلي :', allergy.familyHistory);
    addIfValid('🛡 الاحتياطات :', allergy.precautions);

    addIfValid(
      '🚨 تحذير طبي للمسببات :',
      allergy.isMedicalWarningReceived,
    );

    addIfValid(
      '💉 حمل حقنة الإبينفرين :',
      allergy.carryEpinephrine == null
          ? null
          : allergy.carryEpinephrine!
              ? 'نعم'
              : 'لا',
    );

    return details;
  }
}
