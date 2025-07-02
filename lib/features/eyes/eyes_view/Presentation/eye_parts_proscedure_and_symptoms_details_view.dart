import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_image_with_title.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/features/eyes/eyes_view/logic/eye_view_cubit.dart';
import 'package:we_care/features/eyes/eyes_view/logic/eye_view_state.dart';

class EyePartsProcedureAndSymptomsDetailsView extends StatelessWidget {
  const EyePartsProcedureAndSymptomsDetailsView({
    super.key,
    required this.documentId,
    required this.title,
  });

  final String documentId;
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<EyeViewCubit>()..getEyePartDocumentDetails(documentId),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: BlocConsumer<EyeViewCubit, EyeViewState>(
          listener: (context, state) async {
            if (state.isDeleteRequest &&
                state.requestStatus == RequestStatus.success) {
              Navigator.pop(context);
              await showSuccess(state.responseMessage);
            } else if (state.isDeleteRequest &&
                state.requestStatus == RequestStatus.failure) {
              await showError(state.responseMessage);
            }
          },
          buildWhen: (prev, curr) =>
              prev.selectedEyePartDocumentDetails !=
              curr.selectedEyePartDocumentDetails,
          builder: (context, state) {
            final details = state.selectedEyePartDocumentDetails;

            if (state.requestStatus == RequestStatus.loading ||
                details == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                spacing: 16.h,
                children: [
                  DetailsViewAppBar(
                    title: title,
                    deleteFunction: () => context
                        .read<EyeViewCubit>()
                        .deleteEyePartDocument(documentId),
                    showActionButtons: true,
                  ),
                  DetailsViewInfoTile(
                    title: 'تاريخ الاعراض',
                    value: details.symptomStartDate,
                    icon: 'assets/images/date_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: 'الاعراض',
                    value: details.symptoms.join(', '),
                    icon: 'assets/images/symptoms_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: 'مدة الاعراض',
                    value: details.symptomDuration,
                    icon: 'assets/images/symptoms_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: 'تاريخ الاجراء الطبي',
                    value: details.medicalReportDate,
                    icon: 'assets/images/date_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: 'الاجراء الطبي',
                    value: details.medicalProcedures.join(', '),
                    icon: 'assets/images/doctor_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewImageWithTitleTile(
                    image: details.medicalReportUrl,
                    title: 'التقرير الطبي',
                    isShareEnabled: true,
                  ),
                  DetailsViewImageWithTitleTile(
                    image: details.medicalExaminationImages,
                    title: 'صورة الفحص الطبي',
                    isShareEnabled: true,
                  ),
                  Row(
                    children: [
                      DetailsViewInfoTile(
                        title: 'المستشفى',
                        value: details.centerHospitalName,
                        icon: 'assets/images/hospital_icon.png',
                      ),
                      const Spacer(),
                      DetailsViewInfoTile(
                        title: 'الطبيب',
                        value: details.doctorName,
                        icon: 'assets/images/doctor_name.png',
                      ),
                    ],
                  ),
                  DetailsViewInfoTile(
                    title: 'الدولة',
                    value: details.country,
                    icon: 'assets/images/country_icon.png',
                  ),
                  DetailsViewInfoTile(
                    title: 'الملاحظات',
                    value: details.additionalNotes,
                    icon: 'assets/images/notes_icon.png',
                    isExpanded: true,
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
