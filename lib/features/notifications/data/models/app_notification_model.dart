import 'dart:convert';

import 'package:we_care/features/online_doctor/data/models/booking_model.dart';

/// نوع الرسالة — نفس قيمة `type` فى الرسالة و`pageRoute` فى الـ FCM.
enum AppNotificationType {
  /// المريض ضاف المستخدم لاجتماع كشف.
  meetingParticipantAdded,

  /// الطبيب بدأ الاستشارة — الرسالة فيها زرار الدخول.
  consultationStarted,

  /// نوع جديد التطبيق لسه مايعرفوش — بيتعرض كنص بس.
  unknown;

  static AppNotificationType fromApi(String? value) {
    return AppNotificationType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => AppNotificationType.unknown,
    );
  }
}

/// رسالة واحدة فى صفحة الرسائل — بتتحفظ فى الـ Backend مع كل FCM بيتبعت.
class AppNotificationModel {
  const AppNotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
    this.meeting,
  });

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    // بيانات الاجتماع بترجع على الرسالة نفسها أو جوه `data`، وأى حقل ناقص
    // بيتاخد من `payload` (نفس JSON الـ FCM).
    final nested = json['data'];
    final fields = <String, dynamic>{
      ..._decodePayload(json['payload']),
      ...json,
      if (nested is Map<String, dynamic>) ...nested,
    };
    return AppNotificationModel(
      id: json['id']?.toString() ?? '',
      type: AppNotificationType.fromApi(json['type'] as String?),
      title: json['title'] as String? ?? '',
      body: json['message'] as String? ?? json['body'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '')?.toLocal(),
      isRead: json['isRead'] as bool? ?? false,
      meeting: fields['appointmentId'] == null
          ? null
          : NotificationMeetingData.fromJson(fields),
    );
  }

  static Map<String, dynamic> _decodePayload(Object? payload) {
    if (payload is! String || payload.isEmpty) return const {};
    try {
      final decoded = jsonDecode(payload);
      return decoded is Map<String, dynamic> ? decoded : const {};
    } catch (_) {
      return const {};
    }
  }

  final String id;
  final AppNotificationType type;
  final String title;
  final String body;
  final DateTime? createdAt;
  final bool isRead;

  /// بيانات الاجتماع للرسائل الخاصة بالاستشارات — `null` لغيرها.
  final NotificationMeetingData? meeting;

  /// دعوة لحضور استشارة — بتتعرض بكارت الدعوة وصفحة تفاصيلها.
  bool get isMeetingInvitation =>
      type == AppNotificationType.meetingParticipantAdded && meeting != null;

  /// زرار "دخول الاستشارة" بيظهر لرسالة بدء الاستشارة بس.
  bool get canJoinConsultation =>
      type == AppNotificationType.consultationStarted &&
      (meeting?.appointmentId.isNotEmpty ?? false);

  AppNotificationModel copyWith({bool? isRead}) {
    return AppNotificationModel(
      id: id,
      type: type,
      title: title,
      body: body,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      meeting: meeting,
    );
  }
}

/// تفاصيل الاجتماع اللى الرسالة عنه — المريض صاحب الدعوة والطبيب والموعد.
class NotificationMeetingData {
  const NotificationMeetingData({
    required this.appointmentId,
    required this.patientName,
    required this.doctorName,
    this.startsAt,
    this.bookingType = BookingType.onlineExamination,
    this.patientImage = '',
    this.patientPhone = '',
    this.relation = '',
    this.doctorImage = '',
    this.doctorSpecialty = '',
    this.doctorAcademicTitle = '',
    this.doctorQualification = '',
  });

  factory NotificationMeetingData.fromJson(Map<String, dynamic> json) {
    String text(String key) => json[key]?.toString().trim() ?? '';
    return NotificationMeetingData(
      appointmentId: text('appointmentId'),
      patientName: text('patientName'),
      doctorName: text('doctorName'),
      startsAt: DateTime.tryParse(text('startsAt'))?.toLocal(),
      bookingType: BookingType.fromApi(json['bookingType'] as String?),
      patientImage: text('patientImage'),
      patientPhone: text('patientPhone'),
      relation: text('relation'),
      doctorImage: text('doctorImage'),
      doctorSpecialty: text('doctorSpecialty'),
      doctorAcademicTitle: text('doctorAcademicTitle'),
      doctorQualification: text('doctorQualification'),
    );
  }

  final String appointmentId;
  final String patientName;
  final String doctorName;
  final DateTime? startsAt;
  final BookingType bookingType;

  /// صورة المريض صاحب الدعوة — فاضية لو مفيش.
  final String patientImage;
  final String patientPhone;

  /// صلة قرابة المدعو بالمريض زى ما المريض كتبها وهو بيضيفه.
  final String relation;

  final String doctorImage;

  /// "أمراض القلب والأوعية الدموية".
  final String doctorSpecialty;

  /// "استشاري".
  final String doctorAcademicTitle;

  /// "دكتوراه الطب – أمراض القلب".
  final String doctorQualification;

  /// "د. هالة منصور".
  String get doctorDisplayName =>
      doctorName.startsWith("د.") ? doctorName : "د. $doctorName";

  /// "استشاري أمراض القلب والأوعية الدموية".
  String get doctorTitleLine => [doctorAcademicTitle, doctorSpecialty]
      .where((part) => part.isNotEmpty)
      .join(' ');

  /// "الأحد 16 أغسطس 2026 - 06:00 مساءً" — فاضى لو الموعد مش معروف.
  String get startsAtLabel {
    final date = startsAt;
    if (date == null) return '';
    return "${arabicDateLabel(date)} - ${arabicTimeLabel(date)}";
  }
}

/// صفحة واحدة من الرسائل.
class AppNotificationsPage {
  const AppNotificationsPage({required this.items, required this.hasMore});

  final List<AppNotificationModel> items;

  /// فيه صفحات بعدها لسه متحملتش.
  final bool hasMore;
}
