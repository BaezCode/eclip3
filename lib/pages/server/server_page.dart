import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:animate_do/animate_do.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/server/server_bloc.dart';
import 'package:eclips_3/bloc/socket/socket_bloc.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:eclips_3/pages/homeGroup/widgets/en_llamada_body.dart';
import 'package:eclips_3/pages/homeGroup/widgets/group_call_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:eclips_3/config/agora.config.dart' as config;
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class ServerPage extends StatefulWidget {
  const ServerPage({
    super.key,
  });

  @override
  State<ServerPage> createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> {
  late SocketBloc socketBloc;
  late LoginBloc loginBloc;
  late ServerBloc serverBloc;
  List<Usuario> listaEnLlamada = [];
  int _recordDuration = 0;
  Timer? _timer;
  Timer? _ampTimer;
  late final RtcEngine _engine;
  bool enLlamada = false;
  bool isJoined = false,
      openMicrophone = true,
      enableSpeakerphone = true,
      playEffect = true;
  @override
  void initState() {
    super.initState();
    socketBloc = BlocProvider.of<SocketBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    serverBloc = BlocProvider.of<ServerBloc>(context);
    _engine = createAgoraRtcEngineEx();
    _initEngine();
  }

  Future<void> _initEngine() async {
    // ignore: prefer_const_constructors
    try {
      await socketBloc.connect();
      listaEnLlamada.add(loginBloc.usuario!);

      // ignore: prefer_const_constructors
      await _engine.initialize(RtcEngineContext(
        appId: config.appId,
      ));

      _joinChannel();

      await _engine
          .setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
      await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await _engine.enableAudio();
      _startTimer();
    } catch (e) {
      return;
    }
    _addListeners();
  }

  _addListeners() {
    _engine.registerEventHandler(RtcEngineEventHandler(
      onActiveSpeaker: (connection, uid) {
        try {
          final index = listaEnLlamada.indexWhere(
            (element) => element.uidCall == uid,
          );
          setState(() {
            listaEnLlamada[index].estadoCall = "Hablando";
          });
        } catch (e) {
          return;
        }
      },
      onUserMuteAudio: (connection, remoteUid, muted) {},
      onUserJoined: (connection, remoteUid, elapsed) async {
        /*
        for (var element in serverBloc.state.server!.usuarios) {
          if (element.uidCall == remoteUid &&
              element.uid != loginBloc.usuario!.uid) {
            listaEnLlamada.add(element);
          }
          setState(() {});
        }
        */
      },
      onUserOffline: (connection, remoteUid, reason) {
        /*
        for (var element in serverBloc.state.server!.usuarios) {
          if (element.uidCall == remoteUid &&
              element.uid != loginBloc.usuario!.uid) {
            listaEnLlamada.remove(element);
          }
          setState(() {});
        }
        */
      },
      onJoinChannelSuccess: (connection, elapsed) {
        setState(() {
          enLlamada = true;
        });
      },
    ));
  }

  _joinChannel() async {
    await Permission.microphone.request();
    await _engine
        .joinChannel(
            channelId: serverBloc.channelId,
            token: serverBloc.callToken,
            options: const ChannelMediaOptions(),
            uid: serverBloc.uidCall)
        .catchError((onError) {
      // ignore: avoid_print
      print('error ${onError.toString()}');
    });
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: const TextStyle(color: Colors.white, fontSize: 20),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  void _startTimer() {
    _timer?.cancel();
    _ampTimer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        _recordDuration++;
      });
    });

    _ampTimer =
        Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerBloc, ServerState>(
      builder: (context, state) {
        return Scaffold(
            bottomNavigationBar:
                enLlamada ? FadeIn(child: _crearNavBar()) : null,
            backgroundColor: Colors.grey[900],
            appBar: AppBar(
              actions: const [
                /*
                PopMenuServer(
                  server: state.server!,
                )
                */
              ],
              title: GestureDetector(
                  onTap: () {},
                  child: AppbarTittleCall(
                    server: state.server!,
                    lista: listaEnLlamada,
                  )),
              backgroundColor: const Color(0xfff20262e),
            ),
            body: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey.withOpacity(0.1),
              ),
              itemCount: listaEnLlamada.length,
              itemBuilder: (ctx, i) => EnLlamadaBody(
                usuario: listaEnLlamada[i],
              ),
            ));
      },
    );
  }

  Widget _crearNavBar() {
    final size = MediaQuery.of(context).size;
    final sr = AppLocalizations.of(context)!;

    return Container(
        decoration: BoxDecoration(
            boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 2)],
            color: Colors.grey[900],
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        height: size.height * 0.17,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimer(),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundColor:
                      enableSpeakerphone ? Colors.grey[900] : Colors.blue,
                  radius: 25,
                  child: IconButton(
                      onPressed: _switchSpeakerphone,
                      icon: Icon(
                        enableSpeakerphone
                            ? Icons.volume_down
                            : Icons.volume_up,
                        color: Colors.white,
                        size: 25,
                      )),
                ),
                CircleAvatar(
                  backgroundColor:
                      openMicrophone ? Colors.grey[900] : Colors.blue,
                  radius: 25,
                  child: IconButton(
                      onPressed: _switchMicrophone,
                      icon: Icon(
                        openMicrophone ? Icons.mic : Icons.mic_off,
                        color: Colors.white,
                        size: 25,
                      )),
                ),
                PopupMenuButton(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  icon: const Icon(
                    Icons.record_voice_over,
                    color: Colors.white,
                    size: 20,
                  ),
                  onSelected: (int selectedValue) async {
                    if (selectedValue == 0) {
                      await _engine.setLocalVoiceEqualization(
                          bandFrequency: AudioEqualizationBandFrequency
                              .audioEqualizationBand4k,
                          bandGain: 3);
                      await _engine.setLocalVoicePitch(1.0);
                      setState(() {});
                    }
                    if (selectedValue == 1) {
                      await _engine.setLocalVoiceEqualization(
                          bandFrequency: AudioEqualizationBandFrequency
                              .audioEqualizationBand4k,
                          bandGain: 3);
                      await _engine.setLocalVoicePitch(1.5);
                      setState(() {});
                    }
                    if (selectedValue == 2) {
                      await _engine.setLocalVoiceEqualization(
                          bandFrequency: AudioEqualizationBandFrequency
                              .audioEqualizationBand4k,
                          bandGain: 3);
                      await _engine.setLocalVoicePitch(0.85);
                      setState(() {});
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 0,
                      child: Text(
                        sr.tab27,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: Text(
                        sr.tab28,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Text(
                        sr.tab29,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 25,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          enLlamada = false;
                          listaEnLlamada = [];
                          _recordDuration = 0;
                        });
                        _leaveChannel();
                      },
                      icon: const Icon(
                        Icons.call_end,
                        color: Colors.white,
                        size: 25,
                      )),
                ),
              ],
            ),
          ],
        ));
  }

  _leaveChannel() async {
    try {
      await _engine.leaveChannel();
      await _engine.disableAudio();
      await _engine.release();
      _timer?.cancel();
      _ampTimer?.cancel();

      Navigator.pop(context);
    } catch (e) {
      return;
    }
  }

  _switchMicrophone() {
    _engine.enableLocalAudio(!openMicrophone).then((value) {
      setState(() {
        openMicrophone = !openMicrophone;
      });
    }).catchError((err) {
      // ignore: avoid_print
      print('enableLocalAudio $err');
    });
  }

  _switchSpeakerphone() {
    _engine.setEnableSpeakerphone(!enableSpeakerphone).then((value) {
      setState(() {
        enableSpeakerphone = !enableSpeakerphone;
      });
    }).catchError((err) {
      // ignore: avoid_print
      print('setEnableSpeakerphone $err');
    });
  }

  @override
  void dispose() async {
    _leaveChannel();
    super.dispose();
  }
}
