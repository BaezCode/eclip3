import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class EnLlamadaBody extends StatelessWidget {
  final Usuario usuario;
  const EnLlamadaBody({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    return ListTile(
      leading: ClipOval(
        child: Container(
          color: usuario.estadoCall == "Escuchando"
              ? Colors.transparent
              : Colors.green[700],
          child: LottieBuilder.asset(
            repeat: false,
            'images/skull.json',
          ),
        ),
      ),
      title: Text(
        usuario.nombre! == loginBloc.usuario!.nombre ? "TÚ" : usuario.nombre!,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
      subtitle: const Text(
        "Users",
        style: TextStyle(color: Colors.white),
      ),
      trailing: const Icon(
        Icons.mic,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}
