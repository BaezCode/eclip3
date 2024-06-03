import 'package:eclips_3/bloc/grupos/grupos_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
import 'package:eclips_3/bloc/server/server_bloc.dart';
import 'package:eclips_3/bloc/socket/socket_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/models/msg_model.dart';
import 'package:eclips_3/pages/chats/widgets/atencion_bubble.dart';
import 'package:eclips_3/pages/chats/widgets/audio_bubble.dart';
import 'package:eclips_3/pages/chats/widgets/images_bubble.dart';
import 'package:eclips_3/pages/chats/widgets/input_chat.dart';
import 'package:eclips_3/pages/chats/widgets/messages_bubble.dart';
import 'package:eclips_3/pages/chats/widgets/notas_bubble.dart';
import 'package:eclips_3/pages/chats/widgets/video_bubble.dart';
import 'package:eclips_3/pages/homeGroup/widgets/group_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class ChatsGrupos extends StatefulWidget {
  const ChatsGrupos({
    super.key,
  });

  @override
  State<ChatsGrupos> createState() => _ChatsGruposState();
}

class _ChatsGruposState extends State<ChatsGrupos> {
  late MsgBloc msgBloc;
  late GruposBloc gruposBloc;
  late UsuariosBloc usuariosBloc;
  late SocketBloc socketBloc;
  late LoginBloc loginBloc;
  late ServerBloc serverBloc;

  @override
  void initState() {
    super.initState();
    msgBloc = BlocProvider.of<MsgBloc>(context);
    gruposBloc = BlocProvider.of<GruposBloc>(context);
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    socketBloc = BlocProvider.of<SocketBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    serverBloc = BlocProvider.of<ServerBloc>(context);
    socketBloc.socket.on('mensaje-grupal', _escucharMensaje);
    socketBloc.socket.on('Enviado', _enviado);
    _emiciones();
    inicial();
  }

  inicial() async {
    usuariosBloc.add(SetLoading(true));
    await msgBloc.getGroupChat(gruposBloc.state.grupo!.uid);
    await gruposBloc.getIntegrantes();
    usuariosBloc.add(SetLoading(false));
    gruposBloc.add(SetGrupo(gruposBloc.state.grupo));
  }

  void _emiciones() {
    socketBloc.socket.emit('enSala', {
      "uid": gruposBloc.state.grupo!.uid,
    });
  }

  void _escucharMensaje(dynamic payload) async {
    if (payload['para'] != gruposBloc.state.grupo!.uid) return;
    if (payload['de'] == loginBloc.usuario!.uid) return;
    MsgModel message = MsgModel(
        leido: 1,
        uid: payload['uid'],
        type: payload['type'],
        nombre: payload['nombre'],
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

  void _enviado(dynamic payload) {
    try {
      msgBloc.state.messages[0].leido = 1;
      msgBloc.add(SetMsgs(msgBloc.state.messages));
      if (usuariosBloc.state.enChat) {
        msgBloc.state.messages[0].leido = 2;
        msgBloc.add(SetMsgs(msgBloc.state.messages));
      }
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsuariosBloc, UsuariosState>(
      builder: (context, stateuser) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              /*
              IconButton(
                  onPressed: () {
                    var rng = Random();
                    serverBloc.uidCall = rng.nextInt(1000);
                    serverBloc.callToken = gruposBloc.state.grupo!.token!;
                    serverBloc.channelId = gruposBloc.state.grupo!.channelName!;
                    serverBloc.add(SetServer(gruposBloc.state.grupo!));
                    Navigator.pushNamed(context, 'callGrupo');
                  },
                  icon: const Icon(Icons.groups_2_sharp))
                  */
            ],
            bottom: stateuser.conectado
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
            backgroundColor: const Color(0xfff20262e),
            title: const GroupTitle(),
          ),
          body: BlocBuilder<MsgBloc, MsgState>(
            builder: (context, state) {
              return Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('images/fondo.png'),
                  fit: BoxFit.cover,
                )),
                child: Column(
                  children: [
                    Flexible(
                        child: GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: ListView.builder(
                          reverse: true,
                          itemCount: state.messages.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (_, i) {
                            try {
                              return _msg(
                                  state.messages[i], stateuser.reenviar);
                            } catch (e) {
                              return Container();
                            }
                          }),
                    )),
                    const Divider(height: 10),
                    if (stateuser.loading == false)
                      const InputChat(
                        isGroup: true,
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

  Widget _msg(MsgModel msgModel, bool reenviar) {
    final data = AppLocalizations.of(context)!;

    switch (msgModel.type) {
      case 'video':
        return VideoBubble(
          leido: msgModel.leido,
          dateTime: msgModel.createdAt,
          texto: msgModel.mensaje,
          uid: msgModel.de,
        );
      case 'text':
        final resp = msgBloc.decryptmesaje(msgModel.mensaje);
        return GestureDetector(
          onLongPress: () async {
            await Clipboard.setData(ClipboardData(text: resp));
            Fluttertoast.showToast(
                gravity: ToastGravity.CENTER, msg: data.tab110);
          },
          child: MessageBubble(
            msgBloc: msgBloc,
            nombre: msgModel.nombre,
            msgModel: msgModel,
            texto: resp,
            isGroup: true,
          ),
        );
      case 'Llamada':
        return Container();
      case 'image':
        return ImagesBubble(
          msgBloc: msgBloc,
          msgModel: msgModel,
          texto: msgModel.mensaje,
          isGroup: false,
          reenviar: reenviar,
        );
      case 'audio':
        return AudioBubble(
          msgBloc: msgBloc,
          msgModel: msgModel,
          texto: msgModel.mensaje,
          uid: msgModel.de,
          reenviar: reenviar,
          onTap: () {},
        );

      case 'atencion':
        return AtencionBubble(
          dateTime: msgModel.createdAt,
          texto: msgModel.mensaje,
          uid: msgModel.de,
        );
      case 'nota':
        return NotesBubble(
          leido: msgModel.leido,
          dateTime: msgModel.createdAt,
          texto: msgModel.mensaje,
          uid: msgModel.de,
        );
      default:
        return MessageBubble(
          msgBloc: msgBloc,
          nombre: msgModel.nombre,
          msgModel: msgModel,
          texto: msgModel.mensaje,
          isGroup: true,
        );
    }
  }

  @override
  void dispose() {
    super.dispose();
    socketBloc.socket.off('mensaje-grupal');
    socketBloc.socket.off('Enviado');
  }
}
