
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_image_with_title.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/features/genetic_diseases/data/models/personal_genetic_disease_detaills.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/logic/genetics_diseases_view_cubit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/logic/genetics_diseases_view_state.dart';

class CurrentPersonalGeneticDiseaseDetailsView extends StatelessWidget {
  const CurrentPersonalGeneticDiseaseDetailsView({super.key,required this.documentId});

 final String documentId;
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<GeneticsDiseasesViewCubit>(
      create: (context) => getIt.get<GeneticsDiseasesViewCubit>()
        ..getPersonalGeneticDiseaseDetails(id: documentId),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: BlocBuilder<GeneticsDiseasesViewCubit, GeneticsDiseasesViewState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailsViewAppBar(
                    title: 'المرض الوراثى',
                    shareFunction: () => shareDetails(
                      context,
                      state.currentPersonalGeneticDiseaseDetails,
                    ),
                    deleteFunction: () => context
                        .read<GeneticsDiseasesViewCubit>()
                        .deleteSpecificCurrentPersonalGeneticDiseaseById(
                          id: documentId,
                        ),
                  ),
                  SizedBox(height: 16),
                  PersonalGenaticDiseaseTab(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
class PersonalGenaticDiseaseTab extends StatelessWidget {
  const PersonalGenaticDiseaseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GeneticsDiseasesViewCubit, GeneticsDiseasesViewState>(
      listener: (context, state) {
        if (state.requestStatus == RequestStatus.success&&
            state.isDeleteRequest) {
          Navigator.pop(context);
          showSuccess(state.message!);
        } else if (state.requestStatus == RequestStatus.failure&&
            state.isDeleteRequest) {
          showError(state.message!);
        }
      },
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.requestStatus == RequestStatus.failure) {
          return Center(child: Text(state.message!));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              DetailsViewInfoTile(
                title: 'تاريخ التشخيص',
                value: state.currentPersonalGeneticDiseaseDetails!.date!,
                icon: 'assets/images/date_icon.png',
                isExpanded: true,
              ),
              SizedBox(height: 16.h),
              DetailsViewInfoTile(
                title: "المرض الوراثى",
                value: state.currentPersonalGeneticDiseaseDetails!.geneticDisease!,
                icon: 'assets/images/tumor_icon.png',
                isExpanded: true,
              ),
              SizedBox(height: 16.h),
              DetailsViewInfoTile(
                title: "حالة المرض",
                value: state.currentPersonalGeneticDiseaseDetails!.diseaseStatus!,
                icon: 'assets/images/tumor_icon.png',
                isExpanded: true,
              ),
              verticalSpacing(16),
              Row(
                children: [
                  DetailsViewInfoTile(
                    title: 'الطبيب المعالج',
                    value: state.currentPersonalGeneticDiseaseDetails!.doctor!,
                    icon: 'assets/images/doctor_icon.png',
                  ),
                  Spacer(),
                  DetailsViewInfoTile(
                    title: 'المستشفي',
                    value: state.currentPersonalGeneticDiseaseDetails!.hospital!,
                    icon: 'assets/images/hospital_icon.png',
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              DetailsViewInfoTile(
                title: 'الدولة',
                value: state.currentPersonalGeneticDiseaseDetails!.country!,
                icon: 'assets/images/country_icon.png',
                isExpanded: true,
              ),
              verticalSpacing(16),
              DetailsViewImageWithTitleTile(
                image: state.currentPersonalGeneticDiseaseDetails!.geneticTestsImage!,
                title: "فحصات جينية",
                isShareEnabled: true,
              ),
              verticalSpacing(16),
              DetailsViewImageWithTitleTile(
                image: state.currentPersonalGeneticDiseaseDetails!.otherTestsImage!,
                title: "فحوصات اخري",
                isShareEnabled: true,
              ),
              verticalSpacing(16),
              DetailsViewImageWithTitleTile(
                image: state.currentPersonalGeneticDiseaseDetails!.medicalReport!,
                title: "التقرير الطبي",
                isShareEnabled: true,
              ),
            ],
          ),
        );
      },
    );
  }
}

Future<void> shareDetails(
    BuildContext context, PersonalGeneticDiseasDetails? details) async {
  try {
    // 📝 Generate text content
    final text = '''
🧬 *تفاصيل المرض الوراثي* 🧬

📅 *تاريخ التشخيص*: ${details!.date ?? "غير محدد"}
🦠 *المرض الوراثي*: ${details.geneticDisease ?? "غير محدد"}
📊 *حالة المرض*: ${details.diseaseStatus ?? "غير محددة"}

👨‍⚕️ *الطبيب المعالج*: ${details.doctor ?? "غير محدد"}
🏥 *المستشفى*: ${details.hospital ?? "غير محددة"}
🌍 *الدولة*: ${details.country ?? "غير محددة"}

📎 *الملفات المرفقة إن وجدت*
''';

    final tempDir = await getTemporaryDirectory();
    List<String> imagePaths = [];

    // ✅ تحميل الصور إن وُجدت
    if ((details.geneticTestsImage ?? '').startsWith("http")) {
      final path = await downloadImage(
          details.geneticTestsImage!, tempDir, "genetic_tests.png");
      if (path != null) imagePaths.add(path);
    }

    if ((details.otherTestsImage ?? '').startsWith("http")) {
      final path = await downloadImage(
          details.otherTestsImage!, tempDir, "other_tests.png");
      if (path != null) imagePaths.add(path);
    }

    if ((details.medicalReport ?? '').startsWith("http")) {
      final path = await downloadImage(
          details.medicalReport!, tempDir, "medical_report.png");
      if (path != null) imagePaths.add(path);
    }

    // 📤 مشاركة النص والملفات
    if (imagePaths.isNotEmpty) {
      await Share.shareXFiles(
        imagePaths.map((path) => XFile(path)).toList(),
        text: text,
      );
    } else {
      await Share.share(text);
    }
  } catch (e) {
    await showError("❌ حدث خطأ أثناء مشاركة تفاصيل المرض الوراثي");
  }
}
