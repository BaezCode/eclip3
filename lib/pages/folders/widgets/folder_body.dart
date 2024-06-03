import 'dart:convert';
import 'dart:io';

import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/notes/notes_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customFolder.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/helpers/navegar_fadein.dart';
import 'package:eclips_3/models/folder_2model.dart';
import 'package:eclips_3/models/msg_model.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:eclips_3/pages/chats/widgets/video_player.dart';
import 'package:eclips_3/pages/folders/widgets/conversaciones.dart';
import 'package:eclips_3/pages/folders/widgets/notes_page.dart';
import 'package:eclips_3/pages/folders/widgets/sub_carpetas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FolderBody extends StatefulWidget {
  final Folder2Model data;
  const FolderBody({super.key, required this.data});

  @override
  State<FolderBody> createState() => _FolderBodyState();
}

class _FolderBodyState extends State<FolderBody> {
  late NotesBloc notesBloc;
  late UsuariosBloc usuariosBloc;
  late LoginBloc loginBloc;
  late Usuario? usuario;

  @override
  void initState() {
    super.initState();
    notesBloc = BlocProvider.of<NotesBloc>(context);
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        final index = state.compartirFolders.indexWhere(
          (element) => element.uid == widget.data.uid,
        );
        return ListTile(
          leading: Icon(
            CustomFolder.crearArchivos(widget.data),
            color: Colors.black,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.data.fecha,
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
              if (index != -1)
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.blue[700],
                ),
            ],
          ),
          onLongPress: () {
            CustomWIdgets.buildDialog(
              context,
              widget.data,
            );
          },
          title: Text(
            widget.data.nombre,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black),
          ),
          onTap: state.compartirFol
              ? () {
                  if (widget.data.clase != 0) {
                    notesBloc.compartirFolder(widget.data);
                  } else {
                    notesBloc.carpeta = widget.data;
                    Navigator.push(
                        context,
                        navegarFadeIn(
                            context,
                            SubCarpetas(
                              nombre: widget.data.nombre,
                              tipo: widget.data.sub,
                            ))).then((value) async {
                      notesBloc.add(SetLoadingFolders(true));
                      notesBloc.carpeta = null;
                      await notesBloc.getFolders(1);
                      notesBloc.add(SetLoadingFolders(false));
                    });
                  }
                }
              : () {
                  switch (widget.data.clase) {
                    case 0:
                      notesBloc.carpeta = widget.data;

                      Navigator.push(
                          context,
                          navegarFadeIn(
                              context,
                              SubCarpetas(
                                nombre: widget.data.nombre,
                                tipo: widget.data.sub,
                              ))).then((value) async {
                        notesBloc.add(SetLoadingFolders(true));
                        notesBloc.carpeta = null;

                        await notesBloc.getFolders(1);
                        notesBloc.add(SetLoadingFolders(false));
                      });
                      break;
                    case 1:
                      notesBloc.add(ChargeData(widget.data.nombre, true));
                      Navigator.push(
                          context,
                          navegarFadeIn(
                              context,
                              NotesPage(
                                tipo: 1,
                                folderModel: widget.data,
                              )));
                      break;
                    case 2:
                      final image = base64Decode(widget.data.imagen);
                      Navigator.pushNamed(context, 'imageshow',
                          arguments: image);
                      break;
                    case 3:
                      usuariosBloc.add(SetReenviar(false));
                      final decode = jsonDecode(widget.data.cuerpo);
                      final decodeText = List<MsgModel>.from(
                          decode.map((x) => MsgModel.fromJson(x)));
                      Navigator.push(
                          context,
                          navegarFadeIn(
                              context,
                              Conversaciones(
                                  msg: decodeText, title: widget.data.nombre)));
                      break;
                    case 4:
                      final file = File(widget.data.imagen);
                      Navigator.push(
                          context,
                          navegarFadeIn(
                              context, VideoPlayer(file: file, url: '')));

                      break;

                    default:
                  }
                },
        );
      },
    );
  }
}
