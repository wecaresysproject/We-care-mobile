import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/models/medical_module_enum.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/online_doctor/data/models/book_appointment_dummy_data.dart';
import 'package:we_care/features/online_doctor/data/models/booking_payment_method.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_model.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/appointment_slots_selector.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/booking_section_header.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/data_access_duration_selector.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/data_access_modules_grid.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_specializations_app_bar.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/payment_methods_selector.dart';

/// شاشة "حجز موعد" — بتظهر بعد الضغط على زرار الحجز فى ملف الطبيب.
class BookAppointmentView extends StatefulWidget {
  const BookAppointmentView({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  State<BookAppointmentView> createState() => _BookAppointmentViewState();
}

class _BookAppointmentViewState extends State<BookAppointmentView> {
  /// أول يوم (الأقرب) مختار افتراضيًا عشان توقيتاته تبان على طول.
  int _selectedDayIndex = 0;
  int? _selectedTimeIndex;
  BookingPaymentMethod? _selectedPaymentMethod;
  int? _selectedDurationIndex;
  final Set<MedicalModule> _selectedModules = {};

  bool get _canSubmitPayment =>
      _selectedTimeIndex != null && _selectedPaymentMethod != null;

  void _completePayment() {
    if (_selectedPaymentMethod == BookingPaymentMethod.bankCard) {
      context.pushNamed(Routes.checkoutView, arguments: widget.doctor);
      return;
    }
    //! المحفظة الإلكترونية لسه ملهاش شاشة دفع — رسالة مؤقتة لحد ما تجهز.
    final day = availableAppointmentDays[_selectedDayIndex];
    final slot = day.slots[_selectedTimeIndex!];
    showSuccess(
      "تم حجز موعدك مع ${widget.doctor.name} ${day.dayLabel} ${slot.fromTime}",
    );
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
              child: const DoctorSpecializationsAppBar(title: "حجز موعد"),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BookingSectionHeader(
                      title: "اختر معاد حجزك",
                      iconAsset:
                          "assets/svgs/booking_appointment_file_icon.svg",
                      titleWeight: FontWeightHelper.medium,
                      topPadding: 6,
                    ),
                    verticalSpacing(16),
                    AppointmentSlotsSelector(
                      days: availableAppointmentDays,
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
                      isEnabled: _canSubmitPayment,
                      onPressed: _completePayment,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
