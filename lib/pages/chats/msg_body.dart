import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/models/msg_model.dart';
import 'package:eclips_3/pages/chats/widgets/audio_bubble.dart';
import 'package:eclips_3/pages/chats/widgets/contacto_bubble.dart';
import 'package:eclips_3/pages/chats/widgets/folder_bubble.dart';
import 'package:eclips_3/pages/chats/widgets/images_bubble.dart';
import 'package:eclips_3/pages/chats/widgets/messages_bubble.dart';
import 'package:eclips_3/pages/chats/widgets/notas_bubble.dart';
import 'package:eclips_3/pages/chats/widgets/video_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MsgBody extends StatefulWidget {
  final MsgState state;
  final UsuariosState stateuser;
  final int i;

  const MsgBody(
      {super.key,
      required this.state,
      required this.stateuser,
      required this.i});

  @override
  State<MsgBody> createState() => _MsgBodyState();
}

class _MsgBodyState extends State<MsgBody> {
  late MsgBloc msgBloc;
  late UsuariosBloc usuariosBloc;
  late LoginBloc loginBloc;
  final widgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    msgBloc = BlocProvider.of<MsgBloc>(context);
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final msg = widget.state.messages[widget.i];
    return GestureDetector(
        key: widgetKey,
        onTap: () {
          if (widget.stateuser.reenviar) {
            if (widget.state.messages[widget.i].enviar!) {
              widget.state.messages[widget.i].enviar = false;
              msgBloc.add(SetMsgs(widget.state.messages));
              usuariosBloc.contador = usuariosBloc.contador - 1;
            } else {
              widget.state.messages[widget.i].enviar = true;
              msgBloc.add(SetMsgs(widget.state.messages));
              usuariosBloc.contador = usuariosBloc.contador + 1;
            }
          }
        },
        onLongPress: () {
          _showPopupMenu(widgetKey, widget.state.messages[widget.i]);
        },
        child: _msg(msg, widget.stateuser.reenviar));
  }

  void _showPopupMenu(widgetKey, MsgModel msgModel) async {
    await showMenu(
      color: const Color(0xfff20262e),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      context: context,
      position: _getRelativeRect(widgetKey),
      items: [
        const PopupMenuItem(
          value: 0,
          child: Row(
            children: [
              Text(
                "Selecionar",
                style: TextStyle(color: Colors.white),
              ),
              Spacer(),
              Icon(
                CupertinoIcons.arrow_up_right_circle_fill,
                color: Colors.white,
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Text(
                "Responder",
                style: TextStyle(color: Colors.white),
              ),
              Spacer(),
              Icon(
                CupertinoIcons.arrowshape_turn_up_left,
                color: Colors.white,
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Text(
                "Reenviar",
                style: TextStyle(color: Colors.white),
              ),
              Spacer(),
              Icon(
                CupertinoIcons.arrowshape_turn_up_right,
                color: Colors.white,
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 3,
          child: Row(
            children: [
              Text(
                "Copiar",
                style: TextStyle(color: Colors.white),
              ),
              Spacer(),
              Icon(
                Icons.copy,
                color: Colors.white,
              ),
            ],
          ),
        ),
        if (msgModel.de == loginBloc.usuario!.uid)
          PopupMenuItem(
            value: 4,
            child: Row(
              children: [
                Text(
                  "Eliminar",
                  style: TextStyle(color: Colors.red[700]),
                ),
                const Spacer(),
                Icon(
                  CupertinoIcons.delete,
                  color: Colors.red[700],
                ),
              ],
            ),
          ),
      ],
      elevation: 8.0,
    ).then((value) async {
      if (value == null) {
        return;
      } else if (value == 0) {
        if (widget.stateuser.reenviar == false) {
          usuariosBloc.add(SetReenviar(true));
          final index = widget.state.messages.indexWhere(
              (element) => element.uid == widget.state.messages[widget.i].uid);
          widget.state.messages[index].enviar = true;
          msgBloc.add(SetMsgs(widget.state.messages));
          usuariosBloc.contador = 1;
        }
      } else if (value == 1) {
        msgBloc.add(
            SetReplyChat(true, msgModel.de, msgModel.mensaje, msgModel.type));
      } else if (value == 2) {
        if (widget.stateuser.reenviar == false) {
          usuariosBloc.add(SetReenviar(true));
          final index = widget.state.messages.indexWhere(
              (element) => element.uid == widget.state.messages[widget.i].uid);
          widget.state.messages[index].enviar = true;
          msgBloc.add(SetMsgs(widget.state.messages));
          usuariosBloc.contador = 1;
        }
      } else if (value == 3) {
        final index = widget.state.messages.indexWhere(
            (element) => element.uid == widget.state.messages[widget.i].uid);
        await Clipboard.setData(
            ClipboardData(text: widget.state.messages[index].mensaje));
        Fluttertoast.showToast(
            msg: "ID Copiado Correctamente", gravity: ToastGravity.CENTER);
      } else if (value == 4) {
        CustomWIdgets.loading(context);
        final resp = await msgBloc.deleteMsg(
            List.generate(1, (index) => msgModel.uid), msgBloc.contacto!.uid);
        if (resp && mounted) {
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error");
        }
      }
    });
  }

  RelativeRect _getRelativeRect(GlobalKey key) {
    return RelativeRect.fromSize(
        _getWidgetGlobalRect(key), const Size(200, 200));
  }

  Rect _getWidgetGlobalRect(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    debugPrint('Widget position: ${offset.dx} ${offset.dy}');
    return Rect.fromLTWH(offset.dx / 3.1, offset.dy * 1.05,
        renderBox.size.width, renderBox.size.height);
  }

  Widget _msg(MsgModel msgModel, bool reenviar) {
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
        return MessageBubble(
          onTap: () async {
            /*
            final index = msgBloc.state.messages.indexWhere(
              (element) => element.mensaje == msgModel.replyMsg,
            );
            if (index != -1 && msgBloc.state.messages[index].animated != null) {
              msgBloc.state.messages[index].animated!.reset();
              msgBloc.state.messages[index].animated!.forward();
            }
            */
          },
          msgBloc: msgBloc,
          msgModel: msgModel,
          nombre: msgModel.nombre,
          texto: resp,
          isGroup: false,
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
          onTap: () {},
        );
      case 'audio':
        return AudioBubble(
          msgModel: msgModel,
          msgBloc: msgBloc,
          texto: msgModel.mensaje,
          uid: msgModel.de,
          reenviar: reenviar,
          onTap: () {},
        );

      case 'nota':
        return NotesBubble(
          leido: msgModel.leido,
          dateTime: msgModel.createdAt,
          texto: msgModel.mensaje,
          uid: msgModel.de,
        );
      case 'folder':
        return FolderBubble(
          nombre: msgModel.nombre,
          leido: msgModel.leido,
          dateTime: msgModel.createdAt,
          texto: msgModel.mensaje,
          uid: msgModel.de,
          isGroup: false,
          reenviado: msgModel.reenviado,
          enviado: msgModel.enviar,
        );

      case 'contacto':
        return ContactoBubble(
          msgModel: msgModel,
          msgBloc: msgBloc,
        );

      default:
        return MessageBubble(
          msgBloc: msgBloc,
          nombre: msgModel.nombre,
          msgModel: msgModel,
          texto: msgModel.mensaje,
          isGroup: false,
        );
    }
  }
}
