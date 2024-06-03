import 'package:eclips_3/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:eclips_3/bloc/llamadas/llamadas_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/helpers/navegar_fadein.dart';
import 'package:eclips_3/models/calls_model.dart';
import 'package:eclips_3/pages/chats/chats_page.dart';
import 'package:eclips_3/pages/chats/widgets/call_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CallsHistory extends StatefulWidget {
  final Call call;
  const CallsHistory({super.key, required this.call});

  @override
  State<CallsHistory> createState() => _CallsHistoryState();
}

class _CallsHistoryState extends State<CallsHistory> {
  late LoginBloc loginBloc;
  late LlamadasBloc llamadasBloc;
  late MsgBloc msgBloc;
  late ConversacionesBloc conversacionesBloc;
  late UsuariosBloc usuariosBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
    llamadasBloc = BlocProvider.of<LlamadasBloc>(context);
    msgBloc = BlocProvider.of<MsgBloc>(context);
    conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              conversacionesBloc.conversaciones = null;
              usuariosBloc.add(SetReenviar(false));
              msgBloc.contacto = widget.call.usuario;
              msgBloc.para = widget.call.usuario!.uid;
              msgBloc.tokenPush = widget.call.usuario!.tokenPush!;
              msgBloc.grupo = false;
              msgBloc.add(SetUidConv(widget.call.usuario!.uid));
              final index = conversacionesBloc.state.conversaciones.indexWhere(
                  (element) =>
                      element.de == widget.call.usuario!.uid ||
                      element.para == widget.call.usuario!.uid);
              if (index == -1) {
                msgBloc.loadChats();
                Navigator.push(
                    context,
                    navegarFadeIn(
                        context,
                        ChatPage(
                          contactUID: widget.call.usuario!.uid,
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
                          contactUID: widget.call.usuario!.uid,
                        )));
              }
            },
            icon: const Icon(Icons.chat),
          ),
          IconButton(
              onPressed: () async {
                CustomWIdgets.loading(context);
                final resp = await llamadasBloc.deleteCalls(widget.call.uid);
                if (resp && mounted) {
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                  return;
                } else {
                  Navigator.pop(context);
                  return;
                }
              },
              icon: const Icon(Icons.delete))
        ],
        backgroundColor: const Color(0xfff20262e),
        title: const Text("info. de llamada"),
      ),
      body: Column(
        children: [
          ListTile(
            trailing: IconButton(
                onPressed: () async {
                  CustomWIdgets.loading(context);
                  llamadasBloc.nombre = widget.call.usuario!.nombre!;
                  llamadasBloc.de = widget.call.usuario!.uid;
                  final resp = await llamadasBloc.getTokenCall(
                      widget.call.usuario!.tokenPush!,
                      loginBloc.usuario!.nombre!,
                      widget.call.usuario!.voipID!,
                      loginBloc.usuario!.uid,
                      widget.call.usuario!.uid,
                      false);
                  if (resp && mounted) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        navegarFadeIn(
                            context,
                            const CallPage(
                              isCalling: true,
                            )));
                  } else {
                    Navigator.pop(context);
                    Fluttertoast.showToast(msg: "Error Intente de Nuevo");
                  }
                },
                icon: Icon(
                  Icons.call,
                  color: Colors.green[700],
                )),
            title: Text(widget.call.usuario!.newName != null
                ? widget.call.usuario!.newName!
                : widget.call.usuario!.nombre!),
            leading: CircleAvatar(
              backgroundColor: const Color(0xfff20262e),
              child: Text(
                widget.call.usuario!.newName != null
                    ? widget.call.usuario!.newName![0].toUpperCase()
                    : widget.call.usuario!.nombre![0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          Divider(),
          ListTile(
            subtitle: Text(_retunDate(widget.call.createdAt.toLocal())),
            title: Text(widget.call.de == loginBloc.usuario!.uid
                ? "Saliente"
                : "Entrante"),
            leading: Icon(
              widget.call.de == loginBloc.usuario!.uid
                  ? Icons.arrow_outward
                  : Icons.call_missed_outgoing,
              size: 18,
              color: widget.call.de == loginBloc.usuario!.uid
                  ? Colors.green
                  : Colors.red[700],
            ),
          )
        ],
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
