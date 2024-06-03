import 'dart:convert';

import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/socket/socket_bloc.dart';
import 'package:eclips_3/bloc/solicitudes/solicitudes_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customContact.dart';
import 'package:eclips_3/models/solicitudes_model.dart';
import 'package:eclips_3/pages/contactos/widgets/body_usuarios.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class ContactosPage extends StatefulWidget {
  const ContactosPage({super.key});

  @override
  State<ContactosPage> createState() => _ContactosPageState();
}

class _ContactosPageState extends State<ContactosPage> {
  late LoginBloc loginBloc;
  late SolicitudesBloc solicitudesBloc;
  late SocketBloc socketBloc;
  late UsuariosBloc usuariosBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
    solicitudesBloc = BlocProvider.of<SolicitudesBloc>(context);
    socketBloc = BlocProvider.of<SocketBloc>(context);
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    socketBloc.socket.on('solicitudes', _escuchar);
    init();
  }

  void init() async {
    loginBloc.add(Loading(true));
    await solicitudesBloc.getSolicitudes();
    loginBloc.add(Loading(false));
  }

  void _escuchar(payload) async {
    final solicitud = Solicitudes.fromJson(jsonDecode(payload['solicitudes']));
    if (payload['type'] == 'confirm') {
      loginBloc.add(Loading(true));
      await usuariosBloc.getUsuarios();
      loginBloc.add(Loading(false));
      solicitudesBloc.state.solicitudes
          .removeWhere((element) => element.uid == solicitud.uid);
    } else if (payload['type'] == 'add') {
      solicitudesBloc.state.solicitudes.add(solicitud);
    } else {}
    solicitudesBloc.add(SetSolicitudesList(solicitudesBloc.state.solicitudes));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsuariosBloc, UsuariosState>(
      builder: (context, state) {
        return state.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : loginBloc.usuario!.groupCall == false
                ? _listviewUsuarios(state)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ListTile(
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15,
                        ),
                        leading: const CircleAvatar(
                            backgroundColor: Color(0xfff20262e),
                            child: Icon(
                              Icons.group,
                              color: Colors.white,
                            )),
                        title: const Text(
                          "Nuevo Grupo",
                          style: TextStyle(fontSize: 14),
                        ),
                        onTap: () => CustomContact.buildNewGroup(context),
                      ),
                      BlocBuilder<SolicitudesBloc, SolicitudesState>(
                        builder: (context, state) {
                          return state.solicitudes.isEmpty
                              ? const Center()
                              : ListTile(
                                  trailing: LottieBuilder.asset(
                                    'images/info.json',
                                    height: 30,
                                  ),
                                  leading: const CircleAvatar(
                                      backgroundColor: Color(0xfff20262e),
                                      child: Icon(
                                        Icons.group_add,
                                        color: Colors.white,
                                        size: 18,
                                      )),
                                  title: const Text(
                                    "Solicitudes",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  onTap: () {
                                    List<String> lista = [];
                                    for (var element in state.solicitudes) {
                                      if (element.de ==
                                          loginBloc.usuario!.uid) {
                                        lista.add(element.para);
                                      } else {
                                        lista.add(element.de);
                                      }
                                    }
                                    CustomContact.buildSolicitudes(
                                        context, lista);
                                  });
                        },
                      ),
                      const Divider(),
                      Expanded(child: _listviewUsuarios(state)),
                    ],
                  );
      },
    );
  }

  ListView _listviewUsuarios(UsuariosState state) {
    return ListView.separated(
        itemBuilder: (_, i) => BodyUsuarios(contacts: state.usuarios[i]),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: state.usuarios.length);
  }

  @override
  void dispose() {
    super.dispose();
    socketBloc.socket.off('solicitudes');
  }
}
