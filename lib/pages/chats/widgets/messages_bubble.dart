import 'package:bubble/bubble.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customMsg.dart';
import 'package:eclips_3/models/msg_model.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Key;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final MsgModel msgModel;
  final MsgBloc msgBloc;
  final String texto;
  final bool isGroup;
  final String? nombre;
  final Function()? onTap;

  const MessageBubble({
    super.key,
    required this.texto,
    required this.isGroup,
    this.nombre,
    required this.msgModel,
    required this.msgBloc,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    return Container(
      child: msgModel.de == loginBloc.usuario!.uid
          ? _myMessage(context, loginBloc.usuario!.uid)
          : _notMyMessage(context, loginBloc.usuario!.uid),
    );
  }

  Widget _myMessage(BuildContext context, String uidDe) {
    final dateLocal = msgModel.createdAt.toLocal();
    final String formattedDate = DateFormat('kk:mm').format(dateLocal);
    final prefs = PreferenciasUsuario();
    final size = MediaQuery.of(context).size;
    String respReply = '';
    if (msgModel.replyMsg!.isNotEmpty && msgModel.replyType == 'text') {
      respReply = msgBloc.decryptmesaje(msgModel.replyMsg!);
    }
    return BlocBuilder<UsuariosBloc, UsuariosState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (msgModel.reenviado != null && msgModel.reenviado!)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      CupertinoIcons.arrowshape_turn_up_right,
                      color: Colors.white,
                    ),
                    Text(
                      "Reenviado de: $nombre",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            Bubble(
                nip: BubbleNip.rightBottom,
                padding: const BubbleEdges.all(8.0),
                margin: const BubbleEdges.only(right: 10, bottom: 10, left: 50),
                color: const Color(0xfff20262e),
                child: isGroup
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 35),
                            child: Text(
                              nombre!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: prefs.letra.toDouble(),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 50),
                                child: Text(
                                  texto,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: prefs.letra.toDouble()),
                                ),
                              ),
                              Positioned(
                                bottom: -1,
                                right: -1,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
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
                                      state.reenviar
                                          ? msgModel.enviar!
                                              ? Icons.check_circle_sharp
                                              : Icons.circle_outlined
                                          : CustomMsg.icons(msgModel.leido),
                                      color: state.reenviar
                                          ? msgModel.enviar!
                                              ? const Color.fromARGB(
                                                  255, 213, 213, 213)
                                              : Colors.white
                                          : Colors.white,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    : msgModel.replyMsg!.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: onTap,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            msgModel.replyDe == uidDe
                                                ? "Tu"
                                                : msgBloc.contacto!.nombre!,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.70,
                                                child: Text(
                                                  CustomMsg.texto(
                                                      msgModel.replyType!,
                                                      respReply),
                                                  style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              if (msgModel.replyType != 'text')
                                                Icon(
                                                  CustomMsg.reply(
                                                      msgModel.replyType!),
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
                              const SizedBox(
                                height: 5,
                              ),
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 50.0),
                                    child: Text(
                                      texto,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: prefs.letra.toDouble()),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -1,
                                    right: -1,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          formattedDate,
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Icon(
                                          state.reenviar
                                              ? msgModel.enviar!
                                                  ? Icons.check_circle_sharp
                                                  : Icons.circle_outlined
                                              : CustomMsg.icons(msgModel.leido),
                                          color: state.reenviar
                                              ? msgModel.enviar!
                                                  ? Colors.blue[700]
                                                  : Colors.white
                                              : Colors.white,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        : Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 50.0),
                                child: Text(
                                  texto,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: prefs.letra.toDouble()),
                                ),
                              ),
                              Positioned(
                                bottom: -1,
                                right: -1,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
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
                                      state.reenviar
                                          ? msgModel.enviar!
                                              ? Icons.check_circle_sharp
                                              : Icons.circle_outlined
                                          : CustomMsg.icons(msgModel.leido),
                                      color: state.reenviar
                                          ? msgModel.enviar!
                                              ? Colors.blue[700]
                                              : Colors.green
                                          : Colors.green,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
          ],
        );
      },
    );
  }

  Widget _notMyMessage(BuildContext context, String uidDe) {
    final dateLocal = msgModel.createdAt.toLocal();
    String formattedDate = DateFormat('kk:mm').format(dateLocal);
    final prefs = PreferenciasUsuario();
    final size = MediaQuery.of(context).size;
    String respReply = '';
    if (msgModel.replyMsg!.isNotEmpty && msgModel.replyType == 'text') {
      respReply = msgBloc.decryptmesaje(msgModel.replyMsg!);
    }

    return Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (msgModel.reenviado != null && msgModel.reenviado!)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      CupertinoIcons.arrowshape_turn_up_right,
                      color: Colors.white,
                    ),
                    Text(
                      "Reenviado de: $nombre",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            Bubble(
                nip: BubbleNip.leftTop,
                padding: const BubbleEdges.all(8.0),
                margin: const BubbleEdges.only(left: 10, bottom: 10, right: 50),
                color: Colors.blueGrey[50],
                child: isGroup
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 35),
                            child: Text(
                              nombre!,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: prefs.letra.toDouble(),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 40),
                                child: Text(
                                  texto,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: prefs.letra.toDouble()),
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Positioned(
                                bottom: -1,
                                right: 1,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      formattedDate,
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              if (msgModel.enviar!)
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.blue[700],
                                  child: const Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          )
                        ],
                      )
                    : msgModel.replyMsg!.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: onTap,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            msgModel.replyDe == uidDe
                                                ? "Tu"
                                                : msgBloc.contacto!.nombre!,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.70,
                                                child: Text(
                                                  CustomMsg.texto(
                                                      msgModel.replyType!,
                                                      respReply),
                                                  style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              if (msgModel.replyType != 'text')
                                                Icon(
                                                  CustomMsg.reply(
                                                      msgModel.replyType!),
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
                              const SizedBox(
                                height: 5,
                              ),
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 40),
                                    child: Text(
                                      texto,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: prefs.letra.toDouble()),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -1,
                                    right: -1,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          formattedDate,
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 11),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        : Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 35),
                                child: Text(
                                  texto,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: prefs.letra.toDouble()),
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Positioned(
                                bottom: -1,
                                right: 1,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      formattedDate,
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              if (msgModel.enviar!)
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
                          )),
          ],
        ));
  }
}
