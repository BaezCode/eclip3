import 'package:eclips_3/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customChats.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/helpers/delete_dialog.dart';
import 'package:eclips_3/models/msg_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class DrawerChat extends StatefulWidget {
  const DrawerChat({
    Key? key,
  }) : super(key: key);

  @override
  State<DrawerChat> createState() => _DrawerChatState();
}

class _DrawerChatState extends State<DrawerChat> {
  @override
  Widget build(BuildContext context) {
    final msgBloc = BlocProvider.of<MsgBloc>(context);
    final usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    final conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
    List<MsgModel> data = [];
    final sr = AppLocalizations.of(context)!;

    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon: const Icon(
        Icons.more_vert_rounded,
        color: Colors.white,
        size: 20,
      ),
      onSelected: (int selectedValue) async {
        if (selectedValue == 3) {
          final action = await Dialogs.yesAbortDialog(
              context,
              'Bloquear y Reportar',
              'Puedes Bloquear y Reportar a este usuario por comportamiento Abusivo tu contacto sera eliminado de su dispositivo y evaluaremos el posible bloqueo de cuenta del mismo');
          if (action == DialogAction.yes && mounted) {
            CustomWIdgets.loading(context);
            final resp = await conversacionesBloc.deleteChats(
                conversacionesBloc.conversaciones == null
                    ? '0'
                    : conversacionesBloc.conversaciones!.uid,
                msgBloc.contacto!.uid);
            await usuariosBloc.deleteUser(msgBloc.contacto!);
            if (resp) {
              conversacionesBloc.state.conversaciones
                  .remove(conversacionesBloc.conversaciones!);
              conversacionesBloc
                  .add(SetListConv(conversacionesBloc.state.conversaciones));
              // ignore: use_build_context_synchronously
              Navigator.of(context)
                ..pop()
                ..pop();
            } else {
              // ignore: use_build_context_synchronously
              Navigator.of(context)
                ..pop()
                ..pop();
            }
          } else {}
        }
        if (selectedValue == 2) {
          CustomWIdgets.loading(context);
          final resp = await conversacionesBloc.deleteMensajes(msgBloc.para);
          if (resp && mounted) {
            Navigator.pop(context);
            msgBloc.state.messages.clear();
            msgBloc.chats = [];
            msgBloc.add(SetMsgs(msgBloc.state.messages));
            Fluttertoast.showToast(msg: sr.tab17, gravity: ToastGravity.CENTER);
          } else {
            Navigator.pop(context);
            Fluttertoast.showToast(msg: sr.tab5, gravity: ToastGravity.CENTER);
          }
        }
        if (selectedValue == 1) {
          for (var element in msgBloc.state.messages) {
            if (element.type == "text") {
              data.add(element);
            }
          }
          if (mounted) {
            CustomChats.setNameConversaciones(context, data);
          }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              const Icon(
                Icons.save,
                color: Colors.black,
                size: 18,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                sr.tab18,
                style: const TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              const Icon(
                CupertinoIcons.delete,
                color: Colors.black,
                size: 18,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                sr.tab19,
                style: const TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
        const PopupMenuItem(
          value: 3,
          child: Row(
            children: [
              Icon(
                CupertinoIcons.xmark,
                color: Colors.black,
                size: 18,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Reportar y Bloquear',
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
      ],
    );
  }
}
