import 'dart:async';

import 'package:eclips_3/bloc/llamadas/llamadas_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/socket/socket_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late LoginBloc loginBloc;
  late SocketBloc socketBloc;
  late UsuariosBloc usuarioBloc;
  late LlamadasBloc llamadasBloc;
  final prefs = PreferenciasUsuario();
  FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
    socketBloc = BlocProvider.of<SocketBloc>(context);
    usuarioBloc = BlocProvider.of<UsuariosBloc>(context);
    llamadasBloc = BlocProvider.of<LlamadasBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff20262e),
      body: FutureBuilder(
          future: checkLoginState(),
          builder: (context, snapshot) {
            return Center(
                child: Image.asset(
              'images/logo.png',
              height: 150,
            ));
          }),
    );
  }

  Future checkLoginState() async {
    bool result = await InternetConnectionChecker().hasConnection;
    // final autenticado = await loginBloc.isLoggedIn();
    final token = await storage.read(key: "token") ?? "";

    if (result == false && mounted) {
      Navigator.pushReplacementNamed(context, 'offline');
    } else if (token.isEmpty && mounted) {
      Navigator.pushReplacementNamed(context, 'login');
    } /*else if (mounted) {
      LoginBloc.deletoken();
      Navigator.pushReplacementNamed(context, 'login');
      prefs.activarPin = false;
    } */
    else if (token.isNotEmpty && mounted) {
      Navigator.pushReplacementNamed(context, 'home');
      await socketBloc.connect();
      usuarioBloc.add(SetConectado(result));
    }
  }
}
