import 'dart:math';

import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/notes/notes_bloc.dart';
import 'package:eclips_3/helpers/customFolder.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/models/folder_2model.dart';
import 'package:eclips_3/models/folder_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class GestionarCompartirFol extends StatefulWidget {
  final FolderShare folderShare;
  const GestionarCompartirFol({super.key, required this.folderShare});

  @override
  State<GestionarCompartirFol> createState() => _GestionarCompartirFolState();
}

class _GestionarCompartirFolState extends State<GestionarCompartirFol> {
  late NotesBloc notesBloc;
  late LoginBloc loginBloc;
  var random = Random();

  @override
  void initState() {
    super.initState();
    notesBloc = BlocProvider.of<NotesBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        return SizedBox(
          height: size.height * 0.90,
          child: Column(
            children: [
              _header(state),
              const Divider(),
              Expanded(
                  child: ListView.separated(
                      itemBuilder: (_, i) =>
                          _body(widget.folderShare.archives[i]),
                      separatorBuilder: (_, i) => const Divider(),
                      itemCount: widget.folderShare.archives.length)),
            ],
          ),
        );
      },
    );
  }

  Widget _header(NotesState state) {
    final size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          subtitle: Row(
            children: [
              Text(
                "Compartir",
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(
                width: 5,
              ),
              Icon(
                CupertinoIcons.arrowshape_turn_up_right,
                color: Colors.grey[600],
                size: 15,
              )
            ],
          ),
          leading: const Icon(
            CupertinoIcons.folder,
            color: Colors.black,
          ),
          title: Text(
            widget.folderShare.nombre,
            style: const TextStyle(color: Colors.black),
          ),
          trailing: SizedBox(
            width: size.width * 0.25,
            child: Row(
              children: [
                IconButton(
                    onPressed: () async {
                      final sub = random.nextInt(100000000) * 5;
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(DateTime.now());
                      final data = {
                        'userID': loginBloc.usuario!.uid,
                        'cuerpo': '',
                        'imagen': '',
                        'selected': 0,
                        'tipo': 1,
                        'sub': sub,
                        'clase': 0,
                        'nombre': widget.folderShare.nombre,
                        'fecha': formattedDate,
                        'time': '',
                      };
                      for (var element in widget.folderShare.archives) {
                        element.userID = loginBloc.usuario!.uid;
                        element.fecha = formattedDate;
                        element.tipo = sub;
                      }
                      CustomWIdgets.loading(context);
                      final resp = await notesBloc.folderInserMany(
                          widget.folderShare.archives, data);
                      if (resp && mounted) {
                        Navigator.of(context)
                          ..pop()
                          ..pop();
                        Fluttertoast.showToast(msg: "Guardado Correctamente");
                      } else {
                        Navigator.of(context)
                          ..pop()
                          ..pop();
                        Fluttertoast.showToast(msg: "Error Intente de Nuevo");
                      }
                    },
                    icon: const Icon(
                      CupertinoIcons.arrow_down_doc,
                      color: Colors.black,
                    )),
                const Spacer(),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.black,
                    ))
              ],
            ),
          ),
        ));
  }

  Widget _body(Folder2Model data) {
    return ListTile(
      title: Text(
        data.nombre,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black),
      ),
      leading: Icon(
        CustomFolder.crearArchivos(data),
        color: Colors.black,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_sharp,
        size: 18,
      ),
    );
  }
}
