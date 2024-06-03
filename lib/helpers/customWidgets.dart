import 'dart:convert';

import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/notes/notes_bloc.dart';
import 'package:eclips_3/bloc/socket/socket_bloc.dart';
import 'package:eclips_3/bloc/solicitudes/solicitudes_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/delete_dialog.dart';
import 'package:eclips_3/helpers/navegar_fadein.dart';
import 'package:eclips_3/models/folder_2model.dart';
import 'package:eclips_3/pages/contactos/widgets/compartir_archivos.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class CustomWIdgets {
  CustomWIdgets._();

  static loading(BuildContext context) {
    showCupertinoModalPopup(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext bc) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        });
  }

  static dialogTimerDelete(BuildContext context) {
    final prefs = PreferenciasUsuario();
    final data = AppLocalizations.of(context)!;

    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (ctx) => Theme(
              data: Theme.of(context).copyWith(
                  unselectedWidgetColor: Colors.white,
                  disabledColor: Colors.blue),
              child: StatefulBuilder(
                builder: (BuildContext context, setState) {
                  return SimpleDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Color(0xfff20262e),
                    title: Text(
                      data.tab153,
                      style: TextStyle(color: Colors.white),
                    ),
                    children: [
                      RadioListTile(
                          title: Text(
                            data.tab154,
                            style: TextStyle(color: Colors.white),
                          ),
                          value: 86400,
                          groupValue: prefs.timerDelete,
                          onChanged: (value) {
                            setState(() {
                              prefs.timerDelete = 86400;
                              prefs.nameTimerDelete = "24hs";
                            });
                            Navigator.pop(context);
                          }),
                      RadioListTile(
                          title: Text(
                            data.tab155,
                            style: TextStyle(color: Colors.white),
                          ),
                          value: 172800,
                          groupValue: prefs.timerDelete,
                          onChanged: (value) {
                            setState(() {
                              prefs.timerDelete = 172800;
                              prefs.nameTimerDelete = "48hs";
                            });
                            Navigator.pop(context);
                          }),
                      RadioListTile(
                          title: Text(
                            data.tab156,
                            style: TextStyle(color: Colors.white),
                          ),
                          value: 345600,
                          groupValue: prefs.timerDelete,
                          onChanged: (value) {
                            setState(() {
                              prefs.timerDelete = 345600;
                              prefs.nameTimerDelete = "4 Dias";
                            });
                            Navigator.pop(context);
                          }),
                      RadioListTile(
                          title: Text(
                            data.tab156,
                            style: TextStyle(color: Colors.white),
                          ),
                          value: 604800,
                          groupValue: prefs.timerDelete,
                          onChanged: (value) {
                            setState(() {
                              prefs.timerDelete = 604800;
                              prefs.nameTimerDelete = "7 Dias";
                            });
                            Navigator.pop(context);
                          }),
                    ],
                  );
                },
              ),
            ));
  }

  static userInterface(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sockeBloc = BlocProvider.of<SocketBloc>(context);
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    final prefs = PreferenciasUsuario();
    DateTime dateTime = DateTime.parse(loginBloc.usuario!.createdAt!).toUtc();
    final date = dateTime.add(const Duration(days: 180));
    String formattedDate = DateFormat('dd-MM-yyyy').format(date);
    final data = AppLocalizations.of(context)!;

    showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        backgroundColor: const Color(0xfff20262e),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        builder: (BuildContext bc) {
          return SizedBox(
            height: size.height * 0.65,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data.tab148,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 17),
                        ),
                      ),
                      Text(
                        data.tab149,
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 17,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () async {
                            final action = await Dialogs.yesAbortDialog(
                                context, data.tab150, data.tab151);
                            if (action == DialogAction.yes) {
                              sockeBloc.disconnect();
                              LoginBloc.deletoken();
                              // prefs.ultimaPagina = "";

                              //   prefs.activarPin = false;
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacementNamed(context, 'login');
                            } else {}
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ),
                ListTile(
                  trailing: SizedBox(
                    width: size.width * 0.40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: prefs.idCorto));
                              Fluttertoast.showToast(
                                  msg: "ID Copiado Correctamente");
                            },
                            icon: const Icon(
                              Icons.copy,
                              color: Colors.white,
                            )),
                        IconButton(
                            onPressed: () {
                              showQRCode(context);
                            },
                            icon: const Icon(
                              Icons.qr_code,
                              color: Colors.white,
                            )),
                        IconButton(
                            onPressed: () {
                              editName(context);
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                  leading: const Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 40,
                  ),
                  title: Text(
                    prefs.nombreUsuario,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'ID: ${prefs.idCorto}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(
                  color: Colors.white,
                ),
                SizedBox(
                  height: size.height * 0.070,
                ),
                Center(
                  child: Text(
                    data.tab152,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    formattedDate,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Center(
                  child: Text(
                    'Version Packaged 1.1.26',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Center(
                  child: Text(
                    'Created by Tui-Tui ©Todos los Derechos Reservados',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              ],
            ),
          );
        });
  }

  static editName(
    BuildContext context,
  ) {
    String content = '';
    final prefs = PreferenciasUsuario();
    final usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    final data = AppLocalizations.of(context)!;

    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            actions: [
              TextButton(
                  onPressed: () async {
                    final response = await usuariosBloc.updateUsuario(
                        content.isEmpty ? "Sin nombre" : content,
                        loginBloc.usuario!.palabra);

                    if (response) {
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();

                      Fluttertoast.showToast(
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          msg: data.tab158);
                    } else {
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();

                      Fluttertoast.showToast(
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          msg: data.tab130);
                    }
                  },
                  child: Text(data.tab3))
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: TextFormField(
              initialValue: prefs.nombreUsuario,
              style: const TextStyle(color: Colors.white),
              autofocus: true,
              keyboardType: TextInputType.multiline,
              key: const ValueKey('contenido'),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: data.tab159,
                  hintStyle: const TextStyle(color: Colors.white)),
              maxLines: null,
              onChanged: (value) => content = value,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return data.tab160;
                }
                return null;
              },
            ),
          );
        });
  }

  static showQRCodeUser(BuildContext context, String id) {
    final size = MediaQuery.of(context).size;
    var width = MediaQuery.of(context).size.width;

    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            content: Container(
              alignment: Alignment.center,
              height: size.height * 0.25,
              width: width - 100,
              child: QrImageView(
                  size: 200,
                  gapless: false,
                  padding: const EdgeInsets.all(10),
                  data: id),
            ),
          );
        });
  }

  static showQRCode(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var width = MediaQuery.of(context).size.width;
    final prefs = PreferenciasUsuario();
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            content: Container(
              alignment: Alignment.center,
              height: size.height * 0.25,
              width: width - 100,
              child: QrImageView(
                  size: 200,
                  gapless: false,
                  padding: const EdgeInsets.all(10),
                  data: prefs.idCorto),
            ),
          );
        });
  }

  static addContacto(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String content = '';
    final solicitudesBloc = BlocProvider.of<SolicitudesBloc>(context);
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    final socketBloc = BlocProvider.of<SocketBloc>(context);
    final data = AppLocalizations.of(context)!;
    final prefs = PreferenciasUsuario();
    final _textController = TextEditingController();

    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: const Color(0xfff20262e),
                title: Row(
                  children: [
                    Text(
                      data.tab161,
                      style: const TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    MaterialButton(
                        minWidth: 1,
                        color: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.qr_code_scanner_rounded,
                              color: Colors.white,
                            ),
                            Text(
                              'Scan ID',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        onPressed: () async {
                          loading(context);
                          String barcodeScanRes =
                              await FlutterBarcodeScanner.scanBarcode(
                                  '#3D8BEF', 'Cancelar', false, ScanMode.QR);

                          if (barcodeScanRes == "-1") {
                            Navigator.pop(context);
                            Fluttertoast.showToast(msg: 'ID Incorrecto');
                          } else {
                            final response =
                                await solicitudesBloc.enviarSolicitud(
                                    loginBloc.usuario!.uid, barcodeScanRes);
                            if (response != null) {
                              // ignore: use_build_context_synchronously
                              Navigator.of(context)
                                ..pop()
                                ..pop();
                              socketBloc.socket.emit('solicitudes', {
                                'para': response.para,
                                'type': 'add',
                                'solicitudes': jsonEncode(response)
                              });
                              Fluttertoast.showToast(
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  msg: data.tab162);
                            } else {
                              Navigator.of(context)
                                ..pop()
                                ..pop();
                              Fluttertoast.showToast(
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  msg: prefs.msgError);
                            }
                          }
                        }),
                  ],
                ),
                content: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: _textController,
                    style: const TextStyle(color: Colors.white),
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    key: const ValueKey('Senha'),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'ID',
                        hintStyle: TextStyle(color: Colors.white)),
                    onChanged: (value) => setState(
                      () {
                        content = value;
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.length < 5) {
                        return 'Minimo 5 Caracteres';
                      }
                      return null;
                    },
                  ),
                ),
                actions: [
                  TextButton(
                      child: Text(data.tab3),
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;
                        formKey.currentState!.save();
                        loading(context);

                        final response = await solicitudesBloc.enviarSolicitud(
                            loginBloc.usuario!.uid, content);

                        if (response != null) {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context)
                            ..pop()
                            ..pop();
                          socketBloc.socket.emit('solicitudes', {
                            'para': response.para,
                            'type': 'add',
                            'solicitudes': jsonEncode(response)
                          });
                          Fluttertoast.showToast(
                              gravity: ToastGravity.CENTER, msg: data.tab178);
                        } else {
                          Navigator.pop(context);
                          _textController.clear();

                          Fluttertoast.showToast(
                              gravity: ToastGravity.CENTER,
                              msg: prefs.msgError);
                        }
                      }),
                ],
              );
            },
          );
        });
  }

  static editNameText(BuildContext context, Folder2Model data) {
    final notesBloc = BlocProvider.of<NotesBloc>(context);
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    final resp = AppLocalizations.of(context)!;

    String content = resp.tab164;

    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            backgroundColor: const Color(0xfff20262e),
            actions: [
              TextButton(
                  onPressed: () async {
                    CustomWIdgets.loading(context);
                    await notesBloc.updateFolderDB(
                        data,
                        content,
                        data.cuerpo,
                        data.tipo,
                        data.imagen,
                        data.time,
                        loginBloc.usuario!.uid);

                    Fluttertoast.showToast(
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        msg: resp.tab165);
                    // ignore: use_build_context_synchronously
                    Navigator.of(context)
                      ..pop()
                      ..pop();
                  },
                  child: Text(resp.tab3))
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: TextFormField(
              initialValue: data.nombre,
              style: const TextStyle(color: Colors.white),
              autofocus: true,
              keyboardType: TextInputType.multiline,
              key: const ValueKey('contenido'),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: resp.tab166,
                  hintStyle: const TextStyle(color: Colors.white)),
              maxLines: null,
              onChanged: (value) => content = value,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return resp.tab167;
                }
                return null;
              },
            ),
          );
        });
  }

  static buildDialog(
    BuildContext context,
    Folder2Model data,
  ) {
    final usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    final notesBloc = BlocProvider.of<NotesBloc>(context);
    final resp = AppLocalizations.of(context)!;

    showCupertinoDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: const Color(0xfff20262e),
              title: Text(
                resp.tab168,
                style: const TextStyle(color: Colors.white),
              ),
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    editNameText(context, data);
                  },
                  leading: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  title: Text(
                    resp.tab169,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                if (data.clase != 3 && data.clase != 0)
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      switch (data.clase) {
                        case 1:
                          Navigator.push(
                              context,
                              navegarFadeIn(
                                  context,
                                  CompartirArchivos(
                                    archivo: data.cuerpo,
                                    type: 'nota',
                                    usuarios: usuariosBloc.state.usuarios,
                                  )));
                          break;

                        case 2:
                          Navigator.push(
                              context,
                              navegarFadeIn(
                                  context,
                                  CompartirArchivos(
                                    archivo: data.imagen,
                                    type: 'image',
                                    usuarios: usuariosBloc.state.usuarios,
                                  )));
                          break;
                        default:
                      }
                    },
                    leading: const Icon(
                      CupertinoIcons.arrowshape_turn_up_right_fill,
                      color: Colors.white,
                    ),
                    title: Text(
                      resp.tab170,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    notesBloc.add(SetSeleccionado(data, true));
                  },
                  leading: const Icon(
                    Icons.move_up_rounded,
                    color: Colors.white,
                  ),
                  title: Text(
                    resp.tab171,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    Navigator.pop(context);

                    CustomWIdgets.loading(context);
                    await notesBloc.deleteFolders(
                      data.uid,
                    );
                    Navigator.pop(context);
                  },
                  leading: const Icon(
                    CupertinoIcons.delete,
                    color: Colors.white,
                  ),
                  title: Text(
                    resp.tab172,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  onTap: () => Navigator.pop(context),
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  title: Text(
                    resp.tab173,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ));
  }
}
