import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_model.dart';
import 'package:we_care/features/online_doctor/data/models/doctors_dummy_data.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_card_item.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_sort_dropdown.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_specializations_app_bar.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_specializations_search_field.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctors_rating_footnote.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

class DoctorsListView extends StatefulWidget {
  const DoctorsListView({super.key, required this.specialization});

  /// التخصص اللى المستخدم دخل منه — بيتبعت من شاشة تخصصات الأطباء.
  final String specialization;

  @override
  State<DoctorsListView> createState() => _DoctorsListViewState();
}

class _DoctorsListViewState extends State<DoctorsListView> {
  final TextEditingController _searchController = TextEditingController();

  late final List<DoctorModel> _allDoctors =
      doctorsForSpecialization(widget.specialization);

  String _searchQuery = "";

  /// المعيار المفعّل حاليًا — `null` يعنى الترتيب الافتراضى زى ما جه من الداتا.
  DoctorSortField? _sortField;
  DoctorSortDirection _sortDirection = DoctorSortDirection.descending;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DoctorModel> get _visibleDoctors {
    final query = _searchQuery.trim();
    final doctors = query.isEmpty
        ? [..._allDoctors]
        : _allDoctors.where((doctor) => doctor.name.contains(query)).toList();

    final sortField = _sortField;
    if (sortField != null) {
      doctors.sort((first, second) {
        final comparison = switch (sortField) {
          DoctorSortField.rating => first.rating.compareTo(second.rating),
          DoctorSortField.likes =>
            first.likesCount.compareTo(second.likesCount),
        };
        return _sortDirection == DoctorSortDirection.descending
            ? -comparison
            : comparison;
      });
    }
    return doctors;
  }

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query);
  }

  void _onSortSelected(DoctorSortField field, DoctorSortDirection direction) {
    setState(() {
      _sortField = field;
      _sortDirection = direction;
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctors = _visibleDoctors;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
          child: Column(
            children: [
              const DoctorSpecializationsAppBar(title: "البحث عن طبيب"),
              verticalSpacing(16),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: DoctorSpecializationsSearchField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      hintText: "بحث باسم الطبيب",
                      height: 42,
                      borderRadius: 12,
                      borderColor: OnlineDoctorTheme.fieldBorder,
                      fontSize: 10,
                    ),
                  ),
                  horizontalSpacing(8),
                  Expanded(
                    flex: 3,
                    child: DoctorSortDropdown(
                      label: "ترتيب الإعجابات",
                      icon: Icons.thumb_up_rounded,
                      iconColor: OnlineDoctorTheme.likesBlue,
                      descendingLabel: "الأكثر إعجابًا",
                      ascendingLabel: "الأقل إعجابًا",
                      selectedDirection: _sortField == DoctorSortField.likes
                          ? _sortDirection
                          : null,
                      onSelected: (direction) =>
                          _onSortSelected(DoctorSortField.likes, direction),
                    ),
                  ),
                  horizontalSpacing(8),
                  Expanded(
                    flex: 3,
                    child: DoctorSortDropdown(
                      label: "ترتيب التقييم",
                      icon: Icons.star_rounded,
                      iconColor: OnlineDoctorTheme.ratingAmber,
                      descendingLabel: "الأعلى تقييمًا",
                      ascendingLabel: "الأقل تقييمًا",
                      selectedDirection: _sortField == DoctorSortField.rating
                          ? _sortDirection
                          : null,
                      onSelected: (direction) =>
                          _onSortSelected(DoctorSortField.rating, direction),
                    ),
                  ),
                ],
              ),
              verticalSpacing(16),
              Expanded(
                child: doctors.isEmpty
                    ? Center(
                        child: Text(
                          "لا يوجد طبيب بهذا الاسم",
                          style: AppTextStyles.font16BlackSemiBold,
                        ),
                      )
                    : ListView.separated(
                        itemCount: doctors.length,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(top: 4.h, bottom: 12.h),
                        separatorBuilder: (_, __) => verticalSpacing(16),
                        itemBuilder: (context, index) => DoctorCardItem(
                          doctor: doctors[index],
                          onTap: () async {
                            await context.pushNamed(
                              Routes.doctorProfileView,
                              arguments: doctors[index],
                            );
                          },
                        ),
                      ),
              ),
              const DoctorsRatingFootnote(),
            ],
          ),
        ),
      ),
    );
  }
}
