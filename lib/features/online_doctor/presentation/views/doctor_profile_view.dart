import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/error_view_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_model.dart';
import 'package:we_care/features/online_doctor/logic/cubit/doctor_profile_cubit.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_booking_info_card.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_languages_chips.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_profile_app_bar.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_profile_entry_sections.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_profile_expandable_section.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_profile_header_card.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_specialization_details.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// شاشة "ملف الطبيب" — بتجيب البروفايل بالـ [doctorId] الجاى من قايمة الأطباء.
class DoctorProfileView extends StatelessWidget {
  const DoctorProfileView({super.key, required this.doctorId});

  final String doctorId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorProfileCubit>(
      create: (_) => getIt<DoctorProfileCubit>()..getDoctorProfile(doctorId),
      child: const _DoctorProfileBody(),
    );
  }
}

class _DoctorProfileBody extends StatelessWidget {
  const _DoctorProfileBody();

  String _shareText(DoctorModel doctor) =>
      "${doctor.name}\n${doctor.degree} ${doctor.specialty}\n"
      "${doctor.academicTitle} - ${doctor.hospital}\n${doctor.locationLabel}";

  Future<void> _shareDoctorProfile(DoctorModel doctor) async {
    await Share.share(_shareText(doctor));
  }

  Future<void> _showMoreOptions(
    BuildContext context,
    DoctorModel doctor,
  ) async {
    final cubit = context.read<DoctorProfileCubit>();
    final isFavorite = cubit.state.isFavorite;

    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            verticalSpacing(8),
            _MoreOptionTile(
              icon: Icons.share_outlined,
              title: "مشاركة ملف الطبيب",
              onTap: () => Navigator.of(context).pop("share"),
            ),
            _MoreOptionTile(
              icon: isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              title: isFavorite ? "إزالة من المفضلة" : "إضافة إلى المفضلة",
              onTap: () => Navigator.of(context).pop("favorite"),
            ),
            verticalSpacing(8),
          ],
        ),
      ),
    );

    if (action == "share") {
      await _shareDoctorProfile(doctor);
    } else if (action == "favorite") {
      await cubit.toggleFavorite();
    }
  }

  Widget _buildContent(BuildContext context, DoctorProfileState state) {
    final cubit = context.read<DoctorProfileCubit>();
    final doctor = state.doctor;

    if (state.requestStatus == RequestStatus.failure) {
      return ErrorViewWidget(
        errorMessage: state.errorMessage,
        onRetry: cubit.retry,
      );
    }
    if (doctor == null) {
      return Center(
        child: CircularProgressIndicator(color: AppColorsManager.mainDarkBlue),
      );
    }
    return _DoctorProfileContent(
      doctor: doctor,
      isFavorite: state.isFavorite,
      onFavoriteToggled: cubit.toggleFavorite,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorProfileCubit, DoctorProfileState>(
      listenWhen: (previous, current) =>
          previous.favoriteStatus != current.favoriteStatus,
      listener: (context, state) {
        if (state.favoriteStatus == RequestStatus.success) {
          showSuccess(state.favoriteMessage);
        } else if (state.favoriteStatus == RequestStatus.failure) {
          showError(state.favoriteMessage);
        }
      },
      builder: (context, state) {
        final doctor = state.doctor;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0),
                  child: DoctorProfileAppBar(
                    title: "ملف الطبيب",
                    onSharePressed: doctor == null
                        ? null
                        : () => _shareDoctorProfile(doctor),
                    onMorePressed: doctor == null
                        ? null
                        : () => _showMoreOptions(context, doctor),
                  ),
                ),
                Expanded(child: _buildContent(context, state)),
                if (doctor != null)
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.h),
                    child: _BookAppointmentButton(
                      onPressed: () => Navigator.of(context).pushNamed(
                        Routes.bookAppointmentView,
                        arguments: doctor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// محتوى الملف بعد ما البروفايل يوصل — الأقسام الفاضية بتتخفى زى ما الـ API
/// بيرجّع `[]` مش `null`.
class _DoctorProfileContent extends StatelessWidget {
  const _DoctorProfileContent({
    required this.doctor,
    required this.isFavorite,
    required this.onFavoriteToggled,
  });

  final DoctorModel doctor;
  final bool isFavorite;
  final VoidCallback onFavoriteToggled;

  @override
  Widget build(BuildContext context) {
    final sections = <Widget>[
      DoctorProfileHeaderCard(
        doctor: doctor,
        isFavorite: isFavorite,
        onFavoriteToggled: onFavoriteToggled,
      ),
      DoctorBookingInfoCard(doctor: doctor),
      if (doctor.about.trim().isNotEmpty)
        DoctorProfileExpandableSection(
          title: "نبذة عن الطبيب",
          icon: Icons.person_rounded,
          body: doctor.about,
          initiallyExpanded: true,
        ),
      DoctorProfileExpandableSection(
        title: "التخصص والاهتمامات الطبية",
        iconAsset: "assets/images/doctor_stethoscope_icon.png",
        content: DoctorSpecializationDetails(doctor: doctor),
      ),
      if (doctor.professionalExperience.isNotEmpty)
        DoctorProfileExpandableSection(
          title: "الخبرة المهنية",
          icon: Icons.work_rounded,
          items: [
            for (final experience in doctor.professionalExperience)
              experience.label,
          ],
        ),
      if (doctor.languages.isNotEmpty)
        DoctorProfileExpandableSection(
          title: "اللغات",
          icon: Icons.language_rounded,
          content: DoctorLanguagesChips(languages: doctor.languages),
        ),
      if (doctor.education.isNotEmpty)
        DoctorProfileExpandableSection(
          title: "التعليم والمؤهلات",
          icon: Icons.school_rounded,
          content: DoctorQualificationsList(qualifications: doctor.education),
        ),
      if (doctor.certificates.isNotEmpty)
        DoctorProfileExpandableSection(
          title: "الدورات والشهادات المهنية",
          icon: Icons.assignment_ind_rounded,
          content: DoctorCertificatesList(certificates: doctor.certificates),
        ),
      if (doctor.medicalAssociations.isNotEmpty)
        DoctorProfileExpandableSection(
          title: "الجمعيات الطبية",
          icon: Icons.groups_rounded,
          content: DoctorMembershipsList(
            memberships: doctor.medicalAssociations,
          ),
        ),
      if (doctor.research.isNotEmpty)
        DoctorProfileExpandableSection(
          title: "الأبحاث والرسائل العلمية",
          icon: Icons.biotech_rounded,
          content: DoctorResearchList(research: doctor.research),
        ),
      if (doctor.awards.isNotEmpty)
        DoctorProfileExpandableSection(
          title: "الجوائز والتكريمات",
          icon: Icons.emoji_events_rounded,
          content: DoctorAwardsList(awards: doctor.awards),
        ),
      if (doctor.mediaAppearances.isNotEmpty)
        DoctorProfileExpandableSection(
          title: "ميديا ومقالات",
          icon: Icons.menu_book_rounded,
          content: DoctorMediaList(media: doctor.mediaAppearances),
        ),
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < sections.length; index++) ...[
            if (index != 0) verticalSpacing(10),
            sections[index],
          ],
        ],
      ),
    );
  }
}

class _MoreOptionTile extends StatelessWidget {
  const _MoreOptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 20.sp, color: OnlineDoctorTheme.accentBlue),
      title: Text(
        title,
        style: AppTextStyles.font14blackWeight400.copyWith(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: OnlineDoctorTheme.headingColor,
        ),
      ),
    );
  }
}

class _BookAppointmentButton extends StatelessWidget {
  const _BookAppointmentButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 52.h,
        decoration: BoxDecoration(
          color: AppColorsManager.mainDarkBlue,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "حجز موعد",
              style: AppTextStyles.font22WhiteWeight600.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            horizontalSpacing(8),
            Icon(
              Icons.calendar_month_rounded,
              size: 18.sp,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
