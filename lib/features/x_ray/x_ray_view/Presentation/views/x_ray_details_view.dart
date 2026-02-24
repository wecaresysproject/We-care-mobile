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
import 'package:we_care/core/global/SharedWidgets/details_view_images_with_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
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
                children: [
                  AppBarWithCenteredTitle(
                    title: 'الأشعة',
                    trailingActions: [
                      CircleIconButton(
                        icon: Icons.play_arrow,
                        color: AppColorsManager.mainDarkBlue,
                        onTap: () {},
                      ),
                      SizedBox(width: 12),
                      CircleIconButton(
                        icon: Icons.menu_book_outlined,
                        color: AppColorsManager.mainDarkBlue,
                        onTap: () {
                          ModuleGuidanceAlertDialog.show(
                            context,
                            title: "الأشعة",
                            description: """
🩻 أسنان • 🦷 عظام الفك • 🔎 جذور الأسنان • 🛡️ كشف مبكر

الأشعة التشخيصية هي وسيلة تصوير طبي تُستخدم لإظهار التفاصيل الداخلية
التي لا يمكن رؤيتها بالفحص السريري العادي.

تساعد الأشعة الطبيب في تقييم حالة الأسنان، الجذور، عظام الفك،
والأنسجة المحيطة بدقة عالية.

1️⃣ الكشف عن المشكلات غير المرئية:
- التسوس العميق
- التهابات الجذور
- فقدان العظم

2️⃣ التخطيط العلاجي:
تساعد في تحديد أفضل إجراء علاجي آمن ودقيق.

الأشعة السنية آمنة وتُستخدم بجرعات منخفضة جداً مع اتخاذ جميع الاحتياطات.
""",
                          );
                        },
                      ),
                    ],
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
                  verticalSpacing(15),
                  DetailsViewInfoTile(
                    title: "التاريخ",
                    value: radiologyData!.radiologyDate,
                    icon: 'assets/images/date_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "المنطقة",
                    value: radiologyData.bodyPart,
                    icon: 'assets/images/body_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                      isExpanded: true,
                      title: "النوع",
                      value: radiologyData.radioType,
                      icon: 'assets/images/type_icon.png'),
                  DetailsViewInfoTile(
                    isExpanded: true,
                    title: "نوعية الاحتياج",
                    value: radiologyData.periodicUsage == null
                        ? ""
                        : radiologyData.periodicUsage!
                            .asMap()
                            .entries
                            .map((e) => "${e.key + 1}. ${e.value}")
                            .join("\n"),
                    icon: 'assets/images/need_icon.png',
                  ),
                  DetailsViewInfoTile(
                    title: "الأعراض",
                    value: radiologyData.symptoms == null ||
                            radiologyData.symptoms!.first ==
                                context.translate.no_data_entered
                        ? ""
                        : radiologyData.symptoms!
                            .asMap()
                            .entries
                            .map((e) => "${e.key + 1}. ${e.value}")
                            .join("\n"),
                    icon: 'assets/images/symptoms_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewImagesWithTitleTile(
                    images: radiologyData.radiologyPhotos,
                    isShareEnabled: true,
                    title: "صورة الأشعة",
                  ),
                  DetailsViewImagesWithTitleTile(
                    isShareEnabled: true,
                    title: "صورة التقرير",
                    images: radiologyData.reports,
                  ),
                  DetailsViewInfoTile(
                    title: "التقرير الطبي",
                    value: radiologyData.writtenReport ?? "",
                    icon: 'assets/images/notes_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                      isExpanded: true,
                      title: "الطبيب المعالج",
                      value: radiologyData.doctor ?? "",
                      icon: 'assets/images/doctor_icon.png'),
                  DetailsViewInfoTile(
                      isExpanded: true,
                      title: "طبيب الأشعة",
                      value: radiologyData.radiologyDoctor ?? "",
                      icon: 'assets/images/doctor_icon.png'),
                  DetailsViewInfoTile(
                    isExpanded: true,
                    title: "مركز الأشاعة  / المستشفي",
                    value: radiologyData.hospital ??
                        radiologyData.radiologyCenter ??
                        "",
                    icon: 'assets/images/hospital_icon.png',
                  ),
                  DetailsViewInfoTile(
                    isExpanded: true,
                    title: "الدولة",
                    value: radiologyData.country ?? "",
                    icon: 'assets/images/country_icon.png',
                  ),
                  DetailsViewInfoTile(
                    title: "ملاحظات",
                    value: radiologyData.radiologyNote ?? "",
                    icon: 'assets/images/notes_icon.png',
                    isExpanded: true,
                  ),
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

  if (radiologyData == null) {
    showError("لا توجد بيانات أشعة للمشاركة.");
    return;
  }

  // 🧾 نص المشاركة
  final shareContent = '''
🩺 تفاصيل الأشعة
التاريخ: ${radiologyData.radiologyDate}
المنطقة: ${radiologyData.bodyPart}
النوع: ${radiologyData.radioType}
نوعية الاحتياج: ${radiologyData.periodicUsage ?? ""}
الأعراض: ${radiologyData.symptoms ?? ""}
الطبيب المعالج: ${radiologyData.doctor ?? ""}
طبيب الأشعة: ${radiologyData.radiologyDoctor ?? ""}
المستشفى: ${radiologyData.hospital ?? ""}
مركز الأشاعة: ${radiologyData.radiologyCenter ?? ""}
الدولة: ${radiologyData.country ?? ""}
ملاحظات: ${radiologyData.radiologyNote ?? ""}
التقرير الطبي: ${radiologyData.writtenReport ?? ""}
''';

  final tempDir = await getTemporaryDirectory();
  List<XFile> filesToShare = [];

  // 🖼️ تحميل صور الأشعة
  if (radiologyData.radiologyPhotos != null &&
      radiologyData.radiologyPhotos!.isNotEmpty) {
    for (int i = 0; i < radiologyData.radiologyPhotos!.length; i++) {
      final url = radiologyData.radiologyPhotos![i];
      if (url.startsWith("http")) {
        final imagePath =
            await downloadImage(url, tempDir, 'x_ray_image_$i.png');
        if (imagePath != null) {
          filesToShare.add(XFile(imagePath));
        }
      }
    }
  }

  // 📄 تحميل التقارير
  if (radiologyData.reports != null && radiologyData.reports!.isNotEmpty) {
    for (int i = 0; i < radiologyData.reports!.length; i++) {
      final url = radiologyData.reports![i];
      if (url.startsWith("http")) {
        final reportPath =
            await downloadImage(url, tempDir, 'x_ray_report_$i.png');
        if (reportPath != null) {
          filesToShare.add(XFile(reportPath));
        }
      }
    }
  }

  // 📤 1) مشاركة الصور فقط
  if (filesToShare.isNotEmpty) {
    await Share.shareXFiles(filesToShare);
  }

  // 📤 2) مشاركة البيانات مرة واحدة فقط
  await Share.share(shareContent);
}
