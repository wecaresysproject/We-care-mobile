import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_model.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_booking_info_card.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_languages_chips.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_profile_app_bar.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_profile_entry_sections.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_profile_expandable_section.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_profile_header_card.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_specialization_details.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

class DoctorProfileView extends StatefulWidget {
  const DoctorProfileView({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  State<DoctorProfileView> createState() => _DoctorProfileViewState();
}

class _DoctorProfileViewState extends State<DoctorProfileView> {
  //! لسه محليّة — هتتربط بالباك إند لما endpoint المفضلة يجهز.
  bool _isFavorite = false;

  DoctorModel get _doctor => widget.doctor;

  String get _shareText =>
      "${_doctor.name}\n${_doctor.degree} ${_doctor.specialization}\n"
      "${_doctor.academicTitle} - ${_doctor.hospital}\n${_doctor.location}";

  Future<void> _shareDoctorProfile() async {
    await Share.share(_shareText);
  }

  Future<void> _showMoreOptions() async {
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
              icon: _isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              title: _isFavorite ? "إزالة من المفضلة" : "إضافة إلى المفضلة",
              onTap: () => Navigator.of(context).pop("favorite"),
            ),
            verticalSpacing(8),
          ],
        ),
      ),
    );

    if (action == "share") {
      await _shareDoctorProfile();
    } else if (action == "favorite") {
      _toggleFavorite();
    }
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    showSuccess(
      _isFavorite ? "تمت الإضافة إلى المفضلة" : "تمت الإزالة من المفضلة",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0),
              child: DoctorProfileAppBar(
                title: "ملف الطبيب",
                onSharePressed: _shareDoctorProfile,
                onMorePressed: _showMoreOptions,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DoctorProfileHeaderCard(
                      doctor: _doctor,
                      isFavorite: _isFavorite,
                      onFavoriteToggled: _toggleFavorite,
                    ),
                    verticalSpacing(10),
                    DoctorBookingInfoCard(doctor: _doctor),
                    verticalSpacing(10),
                    DoctorProfileExpandableSection(
                      title: "نبذة عن الطبيب",
                      icon: Icons.person_rounded,
                      body: _doctor.about,
                      initiallyExpanded: true,
                    ),
                    verticalSpacing(10),
                    DoctorProfileExpandableSection(
                      title: "التخصص والاهتمامات الطبية",
                      iconAsset: "assets/images/doctor_stethoscope_icon.png",
                      content: DoctorSpecializationDetails(doctor: _doctor),
                    ),
                    verticalSpacing(10),
                    DoctorProfileExpandableSection(
                      title: "الخبرة المهنية",
                      icon: Icons.work_rounded,
                      items: _doctor.professionalExperience,
                    ),
                    verticalSpacing(10),
                    DoctorProfileExpandableSection(
                      title: "اللغات",
                      icon: Icons.language_rounded,
                      content: DoctorLanguagesChips(
                        languages: _doctor.languages,
                      ),
                    ),
                    verticalSpacing(10),
                    DoctorProfileExpandableSection(
                      title: "التعليم والمؤهلات",
                      icon: Icons.school_rounded,
                      content: DoctorQualificationsList(
                        qualifications: _doctor.education,
                      ),
                    ),
                    verticalSpacing(10),
                    DoctorProfileExpandableSection(
                      title: "الدورات والشهادات المهنية",
                      icon: Icons.assignment_ind_rounded,
                      content: DoctorCertificatesList(
                        certificates: _doctor.certificates,
                      ),
                    ),
                    verticalSpacing(10),
                    DoctorProfileExpandableSection(
                      title: "الجمعيات الطبية",
                      icon: Icons.groups_rounded,
                      content: DoctorMembershipsList(
                        memberships: _doctor.medicalAssociations,
                      ),
                    ),
                    verticalSpacing(10),
                    DoctorProfileExpandableSection(
                      title: "الأبحاث والرسائل العلمية",
                      icon: Icons.biotech_rounded,
                      content: DoctorResearchList(research: _doctor.research),
                    ),
                    verticalSpacing(10),
                    DoctorProfileExpandableSection(
                      title: "الجوائز والتكريمات",
                      icon: Icons.emoji_events_rounded,
                      content: DoctorAwardsList(awards: _doctor.awards),
                    ),
                    verticalSpacing(10),
                    DoctorProfileExpandableSection(
                      title: "ميديا ومقالات",
                      icon: Icons.menu_book_rounded,
                      content: DoctorMediaList(
                        media: _doctor.mediaAppearances,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.h),
              child: _BookAppointmentButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  Routes.bookAppointmentView,
                  arguments: _doctor,
                ),
              ),
            ),
          ],
        ),
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
