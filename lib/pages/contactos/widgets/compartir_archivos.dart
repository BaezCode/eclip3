import 'package:eclips_3/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:eclips_3/bloc/grupos/grupos_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
import 'package:eclips_3/bloc/socket/socket_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/models/msg_model.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class CompartirArchivos extends StatefulWidget {
  final String type;
  final String archivo;
  final List<Usuario> usuarios;

  const CompartirArchivos(
      {super.key,
      required this.archivo,
      required this.type,
      required this.usuarios});

  @override
  State<CompartirArchivos> createState() => _CompartirArchivosState();
}

class _CompartirArchivosState extends State<CompartirArchivos> {
  late UsuariosBloc usuariosBloc;
  late LoginBloc loginBloc;
  late MsgBloc msgBloc;
  late SocketBloc socketBloc;
  late ConversacionesBloc conversacionesBloc;
  late GruposBloc gruposBloc;
  final prefs = PreferenciasUsuario();
  List<Usuario> compartirCon = [];
  List<Usuario> lista = [];
  var uid = const Uuid();
  bool search = false;

  @override
  void initState() {
    super.initState();
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    msgBloc = BlocProvider.of<MsgBloc>(context);
    socketBloc = BlocProvider.of<SocketBloc>(context);
    conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
    gruposBloc = BlocProvider.of<GruposBloc>(context);
    lista.addAll(widget.usuarios);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: compartirCon.isEmpty
            ? null
            : FloatingActionButton(
                backgroundColor: Color(0xfff20262e),
                child: const Icon(Icons.check),
                onPressed: () async {
                  for (var element in compartirCon) {
                    submit(element);
                  }
                  usuariosBloc.add(SetLoading(true));
                  await conversacionesBloc.getConversaciones();
                  usuariosBloc.add(SetLoading(false));
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
                    lista.addAll(widget.usuarios);
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

  void submit(Usuario contacts) async {
    final uidFinal = uid.v4();

    final newMessage = MsgModel(
      replyDe: msgBloc.state.replyDe,
      replyMsg: msgBloc.state.replyMsg,
      replyType: msgBloc.state.replyType,
      leido: 0,
      uid: uidFinal,
      type: widget.type,
      createdAt: DateTime.now().toUtc(),
      tokenPush: msgBloc.grupo == false ? msgBloc.tokenPush : '',
      tokenGroup: msgBloc.grupo == false
          ? []
          : List.generate(gruposBloc.state.usuarios.length,
              (index) => gruposBloc.state.usuarios[index].tokenPush!),
      de: loginBloc.usuario!.uid,
      para: contacts.uid,
      mensaje: widget.archivo,
    );
    CustomWIdgets.loading(context);
    msgBloc.add(SetReplyChat(false, '', '', ''));
    await msgBloc.enviarMensaje(
        newMessage, prefs.timerDelete, usuariosBloc.state.enChat);

    Fluttertoast.showToast(msg: "Enviado Correctamente");
    Navigator.of(context)
      ..pop()
      ..pop();
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
