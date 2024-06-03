import 'dart:convert';

import 'package:bubble/bubble.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
import 'package:eclips_3/bloc/socket/socket_bloc.dart';
import 'package:eclips_3/bloc/solicitudes/solicitudes_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customMsg.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/models/msg_model.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class ContactoBubble extends StatelessWidget {
  final MsgModel msgModel;
  final MsgBloc msgBloc;
  final Function()? onTap;

  const ContactoBubble(
      {super.key, required this.msgModel, required this.msgBloc, this.onTap});

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    return Container(
      child: msgModel.de == loginBloc.usuario!.uid
          ? _myMessage(context, loginBloc, loginBloc.usuario!.uid)
          : _notMyMessage(context, loginBloc, loginBloc.usuario!.uid),
    );
  }

  Widget _myMessage(BuildContext context, LoginBloc loginBloc, String uidDe) {
    final prefs = PreferenciasUsuario();
    final dateLocal = msgModel.createdAt.toLocal();
    final socketBloc = BlocProvider.of<SocketBloc>(context);
    final solicitudesBloc = BlocProvider.of<SolicitudesBloc>(context);
    final data = AppLocalizations.of(context)!;
    String formattedDate = DateFormat('kk:mm').format(dateLocal);
    final size = MediaQuery.of(context).size;

    String respReply = '';
    if (msgModel.replyMsg!.isNotEmpty && msgModel.replyType == 'text') {
      respReply = msgBloc.decryptmesaje(msgModel.replyMsg!);
    }

    return BlocBuilder<UsuariosBloc, UsuariosState>(
      builder: (context, state) {
        return Bubble(
          nip: BubbleNip.rightBottom,
          padding: const BubbleEdges.all(8.0),
          margin: const BubbleEdges.only(right: 10, bottom: 10, left: 50),
          color: const Color(0xfff20262e),
          child: Column(
            children: [
              if (msgModel.replyMsg!.isNotEmpty) ...[
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              msgModel.replyDe == uidDe
                                  ? "Tu"
                                  : msgBloc.contacto!.nombre!,
                              style: const TextStyle(color: Colors.white),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: size.width * 0.70,
                                  child: Text(
                                    CustomMsg.texto(
                                        msgModel.replyType!, respReply),
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.white),
                                  ),
                                ),
                                if (msgModel.replyType != 'text')
                                  Icon(
                                    CustomMsg.reply(msgModel.replyType!),
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
              ],
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue[700],
                    child: Text(
                      msgModel.nombre![0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    msgModel.nombre!,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white, fontSize: prefs.letra.toDouble()),
                  ),
                  const Spacer(),
                  Text(
                    formattedDate,
                    textAlign: TextAlign.end,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                  const SizedBox(
                    width: 5,
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
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
              const Divider(
                color: Colors.white,
              ),
              TextButton(
                  onPressed: () async {
                    CustomWIdgets.loading(context);
                    final response = await solicitudesBloc.enviarSolicitud(
                        loginBloc.usuario!.uid, msgModel.mensaje);

                    if (response != null) {
                      // ignore: use_build_context_synchronously
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                      socketBloc.socket.emit('solicitudes', {
                        'para': response.para,
                        'type': 'add',
                        'solicitudes': jsonEncode(response)
                      });
                      Fluttertoast.showToast(
                          gravity: ToastGravity.CENTER, msg: data.tab178);
                    } else {
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                          gravity: ToastGravity.CENTER, msg: prefs.msgError);
                    }
                  },
                  child: const Text("Adicionar"))
            ],
          ),
        );
      },
    );
  }

  Widget _notMyMessage(
      BuildContext context, LoginBloc loginBloc, String uidDe) {
    final prefs = PreferenciasUsuario();
    final dateLocal = msgModel.createdAt.toLocal();
    final socketBloc = BlocProvider.of<SocketBloc>(context);
    final solicitudesBloc = BlocProvider.of<SolicitudesBloc>(context);
    final data = AppLocalizations.of(context)!;
    String formattedDate = DateFormat('kk:mm').format(dateLocal);
    final size = MediaQuery.of(context).size;
    String respReply = '';
    if (msgModel.replyMsg!.isNotEmpty && msgModel.replyType == 'text') {
      respReply = msgBloc.decryptmesaje(msgModel.replyMsg!);
    }

    return Bubble(
      nip: BubbleNip.leftTop,
      padding: const BubbleEdges.all(8.0),
      margin: const BubbleEdges.only(left: 10, bottom: 10, right: 50),
      color: Colors.blueGrey[50],
      child: Column(
        children: [
          if (msgModel.replyMsg!.isNotEmpty) ...[
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          msgModel.replyDe == uidDe
                              ? "Tu"
                              : msgBloc.contacto!.nombre!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.70,
                              child: Text(
                                CustomMsg.texto(msgModel.replyType!, respReply),
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white),
                              ),
                            ),
                            if (msgModel.replyType != 'text')
                              Icon(
                                CustomMsg.reply(msgModel.replyType!),
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
          ],
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue[700],
                child: Text(
                  msgModel.nombre![0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                msgModel.nombre!,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black, fontSize: prefs.letra.toDouble()),
              ),
              const Spacer(),
              Text(
                formattedDate,
                textAlign: TextAlign.end,
                style: const TextStyle(color: Colors.black, fontSize: 11),
              ),
              const SizedBox(
                width: 5,
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
          ),
          const Divider(
            color: Colors.black,
          ),
          TextButton(
              onPressed: () async {
                CustomWIdgets.loading(context);
                final response = await solicitudesBloc.enviarSolicitud(
                    loginBloc.usuario!.uid, msgModel.mensaje);

                if (response != null) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();

                  socketBloc.socket.emit('solicitudes', {
                    'para': response.para,
                    'type': 'add',
                    'solicitudes': jsonEncode(response)
                  });
                  Fluttertoast.showToast(
                      gravity: ToastGravity.CENTER, msg: data.tab178);
                } else {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                      gravity: ToastGravity.CENTER, msg: prefs.msgError);
                }
              },
              child: const Text("Adicionar"))
        ],
      ),
    );
  }
}
