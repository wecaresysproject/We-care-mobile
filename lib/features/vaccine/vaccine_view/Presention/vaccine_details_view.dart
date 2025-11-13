import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/vaccine/vaccine_view/logic/vaccine_view_cubit.dart';
import 'package:we_care/features/vaccine/vaccine_view/logic/vaccne_view_state.dart';

class VaccineDetailsView extends StatelessWidget {
  const VaccineDetailsView({super.key, required this.documentId});
  final String documentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VaccineViewCubit>(
      create: (context) =>
          getIt<VaccineViewCubit>()..emitVaccineById(documentId),
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0.h,
          ),
          body: BlocConsumer<VaccineViewCubit, VaccineViewState>(
            listener: (context, state) async {
              if (state.requestStatus == RequestStatus.failure &&
                  state.isDeleteRequest == true) {
                await showError(state.responseMessage);
              }
              if (state.requestStatus == RequestStatus.success &&
                  state.isDeleteRequest == true) {
                await showSuccess(state.responseMessage);
                if (!context.mounted) return;
                Navigator.pop(context, true);
              }
            },
            builder: (context, state) {
              if (state.requestStatus == RequestStatus.loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
                child: Column(
                  children: [
                    AppBarWithCenteredTitle(
                        title: state.selectedVaccine!.vaccineName,
                        deleteFunction: () {
                          context
                              .read<VaccineViewCubit>()
                              .deleteVaccineById(documentId);
                        },
                        editFunction: () async {
                          final result = await context.pushNamed(
                            Routes.vaccineDataEntryView,
                            arguments: state.selectedVaccine,
                          );
                          if (result != null && result) {
                            if (!context.mounted) return;
                            await context
                                .read<VaccineViewCubit>()
                                .emitVaccineById(documentId);
                          }
                        },
                        shareFunction: () {
                          _shareDetails(context, state);
                        }),
                    DetailsViewInfoTile(
                        title: "تاريج التطعيم",
                        value: state.selectedVaccine!.vaccineDate,
                        icon: 'assets/images/date_icon.png'),
                    Row(children: [
                      DetailsViewInfoTile(
                          title: "العمر عند التلقي",
                          value:
                              state.selectedVaccine!.userAge ?? "لم يتم ادخاله",
                          icon: 'assets/images/file_icon.png'),
                      Spacer(),
                      DetailsViewInfoTile(
                          title: "العمر النموذجي",
                          value: state.selectedVaccine!.vaccinePerfectAge ??
                              "لم يتم ادخاله",
                          icon: 'assets/images/file_icon.png'),
                    ]),
                    Row(children: [
                      DetailsViewInfoTile(
                          title: "فئة اللقاح",
                          value: state.selectedVaccine!.vaccineCategory,
                          icon: 'assets/images/ratio.png'),
                      Spacer(),
                      DetailsViewInfoTile(
                          title: "اسم الطعم",
                          value: state.selectedVaccine!.vaccineName,
                          icon: 'assets/images/doctor_name.png'),
                    ]),
                    Row(children: [
                      DetailsViewInfoTile(
                          title: "رقم الجرعة",
                          value: state.selectedVaccine!.dose ?? "لم يتم ادخاله",
                          icon: 'assets/images/chat_question_icon.png'),
                      Spacer(),
                      DetailsViewInfoTile(
                        title: "المرض المستهدف",
                        value:
                            state.selectedVaccine!.diseases ?? "لم يتم ادخاله",
                        icon: 'assets/images/tumor_icon.png',
                      ),
                    ]),
                    Row(children: [
                      DetailsViewInfoTile(
                          title: "الفئة العمرية",
                          value: state.selectedVaccine!.ageSection ??
                              "لم يتم ادخاله",
                          icon: 'assets/images/head_question_icon.png'),
                      Spacer(),
                      DetailsViewInfoTile(
                          title: " الزامي / اختياري",
                          value: state.selectedVaccine!.priorityTake ??
                              "لم يتم ادخاله",
                          icon: 'assets/images/chat_question_icon.png'),
                    ]),
                    Row(children: [
                      DetailsViewInfoTile(
                          title: " الجرعة",
                          value: state.selectedVaccine!.doseDaily ??
                              "لم يتم ادخاله",
                          icon: 'assets/images/hugeicons_medicine-01.png'),
                      Spacer(),
                      DetailsViewInfoTile(
                          title: "طريقة الاعطاء",
                          value: state.selectedVaccine!.wayToTakeVaccine ??
                              "لم يتم ادخاله",
                          icon: 'assets/images/hugeicons_medicine-01.png'),
                    ]),
                    Row(children: [
                      DetailsViewInfoTile(
                          title: "جهة التلقي",
                          value: state.selectedVaccine!.regionForVaccine ??
                              "لم يتم ادخاله",
                          icon: 'assets/images/hospital_icon.png'),
                      Spacer(),
                      DetailsViewInfoTile(
                          title: "الدولة",
                          value: state.selectedVaccine!.country,
                          icon: 'assets/images/country_icon.png'),
                    ]),
                    DetailsViewInfoTile(
                      title: "الأعراض الجانبية الشائعة",
                      value: state.selectedVaccine!.sideEffects == null
                          ? "لم يتم ادخاله"
                          : state
                              .selectedVaccine!.sideEffects!.popularSideEffects!
                              .join(', '),
                      icon: 'assets/images/symptoms_icon.png',
                      isExpanded: true,
                    ),
                    DetailsViewInfoTile(
                      title: "الأعراض الجانبية الاقل شيوعا",
                      value: state.selectedVaccine!.sideEffects == null
                          ? "لم يتم ادخاله"
                          : state.selectedVaccine!.sideEffects!
                              .lessPopularSideEffects!
                              .join(', '),
                      icon: 'assets/images/symptoms_icon.png',
                      isExpanded: true,
                    ),
                    DetailsViewInfoTile(
                      title: "الأعراض الجانبية النادرة",
                      value: state.selectedVaccine!.sideEffects == null
                          ? "لم يتم ادخاله"
                          : state.selectedVaccine!.sideEffects!.rareSideEffects!
                              .join(', '),
                      icon: 'assets/images/symptoms_icon.png',
                      isExpanded: true,
                    ),
                    DetailsViewInfoTile(
                      title: "معلومات اضافية",
                      value: state.selectedVaccine!.notes,
                      icon: 'assets/images/notes_icon.png',
                      isExpanded: true,
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}

Future<void> _shareDetails(BuildContext context, VaccineViewState state) async {
  try {
    final vaccineDetails = state.selectedVaccine!;

    final text = '''
    💉 *تفاصيل التطعيم* 💉

    📅 *تاريخ التطعيم*: ${vaccineDetails.vaccineDate}
    👶 *العمر عند التلقي*: ${vaccineDetails.userAge}
    🎯 *العمر النموذجي*: ${vaccineDetails.vaccinePerfectAge}
    🏷 *فئة اللقاح*: ${vaccineDetails.vaccineCategory}
    💊 *اسم الطعم*: ${vaccineDetails.vaccineName}
    🔢 *رقم الجرعة*: ${vaccineDetails.dose}
    🦠 *المرض المستهدف*: ${vaccineDetails.diseases}
    👥 *الفئة العمرية*: ${vaccineDetails.ageSection}
    ⚖️ *إلزامي / اختياري*: ${vaccineDetails.priorityTake}
    🧴 *الجرعة*: ${vaccineDetails.doseDaily}
    🏥 *طريقة الإعطاء*: ${vaccineDetails.wayToTakeVaccine}
    📍 *جهة التلقي*: ${vaccineDetails.regionForVaccine}
    🌍 *الدولة*: ${vaccineDetails.country}

    ⚠️ *الأعراض الجانبية الشائعة*: ${vaccineDetails.sideEffects}
    📝 *معلومات إضافية*: ${vaccineDetails.notes}
    ''';

    await Share.share(text);
  } catch (e) {
    await showError("❌ حدث خطأ أثناء المشاركة");
  }
}
