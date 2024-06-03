import 'dart:convert';

import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
import 'package:eclips_3/helpers/customContact.dart';
import 'package:eclips_3/helpers/customMsg.dart';
import 'package:eclips_3/models/msg_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ImagesBubble extends StatelessWidget {
  final MsgBloc msgBloc;
  final MsgModel msgModel;
  final String texto;
  final bool isGroup;
  final bool? reenviar;
  final Function()? onTap;

  const ImagesBubble({
    Key? key,
    req,
    required this.texto,
    required this.isGroup,
    this.reenviar,
    required this.msgBloc,
    required this.msgModel,
    this.onTap,
  }) : super(key: key);

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
    final size = MediaQuery.of(context).size;
    final image = base64Decode(texto);
    final dateLocal = msgModel.createdAt.toLocal();
    String formattedDate = DateFormat('kk:mm').format(dateLocal);
    String respReply = '';
    if (msgModel.replyMsg!.isNotEmpty && msgModel.replyType == 'text') {
      respReply = msgBloc.decryptmesaje(msgModel.replyMsg!);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () {
              final index = msgBloc.state.messages
                  .indexWhere((element) => element.uid == msgModel.uid);
              msgBloc.state.messages[index].enviar = true;
              msgBloc.add(SetMsgs(msgBloc.state.messages));
              CustomContact.buildReenviar(context);
            },
            icon: const Icon(
              CupertinoIcons.arrowshape_turn_up_right_fill,
              color: Colors.white,
            )),
        GestureDetector(
            onTap: reenviar!
                ? null
                : () {
                    Navigator.pushNamed(
                      context,
                      'imageshow',
                      arguments: image,
                    );
                  },
            child: Align(
                alignment: Alignment.centerRight,
                child: Column(
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
                              "Reenviado de: ${msgModel.nombre}",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.only(
                            right: 5, bottom: 5, left: 50),
                        decoration: BoxDecoration(
                            color: const Color(0xfff20262e),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            if (msgModel.replyMsg!.isNotEmpty)
                              GestureDetector(
                                onTap: onTap,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey[850]),
                                  height: 50,
                                  width: size.width * 0.55,
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
                                                width: size.width * 0.45,
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
                                              if (msgModel.replyType !=
                                                  'text') ...[
                                                Icon(
                                                  CustomMsg.reply(
                                                      msgModel.replyType!),
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
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.asset(
                                    'images/locked.png',
                                    fit: BoxFit.cover,
                                    width: size.width * 0.55,
                                    height: size.height * 0.30,
                                  ),
                                ),
                                Positioned(
                                    bottom: 5,
                                    right: 7,
                                    child: Row(
                                      children: [
                                        Text(
                                          formattedDate,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Icon(
                                          reenviar!
                                              ? msgModel.enviar!
                                                  ? Icons.check_circle_sharp
                                                  : Icons.circle_outlined
                                              : _icons(msgModel.leido),
                                          color: reenviar!
                                              ? msgModel.enviar!
                                                  ? Colors.blue[700]
                                                  : Colors.green
                                              : Colors.green,
                                          size: 15,
                                        ),
                                      ],
                                    )),
                              ],
                            )
                          ],
                        )),
                  ],
                )))
      ],
    );
  }

  Widget _notMyMessage(BuildContext context, String uidDe) {
    final size = MediaQuery.of(context).size;
    final image = base64Decode(texto);
    final dateLocal = msgModel.createdAt.toLocal();
    String formattedDate = DateFormat('kk:mm').format(dateLocal);
    String respReply = '';
    if (msgModel.replyMsg!.isNotEmpty && msgModel.replyType == 'text') {
      respReply = msgBloc.decryptmesaje(msgModel.replyMsg!);
    }

    return GestureDetector(
        onTap: reenviar!
            ? null
            : () {
                Navigator.pushNamed(
                  context,
                  'imageshow',
                  arguments: image,
                );
              },
        child: Align(
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
                          "Reenviado de: ${msgModel.nombre}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                Container(
                    padding: const EdgeInsets.all(8.0),
                    margin:
                        const EdgeInsets.only(left: 5, bottom: 5, right: 50),
                    decoration: BoxDecoration(
                        color: const Color(0xffE4E5E8),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        if (msgModel.replyMsg!.isNotEmpty)
                          GestureDetector(
                            onTap: onTap,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey[850]),
                              height: 50,
                              width: size.width * 0.55,
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
                                        msgModel.replyDe == uidDe
                                            ? "Tu"
                                            : msgBloc.contacto!.nombre!,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.45,
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
                                          if (msgModel.replyType != 'text') ...[
                                            Icon(
                                              CustomMsg.reply(
                                                  msgModel.replyType!),
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
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                'images/locked.png',
                                fit: BoxFit.cover,
                                width: size.width * 0.55,
                                height: size.height * 0.30,
                              ),
                            ),
                            Positioned(
                                bottom: 3,
                                right: 7,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (isGroup) ...[
                                      Text(
                                        msgModel.nombre!,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.blue[700],
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                    Text(
                                      formattedDate,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                )),
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
                        ),
                      ],
                    )),
              ],
            )));
  }

  IconData _icons(int leido) {
    switch (leido) {
      case 0:
        return Icons.access_time_outlined;
      case 2:
        return Icons.remove_red_eye_sharp;
      case 1:
        return Icons.panorama_fish_eye_sharp;
      default:
        return Icons.abc;
    }
  }
}
