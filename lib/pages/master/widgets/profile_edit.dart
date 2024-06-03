import 'package:eclips_3/bloc/master/master_bloc.dart';
import 'package:eclips_3/bloc/socket/socket_bloc.dart';
import 'package:eclips_3/helpers/customMaster.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/helpers/delete_dialog.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({
    super.key,
  });

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  late MasterBloc masterBloc;
  late SocketBloc socketBloc;
  bool habilitado = false;

  @override
  void initState() {
    super.initState();
    masterBloc = BlocProvider.of<MasterBloc>(context);
    socketBloc = BlocProvider.of<SocketBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MasterBloc, MasterState>(
      builder: (context, state) {
        DateTime dateTime = DateTime.parse(state.contacts!.createdAt!).toUtc();
        final date = dateTime.add(const Duration(days: 180));
        String formattedDate = DateFormat('dd-MM-yyyy').format(date);
        String create = DateFormat('dd-MM-yyyy').format(dateTime);
        habilitado = state.contacts!.habilitado!;

        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(state.contacts!.nombre!),
            backgroundColor: const Color(0xfff20262e),
          ),
          body: ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _idUser(context, state.contacts!),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              ListTile(
                subtitle: const Text("Nombre de Usuario"),
                title: Text("Nombre : ${state.contacts!.nombre!}"),
                trailing: const Icon(Icons.arrow_forward_ios_outlined),
              ),
              const Divider(),
              ListTile(
                title: Text("Login: ${state.contacts!.email}"),
                subtitle: const Text("Cambia el Usuario de Login"),
                trailing: const Icon(Icons.arrow_forward_ios_outlined),
              ),
              const Divider(),
              ListTile(
                onTap: () async {
                  CustomWIdgets.loading(context);
                  final rep = await masterBloc.updateVideoLlamada(
                      state.contacts!.videoLlamada == null
                          ? true
                          : state.contacts!.videoLlamada! == false
                              ? true
                              : false,
                      state.contacts!.uid);
                  if (rep) {
                    Navigator.pop(context);

                    Fluttertoast.showToast(msg: "Modificado Correctamente");
                  } else {
                    Navigator.pop(context);
                    Fluttertoast.showToast(msg: "Error Intente de Nuevo");
                  }
                },
                subtitle: Text(
                  state.contacts!.videoLlamada != null
                      ? state.contacts!.videoLlamada == true
                          ? "Habilitado"
                          : "inhabilitado"
                      : "inhabilitado",
                  style: TextStyle(
                      color: state.contacts!.videoLlamada != null
                          ? state.contacts!.videoLlamada == true
                              ? Colors.green[700]
                              : Colors.red[700]
                          : Colors.red[700]),
                ),
                title: const Text("Video Llamada"),
                trailing: const Icon(Icons.arrow_forward_ios_outlined),
              ),
              const Divider(),
              ListTile(
                onTap: () {
                  CustomMaster.updateContrasenha(context, state.contacts!.uid);
                },
                subtitle: const Text("Cambia la Contraseña de Login"),
                title: const Text("Cambiar Contraseña"),
                trailing: const Icon(Icons.arrow_forward_ios_outlined),
              ),
              const Divider(),
              ListTile(
                  subtitle: const Text("Marca que Rol Tiene el Usuario"),
                  title: const Text("Rol"),
                  trailing: Text(state.contacts!.rol)),
              const Divider(),
              ListTile(
                  subtitle: const Text("Fecha de Vencimiento de Licencia"),
                  title: const Text("Vence"),
                  trailing: Text(formattedDate)),
              const Divider(),
              ListTile(
                  subtitle: const Text("Fecha que la Cuenta Fue Creada"),
                  title: const Text("Creado"),
                  trailing: Text(create)),
              const Divider(),
              ListTile(
                onTap: () {
                  CustomMaster.updateValido(
                      context, state.contacts!.valido!, state.contacts!.uid);
                },
                title: const Text("Extender Licencia"),
                trailing: const Icon(Icons.arrow_forward_ios_outlined),
              ),
              const Divider(),
              ListTile(
                subtitle: const Text("Permite Loguearse en Otro Dispositivo"),
                onTap: () async {
                  final action = await Dialogs.yesAbortDialog(
                      context,
                      'Permitir Logueo',
                      'Quieres Permitir a esta Cuenta Loguearse en Otro Dispositivo?');
                  if (action == DialogAction.yes) {
                  } else {}
                },
                title: Text(
                  "Logueado: ${state.contacts!.iMEI == "New" ? " NO" : " Si"}",
                  style: TextStyle(
                      color: state.contacts!.iMEI == "New"
                          ? Colors.red[700]
                          : Colors.green[700]),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_outlined),
              ),
              const Divider(),
              SwitchListTile(
                  title: const Text("Habilitar/Deshabilitar Usuario"),
                  value: habilitado,
                  onChanged: (onChanged) async {
                    if (habilitado) {
                      final action = await Dialogs.yesAbortDialog(
                          context,
                          'Inhabilitar',
                          'Deseas Inhabilitar a ${state.contacts!.nombre}?');
                      if (action == DialogAction.yes) {
                        await socketBloc.inhabilitar(
                            false, state.contacts!.uid);
                        setState(() {
                          habilitado = false;
                        });
                      } else {}
                    } else {
                      await socketBloc.inhabilitar(true, state.contacts!.uid);
                      setState(() {
                        habilitado = true;
                      });
                    }
                  }),
              const Divider(),
              ListTile(
                onTap: () async {
                  final action = await Dialogs.yesAbortDialog(
                      context,
                      'Eliminar Usuario',
                      'Eliminar a ${state.contacts!.nombre} de la base de Datos?');
                  if (action == DialogAction.yes) {
                    final resp = await masterBloc.deleteUser(state.contacts!);
                    if (resp && mounted) {
                      Navigator.pop(context);

                      Fluttertoast.showToast(
                          msg: "Usuario Eliminado Correctamente");
                    }
                  } else {}
                },
                title: const Text("Eliminar Usuario"),
                trailing: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _idUser(BuildContext context, Usuario contacto) {
    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xfff20262e),
              child: Text(
                contacto.nombre![0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Positioned(
              bottom: 1,
              child: CircleAvatar(
                radius: 7,
                backgroundColor:
                    contacto.online! ? Colors.green[700] : Colors.red[700],
              ),
            )
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          contacto.idCorto!,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        IconButton(
            onPressed: () {
              CustomWIdgets.showQRCodeUser(context, contacto.idCorto!);
            },
            icon: Icon(Icons.qr_code)),
        IconButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: contacto.idCorto!));
              Fluttertoast.showToast(
                  gravity: ToastGravity.CENTER, msg: "Copiado");
            },
            icon: const Icon(Icons.copy))
      ],
    );
  }
}
