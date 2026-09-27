import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/bookings/data/models/appointment_time_status.dart';
import 'package:we_care/features/doctor/bookings/data/models/appointment_type.dart';
import 'package:we_care/features/doctor/bookings/data/models/bookings_model.dart';
import 'package:we_care/features/doctor/bookings/data/models/today_appointment_model.dart';
import 'package:we_care/features/doctor/bookings/data/models/waiting_patient_model.dart';

/// No online-session/bookings endpoint exists yet — returns fixed mock data
/// so the UI/Cubit layers are ready to swap in a real service once the
/// backend contract is confirmed.
class BookingsRepo {
  Future<ApiResult<BookingsModel>> getBookings() async {
    return ApiResult.success(
      BookingsModel(
        doctorName: 'د/ أحمد محمود مصطفى',
        specialty: 'أنف وأذن وحنجرة',
        doctorPhotoUrl: 'assets/images/doctor_photo.png',
        todayAppointments: [
          TodayAppointmentModel(
            id: 't1',
            patientName: 'أحمد محمد علي',
            patientPhotoUrl: null,
            bookingTimeLabel: '09:00 ص',
            type: AppointmentType.examination,
            timeStatus: AppointmentTimeStatus.due,
            statusMinutes: null,
          ),
          TodayAppointmentModel(
            id: 't2',
            patientName: 'سارة علي حسن',
            patientPhotoUrl: null,
            bookingTimeLabel: '09:30 ص',
            type: AppointmentType.examination,
            timeStatus: AppointmentTimeStatus.remaining,
            statusMinutes: 15,
          ),
          TodayAppointmentModel(
            id: 't3',
            patientName: 'محمد حسن إبراهيم',
            patientPhotoUrl: null,
            bookingTimeLabel: '10:00 ص',
            type: AppointmentType.consultation,
            timeStatus: AppointmentTimeStatus.late_,
            statusMinutes: 12,
          ),
          TodayAppointmentModel(
            id: 't4',
            patientName: 'منى جمال عبد الله',
            patientPhotoUrl: null,
            bookingTimeLabel: '10:30 ص',
            type: AppointmentType.examination,
            timeStatus: AppointmentTimeStatus.remaining,
            statusMinutes: 30,
          ),
          TodayAppointmentModel(
            id: 't5',
            patientName: 'خالد وليد الشامي',
            patientPhotoUrl: null,
            bookingTimeLabel: '11:00 ص',
            type: AppointmentType.consultation,
            timeStatus: AppointmentTimeStatus.late_,
            statusMinutes: 25,
          ),
        ],
        waitingPatients: [
          WaitingPatientModel(
            id: 'w1',
            patientName: 'ليلى محمود يوسف',
            patientPhotoUrl: null,
            joinRequestTimeLabel: '08:15 ص',
            type: AppointmentType.examination,
            waitingMinutes: 45,
          ),
          WaitingPatientModel(
            id: 'w2',
            patientName: 'يوسف طارق السعيد',
            patientPhotoUrl: null,
            joinRequestTimeLabel: '08:30 ص',
            type: AppointmentType.consultation,
            waitingMinutes: 30,
          ),
          WaitingPatientModel(
            id: 'w3',
            patientName: 'هبة محمد فؤاد',
            patientPhotoUrl: null,
            joinRequestTimeLabel: '09:15 ص',
            type: AppointmentType.examination,
            waitingMinutes: 15,
          ),
        ],
      ),
    );
  }
}
