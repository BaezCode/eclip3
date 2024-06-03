import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:eclips_3/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:eclips_3/bloc/llamadas/llamadas_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
import 'package:eclips_3/bloc/socket/socket_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/bloc/videocall/video_call_bloc.dart';
import 'package:eclips_3/helpers/customChats.dart';
import 'package:eclips_3/helpers/customContact.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/helpers/navegar_fadein.dart';
import 'package:eclips_3/models/msg_model.dart';
import 'package:eclips_3/pages/chats/msg_body.dart';
import 'package:eclips_3/pages/chats/widgets/call_page.dart';
import 'package:eclips_3/pages/chats/widgets/chat_appbar_title.dart';
import 'package:eclips_3/pages/chats/widgets/input_chat.dart';
import 'package:eclips_3/pages/chats/widgets/reply.dart';
import 'package:eclips_3/pages/chats/widgets/test_video_page.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:eclips_3/widgets/pop_menu_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class ChatPage extends StatefulWidget {
  final String contactUID;
  const ChatPage({super.key, required this.contactUID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late MsgBloc msgBloc;
  late SocketBloc socketBloc;
  late LoginBloc loginBloc;
  late ConversacionesBloc conversacionesBloc;
  late UsuariosBloc usuariosBloc;
  late LlamadasBloc llamadasBloc;
  late VideoCallBloc videoCallBloc;
  var rng = Random();
  var uuid = const Uuid();
  final prefs = PreferenciasUsuario();
  @override
  void initState() {
    super.initState();
    msgBloc = BlocProvider.of<MsgBloc>(context);
    socketBloc = BlocProvider.of<SocketBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    llamadasBloc = BlocProvider.of<LlamadasBloc>(context);
    videoCallBloc = BlocProvider.of<VideoCallBloc>(context);
    socketBloc.socket.on('Entro', _entroONo);
    socketBloc.socket.on('mensaje-personal', _escucharMensaje);
    socketBloc.socket.on('mensaje-eliminar', _eliminarMensaje);
    socketBloc.socket.on('mensaje-eliminar-todos', eliminarTodos);
    inicial();
  }

  void _entroONo(payload) {
    usuariosBloc.add(SetEnChat(payload['entro']));
    if (payload['entro']) {
      for (var element in msgBloc.state.messages) {
        if (element.de == loginBloc.usuario!.uid) {
          element.leido = 2;
        }
      }
    }
    if (usuariosBloc.state.enChat == false && payload['entro']) {
      socketBloc.socket
          .emit('Entro', {"para": msgBloc.contacto!.uid, "entro": true});
    }
  }

  void eliminarTodos(payload) {
    msgBloc.add(SetMsgs(const []));
  }

  void _eliminarMensaje(id) {
    final List<String> lista = List.from(id);
    for (var element in lista) {
      msgBloc.state.messages.removeWhere((data) => data.uid == element);
    }
    msgBloc.chats = msgBloc.state.messages;
    msgBloc.add(SetMsgs(msgBloc.state.messages));
  }

  inicial() async {
    usuariosBloc.add(SetLoading(true));
    await msgBloc.getChat(
        widget.contactUID,
        conversacionesBloc.conversaciones != null
            ? conversacionesBloc.conversaciones!.uid
            : '');
    for (var element in msgBloc.state.messages) {
      if (element.mensaje == loginBloc.usuario!.palabra && mounted) {
        socketBloc.disconnect();
        LoginBloc.deletoken();
        Navigator.pushReplacementNamed(context, 'login');
      }
    }
    usuariosBloc.add(SetLoading(false));
    usuariosBloc.add(SetReenviar(
      false,
    ));
    usuariosBloc.contador = 0;
  }

  void _escucharMensaje(dynamic payload) async {
    if (payload['de'] != msgBloc.contacto!.uid) return;
    if (payload['mensaje'] == loginBloc.usuario!.palabra && mounted) {
      socketBloc.disconnect();
      await LoginBloc.deletoken();
      // ignore: use_build_context_synchronously
      Navigator.of(context).popUntil((route) => route.isFirst);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, 'login');
      return;
    }
    MsgModel message = MsgModel(
        replyDe: payload['replyDe'],
        replyMsg: payload['replyMsg'],
        replyType: payload['replyType'],
        leido: 1,
        uid: payload['uid'],
        type: payload['type'],
        createdAt: DateTime.now().toUtc(),
        mensaje: payload['type'] == 'text'
            ? msgBloc.decryptmesaje(payload['mensaje'])
            : payload['mensaje'],
        minutos: payload['minutos'],
        segundos: payload['segundos'],
        de: payload['de'],
        para: payload['de']);

    msgBloc.addChats(message, true);
  }

  @override
  Widget build(BuildContext context) {
    final resp = AppLocalizations.of(context)!;

    return BlocBuilder<UsuariosBloc, UsuariosState>(
      builder: (context, stateuser) {
        return Scaffold(
          appBar: AppBar(
            bottom: stateuser.enLlamada
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(15.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            navegarFadeIn(
                                context,
                                const CallPage(
                                  isCalling: true,
                                )));
                      },
                      child: Container(
                        width: double.infinity,
                        height: 30,
                        color: Colors.green[700],
                        child: const Center(
                          child: Text("En Llamada",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ))
                : stateuser.conectado
                    ? stateuser.loading
                        ? PreferredSize(
                            preferredSize: const Size.fromHeight(4.0),
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.black,
                              color: Colors.green[300],
                            ))
                        : null
                    : PreferredSize(
                        preferredSize: const Size.fromHeight(4.0),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.red[700],
                          color: Colors.red[300],
                        )),
            title: AppbarTittle(
              usuario: msgBloc.contacto!,
            ),
            actions: [
              if (stateuser.reenviar == false) ...[
                if (loginBloc.usuario!.call && stateuser.enLlamada == false)
                  if (loginBloc.usuario!.videoLlamada == null
                      ? false
                      : loginBloc.usuario!.videoLlamada!)
                    IconButton(
                        onPressed: () async {
                          CustomWIdgets.loading(context);
                          videoCallBloc.nombre = msgBloc.contacto!.nombre!;
                          videoCallBloc.de = msgBloc.contacto!.uid;
                          videoCallBloc.uidCall = 1;
                          videoCallBloc.add(SetContactUID(0));
                          final resp = await videoCallBloc.getTokenCall(
                              msgBloc.contacto!.tokenPush!,
                              loginBloc.usuario!.nombre!,
                              msgBloc.contacto!.voipID!,
                              loginBloc.usuario!.uid,
                              msgBloc.contacto!.uid,
                              true);
                          if (resp && mounted) {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                navegarFadeIn(
                                    context,
                                    const TestVidePage(
                                      isCalling: true,
                                    )));
                          } else {
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: "Error Intente de Nuevo");
                          }
                        },
                        icon: const Icon(Icons.video_call_outlined)),
                IconButton(
                    onPressed: () async {
                      CustomWIdgets.loading(context);
                      llamadasBloc.nombre = msgBloc.contacto!.nombre!;
                      llamadasBloc.de = msgBloc.contacto!.uid;
                      final resp = await llamadasBloc.getTokenCall(
                          msgBloc.contacto!.tokenPush!,
                          loginBloc.usuario!.nombre!,
                          msgBloc.contacto!.voipID!,
                          loginBloc.usuario!.uid,
                          msgBloc.contacto!.uid,
                          false);
                      if (resp && mounted) {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            navegarFadeIn(
                                context,
                                const CallPage(
                                  isCalling: true,
                                )));
                      } else {
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: "Error Intente de Nuevo");
                      }
                    },
                    icon: const Icon(
                      Icons.call,
                      color: Colors.white,
                      size: 18,
                    )),
                const DrawerChat(),
              ],
              if (stateuser.reenviar) ...[
                TextButton(
                    onPressed: () {
                      usuariosBloc.add(SetReenviar(false));
                      for (var element in msgBloc.state.messages) {
                        if (element.enviar!) {
                          element.enviar = false;
                        }

                        msgBloc.add(SetMsgs(msgBloc.state.messages));
                      }
                    },
                    child: const Text("Cancelar"))
              ]
            ],
            backgroundColor: const Color(0xfff20262e),
          ),
          body: BlocBuilder<MsgBloc, MsgState>(
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.55), BlendMode.dstATop),
                      image: const AssetImage('images/fondo.jpg'),
                      fit: BoxFit.cover,
                    )),
                child: Column(
                  children: [
                    if (state.messages.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          resp.tab181,
                          style: TextStyle(
                              color: Colors.amberAccent[400],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    Flexible(
                        child: GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: ListView.builder(
                          controller: msgBloc.controller,
                          reverse: true,
                          itemCount: state.messages.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (_, i) {
                            try {
                              return SwipeTo(
                                iconColor: Colors.white,
                                onRightSwipe: () {
                                  msgBloc.add(SetReplyChat(
                                      true,
                                      state.messages[i].de,
                                      state.messages[i].mensaje,
                                      state.messages[i].type));
                                },
                                child: Bounce(
                                  animate: false,
                                  manualTrigger: true,
                                  controller: (animationCtrl) => state
                                      .messages[i].animated = animationCtrl,
                                  child: MsgBody(
                                      state: state, stateuser: stateuser, i: i),
                                ),
                              );
                            } catch (e) {
                              return Container();
                            }
                          }),
                    )),
                    const Divider(height: 10),
                    if (stateuser.loading == false)
                      if (state.reply) ...[
                        const ReplyContainer(),
                      ],
                    if (stateuser.reenviar == false) ...[
                      const InputChat(
                        isGroup: false,
                      ),
                    ],
                    if (stateuser.reenviar)
                      FadeInUp(
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          color: const Color(0xfff20262e),
                          child: SafeArea(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () =>
                                        CustomContact.buildReenviar(context),
                                    icon: const Icon(
                                      CupertinoIcons.arrowshape_turn_up_right,
                                      color: Colors.blue,
                                    )),
                                Text(
                                  "${usuariosBloc.contador} Seleccionados",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const Spacer(),
                                IconButton(
                                    onPressed: () async {
                                      final List<String> ids = [];
                                      for (var element in state.messages) {
                                        if (element.enviar == true &&
                                            element.de ==
                                                loginBloc.usuario!.uid) {
                                          ids.add(element.uid);
                                        }
                                      }
                                      CustomWIdgets.loading(context);
                                      final resp = await msgBloc.deleteMsg(
                                          ids, msgBloc.contacto!.uid);
                                      if (resp && mounted) {
                                        usuariosBloc.add(SetReenviar(false));
                                        for (var element
                                            in msgBloc.state.messages) {
                                          if (element.enviar!) {
                                            element.enviar = false;
                                          }

                                          msgBloc.add(
                                              SetMsgs(msgBloc.state.messages));
                                        }
                                        Navigator.pop(context);
                                        Fluttertoast.showToast(
                                            gravity: ToastGravity.CENTER,
                                            msg: "Mensajes Eliminados");
                                      } else {
                                        usuariosBloc.add(SetReenviar(false));
                                        for (var element
                                            in msgBloc.state.messages) {
                                          if (element.enviar!) {
                                            element.enviar = false;
                                          }
                                          msgBloc.add(
                                              SetMsgs(msgBloc.state.messages));
                                        }
                                        Navigator.pop(context);
                                        Fluttertoast.showToast(msg: "Error");
                                      }
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.delete,
                                      color: Colors.blue,
                                    )),
                                IconButton(
                                    onPressed: () async {
                                      List<MsgModel> data = [];
                                      for (var element
                                          in msgBloc.state.messages) {
                                        if (element.type == "text" &&
                                            element.enviar!) {
                                          data.add(element);
                                        }
                                      }
                                      if (mounted) {
                                        CustomChats.setNameConversaciones(
                                            context, data);
                                      }
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.doc_fill,
                                      color: Colors.blue,
                                    )),
                                const SizedBox(
                                  width: 15,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    usuariosBloc.add(SetEnChat(false));
    socketBloc.socket
        .emit('Entro', {"para": msgBloc.contacto!.uid, "entro": false});
    socketBloc.socket.off('mensaje-personal');
    socketBloc.socket.off('Entro');
    socketBloc.socket.off('mensaje-eliminar');
    socketBloc.socket.off('mensaje-eliminar-todos');
  }
}
