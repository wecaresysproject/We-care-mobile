import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/share_details_helper.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_image_with_title.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/allergy/allergy_view/logic/allergy_view_cubit.dart';

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
                    deleteFunction: () async => await context
                        .read<AllergyViewCubit>()
                        .deleteAllergyById(documentId),
                    shareFunction: () async {
                      final allergy = state.selectedAllergyDetails!;
                      await shareDetails(
                        title: '⚕️ *تفاصيل الحساسية* ⚕️',
                        details: {
                          '📅 *التاريخ*:': allergy.allergyOccurrenceDate,
                          '🦠 *مسببات الحساسية*:': allergy.allergyTriggers,
                          '🤧 *الأعراض الجانبية*:': allergy.expectedSideEffects,
                          '⚡ *حدة الأعراض*:': allergy.symptomSeverity,
                          '💊 *الأدوية*:': allergy.medicationName,
                          '👪 *التاريخ العائلى*:': allergy.familyHistory
                          ,
                          '⚠️ *الاحتياطات*:': allergy.precautions,
                          '📸 *التقارير الطبية*:': allergy.medicalReportImage,
                        },
                        imageUrls: [
                          if (allergy.medicalReportImage != null)
                            allergy.medicalReportImage!,
                        ],
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
                          .join(', '),
                      icon: 'assets/images/chat_question.png'),
                  DetailsViewInfoTile(
                    title: "الأعراض الجانبية المتوقعة",
                    value: state.selectedAllergyDetails!.expectedSideEffects!,
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
                  DetailsViewImageWithTitleTile(
                    isShareEnabled: true,
                    image: state.selectedAllergyDetails!
                        .medicalReportImage!, // Replace with actual image URL or asset
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
}
