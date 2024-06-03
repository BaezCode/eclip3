import 'dart:io';

import 'package:eclips_3/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/socket/socket_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/helpers/delete_dialog.dart';
import 'package:eclips_3/models/conversaciones.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:eclips_3/pages/chats/widgets/reenviar_contactos.dart';
import 'package:eclips_3/pages/contactos/widgets/cofirm_group.dart';
import 'package:eclips_3/pages/contactos/widgets/compartir_contacto.dart';
import 'package:eclips_3/pages/contactos/widgets/crear_grupo.dart';
import 'package:eclips_3/pages/contactos/widgets/solicitudes_page.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart' hide Key;
import 'package:flutter/material.dart' hide Key;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomContact {
  CustomContact._();

  static buildCompartirContacto(BuildContext context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return const CompartirContacto();
        });
  }

  static buildReenviar(BuildContext context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return const ReenviarContactos();
        });
  }

  static buildSolicitudes(BuildContext context, List<String> lista) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return SolicitudesPage(ids: lista);
        });
  }

  static buildNewGroup(BuildContext context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return const CrearGrupo();
        });
  }

  static confirmGroup(BuildContext context, List<Usuario> usuarios) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return ConfirmGroup(
            usuarios: usuarios,
          );
        });
  }

  static buildChatDialog(
      BuildContext context, Usuario usuario, Conversaciones conversaciones) {
    final conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
    final data = AppLocalizations.of(context)!;

    showCupertinoDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: const Color(0xfff20262e),
              title: Text(
                usuario.nombre!,
                style: const TextStyle(color: Colors.white),
              ),
              children: [
                ListTile(
                  onTap: () async {
                    CustomWIdgets.loading(context);
                    final resp = await conversacionesBloc.deleteChats(
                        conversaciones.uid, usuario.uid);
                    if (resp) {
                      conversacionesBloc.state.conversaciones
                          .remove(conversaciones);
                      conversacionesBloc.add(
                          SetListConv(conversacionesBloc.state.conversaciones));
                      // ignore: use_build_context_synchronously
                      Navigator.of(context)
                        ..pop()
                        ..pop();

                      Fluttertoast.showToast(msg: data.tab126);
                    } else {
                      // ignore: use_build_context_synchronously
                      Navigator.of(context)
                        ..pop()
                        ..pop();

                      Fluttertoast.showToast(msg: data.tab127);
                    }
                  },
                  leading: const Icon(
                    CupertinoIcons.delete,
                    color: Colors.white,
                  ),
                  title: Text(
                    data.tab128,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  onTap: () => Navigator.pop(context),
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Salir',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ));
  }

  static showEula(
    BuildContext context,
  ) {
    final prefs = PreferenciasUsuario();
    showCupertinoDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: const Color(0xfff20262e),
              title: const Text(
                "Acepta las Políticas",
                style: TextStyle(color: Colors.white),
              ),
              children: [
                ListTile(
                  onTap: () async {
                    final Uri url = Uri.parse(
                        'https://sites.google.com/view/tui-tui/p%C3%A1gina-principal');
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch');
                    }
                  },
                  leading: const Icon(
                    Icons.policy,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Politica de Privacidad",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    final Uri url = Uri.parse(
                        'https://sites.google.com/view/eulapolticy/p%C3%A1gina-principal');
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch');
                    }
                  },
                  leading: const Icon(
                    Icons.policy,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "EULA",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  onTap: () => exit(0),
                  leading: const Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Salir y no Aceptar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  onTap: () {
                    prefs.eula = true;
                    Navigator.pop(context);
                  },
                  leading: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Aceptar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ));
  }

  static buildContactoDialog(
    BuildContext context,
    Usuario usuario,
  ) {
    final usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    final data = AppLocalizations.of(context)!;

    showCupertinoDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: const Color(0xfff20262e),
              title: Text(
                usuario.nombre!,
                style: const TextStyle(color: Colors.white),
              ),
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    editContactName(context, usuario);
                  },
                  leading: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  title: Text(
                    data.tab131,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    Navigator.pop(context);
                    await Clipboard.setData(
                        ClipboardData(text: usuario.idCorto!));
                    Fluttertoast.showToast(
                      msg: "ID Copiado Correctamente",
                    );
                  },
                  leading: const Icon(
                    Icons.copy,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Copiar ID',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    final action = await Dialogs.yesAbortDialog(
                        context,
                        'Eliminar Contacto',
                        'El contacto se eliminara de Ambos Dispositivos');
                    if (action == DialogAction.yes) {
                      // ignore: use_build_context_synchronously
                      CustomWIdgets.loading(context);
                      final result = await usuariosBloc.deleteUser(usuario);
                      if (result) {
                        Fluttertoast.showToast(
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            msg: data.tab129);
                        // ignore: use_build_context_synchronously
                        Navigator.of(context)
                          ..pop()
                          ..pop();

                        Fluttertoast.showToast(
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            msg: data.tab129);
                      } else {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context)
                          ..pop()
                          ..pop();

                        Fluttertoast.showToast(
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            msg: data.tab130);
                      }
                    } else {}
                  },
                  leading: const Icon(
                    CupertinoIcons.delete,
                    color: Colors.white,
                  ),
                  title: Text(
                    data.tab176,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  onTap: () => Navigator.pop(context),
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Salir',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ));
  }

  static editContactName(BuildContext context, Usuario contacto) {
    final size = MediaQuery.of(context).size;
    final data = AppLocalizations.of(context)!;
    final usuariosBloc = BlocProvider.of<UsuariosBloc>(context);

    String name = '';

    return showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          actions: [
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  data.tab3,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                onPressed: () async {
                  if (name.isEmpty) {
                    Fluttertoast.showToast(
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        msg: data.tab134);
                  } else {
                    usuariosBloc.changeContactName(contacto, name);
                    Navigator.pop(context);
                  }
                })
          ],
          title: Text(
            data.tab159,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
          backgroundColor: const Color(0xfff20262e),
          content: SizedBox(
            width: size.width * 0.7,
            child: CupertinoTextField(
              autofocus: true,
              style: const TextStyle(color: Colors.black),
              key: const ValueKey('nombre'),
              onChanged: (value) => name = value,
            ),
          )),
    );
  }

  static crearPalabra(
    BuildContext context,
  ) {
    final size = MediaQuery.of(context).size;
    final data = AppLocalizations.of(context)!;
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    final usuarioBloc = BlocProvider.of<UsuariosBloc>(context);
    final key = Key.fromLength(32);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));

    String palabra = '';

    return showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          actions: [
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  data.tab3,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                onPressed: () async {
                  CustomWIdgets.loading(context);
                  if (palabra.isEmpty) {
                    Fluttertoast.showToast(
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        msg: data.tab134);
                  } else {
                    final resp = await usuarioBloc.updateUsuario(
                        loginBloc.usuario!.nombre!,
                        encrypter.encrypt(palabra, iv: iv).base64);
                    if (resp) {
                      loginBloc.usuario!.palabra =
                          encrypter.encrypt(palabra, iv: iv).base64;
                      Fluttertoast.showToast(msg: "Palabra Adicionada");
                    } else {
                      Fluttertoast.showToast(msg: "Error Intente de Nuevo");
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.of(context)
                      ..pop()
                      ..pop();
                  }
                })
          ],
          title: const Text(
            'Palabra',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          backgroundColor: const Color(0xfff20262e),
          content: SizedBox(
            width: size.width * 0.7,
            child: CupertinoTextField(
              onSubmitted: (value) async {
                CustomWIdgets.loading(context);
                if (value.isEmpty) {
                  Fluttertoast.showToast(
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      msg: data.tab134);
                } else {
                  final resp = await usuarioBloc.updateUsuario(
                      loginBloc.usuario!.nombre!,
                      encrypter.encrypt(value, iv: iv).base64);
                  if (resp) {
                    loginBloc.usuario!.palabra =
                        encrypter.encrypt(value, iv: iv).base64;
                    Fluttertoast.showToast(msg: "Palabra Adicionada");
                  } else {
                    Fluttertoast.showToast(msg: "Error Intente de Nuevo");
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                }
              },
              autofocus: true,
              style: const TextStyle(color: Colors.black),
              key: const ValueKey('palabra'),
              onChanged: (value) => palabra = value,
            ),
          )),
    );
  }

  static dialogVerificado(
    BuildContext context,
  ) {
    final sockeBloc = BlocProvider.of<SocketBloc>(context);
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    final data = AppLocalizations.of(context)!;

    final prefs = PreferenciasUsuario();
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => AlertDialog(
            title: Text(data.tab132,
                style: TextStyle(color: Colors.white, fontSize: 18)),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    color: Colors.blue[700],
                    onPressed: () async {
                      final resp = await sockeBloc.inhabilitar(
                          false, loginBloc.usuario!.uid);
                      if (resp) {
                        sockeBloc.disconnect();
                        LoginBloc.deletoken();
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacementNamed(context, 'login');
                        prefs.activarPin = false;
                      }
                    },
                    textColor: Colors.white,
                    child: const Text(
                      'OK',
                    ),
                  ),
                ],
              )
            ],
            backgroundColor: Colors.grey[900],
            content: Text(
              data.tab133,
              style: TextStyle(color: Colors.white),
            )));
  }
}
