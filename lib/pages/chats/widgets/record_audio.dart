import 'dart:convert';
import 'dart:io';

import 'package:eclips_3/bloc/audiobloc/audio_bloc.dart';
import 'package:eclips_3/bloc/grupos/grupos_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
import 'package:eclips_3/bloc/socket/socket_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/models/msg_model.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

class RecordAudioForm extends StatefulWidget {
  final String miUID;
  final String contactUID;
  const RecordAudioForm(
      {super.key, required this.miUID, required this.contactUID});

  @override
  State<RecordAudioForm> createState() => _RecordAudioFormState();
}

class _RecordAudioFormState extends State<RecordAudioForm> {
  late AudioBloc audioBloc;
  late MsgBloc msgBloc;
  late SocketBloc socketBloc;
  late Directory appDirectory;
  late UsuariosBloc usuariosBloc;
  late LoginBloc loginBloc;
  late GruposBloc gruposBloc;

  final record = Record();

  var uid = const Uuid();

  final prefs = PreferenciasUsuario();

  @override
  void initState() {
    super.initState();
    audioBloc = BlocProvider.of<AudioBloc>(context);
    msgBloc = BlocProvider.of<MsgBloc>(context);
    socketBloc = BlocProvider.of<SocketBloc>(context);
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    gruposBloc = BlocProvider.of<GruposBloc>(context);
    start();
  }

  Future<String> getDir() async {
    appDirectory = await getTemporaryDirectory();
    final path = "${appDirectory.path}/myFile.m4a";
    return path;
  }

  Future<void> start() async {
    audioBloc.add(SetTimer('00', '00', 0));
    final result = await getDir();
    await record.start(path: result);
    audioBloc.starTimer(0);
    audioBloc.add(SetPath('', false));
    audioBloc.add(SetisRecording(true));
  }

  Future<void> pauseTimer() async {
    audioBloc.cancelTimer();
    await record.pause();
    audioBloc.add(StopStart(true));
  }

  Future<void> resumeTimer() async {
    audioBloc.add(StopStart(false));
    await record.resume();
    audioBloc.starTimer(1);
  }

  Future<String> confirmAudio() async {
    audioBloc.cancelTimer();
    final path = await record.stop();
    File file = File(path!);
    String img64 = base64Encode(file.readAsBytesSync());
    audioBloc.cancelTimer();
    audioBloc.add(SetPath(img64, true));
    return img64;
  }

  Future<void> stopTimer() async {
    audioBloc.cancelTimer();
    await record.stop();
    audioBloc.add(SetTimer('00', '00', 0));
    audioBloc.add(StopStart(false));
    audioBloc.add(SetisRecording(false));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        return Container(
          color: const Color(0xfff20262e),
          width: double.infinity,
          height: state.path.isEmpty ? size.height * 0.17 : size.height * 0.20,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*
                    AudioWaveforms(
                      enableGesture: true,
                      size: Size(MediaQuery.of(context).size.width / 1.9, 35),
                      recorderController: controller,
                      waveStyle: const WaveStyle(
                        waveColor: Colors.white,
                        extendWaveform: true,
                        showMiddleLine: false,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: const EdgeInsets.only(left: 18),
                    ),
                    */
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      '${state.minutes}:${state.seconds}',
                      style: const TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.circle,
                      color: Colors.red,
                      size: 17,
                    ),
                    const SizedBox(
                      width: 15,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: IconButton(
                        onPressed: () async {
                          await stopTimer();
                        },
                        icon: const Icon(
                          CupertinoIcons.delete,
                          size: 22,
                          color: Colors.white,
                        )),
                  ),
                  IconButton(
                      onPressed: () async {
                        if (state.stop) {
                          await resumeTimer();
                        } else {
                          await pauseTimer();
                        }
                      },
                      icon: Icon(
                        state.stop
                            ? CupertinoIcons.play_circle
                            : CupertinoIcons.pause_circle,
                        size: 30,
                        color: Colors.white,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue[700],
                      child: IconButton(
                          onPressed: () async {
                            final img64 = await confirmAudio();
                            audioBloc.add(SetisRecording(false));
                            final uidFinal = uid.v4();
                            final newMessage = MsgModel(
                              replyDe: msgBloc.state.replyDe,
                              replyMsg: msgBloc.state.replyMsg,
                              replyType: msgBloc.state.replyType,
                              leido: 0,
                              type: 'audio',
                              nombre: loginBloc.usuario!.nombre,
                              tokenPush: msgBloc.grupo == false
                                  ? msgBloc.tokenPush
                                  : '',
                              tokenGroup: msgBloc.grupo == false
                                  ? []
                                  : List.generate(
                                      gruposBloc.state.usuarios.length,
                                      (index) => gruposBloc
                                          .state.usuarios[index].tokenPush!),
                              minutos: state.minutes,
                              segundos: state.seconds,
                              uid: uidFinal,
                              createdAt: DateTime.now().toUtc(),
                              de: loginBloc.usuario!.uid,
                              para: msgBloc.para,
                              mensaje: img64,
                            );
                            msgBloc.add(SetReplyChat(false, '', '', ''));
                            await msgBloc.addChats(newMessage, true);
                            await msgBloc.enviarMensaje(newMessage,
                                prefs.timerDelete, usuariosBloc.state.enChat);

                            // ignore: use_build_context_synchronously
                          },
                          icon: const Icon(
                            CupertinoIcons.location_fill,
                            size: 20,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    record.dispose();
    // controller.dispose();
  }
}
