import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/models/video_model.dart';
import 'package:we_care/features/home_tab/models/message_notification_model.dart';

class HomeState extends Equatable {
  final List<CrausalMessageModel> notifications;
  final List<VideoModel> videos;
  final RequestStatus requestStatus;
  final RequestStatus videoRequestStatus;
  final String? errorMessage;

  const HomeState({
    required this.notifications,
    required this.videos,
    required this.requestStatus,
    required this.videoRequestStatus,
    this.errorMessage,
  });

  factory HomeState.initial() {
    return const HomeState(
      notifications: [],
      videos: [],
      requestStatus: RequestStatus.initial,
      videoRequestStatus: RequestStatus.initial,
      errorMessage: null,
    );
  }

  HomeState copyWith({
    List<CrausalMessageModel>? notifications,
    List<VideoModel>? videos,
    RequestStatus? requestStatus,
    RequestStatus? videoRequestStatus,
    String? errorMessage,
  }) {
    return HomeState(
      notifications: notifications ?? this.notifications,
      videos: videos ?? this.videos,
      requestStatus: requestStatus ?? this.requestStatus,
      videoRequestStatus: videoRequestStatus ?? this.videoRequestStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [notifications, videos, requestStatus, videoRequestStatus, errorMessage];
}
