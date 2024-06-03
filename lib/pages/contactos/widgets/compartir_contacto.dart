import 'package:eclips_3/bloc/grupos/grupos_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
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

class CompartirContacto extends StatefulWidget {
  const CompartirContacto({super.key});

  @override
  State<CompartirContacto> createState() => _CompartirContactoState();
}

class _CompartirContactoState extends State<CompartirContacto> {
  late UsuariosBloc usuariosBloc;
  late MsgBloc msgBloc;
  late LoginBloc loginBloc;
  late GruposBloc gruposBloc;
  List<Usuario> contactosAdicionados = [];
  List<Usuario> usuarios = [];
  TextEditingController controller = TextEditingController();
  var uid = const Uuid();
  final prefs = PreferenciasUsuario();

  @override
  void initState() {
    super.initState();
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    msgBloc = BlocProvider.of<MsgBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    gruposBloc = BlocProvider.of<GruposBloc>(context);
    usuarios.addAll(usuariosBloc.state.usuarios);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.90,
      child: Column(
        children: [
          _header(),
          _search(usuarios),
          Expanded(
              child: ListView.separated(
                  itemBuilder: (_, i) => _contactos(usuarios[i]),
                  separatorBuilder: (_, i) => const Divider(),
                  itemCount: usuarios.length)),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar")),
        TextButton(
            onPressed: contactosAdicionados.isEmpty
                ? null
                : () async {
                    CustomWIdgets.loading(context);
                    final uidFinal = uid.v4();
                    for (var element in contactosAdicionados) {
                      final data = MsgModel(
                          replyDe: msgBloc.state.replyDe,
                          replyMsg: msgBloc.state.replyMsg,
                          replyType: msgBloc.state.replyType,
                          nombre: element.nombre,
                          type: 'contacto',
                          mensaje: element.idCorto!,
                          createdAt: DateTime.now(),
                          de: loginBloc.usuario!.uid,
                          tokenPush:
                              msgBloc.grupo == false ? msgBloc.tokenPush : '',
                          tokenGroup: msgBloc.grupo == false
                              ? []
                              : List.generate(
                                  gruposBloc.state.usuarios.length,
                                  (index) => gruposBloc
                                      .state.usuarios[index].tokenPush!),
                          para: msgBloc.para,
                          leido: 0,
                          uid: uidFinal);
                      await msgBloc.addChats(data, false);
                      await msgBloc.enviarMensaje(
                          data, prefs.timerDelete, usuariosBloc.state.enChat);
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.of(context)
                      ..pop()
                      ..pop();
                    Fluttertoast.showToast(msg: "Contactos Compartidos");
                  },
            child: const Text("Confirmar."))
      ],
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
                usuarios = usuariosBloc.state.usuarios;
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
                      usuarios = usuariosBloc.state.usuarios;
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

  Widget _contactos(Usuario contacts) {
    return ListTile(
      onTap: () {
        if (contactosAdicionados.contains(contacts)) {
          contactosAdicionados.remove(contacts);
        } else {
          contactosAdicionados.add(contacts);
        }
        setState(() {});
      },
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: const Color(0xfff20262e),
            child: Text(
              contacts.newName != null
                  ? contacts.newName![0].toUpperCase()
                  : contacts.nombre![0].toUpperCase(),
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
        contacts.newName != null ? contacts.newName! : contacts.nombre!,
        style: const TextStyle(color: Colors.black, fontSize: 14),
      ),
      trailing: Icon(
        contactosAdicionados.contains(contacts)
            ? Icons.circle_rounded
            : Icons.circle_outlined,
      ),
    );
  }
}
