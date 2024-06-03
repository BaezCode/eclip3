import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:bloc/bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/global/enviroments.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:eclips_3/config/agora.config.dart' as config;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'video_call_event.dart';
part 'video_call_state.dart';

class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  late AgoraClient? agoraClient;
  String channelId = '';
  String callToken = '';
  int uidCall = 1;
  String nombre = '';
  String de = '';
  Set<int> remoteUid = {};
  Timer? timer;
  Timer? ampTimer;
  int recordDuration = 0;

  VideoCallBloc() : super(VideoCallState()) {
    on<SetIsJoinded>((event, emit) {
      emit(state.copyWith(isJoined: event.isJoined));
    });
    on<SetSwitchCamera>((event, emit) {
      emit(state.copyWith(switchCamera: event.switchCamera));
    });
    on<SetVideo>((event, emit) {
      emit(state.copyWith(video: event.video));
    });
    on<SetloadingCall>((event, emit) {
      emit(state.copyWith(loading: event.loading));
    });
    on<SetEnableBackround>((event, emit) {
      emit(state.copyWith(
          isEnabledVirtualBackgroundImage:
              event.isEnabledVirtualBackgroundImage));
    });
    on<SetMicroPhoneStatus>((event, emit) {
      emit(state.copyWith(microphone: event.microphone));
    });
    on<SetContactUID>((event, emit) {
      emit(state.copyWith(contactUID: event.contactUID));
    });
    on<SetRecordDuration>((event, emit) {
      emit(state.copyWith(recordDuration: event.recordDuration));
    });
  }
  Future<void> enableVirtualBackground(bool enable) async {
    ByteData data = await rootBundle.load("images/fondo.jpg");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String p = path.join(appDocDir.path, 'fondo.jpg');
    final file = File(p);
    if (!(await file.exists())) {
      await file.create();
      await file.writeAsBytes(bytes);
    }
    await agoraClient!.engine.enableVirtualBackground(
        enabled: !enable,
        backgroundSource: VirtualBackgroundSource(
            backgroundSourceType: BackgroundSourceType.backgroundImg,
            source: p),
        segproperty:
            const SegmentationProperty(modelType: SegModelType.segModelAi));
    add(SetEnableBackround(!enable));
  }

  Future<void> initEngine() async {
    // ignore: prefer_const_constructors
    try {
      // ignore: prefer_const_constructors
      agoraClient = AgoraClient(
        agoraEventHandlers: AgoraRtcEventHandlers(
          onUserJoined: (connection, remoteUid, elapsed) {
            add(SetContactUID(remoteUid));
            stopTimer();
          },
          onUserOffline: (connection, remoteUid, reason) {},
          onJoinChannelSuccess: (connection, elapsed) {
            add(SetIsJoinded(true));
            enableVirtualBackground(false);
          },
          onLeaveChannel: (connection, stats) {
            add(SetIsJoinded(false));
          },
        ),
        agoraConnectionData: AgoraConnectionData(
          tempToken: callToken,
          appId: config.appIDVideo,
          channelName: channelId,
          username: "user",
        ),
      );
    } catch (e) {
      return;
    }
    _addListeners();
  }

  _addListeners() {
    agoraClient!.engine.registerEventHandler(RtcEngineEventHandler(
      onUserJoined: (connection, remoteUid, elapsed) {
        add(SetContactUID(remoteUid));
      },
      onUserOffline: (connection, remoteUid, reason) {},
      onJoinChannelSuccess: (connection, elapsed) {
        add(SetIsJoinded(true));
      },
      onLeaveChannel: (connection, stats) {
        add(SetIsJoinded(false));
      },
    ));
  }

  Future<void> switchCamera(bool switchCamera) async {
    await agoraClient!.engine.switchCamera();
    add(SetSwitchCamera(!switchCamera));
  }

  Future<void> dispose() async {
    timer?.cancel();
    ampTimer?.cancel();
    recordDuration = 0;
    add(SetRecordDuration(0));
    add(SetIsJoinded(false));
  }

  Future<bool> getTokenCall(String token, String nombre, String tokenVOIP,
      String de, String para, bool video) async {
    try {
      final uri = Uri.parse("${Environment.apiUrl}/conversaciones/token/test");
      final data = {
        "tokenVOIP": tokenVOIP,
        "nombre": nombre,
        'tokepPush': token,
        'de': de,
        'para': para,
        'video': video
      };
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken(),
      });
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        callToken = data['token'];
        channelId = data['channelId'];
        initEngine();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void stopTimer() {
    timer?.cancel();
    ampTimer?.cancel();
    recordDuration = 0;
    add(SetRecordDuration(0));
  }

  void startTimer() {
    try {
      timer?.cancel();
      ampTimer?.cancel();
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        add(SetRecordDuration(recordDuration++));
      });

      ampTimer =
          Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {});
    } catch (e) {
      return;
    }
  }
}
