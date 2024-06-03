import 'dart:async';
import 'dart:convert';

import 'package:eclips_3/bloc/audiobloc/audio_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
import 'package:eclips_3/helpers/customMsg.dart';
import 'package:eclips_3/models/msg_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:intl/intl.dart';

class AudioBubble extends StatefulWidget {
  final MsgModel msgModel;
  final MsgBloc msgBloc;
  final String uid;
  final String texto;
  final bool? reenviar;
  final Function()? onTap;

  const AudioBubble(
      {Key? key,
      required this.uid,
      required this.texto,
      this.reenviar,
      required this.msgModel,
      required this.msgBloc,
      this.onTap})
      : super(key: key);

  @override
  State<AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<AudioBubble> {
  bool isPlaying = false;
  int durastion = 0;
  final FlutterSoundPlayer mPlayer = FlutterSoundPlayer();
  late AudioBloc audioBloc;
  int pos = 0;

/*
  final AudioContext audioContext = const AudioContext(
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.playAndRecord,
      options: [
        AVAudioSessionOptions.defaultToSpeaker,
        AVAudioSessionOptions.mixWithOthers,
      ],
    ),
  );
  */

  @override
  void initState() {
    super.initState();
    audioBloc = BlocProvider.of<AudioBloc>(context);
    init();
  }

  init() async {
    await mPlayer.openPlayer();
    final seconds = int.parse(widget.msgModel.segundos!);
    final minutes = int.parse(widget.msgModel.minutos!);
    durastion = minutes + seconds * 1000;
    await mPlayer.setSubscriptionDuration(const Duration(milliseconds: 50));
    try {
      mPlayer.onProgress!.listen((e) {
        setPos(e.position.inMilliseconds);
      });
    } catch (e) {
      return;
    }
  }

  Future<void> setPos(int d) async {
    try {
      if (d > durastion) {
        d = durastion;
      }
      setState(() {
        pos = d;
      });
    } catch (e) {
      return;
    }
  }

  Future<void> seek(double d) async {
    await mPlayer.seekToPlayer(Duration(milliseconds: d.floor()));
    await setPos(d.floor());
  }

  /*
  UrlSource urlSourceFromBytes(Uint8List bytes,
      {String mimeType = "audio/.m4a"}) {
    return UrlSource(Uri.dataFromBytes(bytes, mimeType: mimeType).toString());
  }
  */

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        return Container(
          child: widget.uid == loginBloc.usuario!.uid
              ? _myMessage(context, state, loginBloc.usuario!.uid)
              : _notMyMessage(context, state, loginBloc.usuario!.uid),
        );
      },
    );
  }

  Widget _myMessage(BuildContext context, AudioState state, String uidDe) {
    final dateLocal = widget.msgModel.createdAt.toLocal();

    String formattedDate = DateFormat('dd-MM-yyyy - kk:mm').format(dateLocal);
    final size = MediaQuery.of(context).size;
    String respReply = '';
    if (widget.msgModel.replyMsg!.isNotEmpty &&
        widget.msgModel.replyType == 'text') {
      respReply = widget.msgBloc.decryptmesaje(widget.msgModel.replyMsg!);
    }
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
          margin: const EdgeInsets.only(
            right: 10,
            bottom: 5,
          ),
          decoration: BoxDecoration(
              color: const Color(0xfff20262e),
              borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
              width: 320,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (widget.msgModel.reenviado != null &&
                          widget.msgModel.reenviado!)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                CupertinoIcons.arrowshape_turn_up_right,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Reenviado de: ${widget.msgModel.nombre}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      if (widget.msgModel.replyMsg!.isNotEmpty)
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey[850]),
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          bottomLeft: Radius.circular(5)),
                                      color: Colors.blue[700],
                                    ),
                                    height: double.infinity,
                                    width: 3,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.60,
                                            child: Text(
                                              CustomMsg.texto(
                                                  widget.msgModel.replyType!,
                                                  respReply),
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          if (widget.msgModel.replyType !=
                                              'text') ...[
                                            Icon(
                                              CustomMsg.reply(
                                                  widget.msgModel.replyType!),
                                              size: 13,
                                              color: Colors.white,
                                            )
                                          ]
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                if (isPlaying) {
                                  setState(() {
                                    isPlaying = false;
                                  });
                                  await mPlayer.pausePlayer();
                                } else {
                                  setState(() {
                                    isPlaying = true;
                                  });

                                  await mPlayer.startPlayer(
                                    fromDataBuffer: base64Decode(widget.texto),
                                    whenFinished: () {
                                      setState(() {
                                        isPlaying = false;
                                      });
                                    },
                                  );
                                }
                              },
                              icon: Icon(
                                isPlaying
                                    ? CupertinoIcons.pause_circle_fill
                                    : CupertinoIcons.play_circle_fill,
                                size: 30,
                                color: Colors.white,
                              )),
                          Slider(
                              thumbColor: Colors.white,
                              inactiveColor: Colors.white,
                              activeColor: Colors.blue[700],
                              min: 0,
                              max: durastion + 0.0,
                              value: pos + 0.0,
                              onChanged: seek),
                          Row(
                            children: [
                              Text(
                                "${widget.msgModel.minutos}:${widget.msgModel.segundos}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(
                                Icons.mic,
                                color: Colors.white,
                                size: 12,
                              )
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              formattedDate,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 11),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Icon(
                              widget.reenviar!
                                  ? widget.msgModel.enviar!
                                      ? Icons.check_circle_sharp
                                      : Icons.circle_outlined
                                  : CustomMsg.icons(widget.msgModel.leido),
                              color: widget.reenviar!
                                  ? widget.msgModel.enviar!
                                      ? Colors.blue[700]
                                      : Colors.green
                                  : Colors.green,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 5,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ))),
    );
  }

  Widget _notMyMessage(BuildContext context, AudioState state, String uidDe) {
    final dateLocal = widget.msgModel.createdAt.toLocal();
    String formattedDate = DateFormat('dd-MM-yyyy - kk:mm').format(dateLocal);
    final size = MediaQuery.of(context).size;
    String respReply = '';
    if (widget.msgModel.replyMsg!.isNotEmpty &&
        widget.msgModel.replyType == 'text') {
      respReply = widget.msgBloc.decryptmesaje(widget.msgModel.replyMsg!);
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
          margin: const EdgeInsets.only(
            left: 10,
            bottom: 5,
          ),
          decoration: BoxDecoration(
              color: const Color(0xffE4E5E8),
              borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
              width: 320,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (widget.msgModel.reenviado != null &&
                          widget.msgModel.reenviado!)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                CupertinoIcons.arrowshape_turn_up_right,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Reenviado de: ${widget.msgModel.nombre}",
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      if (widget.msgModel.replyMsg!.isNotEmpty)
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey[850]),
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    color: Colors.blue[700],
                                    height: double.infinity,
                                    width: 3,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Rodrigo Baez",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.60,
                                            child: Text(
                                              CustomMsg.texto(
                                                  widget.msgModel.replyType!,
                                                  respReply),
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          if (widget.msgModel.replyType !=
                                              'text')
                                            Icon(
                                              CustomMsg.reply(
                                                  widget.msgModel.replyType!),
                                              size: 13,
                                              color: Colors.white,
                                            )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                if (isPlaying) {
                                  setState(() {
                                    isPlaying = false;
                                  });
                                  await mPlayer.pausePlayer();
                                } else {
                                  setState(() {
                                    isPlaying = true;
                                  });

                                  await mPlayer.startPlayer(
                                    fromDataBuffer: base64Decode(widget.texto),
                                    whenFinished: () {
                                      setState(() {
                                        isPlaying = false;
                                      });
                                    },
                                  );
                                }
                              },
                              icon: Icon(
                                isPlaying
                                    ? CupertinoIcons.pause_circle_fill
                                    : CupertinoIcons.play_circle_fill,
                                size: 30,
                                color: Colors.black,
                              )),
                          Slider(
                              thumbColor: Colors.white,
                              inactiveColor: Colors.white,
                              activeColor: Colors.blue[700],
                              min: 0,
                              max: durastion + 0.0,
                              value: pos + 0.0,
                              onChanged: seek),
                          Row(
                            children: [
                              Text(
                                "${widget.msgModel.minutos}:${widget.msgModel.segundos}",
                                style: const TextStyle(color: Colors.black),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(
                                Icons.mic,
                                color: Colors.black,
                                size: 12,
                              ),
                              if (widget.msgModel.enviar!)
                                Positioned(
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.blue[700],
                                    child: const Icon(
                                      Icons.check,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, bottom: 2),
                        child: Text(
                          formattedDate,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ))),
    );
  }

  @override
  void dispose() {
    super.dispose();
    mPlayer.closePlayer();
  }
}
