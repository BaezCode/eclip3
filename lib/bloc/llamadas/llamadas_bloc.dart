import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:bloc/bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/global/enviroments.dart';
import 'package:eclips_3/models/calls_model.dart';
import 'package:eclips_3/models/calls_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:http/http.dart' as http;
import 'package:eclips_3/config/agora.config.dart' as config;
import 'package:permission_handler/permission_handler.dart';

part 'llamadas_event.dart';
part 'llamadas_state.dart';

class LlamadasBloc extends Bloc<LlamadasEvent, LlamadasState> {
  String channelId = '';
  String callToken = '';
  String nombre = '';
  String de = '';
  RtcEngine? engine;
  Timer? timer;
  Timer? ampTimer;
  int uidCall = 0;
  String isSingle = '';
  int recordDuration = 0;
  bool isCalling = false;
  bool isJoined = false;

  LlamadasBloc() : super(LlamadasState()) {
    on<SetEnllamada>((event, emit) {
      emit(state.copyWith(enLlamada: event.enLlamada));
    });
    on<SetLoadingCalls>((event, emit) {
      emit(state.copyWith(loadingCalls: event.loadingCalls));
    });
    on<SetCallsList>((event, emit) {
      emit(state.copyWith(calls: event.calls));
    });
    on<SetIsJoinded>((event, emit) {
      emit(state.copyWith(isJoined: event.isJoined));
    });
    on<SetMicrophone>((event, emit) {
      emit(state.copyWith(openMicrophone: event.openMicrophone));
    });
    on<SetSpeakerPhone>((event, emit) {
      emit(state.copyWith(enableSpeakerphone: event.enableSpeakerphone));
    });
    on<SetEffect>((event, emit) {
      emit(state.copyWith(playEffect: event.playEffect));
    });
    on<SetRecordDuration>((event, emit) {
      emit(state.copyWith(recordDuration: event.recordDuration));
    });
  }

  Future<void> initEngine() async {
    // ignore: prefer_const_constructors
    try {
      // ignore: prefer_const_constructors
      await engine!.initialize(RtcEngineContext(
        appId: config.appIDVideo,
      ));

      _joinChannel();
      await engine!
          .setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
      await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await engine!.enableAudio();
    } catch (e) {
      return;
    }
    _addListeners();
  }

  _joinChannel() async {
    await Permission.microphone.request();
    await engine!
        .joinChannel(
            channelId: channelId,
            token: callToken,
            options: const ChannelMediaOptions(),
            uid: uidCall)
        .catchError((onError) {
      // ignore: avoid_print
      print('error ${onError.toString()}');
    });
  }

  Future<void> leaveChannel() async {
    try {
      await FlutterCallkitIncoming.endAllCalls();
      await engine!.leaveChannel();
      await engine!.disableAudio();
      // socketBloc.enLlamada = false;
      //    usuariosBloc.add(SetEnLlamada(false));
      timer?.cancel();
      ampTimer?.cancel();
      recordDuration = 0;
      isJoined = false;
      add(SetRecordDuration(0));
      //   Navigator.pop(context);
    } catch (e) {
      return;
    }
  }

  _addListeners() {
    engine!.registerEventHandler(RtcEngineEventHandler(
      onUserJoined: (connection, remoteUid, elapsed) async {
        add(SetIsJoinded(true));
        startTimer();
      },
      onUserOffline: (connection, remoteUid, reason) {
        leaveChannel();
      },
      onJoinChannelSuccess: (connection, elapsed) {
        if (isCalling == false) {
          startTimer();
        }
      },
    ));
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

  switchMicrophone(bool status) async {
    await engine!.enableLocalAudio(status).then((value) {}).catchError((err) {
      // ignore: avoid_print
      print('enableLocalAudio $err');
    });
  }

  switchSpeakerphone(bool status) async {
    await engine!
        .setEnableSpeakerphone(status)
        .then((value) {})
        .catchError((err) {
      // ignore: avoid_print
      print('setEnableSpeakerphone $err');
    });
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
      };
      final resp = await http.post(uri, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken(),
      });
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        callToken = data['token'];
        channelId = data['channelId'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<Call>> getAllCalls() async {
    try {
      final uri = Uri.parse("${Environment.apiUrl}/calls");
      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken(),
      });
      if (resp.statusCode == 200) {
        final calls = callsResponseFromJson(resp.body);
        return calls.calls;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<bool> deleteCalls(String id) async {
    try {
      final uri = Uri.parse("${Environment.apiUrl}/calls/delete/$id");
      final resp = await http.post(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await LoginBloc.getToken(),
      });
      if (resp.statusCode == 200) {
        final index = state.calls.indexWhere((element) => element.uid == id);
        state.calls.removeAt(index);
        add(SetCallsList(state.calls));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
