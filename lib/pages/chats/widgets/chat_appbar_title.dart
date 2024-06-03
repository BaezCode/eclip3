import 'package:animate_do/animate_do.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppbarTittle extends StatelessWidget {
  final Usuario usuario;
  const AppbarTittle({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsuariosBloc, UsuariosState>(
      builder: (context, state) {
        return ListTile(
          subtitle: state.enChat == false
              ? null
              : const Text(
                  "En Linea",
                  style: TextStyle(color: Colors.white),
                ),
          leading: Stack(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: Colors.grey[700],
                child: Text(
                  usuario.nombre![0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              Positioned(
                left: 1,
                bottom: 1,
                child: CircleAvatar(
                  radius: 4,
                  backgroundColor:
                      state.enChat ? Colors.green[700] : Colors.red[700],
                ),
              )
            ],
          ),
          title: FadeIn(
            child: Text(
                usuario.newName != null ? usuario.newName! : usuario.nombre!,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
          ),
        );
      },
    );
  }
}
