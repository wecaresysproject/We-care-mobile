import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we_care/core/networking/api_error_model.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/video_call/data/repos/video_call_repo.dart';
import 'package:we_care/features/doctor/video_call/logic/cubit/doctor_video_call_cubit.dart';
import 'package:we_care/features/doctor/video_call/presentation/views/video_call_view.dart';
import 'package:we_care/features/online_doctor/data/models/video_meeting_model.dart';
import 'package:we_care/generated/l10n.dart';

/// Fails every request, so the screen settles on its retry notice without
/// opening the Jitsi WebView.
class _FailingVideoCallRepo implements VideoCallRepo {
  ApiResult<VideoMeetingModel> get _failure =>
      ApiResult.failure(ApiErrorModel(errors: ['no meeting']));

  @override
  Future<ApiResult<VideoMeetingModel>> createMeeting(
    String appointmentId,
  ) async =>
      _failure;

  @override
  Future<ApiResult<VideoMeetingModel>> startMeeting(
    String appointmentId,
  ) async =>
      _failure;

  @override
  Future<ApiResult<VideoMeetingModel>> endMeeting(
    String appointmentId,
  ) async =>
      _failure;
}

void main() {
  testWidgets('video call view lays out without overflow', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, __) => MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: BlocProvider<DoctorVideoCallCubit>(
            create: (_) => DoctorVideoCallCubit(_FailingVideoCallRepo())
              ..openMeeting('booking-1'),
            child: const VideoCallView(appointmentId: 'booking-1'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('00:00'), findsOneWidget);
    expect(find.text('no meeting'), findsOneWidget);
  });
}
