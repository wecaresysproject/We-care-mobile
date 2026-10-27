import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:we_care/features/online_doctor/data/models/call_participant_role.dart';
import 'package:we_care/features/online_doctor/data/models/video_meeting_model.dart';
import 'package:we_care/features/online_doctor/video_call_logger.dart';

/// حدث من غرفة Jitsi — الاسم زى ما Jitsi IFrame API بيبعته
/// (`videoConferenceJoined`، `participantJoined`، ...) وبياناته.
typedef JitsiEventCallback = void Function(
  String name,
  Map<String, dynamic> data,
);

/// أندرويد لازم ياخد إذن الكاميرا والميكروفون قبل ما الـ WebView يطلبهم؛
/// iOS بيعرض طلب النظام لوحده أول ما الصفحة تطلبهم.
Future<bool> requestCallMediaPermissions() async {
  if (!Platform.isAndroid) return true;
  final statuses = await [Permission.camera, Permission.microphone].request();
  VideoCallLogger.info(
    'permissions → camera=${statuses[Permission.camera]?.name} '
    'microphone=${statuses[Permission.microphone]?.name}',
  );
  return statuses.values.every((status) => status.isGranted);
}

/// بيتحكم فى غرفة Jitsi المعروضة فى [JitsiMeetingView] — مشترك بين شاشة
/// مكالمة المريض وشاشة مكالمة الطبيب.
class JitsiMeetingController {
  InAppWebViewController? _webViewController;

  /// أمر من أوامر Jitsi IFrame API — `toggleAudio`، `toggleVideo`، `hangup`.
  void runCommand(String command) {
    VideoCallLogger.info('command → $command');
    _webViewController?.evaluateJavascript(
      source: "jitsiCommand(${jsonEncode(command)})",
    );
  }

  /// عدد اللى فى الغرفة زى ما Jitsi شايفه — المستخدم نفسه محسوب ضمنهم.
  Future<int> participantsCount() async {
    final count = await _webViewController?.evaluateJavascript(
      source: "api ? api.getNumberOfParticipants() : 0",
    );
    final participants = count is num ? count.toInt() : 0;
    VideoCallLogger.info('participants in room → $participants');
    return participants;
  }

  /// أدوار كل اللى فى الغرفة (المستخدم نفسه ضمنهم) من أسمائهم جوه Jitsi —
  /// `null` لو سيرفر Jitsi مش بيدعم `getParticipantsInfo`.
  Future<List<CallParticipantRole?>?> participantRoles() async {
    final result = await _webViewController?.evaluateJavascript(
      source: "(function(){try{return JSON.stringify(api.getParticipantsInfo());}"
          "catch(e){return null;}})()",
    );
    if (result is! String) return null;
    try {
      final participants = jsonDecode(result);
      if (participants is! List) return null;
      final roles = [
        for (final participant in participants)
          CallParticipantRole.ofDisplayName(
            participant is Map ? '${participant['displayName'] ?? ''}' : '',
          ),
      ];
      VideoCallLogger.info('participant roles → $roles');
      return roles;
    } catch (_) {
      return null;
    }
  }

  /// فيه حد بالدور [role] فى الغرفة — ولو أدوار الغرفة مش متاحة بيرجع
  /// لعدد اللى فى الغرفة (أكتر من واحد).
  Future<bool> hasParticipantWithRole(CallParticipantRole role) async {
    final roles = await participantRoles();
    if (roles == null) return await participantsCount() > 1;
    return roles.contains(role);
  }
}

/// غرفة Jitsi جوه WebView — بتحمّل IFrame API من سيرفر الاجتماع، بتخفى
/// toolbar بتاع Jitsi، وبتبعت أحداث الغرفة على [onEvent].
class JitsiMeetingView extends StatelessWidget {
  const JitsiMeetingView({
    super.key,
    required this.meeting,
    required this.controller,
    required this.onEvent,
    required this.displayName,
  });

  final VideoMeetingModel meeting;
  final JitsiMeetingController controller;
  final JitsiEventCallback onEvent;

  /// الاسم اللى بيظهر للطرف التانى جوه Jitsi — من غيره أى حد بيظهر باسم
  /// Jitsi الافتراضى "Fellow Jitster" فمنقدرش نميّز مين اللى فى الغرفة.
  final String displayName;

  /// اسم الـ handler اللى صفحة Jitsi بتبعت عليه أحداثها لـ Flutter.
  static const String _eventHandler = 'jitsiEvent';

  String get _meetingHtml {
    final domain = jsonEncode(meeting.domain);
    final room = jsonEncode(meeting.room);
    final name = jsonEncode(displayName);
    return '''
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<style>html,body,#meet{margin:0;padding:0;width:100%;height:100%;background:#2B2F33;overflow:hidden}</style>
</head>
<body>
<div id="meet"></div>
<script src="https://${meeting.domain}/external_api.js"></script>
<script>
var api = null;
var started = false;
function send(name, data) {
  window.flutter_inappwebview.callHandler('$_eventHandler', name, JSON.stringify(data || {}));
}
function jitsiCommand(command) {
  if (api) api.executeCommand(command);
}
function start() {
  if (started) return;
  started = true;
  if (typeof JitsiMeetExternalAPI === 'undefined') {
    send('externalApiLoadFailed');
    return;
  }
  api = new JitsiMeetExternalAPI($domain, {
    roomName: $room,
    parentNode: document.getElementById('meet'),
    width: '100%',
    height: '100%',
    userInfo: { displayName: $name },
    configOverwrite: {
      prejoinConfig: { enabled: false },
      disableDeepLinking: true,
      toolbarButtons: [],
      disableInviteFunctions: true,
      hideConferenceSubject: true,
      hideConferenceTimer: true
    },
    interfaceConfigOverwrite: {
      MOBILE_APP_PROMO: false,
      SHOW_JITSI_WATERMARK: false
    }
  });
  [
    'videoConferenceJoined', 'videoConferenceLeft', 'participantJoined',
    'participantLeft', 'audioMuteStatusChanged', 'videoMuteStatusChanged',
    'cameraError', 'micError', 'errorOccurred', 'readyToClose'
  ].forEach(function (name) {
    api.addListener(name, function (data) { send(name, data); });
  });
  send('apiCreated');
}
if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) {
  start();
} else {
  window.addEventListener('flutterInAppWebViewPlatformReady', start);
}
</script>
</body>
</html>
''';
  }

  void _onWebViewCreated(InAppWebViewController webViewController) {
    controller._webViewController = webViewController;
    VideoCallLogger.info(
      'webview created → domain=${meeting.domain} room=${meeting.room}',
    );
    webViewController.addJavaScriptHandler(
      handlerName: _eventHandler,
      callback: (arguments) {
        final name = arguments.isNotEmpty ? arguments.first.toString() : '';
        final payload = arguments.length > 1 ? arguments[1].toString() : '{}';
        VideoCallLogger.info('jitsi event → $name $payload');
        if (name == 'externalApiLoadFailed') {
          VideoCallLogger.error('external_api.js متحمّلش من سيرفر Jitsi');
        }

        Map<String, dynamic> data = const {};
        try {
          final decoded = jsonDecode(payload);
          if (decoded is Map<String, dynamic>) data = decoded;
        } catch (_) {
          VideoCallLogger.warning('jitsi event payload غير مفهوم → $payload');
        }
        onEvent(name, data);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialData: InAppWebViewInitialData(
        data: _meetingHtml,
        // نفس origin سيرفر Jitsi — الكاميرا والميكروفون محتاجين HTTPS.
        baseUrl: WebUri("https://${meeting.domain}/"),
      ),
      initialSettings: InAppWebViewSettings(
        mediaPlaybackRequiresUserGesture: false,
        allowsInlineMediaPlayback: true,
        iframeAllow: "camera; microphone; autoplay",
        iframeAllowFullscreen: true,
        transparentBackground: true,
      ),
      onWebViewCreated: _onWebViewCreated,
      onLoadStop: (webViewController, url) =>
          VideoCallLogger.info('webview loaded → $url'),
      onPermissionRequest: (webViewController, request) async {
        VideoCallLogger.info(
          'webview permission request → ${request.resources}',
        );
        return PermissionResponse(
          resources: request.resources,
          action: PermissionResponseAction.GRANT,
        );
      },
      onReceivedError: (webViewController, request, error) =>
          VideoCallLogger.error(
        'webview error → ${request.url} ${error.type} ${error.description}',
      ),
      onReceivedHttpError: (webViewController, request, response) =>
          VideoCallLogger.error(
        'webview http error → ${request.url} status=${response.statusCode}',
      ),
      onConsoleMessage: (webViewController, message) {
        if (message.messageLevel == ConsoleMessageLevel.ERROR) {
          VideoCallLogger.error('webview console → ${message.message}');
        }
      },
    );
  }
}
