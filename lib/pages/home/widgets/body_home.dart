import 'package:eclips_3/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customContact.dart';
import 'package:eclips_3/helpers/navegar_fadein.dart';
import 'package:eclips_3/models/conversaciones.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:eclips_3/pages/chats/chats_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class BodyHome extends StatelessWidget {
  final Conversaciones conversaciones;
  final Usuario usuario;
  final int index;
  const BodyHome(
      {super.key,
      required this.conversaciones,
      required this.usuario,
      required this.index});

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    final conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
    final msgBloc = BlocProvider.of<MsgBloc>(context);
    final usuarioBloc = BlocProvider.of<UsuariosBloc>(context);
    return ListTile(
      onLongPress: () {
        CustomContact.buildChatDialog(context, usuario, conversaciones);
      },
      onTap: () async {
        conversacionesBloc.conversaciones = conversaciones;
        usuarioBloc.add(SetReenviar(false));
        msgBloc.contacto = usuario;
        msgBloc.para = usuario.uid;
        msgBloc.tokenPush = usuario.tokenPush!;
        msgBloc.grupo = false;
        msgBloc.add(SetUidConv(usuario.uid));
        msgBloc.loadChats();
        Navigator.push(
            context, navegarFadeIn(context, ChatPage(contactUID: usuario.uid)));
        conversacionesBloc.state.conversaciones[index].badge = false;
        conversacionesBloc
            .add(SetListConv(conversacionesBloc.state.conversaciones));
      },
      leading: CircleAvatar(
        backgroundColor: const Color(0xfff20262e),
        child: Text(
          usuario.nombre![0].toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (conversaciones.lastMsgUid != loginBloc.usuario!.uid &&
              conversaciones.badge)
            LottieBuilder.asset(
              'images/info.json',
              height: 30,
            ),
          const SizedBox(
            height: 2,
          ),
          Text(_retunDate(conversaciones.updatedAt.toLocal()))
        ],
      ),
      title: Text(
        usuario.newName != null ? usuario.newName! : usuario.nombre!,
        style: const TextStyle(color: Colors.black, fontSize: 14),
      ),
      subtitle: const Text(
        '*****',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

String _retunDate(DateTime dateTime) {
  final date2 = DateTime.now();
  final difference = dateTime.difference(date2).inDays;
  String formattedDate = DateFormat('kk:mm').format(dateTime);
  String formattedDateMon = DateFormat('dd/MM/yyyy').format(dateTime);
  switch (difference) {
    case 0:
      return formattedDate;
    case 1:
      return 'Ayer';
    case 3:
      return formattedDateMon;
    default:
      return formattedDateMon;
  }
}
