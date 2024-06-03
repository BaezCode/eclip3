import 'dart:convert';
import 'dart:math';

import 'package:eclips_3/bloc/llamadas/llamadas_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/socket/socket_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class CustomCallInvite {
  CustomCallInvite._();

  static buildListCall(
    BuildContext context,
    List<Usuario> compart,
  ) {
    final size = MediaQuery.of(context).size;
    final socketBloc = BlocProvider.of<SocketBloc>(context);
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    final llamadasBloc = BlocProvider.of<LlamadasBloc>(context);

    final prefs = PreferenciasUsuario();
    var rng = Random();
    var uuid = const Uuid();
    List<Usuario> nuevaLista = compart;
    final data = AppLocalizations.of(context)!;

    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      context: context,
      builder: (context) {
        return SizedBox(
          height: size.height * 1.0,
          child: StatefulBuilder(
            builder: (ctx, setState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          data.tab122,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search,
                            )),
                        if (nuevaLista.isNotEmpty)
                          IconButton(
                              onPressed: () async {
                                final uidFinal = uuid.v4();
                                for (var element in nuevaLista) {
                                  socketBloc.socket.emit('mensaje-personal', {
                                    "de": loginBloc.usuario!.uid,
                                    "para": element.uid,
                                    "leido": 1,
                                    "uid": uidFinal,
                                    "lista": jsonEncode(nuevaLista),
                                    "name": loginBloc.usuario!.nombre,
                                    "isSingle": 'false',
                                    "mensaje": 'texto',
                                    "callToken": llamadasBloc.callToken,
                                    "channelId": llamadasBloc.channelId,
                                    'subMsg': '',
                                    "tokenPush": element.tokenPush,
                                    "type": 'Llamada',
                                    "timer": prefs.timerDelete
                                  });
                                }

                                Navigator.pop(context);

                                Fluttertoast.showToast(msg: "Enviado");
                              },
                              icon: const Icon(
                                Icons.check,
                              )),
                      ],
                    ),
                  ),
                  Divider(),
                  BlocBuilder<UsuariosBloc, UsuariosState>(
                    builder: (context, state) {
                      return Expanded(
                        child: ListView.separated(
                          separatorBuilder: (_, i) => const Divider(),
                          itemCount: state.usuarios.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (_, i) {
                            if (nuevaLista.contains(state.usuarios[i])) {
                            } else {
                              final contacts = state.usuarios[i];
                              return ListTile(
                                trailing: Icon(
                                  nuevaLista.contains(contacts)
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color: Colors.black,
                                ),
                                leading: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundColor: const Color(0xfff20262e),
                                      child: Text(
                                        contacts.nombre![0].toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 1,
                                      child: CircleAvatar(
                                        radius: 5,
                                        backgroundColor: contacts.online!
                                            ? Colors.green[700]
                                            : Colors.red[700],
                                      ),
                                    )
                                  ],
                                ),
                                title: Text(
                                  contacts.nombre!,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                onTap: () {
                                  final resp = nuevaLista.contains(contacts);
                                  if (resp) {
                                    nuevaLista.remove(contacts);
                                    setState(() {});
                                  } else {
                                    contacts.uidCall = rng.nextInt(10000);
                                    nuevaLista.add(contacts);
                                    setState(() {});
                                  }
                                },
                              );
                            }
                            return null;
                          },
                        ),
                      );
                    },
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
