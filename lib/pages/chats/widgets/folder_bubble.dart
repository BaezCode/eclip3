import 'dart:convert';

import 'package:bubble/bubble.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customFolder.dart';
import 'package:eclips_3/models/folder_share.dart';
import 'package:eclips_3/models/msg_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FolderBubble extends StatelessWidget {
  final DateTime dateTime;
  final String texto;
  final String uid;
  final int leido;
  final MsgModel? reply;
  final bool isGroup;
  final String? nombre;
  final bool? reenviado;
  final bool? enviado;
  const FolderBubble(
      {super.key,
      required this.dateTime,
      required this.texto,
      required this.uid,
      required this.leido,
      this.reply,
      required this.isGroup,
      this.nombre,
      this.reenviado,
      this.enviado});

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    final decode = jsonDecode(texto);
    final folderShare = FolderShare.fromJson(decode);
    return Container(
      child: uid == loginBloc.usuario!.uid
          ? _myMessage(folderShare, context)
          : _notMyMessage(folderShare, context),
    );
  }

  Widget _myMessage(FolderShare folderShare, BuildContext context) {
    final dateLocal = dateTime.toLocal();
    final String formattedDate = DateFormat('kk:mm').format(dateLocal);
    return BlocBuilder<UsuariosBloc, UsuariosState>(
      builder: (context, state) {
        return Bubble(
          nip: BubbleNip.rightTop,
          padding: const BubbleEdges.all(8.0),
          margin: const BubbleEdges.only(right: 10, bottom: 5, left: 50),
          color: const Color(0xfff20262e),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(5)),
                child: ListTile(
                  trailing: TextButton(
                      onPressed: () {
                        CustomFolder.gestionCompartir(context, folderShare);
                      },
                      child: const Text(
                        "Ver",
                      )),
                  title: Text(
                    folderShare.nombre,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        "Compartido",
                        style: TextStyle(color: Colors.grey[200], fontSize: 13),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        CupertinoIcons.arrowshape_turn_up_right,
                        size: 15,
                        color: Colors.grey[200],
                      ),
                    ],
                  ),
                  leading: const Icon(
                    CupertinoIcons.folder_badge_person_crop,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formattedDate,
                    textAlign: TextAlign.end,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Icon(
                    state.reenviar
                        ? enviado!
                            ? Icons.check_circle_sharp
                            : Icons.circle_outlined
                        : _icons(leido),
                    color: state.reenviar
                        ? enviado!
                            ? const Color.fromARGB(255, 213, 213, 213)
                            : Colors.white
                        : Colors.white,
                    size: 15,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _notMyMessage(FolderShare folderShare, BuildContext context) {
    final dateLocal = dateTime.toLocal();
    final String formattedDate = DateFormat('kk:mm').format(dateLocal);
    return Bubble(
      nip: BubbleNip.leftTop,
      padding: const BubbleEdges.all(8.0),
      margin: const BubbleEdges.only(left: 10, bottom: 10, right: 100),
      color: const Color(0xffE4E5E8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(5)),
            child: ListTile(
              trailing: TextButton(
                  onPressed: () {
                    CustomFolder.gestionCompartir(context, folderShare);
                  },
                  child: const Text(
                    "Ver",
                  )),
              title: Text(folderShare.nombre),
              subtitle: Row(
                children: [
                  Text(
                    "Compartido",
                    style: TextStyle(color: Colors.grey[800], fontSize: 13),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(
                    CupertinoIcons.arrowshape_turn_up_right,
                    size: 15,
                  ),
                ],
              ),
              leading: const Icon(
                CupertinoIcons.folder_badge_person_crop,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            formattedDate,
            textAlign: TextAlign.end,
            style: const TextStyle(color: Colors.black, fontSize: 12),
          ),
        ],
      ),
    );
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
