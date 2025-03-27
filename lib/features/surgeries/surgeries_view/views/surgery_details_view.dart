import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_image_with_title.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/features/surgeries/surgeries_view/logic/surgeries_view_cubit.dart';
import 'package:we_care/features/surgeries/surgeries_view/logic/surgeries_view_state.dart';

class SurgeryDetailsView extends StatelessWidget {
  const SurgeryDetailsView({super.key, required this.documentId});
  final String documentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<SurgeriesViewCubit>()..getSurgeryDetailsById(documentId),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.h,
        ),
        body: BlocBuilder<SurgeriesViewCubit, SurgeriesViewState>(
          buildWhen: (previous, current) =>
              previous.selectedSurgeryDetails != current.selectedSurgeryDetails,
          builder: (context, state) {
            if (state.requestStatus == RequestStatus.loading ||
                state.selectedSurgeryDetails == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
              child: Column(
                spacing: 16.h,
                children: [
                  DetailsViewAppBar(title: 'العمليات'),
                  Row(children: [
                    DetailsViewInfoTile(
                      title: "كود ICHI",
                      value: state.selectedSurgeryDetails!.ichiCode ?? "-",
                      icon: 'assets/images/data_search_icon.png',
                    ),
                    Spacer(),
                    DetailsViewInfoTile(
                        title: "التاريخ",
                        value: state.selectedSurgeryDetails!.surgeryDate,
                        icon: 'assets/images/date_icon.png'),
                  ]),
                  Row(children: [
                    DetailsViewInfoTile(
                      title: "العضو",
                      value: state.selectedSurgeryDetails!.surgeryRegion,
                      icon: 'assets/images/body_icon.png',
                    ),
                    Spacer(),
                    DetailsViewInfoTile(
                        title: "المنطقة الفرعية ",
                        value: state.selectedSurgeryDetails!.subSurgeryRegion,
                        icon: 'assets/images/body_icon.png'),
                  ]),
                  DetailsViewInfoTile(
                    title: 'اسم العملية',
                    value: state.selectedSurgeryDetails!.surgeryName,
                    icon: 'assets/images/doctor_name.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: ' الهدف من الاجراء',
                    value: state.selectedSurgeryDetails!.purpose ??
                        "لم يتم تحديده",
                    icon: 'assets/images/chat_question_icon.png',
                    isExpanded: true,
                  ),
                  Row(children: [
                    DetailsViewInfoTile(
                      title: "التقنية المستخدمة",
                      value: state.selectedSurgeryDetails!.usedTechnique,
                      icon: 'assets/images/data_search_icon.png',
                    ),
                    Spacer(),
                    DetailsViewInfoTile(
                        title: "حالة العملية",
                        value: state.selectedSurgeryDetails!.surgeryStatus,
                        icon: 'assets/images/ratio.png'),
                  ]),
                  DetailsViewInfoTile(
                      title: "وصف مفصل",
                      value: state.selectedSurgeryDetails!.surgeryDescription,
                      icon: 'assets/images/notes_icon.png',
                      isExpanded: true),
                  Row(children: [
                    DetailsViewInfoTile(
                      title: "الجراح ",
                      value: state.selectedSurgeryDetails!.surgeonName,
                      icon: 'assets/images/surgery_icon.png',
                    ),
                    Spacer(),
                    DetailsViewInfoTile(
                      title: "طبيب الباطنة ",
                      value: state.selectedSurgeryDetails!.anesthesiologistName,
                      icon: 'assets/images/doctor_icon.png',
                    ),
                  ]),
                  Row(children: [
                    DetailsViewInfoTile(
                        title: "الدولة",
                        value: state.selectedSurgeryDetails!.country,
                        icon: 'assets/images/country_icon.png'),
                    Spacer(),
                    DetailsViewInfoTile(
                        title: "المستشفي",
                        value: state.selectedSurgeryDetails!.hospitalCenter,
                        icon: 'assets/images/hospital_icon.png'),
                  ]),
                  DetailsViewInfoTile(
                      title: " تعليمات بعد العملية",
                      value:
                          state.selectedSurgeryDetails!.postSurgeryInstructions,
                      icon: 'assets/images/symptoms_icon.png',
                      isExpanded: true),
                  DetailsViewInfoTile(
                      title: " توصيف العملية",
                      value: state.selectedSurgeryDetails!.surgeryDescription,
                      icon: 'assets/images/file_date_icon.png',
                      isExpanded: true),
                  DetailsViewInfoTile(
                      title: " ملاحظات شخصية",
                      value: state.selectedSurgeryDetails!.additionalNotes,
                      icon: 'assets/images/notes_icon.png',
                      isExpanded: true),
                  DetailsViewImageWithTitleTile(
                    image: state.selectedSurgeryDetails!.medicalReportImage,
                    title: "التقرير الطبي",
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
