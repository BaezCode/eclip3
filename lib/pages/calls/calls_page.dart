import 'package:eclips_3/bloc/llamadas/llamadas_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/helpers/navegar_fadein.dart';
import 'package:eclips_3/models/calls_model.dart';
import 'package:eclips_3/pages/calls/widget/calls_history.dart';
import 'package:eclips_3/pages/chats/widgets/call_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CallsPageHome extends StatefulWidget {
  const CallsPageHome({super.key});

  @override
  State<CallsPageHome> createState() => _CallsPageHomeState();
}

class _CallsPageHomeState extends State<CallsPageHome> {
  late LlamadasBloc llamadasBloc;
  late LoginBloc loginBloc;
  late UsuariosBloc usuariosBloc;

  @override
  void initState() {
    super.initState();
    llamadasBloc = BlocProvider.of<LlamadasBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    init();
  }

  void init() async {
    llamadasBloc.add(SetLoadingCalls(true));
    final list = await llamadasBloc.getAllCalls();
    if (list.isEmpty) {
      llamadasBloc.add(SetCallsList(const []));
    } else {
      for (var element in list) {
        if (element.de == loginBloc.usuario!.uid) {
          try {
            final index = usuariosBloc.state.usuarios
                .indexWhere((data) => data.uid == element.para);
            if (index != -1) {
              element.usuario = usuariosBloc.state.usuarios[index];
            }
          } catch (e) {
            return;
          }
        } else {
          try {
            final index = usuariosBloc.state.usuarios
                .indexWhere((data) => data.uid == element.de);
            if (index != -1) {
              element.usuario = usuariosBloc.state.usuarios[index];
            }
          } catch (e) {
            return;
          }
        }
      }
      llamadasBloc.add(SetCallsList(list));
    }
    llamadasBloc.add(SetLoadingCalls(false));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LlamadasBloc, LlamadasState>(
      builder: (context, state) {
        return state.loadingCalls
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : state.calls.isEmpty
                ? const Center(
                    child: Text("No tienes Registros"),
                  )
                : ListView.builder(
                    itemCount: state.calls.length,
                    itemBuilder: (ctx, index) {
                      if (state.calls[index].usuario != null) {
                        return _crearBody(state.calls[index]);
                      } else {
                        return Container();
                      }
                    });
      },
    );
  }

  Widget _crearBody(Call call) {
    return Dismissible(
      secondaryBackground: Container(
          color: Colors.red[700],
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Eliminar",
                textAlign: TextAlign.end,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 15,
              )
            ],
          )),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          CustomWIdgets.loading(context);
          final resp = await llamadasBloc.deleteCalls(call.uid);
          if (resp && mounted) {
            Navigator.pop(context);
            return true;
          } else {
            Navigator.pop(context);
            return false;
          }
        } else {
          return false;
        }
      },
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.delete,
          color: Colors.red[700],
        ),
      ),
      key: UniqueKey(),
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              navegarFadeIn(
                  context,
                  CallsHistory(
                    call: call,
                  )));
        },
        leading: CircleAvatar(
          backgroundColor: const Color(0xfff20262e),
          child: Text(
            call.usuario!.newName != null
                ? call.usuario!.newName![0].toUpperCase()
                : call.usuario!.nombre![0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        title: Text(call.usuario!.newName != null
            ? call.usuario!.newName!
            : call.usuario!.nombre!),
        subtitle: Row(
          children: [
            Icon(
              call.de == loginBloc.usuario!.uid
                  ? Icons.arrow_outward
                  : Icons.call_missed_outgoing,
              size: 18,
              color: call.de == loginBloc.usuario!.uid
                  ? Colors.green
                  : Colors.red[700],
            ),
            const SizedBox(
              width: 7,
            ),
            Text(_retunDate(call.createdAt.toLocal())),
          ],
        ),
        trailing: IconButton(
            onPressed: () async {
              CustomWIdgets.loading(context);
              llamadasBloc.nombre = call.usuario!.nombre!;
              llamadasBloc.de = call.usuario!.uid;
              final resp = await llamadasBloc.getTokenCall(
                  call.usuario!.tokenPush!,
                  loginBloc.usuario!.nombre!,
                  call.usuario!.voipID!,
                  loginBloc.usuario!.uid,
                  call.usuario!.uid,
                  false);
              if (resp && mounted) {
                Navigator.pop(context);
                Navigator.push(
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
            icon: const Icon(
              Icons.call,
              color: Colors.green,
            )),
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
