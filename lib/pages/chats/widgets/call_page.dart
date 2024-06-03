import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:eclips_3/bloc/llamadas/llamadas_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/socket/socket_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class CallPage extends StatefulWidget {
  final bool isCalling;
  const CallPage({
    super.key,
    required this.isCalling,
  });

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late LoginBloc loginBloc;
  late LlamadasBloc llamadasBloc;
  late SocketBloc socketBloc;
  late UsuariosBloc usuariosBloc;
  bool rechazo = false;
  int rechaso = 0;
  @override
  void initState() {
    super.initState();
    llamadasBloc = BlocProvider.of<LlamadasBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    socketBloc = BlocProvider.of<SocketBloc>(context);
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    socketBloc.socket.on('corto', _escuchar);
    llamadasBloc.isCalling = widget.isCalling;
    if (usuariosBloc.state.enLlamada == false) {
      llamadasBloc.initEngine();
      usuariosBloc.add(SetEnLlamada(true));
    }
    getCurrentCall();
  }

  getCurrentCall() async {
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        return calls[0];
      } else {
        llamadasBloc.leaveChannel();
        return null;
      }
    }
  }

  void _escuchar(payload) async {
    await llamadasBloc.leaveChannel();
    if (widget.isCalling == true && rechaso == 0 && mounted) {
      setState(() {
        rechaso++;
      });
      Navigator.pop(context);
      socketBloc.socket.off('corto');
    }
    usuariosBloc.add(SetEnLlamada(false));
  }

  @override
  Widget build(BuildContext context) {
    final data = AppLocalizations.of(context)!;

    return BlocBuilder<LlamadasBloc, LlamadasState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
              title: Row(
                children: [
                  Text(
                    data.tab78,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    Icons.lock,
                    size: 18,
                  )
                ],
              ),
              backgroundColor: Color(0xfff20262e),
            ),
            bottomNavigationBar: _crearNavBar(state),
            backgroundColor: const Color(0xfff20262e),
            body: _singleCall(state));
      },
    );
  }

  Widget _singleCall(LlamadasState state) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.account_circle,
          color: Colors.white,
          size: 150,
        ),
        const SizedBox(
          height: 25,
        ),
        Text(
          llamadasBloc.nombre,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        _crearHeader(state),
        SizedBox(height: size.height * 0.25),
        //  if (state.isJoined) _buildTimer(state),
      ],
    );
  }

  Widget _crearHeader(LlamadasState state) {
    final data = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (state.isJoined == false)
          Text(
            rechazo ? data.tab80 : data.tab81,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        const SizedBox(
          width: 2,
        ),
        if (state.isJoined == false)
          const SpinKitThreeBounce(
            color: Colors.white,
            size: 10.0,
          ),
        if (state.isJoined)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimer(state),
              const SizedBox(
                width: 5,
              ),
              const Icon(
                Icons.lock,
                color: Colors.white,
                size: 15,
              ),
            ],
          ),
      ],
    );
  }

  Widget _crearNavBar(LlamadasState state) {
    final data = AppLocalizations.of(context)!;

    final size = MediaQuery.of(context).size;
    return Container(
        decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        height: size.height * 0.17,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundColor: state.enableSpeakerphone == false
                      ? Colors.grey[900]
                      : Colors.blue,
                  radius: 25,
                  child: IconButton(
                      onPressed: () {
                        if (state.enableSpeakerphone) {
                          llamadasBloc.add(SetSpeakerPhone(false));
                          llamadasBloc.switchSpeakerphone(false);
                        } else {
                          llamadasBloc.add(SetSpeakerPhone(true));
                          llamadasBloc.switchSpeakerphone(true);
                        }
                      },
                      icon: Icon(
                        state.enableSpeakerphone == false
                            ? Icons.volume_down
                            : Icons.volume_up,
                        color: Colors.white,
                        size: 25,
                      )),
                ),
                CircleAvatar(
                  backgroundColor:
                      state.openMicrophone ? Colors.grey[900] : Colors.blue,
                  radius: 25,
                  child: IconButton(
                      onPressed: () {
                        if (state.openMicrophone) {
                          llamadasBloc.add(SetMicrophone(false));
                          llamadasBloc.switchMicrophone(false);
                        } else {
                          llamadasBloc.add(SetMicrophone(true));
                          llamadasBloc.switchMicrophone(true);
                        }
                      },
                      icon: Icon(
                        state.openMicrophone ? Icons.mic : Icons.mic_off,
                        color: Colors.white,
                        size: 25,
                      )),
                ),
                PopupMenuButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  icon: const Icon(
                    Icons.record_voice_over,
                    color: Colors.white,
                    size: 20,
                  ),
                  onSelected: (int selectedValue) async {
                    if (selectedValue == 0) {
                      await llamadasBloc.engine!.setLocalVoiceEqualization(
                          bandFrequency: AudioEqualizationBandFrequency
                              .audioEqualizationBand4k,
                          bandGain: 3);
                      await llamadasBloc.engine!.setLocalVoicePitch(1.0);
                      setState(() {});
                    }
                    if (selectedValue == 1) {
                      await llamadasBloc.engine!.setLocalVoiceEqualization(
                          bandFrequency: AudioEqualizationBandFrequency
                              .audioEqualizationBand4k,
                          bandGain: 3);
                      await llamadasBloc.engine!.setLocalVoicePitch(1.5);
                      setState(() {});
                    }
                    if (selectedValue == 2) {
                      await llamadasBloc.engine!.setLocalVoiceEqualization(
                          bandFrequency: AudioEqualizationBandFrequency
                              .audioEqualizationBand4k,
                          bandGain: 3);
                      await llamadasBloc.engine!.setLocalVoicePitch(0.85);
                      setState(() {});
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 0,
                      child: Text(data.tab27),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: Text(data.tab28),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Text(data.tab29),
                    ),
                  ],
                ),
                CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 25,
                  child: IconButton(
                      onPressed: () async {
                        setState(() {
                          rechazo = true;
                        });
                        if (widget.isCalling == true) {
                          Navigator.pop(context);

                          await llamadasBloc.leaveChannel();
                        } else {
                          await FlutterCallkitIncoming.endAllCalls();
                        }
                        usuariosBloc.add(SetEnLlamada(false));
                        socketBloc.socket.emit('corto', {
                          "de": llamadasBloc.de,
                        });
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

  Widget _buildTimer(LlamadasState state) {
    final String minutes = _formatNumber(state.recordDuration ~/ 60);
    final String seconds = _formatNumber(state.recordDuration % 60);

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

  @override
  Future<void> dispose() async {
    super.dispose();
    socketBloc.socket.off('corto');

    /*
    try {
      await FlutterCallkitIncoming.endAllCalls();
      await _engine.leaveChannel();
      await _engine.release();
      socketBloc.socket.off('enLlamada');
    } catch (e) {
      return;
    }
    */
  }
}
