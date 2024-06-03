import 'package:eclips_3/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:eclips_3/bloc/llamadas/llamadas_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
import 'package:eclips_3/bloc/socket/socket_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/pages/home/widgets/body_home.dart';
import 'package:eclips_3/pages/home/widgets/sin_chats.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late MsgBloc msgBloc;
  late ConversacionesBloc conversacionesBloc;
  late LoginBloc loginBloc;
  late SocketBloc socketBloc;
  late UsuariosBloc usuariosBloc;
  late LlamadasBloc llamadasBloc;
  final prefs = PreferenciasUsuario();

  @override
  void initState() {
    super.initState();
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    msgBloc = BlocProvider.of<MsgBloc>(context);
    conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    socketBloc = BlocProvider.of<SocketBloc>(context);
    inicial();
  }

  inicial() async {
    conversacionesBloc.add(LoadingConv(true));
    await conversacionesBloc.getConversaciones();
    conversacionesBloc.add(LoadingConv(false));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversacionesBloc, ConversacionesState>(
      builder: (context, state) {
        return state.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : state.conversaciones.isEmpty
                ? const SinChats()
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.conversaciones.length,
                    itemBuilder: (_, i) {
                      final id =
                          state.conversaciones[i].de == loginBloc.usuario!.uid
                              ? state.conversaciones[i].para
                              : state.conversaciones[i].de;
                      final resp = usuariosBloc.state.usuarios
                          .indexWhere((element) => element.uid == id);
                      if (resp == -1) {
                        return const Center();
                      } else {
                        final usuario = usuariosBloc.state.usuarios[resp];
                        return BodyHome(
                            conversaciones: state.conversaciones[i],
                            usuario: usuario,
                            index: i);
                      }
                    },
                  );
      },
    );
  }
}
