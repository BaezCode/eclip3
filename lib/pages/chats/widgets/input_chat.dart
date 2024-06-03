import 'package:animate_do/animate_do.dart';
import 'package:eclips_3/bloc/audiobloc/audio_bloc.dart';
import 'package:eclips_3/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:eclips_3/bloc/grupos/grupos_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
import 'package:eclips_3/bloc/socket/socket_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/models/msg_model.dart';
import 'package:eclips_3/pages/chats/widgets/boton_galeria.dart';
import 'package:eclips_3/pages/chats/widgets/record_audio.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class InputChat extends StatefulWidget {
  final bool isGroup;
  const InputChat({super.key, required this.isGroup});

  @override
  State<InputChat> createState() => _InputChatState();
}

class _InputChatState extends State<InputChat> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final prefs = PreferenciasUsuario();
  late MsgBloc msgBloc;
  late LoginBloc loginBloc;
  late SocketBloc socketBloc;
  late ConversacionesBloc conversacionesBloc;
  late AudioBloc audioBloc;
  late UsuariosBloc usuariosBloc;
  late GruposBloc gruposBloc;
  var uid = const Uuid();

  @override
  void initState() {
    super.initState();
    msgBloc = BlocProvider.of<MsgBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    socketBloc = BlocProvider.of<SocketBloc>(context);
    conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
    audioBloc = BlocProvider.of<AudioBloc>(context);
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    gruposBloc = BlocProvider.of<GruposBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        return state.isRecording
            ? FadeInUp(
                duration: const Duration(milliseconds: 200),
                child: RecordAudioForm(
                    miUID: loginBloc.usuario!.uid,
                    contactUID: msgBloc.contacto!.uid),
              )
            : BlocBuilder<MsgBloc, MsgState>(
                builder: (context, state) {
                  return Container(
                      color: const Color(0xfff20262e),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          SafeArea(
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                const BotonGaleria(),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: TextField(
                                        onChanged: (value) {
                                          if (value.isEmpty) {
                                            msgBloc.add(SetEscribiendo(false));
                                          } else {
                                            msgBloc.add(SetEscribiendo(true));
                                          }
                                        },
                                        onEditingComplete:
                                            () {}, // this prevents keyboard from closing
                                        controller: _textController,
                                        style: const TextStyle(
                                            color: Colors.white),
                                        maxLines: null,
                                        decoration:
                                            const InputDecoration.collapsed(
                                                fillColor: Colors.white,
                                                hintText: 'Send Messaje',
                                                hintStyle: TextStyle(
                                                    color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                CircleAvatar(
                                  radius: 22,
                                  child: IconButton(
                                      onPressed: msgBloc.state.estaEscribiendo
                                          ? () => _handleSubmit(
                                                _textController.text.trim(),
                                              )
                                          : () async {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();

                                              audioBloc
                                                  .add(SetisRecording(true));
                                            },
                                      icon: Icon(
                                        msgBloc.state.estaEscribiendo
                                            ? CupertinoIcons.location_fill
                                            : Icons.mic,
                                        color: Colors.white,
                                        size: 22,
                                      )),
                                ),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                          ),
                        ],
                      ));
                },
              );
      },
    );
  }

  _handleSubmit(String texto) async {
    if (texto.isEmpty) return;
    _textController.clear();
    msgBloc.add(SetEscribiendo(false));
    final uidFinal = uid.v4();

    final newMessage = MsgModel(
      replyDe: msgBloc.state.replyDe,
      replyMsg: msgBloc.state.replyMsg,
      replyType: msgBloc.state.replyType,
      leido: 0,
      type: 'text',
      nombre: loginBloc.usuario!.nombre,
      uid: uidFinal,
      createdAt: DateTime.now(),
      de: loginBloc.usuario!.uid,
      tokenPush: msgBloc.grupo == false ? msgBloc.tokenPush : '',
      tokenGroup: msgBloc.grupo == false
          ? []
          : List.generate(gruposBloc.state.usuarios.length,
              (index) => gruposBloc.state.usuarios[index].tokenPush!),
      para: msgBloc.para,
      mensaje: texto,
    );
    await msgBloc.addChats(newMessage, true);
    if (msgBloc.grupo) {
      msgBloc.add(SetReplyChat(false, '', '', ''));
      await msgBloc.enviarMensajeGrupo(newMessage, prefs.timerDelete);
    } else {
      msgBloc.add(SetReplyChat(false, '', '', ''));
      await msgBloc.enviarMensaje(
          newMessage, prefs.timerDelete, usuariosBloc.state.enChat);
    }

    /*
    socketBloc.socket
        .emit(msgBloc.grupo == false ? 'mensaje-personal' : 'mensaje-grupal', {
      "de": loginBloc.usuario!.uid,
      "nombre": loginBloc.usuario!.nombre,
      "lastID": loginBloc.usuario!.idCorto,
      "para": msgBloc.para,
      "leido": usuariosBloc.state.enChat ? 2 : 1,
      "uid": uidFinal,
      "mensaje": resp,
      'subMsg': '',
      "tokenPush": msgBloc.grupo == false
          ? msgBloc.tokenPush
          : List.generate(gruposBloc.state.usuarios.length,
              (index) => gruposBloc.state.usuarios[index].tokenPush),
      "type": 'text',
      "timer": prefs.timerDelete
    });
    */
  }
}
