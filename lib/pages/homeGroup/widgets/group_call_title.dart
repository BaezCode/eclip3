import 'package:animate_do/animate_do.dart';
import 'package:eclips_3/models/grupo_model.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:flutter/material.dart';

class AppbarTittleCall extends StatelessWidget {
  final Grupo server;
  final List<Usuario> lista;

  const AppbarTittleCall(
      {super.key, required this.server, required this.lista});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: lista.isEmpty
          ? null
          : Text(
              "Users: ",
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey[700],
        child: CircleAvatar(
            backgroundColor: const Color(0xfff20262e),
            child: Text(
              server.nombre[0].toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            )),
      ),
      title: FadeIn(
        child: Text(server.nombre,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 13)),
      ),
    );
  }
}
