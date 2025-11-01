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
import 'package:we_care/features/x_ray/x_ray_view/logic/x_ray_view_cubit.dart';
import 'package:we_care/features/x_ray/x_ray_view/logic/x_ray_view_state.dart';

class XRayDetailsView extends StatelessWidget {
  const XRayDetailsView({super.key, required this.documentId});
  final String documentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<XRayViewCubit>()
        ..emitspecificUserRadiologyDocument(documentId),
      child: BlocConsumer<XRayViewCubit, XRayViewState>(
        listenWhen: (previous, current) =>
            previous.isDeleteRequest != current.isDeleteRequest,
        listener: (context, state) {
          if (state.requestStatus == RequestStatus.success) {
            showSuccess(state.responseMessage);
            Navigator.pop(context);
          } else if (state.requestStatus == RequestStatus.failure) {
            showError(state.responseMessage);
          }
        },
        builder: (context, state) {
          final radiologyData = state.selectedRadiologyDocument;
          if (state.requestStatus == RequestStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 0.h,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                spacing: 16.h,
                children: [
                  AppBarWithCenteredTitle(
                    title: 'الاشعة',
                    deleteFunction: () async {
                      await BlocProvider.of<XRayViewCubit>(context)
                          .deleteMedicineById(documentId);
                    },
                    editFunction: () async {
                      final result = await context.pushNamed(
                        Routes.xrayCategoryDataEntryView,
                        arguments: state.selectedRadiologyDocument!,
                      );
                      if (result != null && result) {
                        if (!context.mounted) return;
                        await context
                            .read<XRayViewCubit>()
                            .emitspecificUserRadiologyDocument(documentId);
                      }
                    },
                    shareFunction: () async {
                      await shareXRayDetails(context, state);
                    },
                  ),
                  Row(children: [
                    DetailsViewInfoTile(
                        title: "التاريخ",
                        value: radiologyData!.radiologyDate,
                        icon: 'assets/images/date_icon.png'),
                    Spacer(),
                    DetailsViewInfoTile(
                      title: "المنطقة",
                      value: radiologyData.bodyPart,
                      icon: 'assets/images/body_icon.png',
                    ),
                  ]),
                  DetailsViewInfoTile(
                    isExpanded: true,
                      title: "النوع",
                      value: radiologyData.radioType,
                      icon: 'assets/images/type_icon.png'),
                  DetailsViewInfoTile(
                    isExpanded: true,
                      title: "نوعية الاحتياج",
                      value: radiologyData.periodicUsage ?? 'لم يتم ادخاله',
                      icon: 'assets/images/need_icon.png'),
                  DetailsViewInfoTile(
                      title: "الأعراض",
                      value: radiologyData.symptoms ?? 'لم يتم ادخاله',
                      icon: 'assets/images/symptoms_icon.png',
                      isExpanded: true),
                  DetailsViewImageWithTitleTile(
                      image: radiologyData.radiologyPhoto,
                      isShareEnabled: true,
                      title: "صورة الأشعة"),
                      DetailsViewImageWithTitleTile(
                    isShareEnabled: true,
                    image: radiologyData.report,
                    title: "صورة التقرير",
                  ),
                  DetailsViewInfoTile(
                    isExpanded: true,
                      title: "الطبيب المعالج",
                      value: radiologyData.doctor ?? 'لم يتم ادخاله',
                      icon: 'assets/images/doctor_icon.png'),
                  DetailsViewInfoTile(
                    isExpanded: true,
                      title: "طبيب الأشعة",
                      value: radiologyData.radiologyDoctor ?? 'لم يتم ادخاله',
                      icon: 'assets/images/doctor_icon.png'),
                  DetailsViewInfoTile(
                    isExpanded: true,
                      title: "المستشفى",
                      value: radiologyData.hospital ?? 'لم يتم ادخاله',
                      icon: 'assets/images/hospital_icon.png'),
                  DetailsViewInfoTile(
                    isExpanded: true,
                      title: "الدولة",
                      value: radiologyData.country ?? 'لم يتم ادخاله',
                      icon: 'assets/images/country_icon.png'),
                  DetailsViewInfoTile(
                      title: "ملاحظات",
                      value: radiologyData.radiologyNote ?? 'لم يتم ادخاله',
                      icon: 'assets/images/notes_icon.png',
                      isExpanded: true),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

//share x-ray details

Future<void> shareXRayDetails(BuildContext context, XRayViewState state) async {
  final radiologyData = state.selectedRadiologyDocument;
  if (radiologyData != null) {
    final shareContent = '''
🩺 تفاصيل الاشعة    
التاريخ: ${radiologyData.radiologyDate}
المنطقة: ${radiologyData.bodyPart}
النوع: ${radiologyData.radioType}
نوعية الاحتياج: ${radiologyData.periodicUsage ?? 'لم يتم ادخاله'}
الأعراض: ${radiologyData.symptoms ?? 'لم يتم ادخاله'}
الطبيب المعالج: ${radiologyData.doctor ?? 'لم يتم ادخاله'}
طبيب الأشعة: ${radiologyData.radiologyDoctor ?? 'لم يتم ادخاله'}
المستشفى: ${radiologyData.hospital ?? 'لم يتم ادخاله'}
الدولة: ${radiologyData.country ?? 'لم يتم ادخاله'}
ملاحظات: ${radiologyData.radiologyNote ?? 'لم يتم ادخاله'}
    ''';

    // 📥 Download images
    final tempDir = await getTemporaryDirectory();
    List<String> imagePaths = [];

    if (radiologyData.radiologyPhoto.startsWith("http")) {
      final imagePath = await downloadImage(
          radiologyData.radiologyPhoto, tempDir, 'x_ray_image.png');
      if (imagePath != null) imagePaths.add(imagePath);
    }
    if (radiologyData.report != null) {
      final imagePath = await downloadImage(
          radiologyData.report!, tempDir, 'x_ray_report.png');
      if (imagePath != null) imagePaths.add(imagePath);
    }

//!TODO: to be removed after adding real data
    // 📤 Share text & images
    if (imagePaths.isNotEmpty) {
      await Share.shareXFiles([XFile(imagePaths.first)], text: shareContent);
    } else {
      await Share.share(shareContent);
    }
    await Share.share(shareContent);
  } else {
    showError("No X-Ray data available to share.");
  }
}
