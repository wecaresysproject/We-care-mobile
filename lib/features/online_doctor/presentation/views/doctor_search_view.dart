import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_specializations_data.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_specialization_item.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_specializations_app_bar.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_specializations_search_field.dart';

class DoctorSearchView extends StatefulWidget {
  const DoctorSearchView({super.key});

  @override
  State<DoctorSearchView> createState() => _DoctorSearchViewState();
}

class _DoctorSearchViewState extends State<DoctorSearchView> {
  final TextEditingController _searchController = TextEditingController();

  //* كل الموديولز بتتعرض بنفس الشكل — مفيش تمييز بين مفعّل وغير مفعّل هنا.
  List<Map<String, dynamic>> _filteredSpecializations = doctorSpecializations;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final normalizedQuery = query.trim();
    setState(() {
      _filteredSpecializations = normalizedQuery.isEmpty
          ? doctorSpecializations
          : doctorSpecializations
              .where(
                (specialization) => (specialization["title"] as String)
                    .replaceAll('\n', ' ')
                    .contains(normalizedQuery),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            children: [
              const DoctorSpecializationsAppBar(title: "تخصصات الأطباء"),
              verticalSpacing(16),
              DoctorSpecializationsSearchField(
                controller: _searchController,
                onChanged: _onSearchChanged,
              ),
              verticalSpacing(16),
              Expanded(
                child: _filteredSpecializations.isEmpty
                    ? Center(
                        child: Text(
                          "لا يوجد تخصص بهذا الاسم",
                          style: AppTextStyles.font16BlackSemiBold,
                        ),
                      )
                    : GridView.builder(
                        itemCount: _filteredSpecializations.length,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 24.h),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisExtent: 112.h,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 16.h,
                        ),
                        itemBuilder: (context, index) {
                          final specialization =
                              _filteredSpecializations[index];
                          return DoctorSpecializationItem(
                            title: specialization["title"] as String,
                            imagePath: specialization["image"] as String,
                            onTap: () async {
                              await context.pushNamed(
                                Routes.doctorsListView,
                                arguments: specialization["title"] as String,
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
