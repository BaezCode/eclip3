import 'dart:convert';

import 'package:eclips_3/bloc/socket/socket_bloc.dart';
import 'package:eclips_3/bloc/solicitudes/solicitudes_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class SolicitudesPage extends StatefulWidget {
  final List<String> ids;
  const SolicitudesPage({super.key, required this.ids});

  @override
  State<SolicitudesPage> createState() => _SolicitudesPageState();
}

class _SolicitudesPageState extends State<SolicitudesPage> {
  late SolicitudesBloc solicitudesBloc;
  late UsuariosBloc usuariosBloc;
  late SocketBloc socketBloc;

  TextEditingController controller = TextEditingController();
  List<Usuario> usuarios = [];

  @override
  void initState() {
    super.initState();
    solicitudesBloc = BlocProvider.of<SolicitudesBloc>(context);
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    socketBloc = BlocProvider.of<SocketBloc>(context);

    init();
  }

  void init() async {
    solicitudesBloc.add(SetLoadingSolicitudes(true));
    usuarios = await solicitudesBloc.getUsuariosSolicitudes(widget.ids);
    solicitudesBloc.add(SetLoadingSolicitudes(false));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<SolicitudesBloc, SolicitudesState>(
      builder: (context, state) {
        return SizedBox(
          height: size.height * 0.90,
          child: state.loadingSolicitudes
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    _header(),
                    _search(usuarios),
                    if (state.solicitudes.isNotEmpty)
                      Expanded(
                          child: ListView.separated(
                              itemBuilder: (_, i) =>
                                  _contactos(usuarios[i], state),
                              separatorBuilder: (_, i) => const Divider(),
                              itemCount: usuarios.length)),
                  ],
                ),
        );
      },
    );
  }

  Widget _contactos(Usuario contacts, SolicitudesState state) {
    final data = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final index = state.solicitudes.indexWhere((element) =>
        element.de == contacts.uid || element.para == contacts.uid);
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: const Color(0xfff20262e),
            child: Text(
              contacts.nombre![0].toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Positioned(
            bottom: 1,
            child: CircleAvatar(
              radius: 5,
              backgroundColor:
                  contacts.online! ? Colors.green[700] : Colors.red[700],
            ),
          )
        ],
      ),
      title: Text(
        contacts.nombre!,
        style: const TextStyle(color: Colors.black, fontSize: 14),
      ),
      trailing: state.solicitudes[index].de != contacts.uid
          ? const Text('Pendiente')
          : SizedBox(
              width: size.width * 0.25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () async {
                        CustomWIdgets.loading(context);
                        final response = await usuariosBloc.addUser(
                            state.solicitudes[index].uid, contacts);
                        if (response) {
                          socketBloc.socket.emit('solicitudes', {
                            'para': contacts.uid,
                            'type': 'confirm',
                            'solicitudes': jsonEncode(state.solicitudes[index])
                          });
                          state.solicitudes.removeWhere((element) =>
                              element.uid == state.solicitudes[index].uid);
                          solicitudesBloc
                              .add(SetSolicitudesList(state.solicitudes));
                          usuarios.remove(contacts);
                          setState(() {});
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(msg: data.tab178);
                        } else {
                          Navigator.pop(context);
                          Fluttertoast.showToast(msg: data.tab163);
                        }
                      },
                      icon: const Icon(
                        Icons.check,
                        color: Colors.blue,
                      )),
                  IconButton(
                      onPressed: () async {
                        CustomWIdgets.loading(context);

                        final response = await solicitudesBloc
                            .eliminarSolicitud(state.solicitudes[index].uid);
                        if (response) {
                          socketBloc.socket.emit('solicitudes', {
                            'para': contacts.uid,
                            'type': 'delete',
                            'solicitudes': jsonEncode(state.solicitudes[index])
                          });
                          state.solicitudes.removeWhere((element) =>
                              element.uid == state.solicitudes[index].uid);
                          solicitudesBloc
                              .add(SetSolicitudesList(state.solicitudes));
                          usuarios.remove(contacts);
                          setState(() {});
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(msg: data.tab178);
                        } else {
                          Navigator.pop(context);

                          Fluttertoast.showToast(msg: data.tab163);
                        }
                      },
                      icon: const Icon(Icons.cancel_outlined))
                ],
              ),
            ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            " Solicitudes",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar")),
        ],
      ),
    );
  }

  Widget _search(List<Usuario> contactos) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 40,
        child: CupertinoTextField(
          controller: controller,
          onChanged: (value) {
            if (value.isEmpty) {
              setState(() {
                usuarios = solicitudesBloc.state.usuariosSolicitudes;
              });
            } else {
              final list = contactos
                  .where((user) => user.nombre!
                      .toLowerCase()
                      .contains(value.trim().toLowerCase()))
                  .toList();
              setState(() {
                usuarios = list;
              });
            }
          },
          autofocus: false,
          suffix: controller.text.isEmpty
              ? null
              : IconButton(
                  splashColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      controller.clear();
                      usuarios = solicitudesBloc.state.usuariosSolicitudes;
                    });
                  },
                  icon: const Icon(Icons.cancel)),
          prefix: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Icon(CupertinoIcons.search),
          ),
        ),
      ),
    );
  }
}
