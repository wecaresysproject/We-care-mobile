import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_image_with_title.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/prescription/Presentation_view/logic/prescription_view_cubit.dart';
import 'package:we_care/features/prescription/Presentation_view/logic/prescription_view_state.dart';

class PrescriptionDetailsView extends StatelessWidget {
  const PrescriptionDetailsView({super.key, required this.documentId});
  final String documentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.h,
      ),
      body: BlocProvider.value(
        value: getIt<PrescriptionViewCubit>()
          ..getUserPrescriptionDetailsById(documentId),
        child: BlocConsumer<PrescriptionViewCubit, PrescriptionViewState>(
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
          builder: (context, state) {
            if (state.requestStatus == RequestStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
              child: Column(
                spacing: 16.h,
                children: [
                  AppBarWithCenteredTitle(
                    title: 'الروشتة',
                    editFunction: () async {
                      final result = await context.pushNamed(
                        Routes.prescriptionCategoryDataEntryView,
                        arguments: state.selectedPrescriptionDetails!,
                      );
                      if (result) {
                        if (!context.mounted) return;
                        await context
                            .read<PrescriptionViewCubit>()
                            .getUserPrescriptionDetailsById(documentId);
                      }
                    },
                    shareFunction: () => _shareDetails(context, state),
                    deleteFunction: () async {
                      await context
                          .read<PrescriptionViewCubit>()
                          .deletePrescriptionById(documentId);
                    },
                  ),
                  DetailsViewInfoTile(
                      title: "التاريخ",
                      value: state
                          .selectedPrescriptionDetails!.preDescriptionDate,
                          isExpanded: true,
                      icon: 'assets/images/date_icon.png'),
                          DetailsViewInfoTile(
                      title: "التشخيص",
                      isExpanded: true,
                      value: state.selectedPrescriptionDetails!.disease,
                      icon: 'assets/images/symptoms_icon.png',
                    ),
                  DetailsViewInfoTile(
                    title: "اسم الطبيب",
                    value: state.selectedPrescriptionDetails!.doctorName,
                    icon: 'assets/images/doctor_name.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                      title: "التخصص ",
                      isExpanded: true,
                      value:
                          state.selectedPrescriptionDetails!.doctorSpecialty,
                      icon: 'assets/images/doctor_icon.png'),
                  DetailsViewImageWithTitleTile(
                    image:
                        state.selectedPrescriptionDetails!.preDescriptionPhoto,
                    title: "صورة الروشتة",
                    isShareEnabled: true,
                  ),
                  DetailsViewInfoTile(
                      title: "الأعراض",
                      value: state.selectedPrescriptionDetails!.cause,
                      icon: 'assets/images/symptoms_icon.png',
                      isExpanded: true),
                  DetailsViewInfoTile(
                      title: "ملاحظات",
                      value: state
                          .selectedPrescriptionDetails!.preDescriptionNotes,
                      icon: 'assets/images/notes_icon.png',
                      isExpanded: true),
                  Row(children: [
                    DetailsViewInfoTile(
                        title: "الدولة",
                        value: state.selectedPrescriptionDetails!.country,
                        icon: 'assets/images/country_icon.png'),
                    Spacer(),
                    DetailsViewInfoTile(
                        title: "المدينة",
                        value: state.selectedPrescriptionDetails!.governate,
                        icon: 'assets/images/hospital_icon.png'),
                  ]),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<void> _shareDetails(
    BuildContext context, PrescriptionViewState state) async {
  try {
    final prescriptionDetails = state.selectedPrescriptionDetails!;

    // 📝 Extract text details
    final text = '''
    🩺 *تفاصيل الروشتة* 🩺

    📅 *التاريخ*: ${prescriptionDetails.preDescriptionDate}
    👩‍⚕️ *الاعراض *: ${prescriptionDetails.cause}
    🔬 * المرض*: ${prescriptionDetails.disease}
    👨‍⚕️ *الطبيب المعالج*: ${prescriptionDetails.doctorName}
    🏥 *التخصص*: ${prescriptionDetails.doctorSpecialty}
    🌍 *الدولة*: ${prescriptionDetails.country}
    📝 *ملاحظات*: ${prescriptionDetails.preDescriptionNotes}
    ''';

    // 📥 Download images
    final tempDir = await getTemporaryDirectory();
    List<String> imagePaths = [];

    if (prescriptionDetails.preDescriptionPhoto.startsWith("http")) {
      final imagePath = await downloadImage(
          prescriptionDetails.preDescriptionPhoto,
          tempDir,
          'analysis_image.png');
      if (imagePath != null) imagePaths.add(imagePath);
    }

//!TODO: to be removed after adding real data
    // 📤 Share text & images
    if (imagePaths.isNotEmpty) {
      await Share.shareXFiles([XFile(imagePaths.first)], text: text);
    } else {
      await Share.share(text);
    }
  } catch (e) {
    await showError("❌ حدث خطأ أثناء المشاركة");
  }
}
