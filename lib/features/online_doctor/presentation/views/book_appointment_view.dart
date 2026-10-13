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
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/models/medical_module_enum.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/online_doctor/data/models/book_appointment_dummy_data.dart';
import 'package:we_care/features/online_doctor/data/models/book_appointment_request.dart';
import 'package:we_care/features/online_doctor/data/models/booking_payment_method.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_model.dart';
import 'package:we_care/features/online_doctor/logic/cubit/book_appointment_cubit.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/appointment_slots_selector.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/booking_section_header.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/checkout_payment_dialogs.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/data_access_duration_selector.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/data_access_modules_grid.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_specializations_app_bar.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/payment_methods_selector.dart';

/// شاشة "حجز موعد" — بتظهر بعد الضغط على زرار الحجز فى ملف الطبيب.
class BookAppointmentView extends StatelessWidget {
  const BookAppointmentView({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookAppointmentCubit>(
      create: (_) =>
          getIt<BookAppointmentCubit>()..getDoctorAvailability(doctor.id),
      child: _BookAppointmentBody(doctor: doctor),
    );
  }
}

class _BookAppointmentBody extends StatefulWidget {
  const _BookAppointmentBody({required this.doctor});

  final DoctorModel doctor;

  @override
  State<_BookAppointmentBody> createState() => _BookAppointmentBodyState();
}

class _BookAppointmentBodyState extends State<_BookAppointmentBody> {
  /// أول يوم (الأقرب) مختار افتراضيًا عشان توقيتاته تبان على طول.
  int _selectedDayIndex = 0;
  int? _selectedTimeIndex;
  BookingPaymentMethod? _selectedPaymentMethod;
  int? _selectedDurationIndex;
  final Set<MedicalModule> _selectedModules = {};

  bool get _canSubmitPayment =>
      _selectedTimeIndex != null && _selectedPaymentMethod != null;

  BookAppointmentCubit get _cubit => context.read<BookAppointmentCubit>();

  Future<void> _completePayment() async {
    final day = _cubit.state.availableDays[_selectedDayIndex];
    final durationIndex = _selectedDurationIndex;
    final request = BookAppointmentRequest(
      doctor: widget.doctor,
      day: day,
      slot: day.slots[_selectedTimeIndex!],
      paymentMethod: _selectedPaymentMethod!,
      dataAccessDurationHours: durationIndex == null
          ? null
          : dataAccessDurationsInHours[durationIndex],
      dataAccessModules: _selectedModules.toList(),
    );

    if (request.paymentMethod == BookingPaymentMethod.bankCard) {
      // شاشة الدفع بترجّع `true` لو الحجز فشل — الميعاد غالبًا اتحجز،
      // فبنحمّل المواعيد المتاحة من جديد.
      final bookingFailed =
          await context.pushNamed(Routes.checkoutView, arguments: request);
      if (bookingFailed == true && mounted) _refreshAvailability();
      return;
    }
    //! المحفظة الإلكترونية لسه ملهاش شاشة دفع — الحجز بيتأكد على طول.
    _cubit.bookAppointment(request);
  }

  void _refreshAvailability() {
    // قايمة المواعيد هتتغير — الاختيار القديم ممكن ميبقاش موجود.
    setState(() {
      _selectedDayIndex = 0;
      _selectedTimeIndex = null;
    });
    _cubit.getDoctorAvailability(widget.doctor.id);
  }

  /// بيرجع لشاشة "طبيبك أون لاين" وبيفتح "حجوزاتى" — شاشات الحجز خلص دورها.
  void _goToMyBookings() {
    context.pushNamedAndRemoveUntil(
      Routes.myBookingsView,
      predicate: (route) =>
          route.settings.name == Routes.onlineDoctorView || route.isFirst,
    );
  }

  void _onBookingStatusChanged(
    BuildContext context,
    BookAppointmentState state,
  ) {
    if (state.bookingStatus == RequestStatus.success) {
      showCheckoutSuccessDialog(context, onGoToBookings: _goToMyBookings);
    } else if (state.bookingStatus == RequestStatus.failure) {
      showError(state.bookingMessage);
      _refreshAvailability();
    }
  }

  void _onDaySelected(int index) {
    if (index == _selectedDayIndex) return;
    setState(() {
      _selectedDayIndex = index;
      // اليوم اتغير — التوقيت المختار قبل كده بقى ملوش معنى.
      _selectedTimeIndex = null;
    });
  }

  void _toggleModule(MedicalModule module) {
    setState(() {
      if (!_selectedModules.remove(module)) _selectedModules.add(module);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookAppointmentCubit, BookAppointmentState>(
      listenWhen: (previous, current) =>
          previous.bookingStatus != current.bookingStatus,
      listener: _onBookingStatusChanged,
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                  child: const DoctorSpecializationsAppBar(title: "حجز موعد"),
                ),
                Expanded(child: _buildContent(state)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BookAppointmentState state) {
    final availableDays = state.availableDays;

    if (state.availabilityStatus == RequestStatus.failure) {
      return ErrorViewWidget(
        errorMessage: state.errorMessage,
        onRetry: _refreshAvailability,
      );
    }
    if (state.availabilityStatus != RequestStatus.success) {
      return Center(
        child: CircularProgressIndicator(color: AppColorsManager.mainDarkBlue),
      );
    }
    if (availableDays.isEmpty) {
      return Center(
        child: Text(
          "لا توجد مواعيد متاحة حالياً",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeightHelper.medium,
            fontFamily: AppStrings.cairoFontFamily,
            color: AppColorsManager.mainDarkBlue,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BookingSectionHeader(
            title: "اختر معاد حجزك",
            iconAsset: "assets/svgs/booking_appointment_file_icon.svg",
            titleWeight: FontWeightHelper.medium,
            topPadding: 6,
          ),
          verticalSpacing(16),
          AppointmentSlotsSelector(
            days: availableDays,
            selectedDayIndex: _selectedDayIndex,
            selectedTimeIndex: _selectedTimeIndex,
            onDaySelected: _onDaySelected,
            onTimeSelected: (index) =>
                setState(() => _selectedTimeIndex = index),
          ),
          verticalSpacing(32),
          const BookingSectionHeader(
            title: "اختر طريقة الدفع",
            iconAsset: "assets/svgs/booking_payment_money_icon.svg",
          ),
          verticalSpacing(16),
          PaymentMethodsSelector(
            selectedMethod: _selectedPaymentMethod,
            onMethodSelected: (method) =>
                setState(() => _selectedPaymentMethod = method),
          ),
          verticalSpacing(32),
          const BookingSectionHeader(
            title: "السماح بالوصول للبيانات",
            iconAsset: "assets/svgs/booking_data_access_icon.svg",
          ),
          verticalSpacing(20),
          DataAccessDurationSelector(
            durations: dataAccessDurations,
            selectedIndex: _selectedDurationIndex,
            onDurationSelected: (index) =>
                setState(() => _selectedDurationIndex = index),
          ),
          verticalSpacing(22),
          DataAccessModulesGrid(
            options: dataAccessModules,
            selectedModules: _selectedModules,
            onModuleToggled: _toggleModule,
          ),
          verticalSpacing(24),
          AppCustomButton(
            title: "إتمام الدفع",
            textFontSize: 16,
            isLoading: state.bookingStatus == RequestStatus.loading,
            isEnabled: _canSubmitPayment,
            onPressed: _completePayment,
          ),
        ],
      ),
    );
  }
}
