import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_image_with_title.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/essential_info/essential_info_view/logic/%20essential_info_view_cubit.dart';
import 'package:we_care/features/essential_info/essential_info_view/logic/essential_info_view_state.dart';

class EssentialDataView extends StatelessWidget {
  const EssentialDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<EssentialInfoViewCubit>()..getUserEssentialInfo(),
      child: BlocBuilder<EssentialInfoViewCubit, EssentialInfoViewState>(
        builder: (context, state) {
          final info = state.userEssentialInfo;

          if (state.deleteRequestStatus == RequestStatus.success) {
            showSuccess(state.responseMessage);
            context.pop();
          }

          if (state.requestStatus == RequestStatus.loading) {
            return Scaffold(
                body: const Center(child: CircularProgressIndicator()));
          }

          if (state.requestStatus == RequestStatus.failure) {
            return Scaffold(body: Center(child: Text(state.responseMessage)));
          }

          if (info == null) {
            return Scaffold(
                body: const Center(child: Text("لا توجد بيانات حالياً")));
          }

          return Scaffold(
            appBar: AppBar(toolbarHeight: 0.h),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                children: [
                  // App bar
                  AppBarWithCenteredTitle(
                    title: 'البيانات الأساسية',
                    editFunction: () async {
                      await context.pushNamed(
                        Routes.essentialInfoDataEntry,
                        arguments: state.userEssentialInfo,
                      );
                      if (context.mounted) {
                        await context
                            .read<EssentialInfoViewCubit>()
                            .getUserEssentialInfo();
                      }
                    },
                    shareFunction: () async {
                      await context
                          .read<EssentialInfoViewCubit>()
                          .shareEssentialInfoDetails();
                    },
                    deleteFunction: () {
                      context
                          .read<EssentialInfoViewCubit>()
                          .deleteEssentialInfo();
                    },
                  ),

                  // Full Name
                  DetailsViewInfoTile(
                    title: "الاسم الرباعي",
                    value: info.fullName ?? '',
                    icon: 'assets/images/notes_icon.png',
                    isExpanded: true,
                  ),

                  // National ID & Birth Date
                  Row(
                    children: [
                      Expanded(
                        child: DetailsViewInfoTile(
                          title: "تاريخ الميلاد",
                          value: info.dateOfBirth ?? '',
                          icon: 'assets/images/date_icon.png',
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: DetailsViewInfoTile(
                          title: "الرقم الوطني",
                          value: info.nationalID ?? '',
                          icon: 'assets/images/id_icon.png',
                        ),
                      ),
                    ],
                  ),

                  DetailsViewInfoTile(
                    title: "النوع",
                    value: info.gender ?? "",
                    isExpanded: true,
                  ),
                  // Email
                  DetailsViewInfoTile(
                    title: "البريد الإلكتروني",
                    value: info.email ?? '',
                    icon: 'assets/images/email_icon.png',
                    isExpanded: true,
                  ),

                  // Personal Photo
                  if (info.personalPhotoUrl != null)
                    DetailsViewImageWithTitleTile(
                      image: info.personalPhotoUrl!,
                      title: "صورة شخصية (4×6)",
                      isShareEnabled: true,
                    ),

                  // Country & City
                  Row(
                    children: [
                      Expanded(
                        child: DetailsViewInfoTile(
                          title: "دولة",
                          value: info.country ?? '',
                          icon: 'assets/images/country_icon.png',
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: DetailsViewInfoTile(
                          title: "مدينة",
                          value: info.city ?? '',
                          icon: 'assets/images/city_icon.png',
                        ),
                      ),
                    ],
                  ),

                  // Area / District
                  DetailsViewInfoTile(
                    title: "المنطقة/مدينة",
                    value: info.areaOrDistrict ?? '',
                    icon: 'assets/images/city_icon.png',
                    isExpanded: true,
                  ),

                  // Blood Type & Work Hours
                  Row(
                    children: [
                      Expanded(
                        child: DetailsViewInfoTile(
                          title: "فصيلة الدم",
                          value: info.bloodType ?? '',
                          icon: 'assets/images/blood_icon.png',
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: DetailsViewInfoTile(
                          title: "ساعات العمل",
                          value: info.workHours ?? '',
                          icon: 'assets/images/times_icon.png',
                        ),
                      ),
                    ],
                  ),

                  // Insurance Info
                  Row(
                    children: [
                      Expanded(
                        child: DetailsViewInfoTile(
                          title: "شركة التأمين",
                          value: info.insuranceCompany ?? '',
                          icon: 'assets/images/doctor_name.png',
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: DetailsViewInfoTile(
                          title: "انتهاء التغطية",
                          value: info.insuranceCoverageExpiryDate ?? '',
                          icon: 'assets/images/date_icon.png',
                        ),
                      ),
                    ],
                  ),

                  DetailsViewInfoTile(
                    title: "شروط إضافية",
                    value: info.additionalTerms ?? '',
                    icon: 'assets/images/notes_icon.png',
                    isExpanded: true,
                  ),

                  if (info.insuranceCardPhotoUrl != null)
                    DetailsViewImageWithTitleTile(
                      image: info.insuranceCardPhotoUrl!,
                      title: "صورة بطاقة التأمين",
                      isShareEnabled: true,
                    ),

                  // Disability Info
                  DetailsViewInfoTile(
                    title: "نوع العجز",
                    value: info.disabilityType ?? '',
                    icon: 'assets/images/disability_icon.png',
                    isExpanded: true,
                  ),

                  DetailsViewInfoTile(
                    title: "العجز إن وجد",
                    value: info.disabilityDetails ?? '',
                    icon: 'assets/images/disability_icon.png',
                    isExpanded: true,
                  ),

                  // Family Info
                  Row(
                    children: [
                      Expanded(
                        child: DetailsViewInfoTile(
                          title: "عدد الأطفال",
                          value: (info.numberOfChildren ?? 0).toString(),
                          icon: 'assets/images/family_icon.png',
                        ),
                      ),
                      Expanded(
                        child: DetailsViewInfoTile(
                          title: "الحالة الاجتماعية",
                          value: info.socialStatus ?? '',
                          icon: 'assets/images/social_icon.png',
                        ),
                      ),
                    ],
                  ),

                  // Emergency Contacts
                  Row(
                    children: [
                      Expanded(
                        child: DetailsViewInfoTile(
                          title: "هاتف الطوارئ 1",
                          value: info.emergencyContact1 ?? '',
                          icon: 'assets/images/phone_icon.png',
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: DetailsViewInfoTile(
                          title: "هاتف الطوارئ 2",
                          value: info.emergencyContact2 ?? '',
                          icon: 'assets/images/phone_icon.png',
                        ),
                      ),
                    ],
                  ),

                  // Family Doctor
                  DetailsViewInfoTile(
                    title: "طبيب الأسرة",
                    value: info.familyDoctorName ?? '',
                    icon: 'assets/images/doctor_icon.png',
                    isExpanded: true,
                  ),

                  DetailsViewInfoTile(
                    title: "هاتف طبيب الأسرة",
                    value: info.familyDoctorPhoneNumber ?? '',
                    icon: 'assets/images/phone_icon.png',
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
