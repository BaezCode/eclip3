import 'dart:convert';

import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
import 'package:eclips_3/bloc/notes/notes_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/models/folder_share.dart';
import 'package:eclips_3/models/msg_model.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:uuid/uuid.dart';

class CompartirFolder extends StatefulWidget {
  const CompartirFolder({super.key});

  @override
  State<CompartirFolder> createState() => _CompartirFolderState();
}

class _CompartirFolderState extends State<CompartirFolder> {
  late UsuariosBloc usuariosBloc;
  late LoginBloc loginBloc;
  late MsgBloc msgBloc;
  late NotesBloc notesBloc;
  List<Usuario> compartirCon = [];
  List<Usuario> lista = [];
  bool search = false;
  var uid = const Uuid();

  @override
  void initState() {
    super.initState();
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    msgBloc = BlocProvider.of<MsgBloc>(context);
    notesBloc = BlocProvider.of<NotesBloc>(context);
    lista.addAll(usuariosBloc.state.usuarios);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: compartirCon.isEmpty
            ? null
            : FloatingActionButton(
                backgroundColor: const Color(0xfff20262e),
                child: const Icon(Icons.check),
                onPressed: () async {
                  CustomWIdgets.loading(context);
                  final folderShare = FolderShare(
                      nombre: notesBloc.state.nombreCompartir,
                      archives: notesBloc.state.compartirFolders);
                  for (var element in compartirCon) {
                    final uidFinal = uid.v4();
                    final newMessage = MsgModel(
                        replyDe: msgBloc.state.replyDe,
                        replyMsg: msgBloc.state.replyMsg,
                        replyType: msgBloc.state.replyType,
                        leido: 0,
                        uid: uidFinal,
                        type: 'folder',
                        createdAt: DateTime.now().toUtc(),
                        de: loginBloc.usuario!.uid,
                        para: element.uid,
                        mensaje: jsonEncode(folderShare),
                        tokenPush: element.tokenPush,
                        tokenGroup: []);
                    await msgBloc.enviarMensaje(
                        newMessage, 86400, usuariosBloc.state.enChat);
                  }
                  // ignore: use_build_context_synchronously
                  notesBloc.clearALL();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                  Fluttertoast.showToast(msg: "Enviado Correctamente");
                }),
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  if (search) {
                    setState(() {
                      search = false;
                    });
                    lista.clear();
                    lista.addAll(usuariosBloc.state.usuarios);
                  } else {
                    setState(() {
                      search = true;
                    });
                  }
                },
                icon: Icon(
                  search ? Icons.cancel_outlined : CupertinoIcons.search,
                  size: 18,
                  color: Colors.white,
                )),
            if (compartirCon.isNotEmpty)
              IconButton(
                  onPressed: () {
                    compartirCon = [];
                    setState(() {});
                  },
                  icon: const Icon(
                    CupertinoIcons.delete,
                    size: 18,
                  ))
          ],
          centerTitle: false,
          title: search
              ? _buildSearch(lista)
              : Text(
                  compartirCon.length == 1
                      ? "Compartir Con : ${compartirCon.length} Contacto"
                      : "Compartir Con : ${compartirCon.length} Contactos",
                  style: const TextStyle(fontSize: 15),
                ),
          backgroundColor: const Color(0xfff20262e),
        ),
        body: _listviewUsuarios());
  }

  ListView _listviewUsuarios() {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, i) => _body(lista[i]),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: lista.length);
  }

  Widget _body(Usuario contacts) {
    return ListTile(
      trailing: Icon(
        compartirCon.contains(contacts)
            ? Icons.check_circle
            : Icons.circle_outlined,
        color: Colors.black,
      ),
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xfff20262e),
            child: Text(
              contacts.newName != null
                  ? contacts.newName![0].toUpperCase()
                  : contacts.nombre![0].toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 1,
            child: CircleAvatar(
              radius: 7,
              backgroundColor:
                  contacts.online! ? Colors.green[700] : Colors.red[700],
            ),
          )
        ],
      ),
      title: Text(
        contacts.newName != null ? contacts.newName! : contacts.nombre!,
        style: const TextStyle(color: Colors.black),
      ),
      onTap: () {
        final resp = compartirCon.contains(contacts);
        if (resp) {
          compartirCon.remove(contacts);
          setState(() {});
        } else {
          compartirCon.add(contacts);
          setState(() {});
        }
      },
    );
  }

  Widget _buildSearch(List<Usuario> usuarios) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        onFieldSubmitted: (value) {
          final list = usuarios
              .where((user) => user.nombre!
                  .toLowerCase()
                  .contains(value.trim().toLowerCase()))
              .toList();
          lista.clear();
          lista.addAll(list);
          setState(() {});
        },
        autofocus: true,
        style: TextStyle(color: Colors.white),
        decoration: const InputDecoration(),
      ),
    );
  }
}
