import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/eyes/eyes_view/Presentation/widgets/lense_details_card.dart';
import 'package:we_care/features/eyes/eyes_view/logic/eye_view_cubit.dart';
import 'package:we_care/features/eyes/eyes_view/logic/eye_view_state.dart';

class EyesGlassesDetailsView extends StatelessWidget {
  final String documentId;
  const EyesGlassesDetailsView({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<EyeViewCubit>()..getEyeGlassesDetails(documentId),
      child: BlocBuilder<EyeViewCubit, EyeViewState>(
        builder: (context, state) {
          if (state.requestStatus == RequestStatus.loading ||
              state.selectedEyeGlassesDetails == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final data = state.selectedEyeGlassesDetails!;

          return Scaffold(
            appBar: AppBar(toolbarHeight: 0.h),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
              child: Column(
                spacing: 16.h,
                children: [
                  const DetailsViewAppBar(
                    title: 'بيانات النظارات',
                    showActionButtons: true,
                  ),
                  Image.asset('assets/images/glass.png'),
                  Row(children: [
                    DetailsViewInfoTile(
                      title: "تاريخ الفحص",
                      value: data.date,
                      icon: 'assets/images/data_search_icon.png',
                    ),
                    const Spacer(),
                    DetailsViewInfoTile(
                      title: "المركز/المستشفى",
                      value: data.hospitalName,
                      icon: 'assets/images/date_icon.png',
                    ),
                  ]),
                  Row(children: [
                    DetailsViewInfoTile(
                      title: "الطبيب",
                      value: data.doctorName,
                      icon: 'assets/images/doctor_name.png',
                    ),
                    const Spacer(),
                    DetailsViewInfoTile(
                      title: "محل النظارات",
                      value: data.storeName,
                      icon: 'assets/images/hospital_icon.png',
                    ),
                  ]),
                  Row(
                    children: [
                      DetailsViewInfoTile(
                        title: "حماية من ضوء \nازرق",
                        value: data.blueLightProtection == null
                            ? "-"
                            : data.blueLightProtection!
                                ? "نعم"
                                : "لا",
                        icon: 'assets/images/blue_light.png',
                        isSmallContainers: true,
                      ),
                      const Spacer(),
                      DetailsViewInfoTile(
                        title: "مقاومة الخدش",
                        value: data.scratchResistance == null
                            ? "-"
                            : data.scratchResistance!
                                ? "نعم"
                                : "لا",
                        icon: 'assets/images/scratch_protection.png',
                        isSmallContainers: true,
                      ),
                      const Spacer(),
                      DetailsViewInfoTile(
                        title: "مضاد للانعكاس",
                        value: data.antiReflection == null
                            ? "-"
                            : data.antiReflection!
                                ? "نعم"
                                : "لا",
                        icon: 'assets/images/reflection.png',
                        isSmallContainers: true,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      DetailsViewInfoTile(
                        title: "طبقة مضادة\n لبصمات",
                        value: data.fingerprintResistance == null
                            ? "-"
                            : data.fingerprintResistance!
                                ? "نعم"
                                : "لا",
                        icon: 'assets/images/fingerprint.png',
                        isSmallContainers: true,
                      ),
                      const Spacer(),
                      DetailsViewInfoTile(
                        title: "طبقة مضادة\n لضباب",
                        value: data.antiFog == null
                            ? "-"
                            : data.antiFog!
                                ? "نعم"
                                : "لا",
                        icon: 'assets/images/fog.png',
                        isSmallContainers: true,
                      ),
                      const Spacer(),
                      DetailsViewInfoTile(
                        title: "حماية من أشعة \nفوق بنفسجية",
                        value: data.uvProtection == null
                            ? "-"
                            : data.uvProtection!
                                ? "نعم"
                                : "لا",
                        icon: 'assets/images/uv.png',
                        isSmallContainers: true,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LensDetailsCard(
                        lensSide: "العدسة اليمنى",
                        icon: 'assets/images/right_lense.png',
                        lensData: {
                          "قصر النظر": data.rightEye.myopiaDegree,
                          "طول القصر": data.rightEye.hyperopiaDegree,
                          "الاستجماتزم": data.rightEye.astigmatismDegree,
                          "محور الاستجماتزم": data.rightEye.astigmatismAxis,
                          "الإضافة البؤرية": data.rightEye.addition,
                          "تباعُد الحدقتين": data.rightEye.nearAddition,
                          "معامل الانكسار": data.rightEye.refractiveIndex,
                          "قطر العدسة": data.rightEye.lensDiameter,
                          "المركز": data.rightEye.lensCentering,
                          "الحواف": data.rightEye.lensEdgeType,
                          "سطح العدسة": data.rightEye.lensSurfaceType,
                          "سُمك العدسة": data.rightEye.lensThickness,
                          "نوع العدسة": data.rightEye.lensType,
                        },
                      ),
                      SizedBox(width: 12.w),
                      LensDetailsCard(
                        lensSide: "العدسة اليسرى",
                        icon: 'assets/images/left_lense.png',
                        lensData: {
                          "قصر النظر": data.leftEye.myopiaDegree,
                          "طول القصر": data.leftEye.hyperopiaDegree,
                          "الاستجماتزم": data.leftEye.astigmatismDegree,
                          "محور الاستجماتزم": data.leftEye.astigmatismAxis,
                          "الإضافة البؤرية": data.leftEye.addition,
                          "تباعُد الحدقتين": data.leftEye.nearAddition,
                          "معامل الانكسار": data.leftEye.refractiveIndex,
                          "قطر العدسة": data.leftEye.lensDiameter,
                          "المركز": data.leftEye.lensCentering,
                          "الحواف": data.leftEye.lensEdgeType,
                          "سطح العدسة": data.leftEye.lensSurfaceType,
                          "سُمك العدسة": data.leftEye.lensThickness,
                          "نوع العدسة": data.leftEye.lensType,
                        },
                      ),
                    ],
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
