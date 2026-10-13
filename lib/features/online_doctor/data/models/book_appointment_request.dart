import 'package:we_care/core/models/medical_module_enum.dart';
import 'package:we_care/features/online_doctor/data/models/appointment_slot_model.dart';
import 'package:we_care/features/online_doctor/data/models/booking_payment_method.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_model.dart';

/// اختيارات المريض فى شاشة "حجز موعد" — بتتبعت زى ما هى لـ endpoint الحجز،
/// وبتتنقل لشاشة "الدفع" لو الدفع ببطاقة بنكية.
class BookAppointmentRequest {
  const BookAppointmentRequest({
    required this.doctor,
    required this.day,
    required this.slot,
    required this.paymentMethod,
    this.dataAccessDurationHours,
    this.dataAccessModules = const [],
  });

  final DoctorModel doctor;
  final AppointmentDayModel day;
  final AppointmentTimeSlot slot;
  final BookingPaymentMethod paymentMethod;

  /// قسم "السماح بالوصول للبيانات" اختيارى — `null` لو المريض مختارش مدة.
  final int? dataAccessDurationHours;
  final List<MedicalModule> dataAccessModules;

  Map<String, dynamic> toJson() => {
        "doctorId": doctor.id,
        "date": day.apiDate,
        "startTime": slot.apiStartTime,
        "paymentMethod": paymentMethod.name,
        if (dataAccessDurationHours != null)
          "dataAccessDurationHours": dataAccessDurationHours,
        "dataAccessModules": [
          for (final module in dataAccessModules) module.name,
        ],
      };
}
