import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/doctor/bookings/data/models/appointment_type.dart';
import 'package:we_care/features/doctor/patient_files/data/models/patient_file_models.dart';
import 'package:we_care/features/doctor/patient_files/logic/patient_files_cubit.dart';
import 'package:we_care/features/doctor/patient_files/presentation/views/widgets/patient_file_cards.dart';
import 'package:we_care/features/doctor/patient_medical_file/presentation/patient_medical_file_launcher.dart';
import 'package:we_care/features/doctor/prescription/logic/cubit/previous_prescriptions_cubit.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/we_care_brand_mark.dart';

const _navy = AppColorsManager.prescriptionTitleColor;
const _border = AppColorsManager.prescriptionCardBorder;
const _tabIdle = Color(0xFFE9EFF8);

/// "ملفات المرضى" — from the doctor home's quick actions. Two tabs:
/// - "ملفات مفتوحة بالصلاحية": bookings whose patient-data access is still
///   open; the folder opens the medical file (allowed modules only).
/// - "ملفات المرضى القدامى": every patient the doctor examined; "الروشتات"
///   opens what the doctor wrote for them.
/// Expects a [PatientFilesCubit] above it (see `AppRouter`).
class DoctorPatientFilesView extends StatelessWidget {
  const DoctorPatientFilesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsManager.prescriptionScaffoldBackground,
      body: SafeArea(
        child: BlocBuilder<PatientFilesCubit, PatientFilesState>(
          builder: (context, state) {
            final cubit = context.read<PatientFilesCubit>();
            final isOpenTab = state.tab == PatientFilesTab.open;
            return Column(
              children: [
                const _Header(),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 10.h),
                  child: Row(
                    children: [
                      _TabButton(
                        icon: Icons.folder_rounded,
                        label: "ملفات مفتوحة بالصلاحية",
                        isSelected: isOpenTab,
                        onTap: () => cubit.selectTab(PatientFilesTab.open),
                      ),
                      horizontalSpacing(10),
                      _TabButton(
                        icon: Icons.history_rounded,
                        label: "ملفات المرضى القدامى",
                        isSelected: !isOpenTab,
                        onTap: () => cubit.selectTab(PatientFilesTab.previous),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
                  child: Row(
                    children: [
                      Expanded(child: _SearchField(onChanged: cubit.search)),
                      horizontalSpacing(8),
                      if (isOpenTab)
                        _FilterChip<PatientFileBookingStatus>(
                          label: "حالة الكشف",
                          value: state.statusFilter,
                          options: PatientFileBookingStatus.values,
                          optionLabel: (status) => status.label,
                          onChanged: cubit.filterStatus,
                        )
                      else
                        _FilterChip<AppointmentType>(
                          label: "نوع الكشف",
                          value: state.typeFilter,
                          options: AppointmentType.values,
                          optionLabel: (type) => type.label,
                          onChanged: cubit.filterType,
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: isOpenTab
                      ? _OpenFilesList(state: state)
                      : _PreviousPatientsList(state: state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 6.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "ملفات المرضى",
              style: AppTextStyles.font20blackWeight700.copyWith(
                fontSize: 20.sp,
                color: _navy,
              ),
            ),
          ),
          WeCareBrandMark(width: 64.w),
          horizontalSpacing(10),
          Material(
            color: Colors.white,
            shape: const CircleBorder(side: BorderSide(color: _border)),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: EdgeInsets.all(8.r),
                child: Icon(
                  // Points left like the other doctor screens.
                  Icons.keyboard_arrow_left_rounded,
                  size: 22.r,
                  color: _navy,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Colors.white : _navy;
    return Expanded(
      child: Material(
        color: isSelected ? _navy : _tabIdle,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 17.r, color: color),
                horizontalSpacing(5),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      style: AppTextStyles.font14blackWeight400.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: const BorderSide(color: _border),
    );
    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: AppTextStyles.font14blackWeight400.copyWith(color: _navy),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        hintText: "ابحث باسم المريض",
        hintStyle: AppTextStyles.font14blackWeight400.copyWith(
          fontSize: 13.sp,
          color: AppColorsManager.prescriptionSubtitleColor,
        ),
        prefixIcon: Icon(Icons.search_rounded, size: 22.r, color: _navy),
        contentPadding: EdgeInsets.symmetric(vertical: 13.h),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: const BorderSide(color: _navy),
        ),
      ),
    );
  }
}

/// "حالة الكشف: الكل" — small, opens a menu with "الكل" and [options].
class _FilterChip<T> extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.value,
    required this.options,
    required this.optionLabel,
    required this.onChanged,
  });

  final String label;
  final T? value;
  final List<T> options;
  final String Function(T) optionLabel;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final current = value;
    return PopupMenuButton<int>(
      // -1 = الكل; otherwise the option's index.
      onSelected: (index) => onChanged(index < 0 ? null : options[index]),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      itemBuilder: (_) => [
        const PopupMenuItem(value: -1, child: Text("الكل")),
        for (var i = 0; i < options.length; i++)
          PopupMenuItem(value: i, child: Text(optionLabel(options[i]))),
      ],
      child: Container(
        padding: EdgeInsets.fromLTRB(6.w, 6.h, 8.w, 6.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: _border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "$label:",
              style: AppTextStyles.font14blackWeight400.copyWith(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: _navy,
              ),
            ),
            horizontalSpacing(4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: _navy,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                current == null ? "الكل" : optionLabel(current),
                style: AppTextStyles.font14blackWeight400.copyWith(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OpenFilesList extends StatelessWidget {
  const _OpenFilesList({required this.state});

  final PatientFilesState state;

  @override
  Widget build(BuildContext context) {
    final files = state.visibleOpenFiles;
    final now = DateTime.now();
    return _TabBody(
      status: state.openStatus,
      errorMessage: state.openMessage,
      isSearching: state.isOpenSearching,
      isEmpty: files.isEmpty,
      emptyMessage: state.query.isEmpty && state.statusFilter == null
          ? "لا توجد ملفات مفتوحة حالياً"
          : "لا توجد نتائج",
      itemCount: files.length,
      itemBuilder: (context, index) => OpenPatientFileCard(
        file: files[index],
        now: now,
        onOpenFile: () => PatientMedicalFileLauncher.open(
          context,
          bookingId: files[index].bookingId,
        ),
      ),
    );
  }
}

class _PreviousPatientsList extends StatelessWidget {
  const _PreviousPatientsList({required this.state});

  final PatientFilesState state;

  @override
  Widget build(BuildContext context) {
    final patients = state.visiblePreviousPatients;
    return _TabBody(
      status: state.previousStatus,
      errorMessage: state.previousMessage,
      isSearching: state.isPreviousSearching,
      isEmpty: patients.isEmpty,
      emptyMessage: state.query.isEmpty && state.typeFilter == null
          ? "لا يوجد مرضى سابقون"
          : "لا توجد نتائج",
      itemCount: patients.length,
      itemBuilder: (context, index) => PreviousPatientCard(
        patient: patients[index],
        onOpenPrescriptions: () => Navigator.of(context).pushNamed(
          Routes.doctorPreviousPrescriptionsView,
          arguments:
              PreviousPrescriptionsArgs.patient(patients[index].patientId),
        ),
      ),
    );
  }
}

/// Loading / error / empty / list for one tab, with pull to refresh.
class _TabBody extends StatelessWidget {
  const _TabBody({
    required this.status,
    required this.errorMessage,
    required this.isSearching,
    required this.isEmpty,
    required this.emptyMessage,
    required this.itemCount,
    required this.itemBuilder,
  });

  final RequestStatus status;
  final String? errorMessage;

  /// A search is loading over the list on screen.
  final bool isSearching;
  final bool isEmpty;
  final String emptyMessage;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PatientFilesCubit>();
    if (status == RequestStatus.failure) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                errorMessage ?? "تعذر تحميل ملفات المرضى",
                textAlign: TextAlign.center,
                style: AppTextStyles.font16BlackSemiBold.copyWith(color: _navy),
              ),
              verticalSpacing(8),
              TextButton(
                onPressed: cubit.retry,
                child: const Text("إعادة المحاولة"),
              ),
            ],
          ),
        ),
      );
    }
    if (status != RequestStatus.success) {
      return const Center(child: CircularProgressIndicator());
    }
    final list = RefreshIndicator(
      onRefresh: cubit.refresh,
      child: isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 80.h),
                  child: Text(
                    emptyMessage,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font16BlackSemiBold.copyWith(
                      color: AppColorsManager.prescriptionSubtitleColor,
                    ),
                  ),
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
              itemCount: itemCount,
              separatorBuilder: (_, __) => verticalSpacing(12),
              itemBuilder: itemBuilder,
            ),
    );
    return Stack(
      children: [
        list,
        if (isSearching)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(minHeight: 2),
          ),
      ],
    );
  }
}
