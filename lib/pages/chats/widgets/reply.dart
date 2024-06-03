import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReplyContainer extends StatefulWidget {
  const ReplyContainer({super.key});

  @override
  State<ReplyContainer> createState() => _ReplyContainerState();
}

class _ReplyContainerState extends State<ReplyContainer> {
  late MsgBloc msgBloc;
  late LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    msgBloc = BlocProvider.of<MsgBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final usuario = msgBloc.contacto!;
    final size = MediaQuery.of(context).size;
    return BlocBuilder<MsgBloc, MsgState>(
      builder: (context, state) {
        return Container(
          color: const Color(0xfff20262e),
          child: ListTile(
            subtitle: Row(
              children: [
                Icon(
                  _icono(state.replyType),
                  color: Colors.white,
                  size: 15,
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: size.width * 0.60,
                  child: Text(
                    _texto(state.replyMsg, state.replyType),
                    style: const TextStyle(
                        color: Colors.white, overflow: TextOverflow.ellipsis),
                  ),
                )
              ],
            ),
            title: Text(
              state.replyDe == loginBloc.usuario!.uid
                  ? "Tú"
                  : usuario.newName != null
                      ? usuario.newName!
                      : usuario.nombre!,
              style: TextStyle(color: Colors.blue[700]),
            ),
            trailing: IconButton(
                onPressed: () {
                  msgBloc.add(SetReplyChat(false, '', '', ''));
                },
                icon: Icon(
                  CupertinoIcons.xmark_octagon,
                  color: Colors.blue[700],
                )),
          ),
        );
      },
    );
  }

  IconData _icono(String type) {
    switch (type) {
      case 'text':
        return CupertinoIcons.text_bubble;
      case 'image':
        return CupertinoIcons.photo;
      case 'audio':
        return CupertinoIcons.mic;
      case 'nota':
        return CupertinoIcons.arrow_up_doc;
      case 'folder':
        return CupertinoIcons.folder;
      case 'contacto':
        return CupertinoIcons.person;

      default:
        return CupertinoIcons.text_bubble;
    }
  }

  String _texto(String msg, String type) {
    switch (type) {
      case 'text':
        final resp = msgBloc.decryptmesaje(msg);
        return resp;
      case 'image':
        return 'Image File';
      case 'audio':
        return 'Mensaje de voz';
      case 'nota':
        return 'Archivo de Nota';
      case 'folder':
        return 'Carpeta';
      case 'contacto':
        return 'Contacto';
      default:
        final resp = msgBloc.decryptmesaje(msg);
        return resp;
    }
  }
}
