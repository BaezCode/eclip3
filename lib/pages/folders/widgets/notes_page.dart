import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/notes/notes_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/helpers/navegar_fadein.dart';
import 'package:eclips_3/models/folder_2model.dart';
import 'package:eclips_3/pages/contactos/widgets/compartir_archivos.dart';
import 'package:eclips_3/widgets/boton_trasero.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class NotesPage extends StatefulWidget {
  final int tipo;
  final Folder2Model? folderModel;
  const NotesPage({super.key, required this.tipo, this.folderModel});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  QuillController _controller = QuillController.basic();
  final FocusNode _focusNode = FocusNode();
  late NotesBloc notesBloc;
  late UsuariosBloc usuariosBloc;
  late LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    notesBloc = BlocProvider.of<NotesBloc>(context);
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);

    if (widget.folderModel != null) {
      try {
        var myJSON = jsonDecode(widget.folderModel!.cuerpo);
        _controller = QuillController(
            document: Document.fromJson(myJSON),
            selection: const TextSelection.collapsed(offset: 0));
      } catch (e) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            var json = jsonEncode(_controller.document.toDelta().toJson());
            if (state.updated) {
              await notesBloc.updateFolderDB(widget.folderModel!, state.titulo,
                  json, widget.tipo, '', '', loginBloc.usuario!.uid);
              Navigator.pop(context);
            } else {
              await notesBloc.nuevoFolderDB(widget.tipo, state.titulo, 1, json,
                  '', '', loginBloc.usuario!.uid);
              Navigator.pop(context);
            }
            notesBloc.add(ClearNotes());
            return true;
          },
          child: Scaffold(
            appBar: appBar(state, context),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                      child: QuillEditor(
                          controller: _controller,
                          focusNode: _focusNode,
                          scrollController: ScrollController(),
                          scrollable: true,
                          padding: const EdgeInsets.all(8),
                          autoFocus: false,
                          readOnly: false,
                          expands: false)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: QuillToolbar.basic(
                        fontSizeValues: const {
                          '8': '8',
                          '10': '10',
                          '12': '12',
                          '15': '15',
                          '18': '18',
                          '20': '20',
                          '22': '22'
                        },
                        showQuote: false,
                        showInlineCode: false,
                        toolbarIconSize: 20,
                        showCodeBlock: false,
                        showBoldButton: true,
                        showLink: false,
                        controller: _controller),
                  ),

                  //          Expanded(child: _crearCuerpo(state, context)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar appBar(
    NotesState state,
    BuildContext context,
  ) {
    final size = MediaQuery.of(context).size;
    final notesBloc = BlocProvider.of<NotesBloc>(context);

    return AppBar(
      actions: [
        IconButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            icon: const Icon(
              CupertinoIcons.book,
              size: 23,
              color: Colors.black,
            )),
        IconButton(
            onPressed: () {
              var json = jsonEncode(_controller.document.toDelta().toJson());
              Navigator.push(
                  context,
                  navegarFadeIn(
                      context,
                      CompartirArchivos(
                        archivo: json,
                        type: 'nota',
                        usuarios: usuariosBloc.state.usuarios,
                      )));
            },
            icon: const Icon(
              CupertinoIcons.arrowshape_turn_up_right_fill,
              color: Colors.black,
            ))
      ],
      title: GestureDetector(
        onTap: () {
          notesBloc.add(AppBarActive(true));
        },
        child: Text(
          state.titulo,
          style: TextStyle(color: Colors.grey[500], fontSize: 20),
        ),
      ),
      leading: state.appBarActive
          ? IconButton(onPressed: () {
              notesBloc.add(AppBarActive(false));
            }, icon: FlipInY(child: BotonTrasero(ontap: () async {
              CustomWIdgets.loading(context);
              var json = jsonEncode(_controller.document.toDelta().toJson());
              if (state.updated) {
                await notesBloc.updateFolderDB(
                    widget.folderModel!,
                    state.titulo,
                    json,
                    widget.tipo,
                    '',
                    '',
                    loginBloc.usuario!.uid);
                Navigator.of(context)
                  ..pop()
                  ..pop();
              } else {
                await notesBloc.nuevoFolderDB(widget.tipo, state.titulo, 1,
                    json, '', '', loginBloc.usuario!.uid);
                Navigator.of(context)
                  ..pop()
                  ..pop();
              }
              notesBloc.add(ClearNotes());
            })))
          : FlipInX(child: BotonTrasero(
              ontap: () async {
                CustomWIdgets.loading(context);

                var json = jsonEncode(_controller.document.toDelta().toJson());
                if (state.updated) {
                  await notesBloc.updateFolderDB(
                      widget.folderModel!,
                      state.titulo,
                      json,
                      widget.tipo,
                      '',
                      '',
                      loginBloc.usuario!.uid);
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                } else {
                  await notesBloc.nuevoFolderDB(widget.tipo, state.titulo, 1,
                      json, '', '', loginBloc.usuario!.uid);
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                }
                notesBloc.add(ClearNotes());
              },
            )),
      bottom: state.appBarActive
          ? PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: FadeIn(
                child: SizedBox(
                  height: 50,
                  width: size.width * 0.80,
                  child: TextFormField(
                    initialValue: state.titulo,
                    style: const TextStyle(color: Colors.black, fontSize: 17),
                    textInputAction: TextInputAction.go,
                    autofocus: true,
                    key: const ValueKey('contenido'),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'location.hintTitle',
                        hintStyle:
                            TextStyle(fontSize: 20, color: Colors.black)),
                    onChanged: (value) async {
                      if (widget.folderModel == null) {
                        notesBloc.add(SetTitulo(value));
                      } else {
                        notesBloc.add(SetTitulo(value));
                      }
                    },
                    onFieldSubmitted: (vata) {
                      notesBloc.add(AppBarActive(false));
                    },
                  ),
                ),
              ))
          : null,
      backgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
