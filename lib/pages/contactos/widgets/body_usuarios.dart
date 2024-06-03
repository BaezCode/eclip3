import 'package:eclips_3/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customContact.dart';
import 'package:eclips_3/helpers/navegar_fadein.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:eclips_3/pages/chats/chats_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BodyUsuarios extends StatefulWidget {
  final Usuario contacts;
  const BodyUsuarios({super.key, required this.contacts});

  @override
  State<BodyUsuarios> createState() => _BodyUsuariosState();
}

class _BodyUsuariosState extends State<BodyUsuarios> {
  late UsuariosBloc usuariosBloc;
  late MsgBloc msgBloc;
  late ConversacionesBloc conversacionesBloc;

  @override
  void initState() {
    super.initState();
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    msgBloc = BlocProvider.of<MsgBloc>(context);
    conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () async {
        CustomContact.buildContactoDialog(
          context,
          widget.contacts,
        );
      },
      onTap: () {
        conversacionesBloc.conversaciones = null;
        usuariosBloc.add(SetReenviar(false));
        msgBloc.contacto = widget.contacts;
        msgBloc.para = widget.contacts.uid;
        msgBloc.tokenPush = widget.contacts.tokenPush!;
        msgBloc.grupo = false;
        msgBloc.add(SetUidConv(widget.contacts.uid));
        final index = conversacionesBloc.state.conversaciones.indexWhere(
            (element) =>
                element.de == widget.contacts.uid ||
                element.para == widget.contacts.uid);
        if (index == -1) {
          msgBloc.loadChats();
          Navigator.push(
              context,
              navegarFadeIn(
                  context,
                  ChatPage(
                    contactUID: widget.contacts.uid,
                  )));
        } else {
          conversacionesBloc.state.conversaciones[index].badge = false;
          conversacionesBloc
              .add(SetListConv(conversacionesBloc.state.conversaciones));
          msgBloc.loadChats();
          Navigator.push(
              context,
              navegarFadeIn(
                  context,
                  ChatPage(
                    contactUID: widget.contacts.uid,
                  )));
        }
      },
      trailing: widget.contacts.newName != null
          ? Text(widget.contacts.nombre!)
          : null,
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xfff20262e),
            child: Text(
              widget.contacts.newName != null
                  ? widget.contacts.newName![0].toUpperCase()
                  : widget.contacts.nombre![0].toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Positioned(
            bottom: 1,
            child: CircleAvatar(
              radius: 5,
              backgroundColor:
                  widget.contacts.online! ? Colors.green[700] : Colors.red[700],
            ),
          )
        ],
      ),
      subtitle: Text("id: ${widget.contacts.idCorto}"),
      title: Text(
        widget.contacts.newName != null
            ? widget.contacts.newName!
            : widget.contacts.nombre!,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
