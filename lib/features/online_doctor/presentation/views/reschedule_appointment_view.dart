import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/error_view_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/data/models/appointment_slot_model.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';
import 'package:we_care/features/online_doctor/logic/cubit/reschedule_appointment_cubit.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/appointment_slots_selector.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/booking_section_header.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_specializations_app_bar.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/local_timezone_note.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// شاشة "تعديل الموعد" — بتتفتح من زرار "تعديل الموعد" فى كارت الكشف:
/// الموعد الحالى فوق، وتحته الأيام المتاحة عند نفس الطبيب وتوقيتات كل يوم.
/// لما الـ API يأكد التعديل بترجّع الحجز بميعاده الجديد (`BookingModel`)
/// للشاشة اللى فتحتها.
class RescheduleAppointmentView extends StatelessWidget {
  const RescheduleAppointmentView({super.key, required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RescheduleAppointmentCubit>(
      create: (_) => getIt<RescheduleAppointmentCubit>()
        ..getDoctorAvailability(booking.doctor.id),
      child: _RescheduleAppointmentBody(booking: booking),
    );
  }
}

class _RescheduleAppointmentBody extends StatefulWidget {
  const _RescheduleAppointmentBody({required this.booking});

  final BookingModel booking;

  @override
  State<_RescheduleAppointmentBody> createState() =>
      _RescheduleAppointmentBodyState();
}

class _RescheduleAppointmentBodyState
    extends State<_RescheduleAppointmentBody> {
  RescheduleAppointmentCubit get _cubit =>
      context.read<RescheduleAppointmentCubit>();

  List<AppointmentDayModel> get _availableDays => _cubit.state.availableDays;

  /// أول يوم (الأقرب) مختار افتراضيًا عشان توقيتاته تبان على طول.
  int _selectedDayIndex = 0;
  int? _selectedTimeIndex;

  AppointmentTimeSlot? get _selectedSlot {
    final timeIndex = _selectedTimeIndex;
    if (timeIndex == null || _availableDays.isEmpty) return null;
    return _availableDays[_selectedDayIndex].slots[timeIndex];
  }

  void _onDaySelected(int index) {
    if (index == _selectedDayIndex) return;
    setState(() {
      _selectedDayIndex = index;
      // اليوم اتغير — التوقيت المختار قبل كده بقى ملوش معنى.
      _selectedTimeIndex = null;
    });
  }

  void _confirmReschedule() {
    final selectedSlot = _selectedSlot;
    if (selectedSlot == null) return;
    _cubit.rescheduleBooking(
      booking: widget.booking,
      day: _availableDays[_selectedDayIndex],
      slot: selectedSlot,
    );
  }

  void _refreshAvailability() {
    // قايمة المواعيد هتتغير — الاختيار القديم ممكن ميبقاش موجود.
    setState(() {
      _selectedDayIndex = 0;
      _selectedTimeIndex = null;
    });
    _cubit.getDoctorAvailability(widget.booking.doctor.id);
  }

  void _onRescheduleStatusChanged(
    BuildContext context,
    RescheduleAppointmentState state,
  ) {
    if (state.rescheduleStatus == RequestStatus.success) {
      context.pop(result: state.updatedBooking);
    } else if (state.rescheduleStatus == RequestStatus.failure) {
      // الميعاد غالبًا اتحجز — بنعرض رسالة السيرفر ونحمّل المتاح من جديد.
      showError(state.rescheduleMessage);
      _refreshAvailability();
    }
  }

  Widget _buildSlots(RescheduleAppointmentState state) {
    if (state.availabilityStatus == RequestStatus.failure) {
      return ErrorViewWidget(
        errorMessage: state.errorMessage,
        onRetry: _refreshAvailability,
      );
    }
    if (state.availabilityStatus != RequestStatus.success) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Center(
          child:
              CircularProgressIndicator(color: AppColorsManager.mainDarkBlue),
        ),
      );
    }
    if (_availableDays.isEmpty) return const _NoAvailableSlotsNote();

    return AppointmentSlotsSelector(
      days: _availableDays,
      selectedDayIndex: _selectedDayIndex,
      selectedTimeIndex: _selectedTimeIndex,
      onDaySelected: _onDaySelected,
      onTimeSelected: (index) => setState(() => _selectedTimeIndex = index),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RescheduleAppointmentCubit>().state;
    final selectedSlot = _selectedSlot;

    return BlocListener<RescheduleAppointmentCubit, RescheduleAppointmentState>(
      listenWhen: (previous, current) =>
          previous.rescheduleStatus != current.rescheduleStatus,
      listener: _onRescheduleStatusChanged,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                child: const DoctorSpecializationsAppBar(title: "تعديل الموعد"),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _CurrentAppointmentCard(booking: widget.booking),
                      verticalSpacing(24),
                      const BookingSectionHeader(
                        title: "اختر الموعد الجديد",
                        iconAsset:
                            "assets/svgs/booking_appointment_file_icon.svg",
                        titleWeight: FontWeightHelper.medium,
                        topPadding: 6,
                      ),
                      verticalSpacing(16),
                      _buildSlots(state),
                      verticalSpacing(20),
                      const LocalTimezoneNote(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selectedSlot != null) ...[
                      _NewAppointmentSummary(
                          newDateTime: selectedSlot.startsAt),
                      verticalSpacing(10),
                    ],
                    AppCustomButton(
                      title: "تأكيد تعديل الموعد",
                      textFontSize: 16,
                      isLoading:
                          state.rescheduleStatus == RequestStatus.loading,
                      isEnabled: selectedSlot != null,
                      onPressed: _confirmReschedule,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// كارت "الموعد الحالي" — اسم الطبيب وتخصصه وتاريخ ووقت الموعد قبل التعديل.
class _CurrentAppointmentCard extends StatelessWidget {
  const _CurrentAppointmentCard({required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: OnlineDoctorTheme.cardSurface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: OnlineDoctorTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "الموعد الحالي",
            style: AppTextStyles.font12blackWeight400.copyWith(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
              color: OnlineDoctorTheme.mutedText,
            ),
          ),
          verticalSpacing(6),
          Text(
            booking.doctor.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font16BlackSemiBold.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: OnlineDoctorTheme.headingColor,
            ),
          ),
          verticalSpacing(2),
          Text(
            booking.doctor.specialization,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font14blackWeight400.copyWith(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
              color: OnlineDoctorTheme.accentBlue,
            ),
          ),
          verticalSpacing(10),
          Container(height: 1, color: OnlineDoctorTheme.cardBorder),
          verticalSpacing(10),
          Row(
            children: [
              Expanded(
                child: _AppointmentInfoItem(
                  icon: Icons.calendar_month_rounded,
                  label: booking.dateLabel,
                ),
              ),
              horizontalSpacing(8),
              _AppointmentInfoItem(
                icon: Icons.access_time_rounded,
                label: booking.timeLabel,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppointmentInfoItem extends StatelessWidget {
  const _AppointmentInfoItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15.sp, color: AppColorsManager.mainDarkBlue),
        horizontalSpacing(5),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font12blackWeight400.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: OnlineDoctorTheme.headingColor,
            ),
          ),
        ),
      ],
    );
  }
}

/// سطر "الموعد الجديد" فوق زرار التأكيد — بيظهر بعد اختيار توقيت
/// عشان المستخدم يراجع الميعاد قبل ما يأكد.
class _NewAppointmentSummary extends StatelessWidget {
  const _NewAppointmentSummary({required this.newDateTime});

  final DateTime newDateTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: OnlineDoctorTheme.consultationSurface,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available_rounded,
            size: 15.sp,
            color: OnlineDoctorTheme.consultationGreen,
          ),
          horizontalSpacing(6),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "الموعد الجديد: ${arabicDateLabel(newDateTime)} - "
                "${arabicTimeLabel(newDateTime)}",
                maxLines: 1,
                style: AppTextStyles.font12blackWeight400.copyWith(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w700,
                  color: OnlineDoctorTheme.headingColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// بتظهر لو الطبيب معندوش أى مواعيد متاحة حاليًا.
class _NoAvailableSlotsNote extends StatelessWidget {
  const _NoAvailableSlotsNote();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Text(
        "لا توجد مواعيد متاحة لدى الطبيب حالياً",
        textAlign: TextAlign.center,
        style: AppTextStyles.font14blackWeight400.copyWith(
          color: AppColorsManager.placeHolderColor,
        ),
      ),
    );
  }
}
