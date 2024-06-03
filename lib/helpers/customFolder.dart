import 'package:eclips_3/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/notes/notes_bloc.dart';
import 'package:eclips_3/bloc/socket/socket_bloc.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/helpers/delete_dialog.dart';
import 'package:eclips_3/models/folder_2model.dart';
import 'package:eclips_3/models/folder_share.dart';
import 'package:eclips_3/pages/folders/widgets/build_body_enviarFol.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

import '../pages/folders/widgets/gestionart_compartir_fol.dart';

class CustomFolder {
  CustomFolder._();
  static gestionCompartir(BuildContext context, FolderShare folderShare) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return GestionarCompartirFol(
            folderShare: folderShare,
          );
        });
  }

  static enviarCompartirFol(
    BuildContext context,
  ) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return const EnviarFol();
        });
  }

  static customCarpetaCompartida(
    BuildContext context,
  ) {
    final size = MediaQuery.of(context).size;
    final data = AppLocalizations.of(context)!;
    String name = data.tab174;
    final notesBloc = BlocProvider.of<NotesBloc>(context);

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
                onPressed: () {
                  notesBloc.add(SetCompartirFolders(const [], true, name));
                  Navigator.pop(context);
                })
          ],
          title: Text(
            data.tab134,
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

  static customMoveArchives(BuildContext context, Folder2Model folder) async {
    final size = MediaQuery.of(context).size;
    bool expanded = false;
    List<Folder2Model> ingresados = [];

    return showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context,
        builder: (BuildContext bc) {
          return BlocBuilder<NotesBloc, NotesState>(
            builder: (context, state) {
              List<Folder2Model> lista = state.folders
                  .where((i) => i.clase == 0 && i.uid != folder.uid)
                  .toList();
              return StatefulBuilder(
                builder: (context, setState) {
                  return SizedBox(
                      height: size.height * 0.75,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(Icons.folder),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: size.width * 0.60,
                                    height: 20,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: ingresados.length,
                                      itemBuilder: (context, index) {
                                        return Center(
                                          child: Text(
                                            "${ingresados[index].nombre}/",
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: const Icon(Icons.arrow_back)),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.check_circle)),
                                  const SizedBox(
                                    width: 5,
                                  )
                                ],
                              ),
                            ),
                            const Divider(),
                            ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              shrinkWrap: true,
                              itemCount: lista.length,
                              itemBuilder: (context, i) {
                                final data = lista[i];
                                return ListTile(
                                  trailing: IconButton(
                                      onPressed: () {
                                        /*
                                             expanded = !expanded;
                                                indix = i;
                                                */
                                      },
                                      icon: Icon(expanded
                                          // ignore: dead_code
                                          ? Icons.expand_less
                                          : Icons.expand_more)),
                                  onTap: () {
                                    setState(
                                      () {
                                        ingresados.add(data);
                                      },
                                    );
                                  },
                                  title: Text(
                                    data.nombre,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  leading: Icon(
                                    crearArchivos(data),
                                    color: Colors.black,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ));
                },
              );
            },
          );
        });
  }

  static IconData crearArchivos(Folder2Model data) {
    switch (data.clase) {
      case 0:
        return CupertinoIcons.folder_fill;
      case 1:
        return Icons.text_fields_rounded;
      case 2:
        return Icons.image;
      case 3:
        return CupertinoIcons.chat_bubble_text;

      case 4:
        return Icons.video_call;

      default:
        return Icons.image;
    }
  }

  static customFolder(BuildContext context, int tipo) {
    final size = MediaQuery.of(context).size;
    final data = AppLocalizations.of(context)!;

    String name = data.tab174;
    final notesbloc = BlocProvider.of<NotesBloc>(context);
    final loginBloc = BlocProvider.of<LoginBloc>(context);

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
                  Navigator.pop(context);

                  CustomWIdgets.loading(context);
                  await notesbloc.nuevoFolderDB(
                      tipo, name, 0, '', '', '', loginBloc.usuario!.uid);
                  //     notesbloc.nuevoFolder(tipo, name, 0, '', '', '');
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);

                  Fluttertoast.showToast(
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      msg: data.tab133);
                })
          ],
          title: Text(
            data.tab134,
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

  static customPIM(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final prefs = PreferenciasUsuario();
    String data = '';
    prefs.intentados = prefs.intentados < prefs.getIntentos
        ? prefs.intentados
        : prefs.getIntentos;
    final conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
    final socketBloc = BlocProvider.of<SocketBloc>(context);
    final textController = TextEditingController();
    conversacionesBloc.inPop = true;
    final res = AppLocalizations.of(context)!;

    return showDialog(
      barrierColor: Colors.white,
      barrierDismissible: false,
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
              actions: [
                TextButton(
                    onPressed: () async {
                      if (prefs.intentados <= 0) {
                        textController.clear();

                        LoginBloc.deletoken();
                        prefs.activarPin = false;
                        Navigator.pushReplacementNamed(context, 'login');
                        conversacionesBloc.inPop = false;
                      } else if (prefs.pinUsuario == data) {
                        textController.clear();

                        Navigator.pop(context);
                        conversacionesBloc.inPop = false;
                        prefs.intentados = prefs.getIntentos;
                      } else {
                        textController.clear();
                        prefs.intentados = prefs.intentados - 1;
                        setState(() {});
                        Fluttertoast.showToast(
                            gravity: ToastGravity.TOP,
                            msg:
                                "${res.tab135} ${prefs.intentados} ${res.tab118}");
                      }
                    },
                    // ignoconst const re: prefer_const_constructors
                    // ignore: prefer_const_constructors
                    child: Text(
                      res.tab3,
                      style: const TextStyle(color: Colors.white),
                    ))
              ],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Row(
                children: [
                  Text(
                    '${prefs.intentados} ${res.tab118}',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () async {
                        final action = await Dialogs.yesAbortDialog(
                            context, res.tab150, res.tab151);
                        if (action == DialogAction.yes) {
                          socketBloc.disconnect();
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
                      ))
                ],
              ),
              backgroundColor: const Color(0xfff20262e),
              content: SizedBox(
                width: size.width * 0.7,
                child: CupertinoTextField(
                  controller: textController,
                  onSubmitted: (value) {
                    if (prefs.intentados <= 0) {
                      textController.clear();
                      LoginBloc.deletoken();
                      prefs.activarPin = false;
                      Navigator.pushReplacementNamed(context, 'login');
                      conversacionesBloc.inPop = false;
                    } else if (prefs.pinUsuario == data) {
                      textController.clear();

                      Navigator.pop(context);
                      conversacionesBloc.inPop = false;
                      prefs.intentados = prefs.getIntentos;
                    } else {
                      textController.clear();

                      prefs.intentados = prefs.intentados - 1;
                      setState(() {});
                      Fluttertoast.showToast(
                          gravity: ToastGravity.TOP,
                          msg:
                              "${res.tab135} ${prefs.intentados} ${res.tab118}");
                    }
                  },
                  autofocus: false,
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                  key: const ValueKey('pin'),
                  onChanged: (value) => data = value,
                ),
              ));
        },
      ),
    );
  }
}
