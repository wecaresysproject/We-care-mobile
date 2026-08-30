import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/error_view_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_summary_model.dart';
import 'package:we_care/features/online_doctor/logic/cubit/doctors_list_cubit.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_card_item.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_sort_dropdown.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_specializations_app_bar.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_specializations_search_field.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctors_rating_footnote.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

class DoctorsListView extends StatelessWidget {
  const DoctorsListView({super.key, required this.specialtyIdentifier});

  /// الـ `identifierName` بتاع التخصص اللى المستخدم اختاره من شاشة التخصصات —
  /// بيتبعت للـ API زى ما هو (مثال: `internalMedicine`).
  final String specialtyIdentifier;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorsListCubit>(
      create: (_) =>
          getIt<DoctorsListCubit>()..getDoctorsBySpecialty(specialtyIdentifier),
      child: const _DoctorsListBody(),
    );
  }
}

class _DoctorsListBody extends StatefulWidget {
  const _DoctorsListBody();

  @override
  State<_DoctorsListBody> createState() => _DoctorsListBodyState();
}

class _DoctorsListBodyState extends State<_DoctorsListBody> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = "";

  /// المعيار المفعّل حاليًا — `null` يعنى الترتيب الافتراضى زى ما جه من الـ API.
  DoctorSortField? _sortField;
  DoctorSortDirection _sortDirection = DoctorSortDirection.descending;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// البحث بالاسم والترتيب بيتعملوا محليًا على القايمة اللى جت من الـ API.
  List<DoctorSummaryModel> _visibleDoctors(
    List<DoctorSummaryModel> allDoctors,
  ) {
    final query = _searchQuery.trim();
    final doctors = query.isEmpty
        ? [...allDoctors]
        : allDoctors.where((doctor) => doctor.name.contains(query)).toList();

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

  Widget _buildDoctors(BuildContext context, DoctorsListState state) {
    switch (state.requestStatus) {
      case RequestStatus.initial:
      case RequestStatus.loading:
        return Center(
          child: CircularProgressIndicator(
            color: AppColorsManager.mainDarkBlue,
          ),
        );
      case RequestStatus.failure:
        return ErrorViewWidget(
          errorMessage: state.errorMessage,
          onRetry: context.read<DoctorsListCubit>().retry,
        );
      case RequestStatus.success:
        if (state.doctors.isEmpty) {
          return const _EmptyMessage(
            "لا يوجد أطباء متاحون في هذا التخصص حاليًا",
          );
        }
        final doctors = _visibleDoctors(state.doctors);
        if (doctors.isEmpty) {
          return const _EmptyMessage("لا يوجد طبيب بهذا الاسم");
        }
        return ListView.separated(
          itemCount: doctors.length,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 4.h, bottom: 12.h),
          separatorBuilder: (_, __) => verticalSpacing(16),
          itemBuilder: (context, index) => DoctorCardItem(
            doctor: doctors[index],
            onTap: () async {
              await context.pushNamed(
                Routes.doctorProfileView,
                arguments: doctors[index].id,
              );
            },
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                child: BlocBuilder<DoctorsListCubit, DoctorsListState>(
                  builder: _buildDoctors,
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

class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: AppTextStyles.font16BlackSemiBold,
      ),
    );
  }
}
