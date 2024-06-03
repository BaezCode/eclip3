import 'package:animate_do/animate_do.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customContact.dart';
import 'package:eclips_3/models/msg_model.dart';
import 'package:eclips_3/pages/chats/widgets/messages_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Conversaciones extends StatefulWidget {
  final String title;
  final List<MsgModel> msg;
  const Conversaciones({super.key, required this.msg, required this.title});

  @override
  State<Conversaciones> createState() => _ConversacionesState();
}

class _ConversacionesState extends State<Conversaciones> {
  late MsgBloc msgBloc;
  late UsuariosBloc usuariosBloc;

  @override
  void initState() {
    super.initState();
    msgBloc = BlocProvider.of<MsgBloc>(context);
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    msgBloc.add(SetMsgs(widget.msg));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsuariosBloc, UsuariosState>(
      builder: (context, stateuser) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xfff20262e),
            title: Text(widget.title),
          ),
          body: BlocBuilder<MsgBloc, MsgState>(
            builder: (context, state) {
              return Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('images/fondo.png'),
                  fit: BoxFit.cover,
                )),
                child: Column(
                  children: [
                    Flexible(
                      child: ListView.builder(
                          reverse: true,
                          itemCount: state.messages.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (_, i) {
                            final mgs = state.messages[i];
                            try {
                              return GestureDetector(
                                  onLongPress: () {
                                    if (stateuser.reenviar == false) {
                                      usuariosBloc.add(SetReenviar(true));
                                      mgs.enviar = true;
                                      msgBloc.add(SetMsgs(state.messages));
                                      usuariosBloc.contador = 1;
                                    }
                                  },
                                  onTap: () {
                                    if (stateuser.reenviar) {
                                      if (mgs.enviar!) {
                                        mgs.enviar = false;
                                        msgBloc.add(SetMsgs(state.messages));
                                        usuariosBloc.contador =
                                            usuariosBloc.contador - 1;
                                      } else {
                                        mgs.enviar = true;
                                        msgBloc.add(SetMsgs(state.messages));
                                        usuariosBloc.contador =
                                            usuariosBloc.contador + 1;
                                      }
                                    }
                                  },
                                  child: _msg(mgs));
                            } catch (e) {
                              return Container();
                            }
                          }),
                    ),
                    if (stateuser.reenviar) _reenviar(state)
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _reenviar(MsgState state) {
    return FadeInUp(
      duration: const Duration(milliseconds: 200),
      child: Container(
        color: const Color(0xfff20262e),
        child: SafeArea(
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Text(
                "${usuariosBloc.contador} Seleccionados",
                style: const TextStyle(color: Colors.white),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () => CustomContact.buildReenviar(context),
                  icon: const Icon(
                    CupertinoIcons.arrowshape_turn_up_right,
                    color: Colors.blue,
                  )),
              IconButton(
                  onPressed: () {
                    for (var element in state.messages) {
                      element.enviar = false;
                    }
                    usuariosBloc.add(SetReenviar(false));
                  },
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.blue,
                  )),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _msg(MsgModel msgModel) {
    final resp = msgBloc.decryptmesaje(msgModel.mensaje);

    switch (msgModel.type) {
      case 'text':
        return MessageBubble(
          msgBloc: msgBloc,
          nombre: msgModel.nombre,
          texto: resp,
          isGroup: true,
          msgModel: msgModel,
        );

      default:
        return MessageBubble(
          msgBloc: msgBloc,
          nombre: msgModel.nombre,
          texto: resp,
          isGroup: true,
          msgModel: msgModel,
        );
    }
  }
}
