import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_image_with_title.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
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
      child: BlocBuilder<XRayViewCubit, XRayViewState>(
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
                  DetailsViewAppBar(title: 'الاشعة'),
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
                  Row(children: [
                    DetailsViewInfoTile(
                        title: "النوع",
                        value: radiologyData.radioType,
                        icon: 'assets/images/type_icon.png'),
                    Spacer(),
                    DetailsViewInfoTile(
                        title: "نوعية الاحتياج",
                        value: radiologyData.periodicUsage ?? 'لم يتم ادخاله',
                        icon: 'assets/images/need_icon.png'),
                  ]),
                  DetailsViewInfoTile(
                      title: "الأعراض",
                      value: radiologyData.symptoms ?? 'لم يتم ادخاله',
                      icon: 'assets/images/symptoms_icon.png',
                      isExpanded: true),
                  Row(children: [
                    DetailsViewInfoTile(
                        title: "الطبيب المعالج",
                        value: radiologyData.doctor ?? 'لم يتم ادخاله',
                        icon: 'assets/images/doctor_icon.png'),
                    Spacer(),
                    DetailsViewInfoTile(
                        title: "طبيب الأشعة",
                        value: radiologyData.radiologyDoctor ?? 'لم يتم ادخاله',
                        icon: 'assets/images/doctor_icon.png'),
                  ]),
                  Row(children: [
                    DetailsViewInfoTile(
                        title: "المستشفى",
                        value: radiologyData.hospital ?? 'لم يتم ادخاله',
                        icon: 'assets/images/hospital_icon.png'),
                    Spacer(),
                    DetailsViewInfoTile(
                        title: "الدولة",
                        value: radiologyData.country ?? 'لم يتم ادخاله',
                        icon: 'assets/images/country_icon.png'),
                  ]),
                  DetailsViewInfoTile(
                      title: "ملاحظات",
                      value: radiologyData.radiologyNote ?? 'لم يتم ادخاله',
                      icon: 'assets/images/notes_icon.png',
                      isExpanded: true),
                  DetailsViewImageWithTitleTile(
                      image: radiologyData.radiologyPhoto,
                      title: "صورة الأشعة"),
                  DetailsViewImageWithTitleTile(
                      //  image: radiologyData.report,
                      image: '',
                      title: "صورة التقرير"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
