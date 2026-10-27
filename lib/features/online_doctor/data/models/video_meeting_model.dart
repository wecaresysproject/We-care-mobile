import 'package:we_care/features/online_doctor/data/models/call_participant_role.dart';

/// اجتماع الفيديو المرتبط بموعد واحد — الغرفة ورابطها بيتولدوا فى الـ Backend.
class VideoMeetingModel {
  const VideoMeetingModel({
    required this.appointmentId,
    required this.roomName,
    required this.meetingUrl,
    required this.status,
    this.startedAt,
    this.endedAt,
    this.displayName = '',
    this.role,
  });

  factory VideoMeetingModel.fromJson(Map<String, dynamic> json) {
    return VideoMeetingModel(
      appointmentId: json['appointmentId']?.toString() ?? '',
      roomName: json['roomName'] as String? ?? '',
      meetingUrl: json['meetingUrl'] as String? ?? '',
      status: VideoMeetingStatus.fromApi(json['status'] as String?),
      startedAt: DateTime.tryParse(json['startedAt'] as String? ?? ''),
      endedAt: DateTime.tryParse(json['endedAt'] as String? ?? ''),
      displayName: json['displayName'] as String? ?? '',
      role: CallParticipantRole.fromApi(json['role'] as String?),
    );
  }

  final String appointmentId;
  final String roomName;

  /// `https://<jitsi-domain>/<roomName>` — الدومين بييجى من إعدادات الـ Backend.
  final String meetingUrl;
  final VideoMeetingStatus status;
  final DateTime? startedAt;
  final DateTime? endedAt;

  /// الاسم الحقيقى للى طالب الاجتماع — فاضى لو الـ Backend مرجّعهوش.
  final String displayName;

  /// دور اللى طالب الاجتماع — `null` لو الـ Backend مرجّعهوش.
  final CallParticipantRole? role;

  /// دومين سيرفر Jitsi (بالـ port لو موجود) — فاضى لو الرابط مش صالح.
  String get domain => Uri.tryParse(meetingUrl)?.authority ?? '';

  /// اسم الغرفة — من `roomName`، ولو فاضى من آخر جزء فى الرابط.
  String get room {
    if (roomName.isNotEmpty) return roomName;
    final segments = Uri.tryParse(meetingUrl)?.pathSegments ?? const [];
    return segments.isEmpty ? '' : segments.last;
  }

  bool get isJoinable => domain.isNotEmpty && room.isNotEmpty;
}

enum VideoMeetingStatus {
  /// الطبيب أنشأ الاجتماع ولسه مبدأش.
  created,
  started,
  ended;

  /// أى قيمة غير معروفة بتتعامل كـ [created] — المريض بيفضل مستنى الطبيب.
  static VideoMeetingStatus fromApi(String? value) {
    return VideoMeetingStatus.values.firstWhere(
      (status) => status.name == value?.toLowerCase(),
      orElse: () => VideoMeetingStatus.created,
    );
  }
}
