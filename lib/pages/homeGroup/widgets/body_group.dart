import 'dart:convert';

import 'package:eclips_3/bloc/grupos/grupos_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
import 'package:eclips_3/helpers/customGroup.dart';
import 'package:eclips_3/models/grupo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BodyGroup extends StatelessWidget {
  final Grupo grupo;
  const BodyGroup({super.key, required this.grupo});

  @override
  Widget build(BuildContext context) {
    final msgBloc = BlocProvider.of<MsgBloc>(context);
    final gruposBloc = BlocProvider.of<GruposBloc>(context);
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    String formattedDate = DateFormat('kk:mm').format(grupo.updatedAt);
    final respuesta = grupo.leido.contains(loginBloc.usuario!.uid);

    return ListTile(
      tileColor: respuesta == false ? Colors.red[700] : Colors.transparent,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (respuesta == false)
            const CircleAvatar(
              radius: 10,
              child: Text(
                '!',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          const SizedBox(
            height: 2,
          ),
          Text(formattedDate)
        ],
      ),
      onLongPress: () {
        CustomGroup.buildGroupDialog(context, grupo);
      },
      onTap: () {
        msgBloc.para = grupo.uid;
        msgBloc.tokenPush = 'sera';
        msgBloc.grupo = true;
        msgBloc.loadChats();
        gruposBloc.add(SetGrupo(grupo));
        Navigator.pushNamed(context, 'chatGrupo');
      },
      subtitle: const Text(
        '*****',
        style: TextStyle(color: Colors.black),
      ),
      title: Text(grupo.nombre),
      leading: grupo.img.isNotEmpty
          ? CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: MemoryImage(base64Decode(grupo.img)),
            )
          : CircleAvatar(
              backgroundColor: const Color(0xfff20262e),
              child: Text(
                grupo.nombre[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
    );
  }
}
