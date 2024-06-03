import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:eclips_3/bloc/notes/notes_bloc.dart';
import 'package:eclips_3/helpers/customFolder.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/helpers/navegar_fadein.dart';
import 'package:eclips_3/models/folder_2model.dart';
import 'package:eclips_3/models/msg_model.dart';
import 'package:eclips_3/pages/folders/widgets/build_body_compartirFol.dart';
import 'package:eclips_3/pages/folders/widgets/build_body_mover.dart';
import 'package:eclips_3/pages/folders/widgets/conversaciones.dart';
import 'package:eclips_3/pages/folders/widgets/drawer_folder.dart';
import 'package:eclips_3/pages/folders/widgets/floatin_notes.dart';
import 'package:eclips_3/pages/folders/widgets/notes_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class SubCarpetas extends StatefulWidget {
  final String nombre;
  final int tipo;
  const SubCarpetas({super.key, required this.nombre, required this.tipo});

  @override
  State<SubCarpetas> createState() => _SubCarpetasState();
}

class _SubCarpetasState extends State<SubCarpetas> {
  late NotesBloc notesBloc;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    notesBloc = BlocProvider.of<NotesBloc>(context);
    init();
  }

  void init() async {
    notesBloc.add(SetLoadingFolders(true));
    await notesBloc.getFolders(widget.tipo);
    notesBloc.add(SetLoadingFolders(false));
  }

  @override
  Widget build(BuildContext context) {
    final resp = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: DrawerHome(tipo: widget.tipo),
          floatingActionButton: state.compartirFol
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.085),
                  child: FadeIn(
                      child: FloatingActionButton(
                          backgroundColor: Color(0xfff20262e),
                          child: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            notesBloc.cancelar();
                          })))
              : state.mover
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.085),
                      child:
                          FadeInRight(child: Floatingnotes(tipo: widget.tipo)))
                  : FadeIn(child: Floatingnotes(tipo: widget.tipo)),
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  icon: const Icon(Icons.all_inbox))
            ],
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.white,
                )),
            backgroundColor: const Color(0xfff20262e),
            title: Text(
              widget.nombre,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: state.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    if (state.folders.isEmpty) ...[
                      Flexible(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                CupertinoIcons.doc,
                                size: 40,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Text(
                                resp.tab100,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                    if (state.folders.isNotEmpty) ...[
                      Flexible(
                        child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: state.folders.length,
                            itemBuilder: (ctx, i) => FadeIn(
                                child: _crearBody(
                                    state.folders[i], context, state))),
                      ),
                    ],
                    if (state.mover)
                      FadeIn(
                          child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xfff20262e),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5))),
                        height: 100,
                        child:
                            BuildBodyMover(seleccionado: state.seleccionado!),
                      )),
                    if (state.compartirFol)
                      FadeIn(
                          child: Container(
                              decoration: const BoxDecoration(
                                  color: Color(0xfff20262e),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5))),
                              height: 100,
                              child: const BodyCompartirFold()))
                  ],
                ),
        );
      },
    );
  }

  Widget _crearBody(Folder2Model data, BuildContext context, NotesState state) {
    final notesBloc = BlocProvider.of<NotesBloc>(context);
    final index = state.compartirFolders.indexWhere(
      (element) => element.uid == data.uid,
    );

    return ListTile(
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            data.fecha,
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
          if (index != -1)
            Icon(
              Icons.check_circle_rounded,
              color: Colors.blue[700],
            ),
        ],
      ),
      onLongPress: () => CustomWIdgets.buildDialog(
        context,
        data,
      ),
      title: Text(
        data.nombre,
        style: const TextStyle(color: Colors.black),
      ),
      leading: Icon(
        CustomFolder.crearArchivos(data),
        color: Colors.black,
      ),
      onTap: state.compartirFol
          ? () {
              if (data.clase != 0) {
                notesBloc.compartirFolder(
                  data,
                );
              } else {
                notesBloc.carpeta = data;
                Navigator.push(
                    context,
                    navegarFadeIn(
                        context,
                        SubCarpetas(
                          nombre: data.nombre,
                          tipo: data.sub,
                        ))).then((value) async {
                  notesBloc.add(SetLoadingFolders(true));
                  notesBloc.carpeta = null;
                  await notesBloc.getFolders(widget.tipo);
                  notesBloc.add(SetLoadingFolders(false));
                });
              }
            }
          : () {
              switch (data.clase) {
                case 0:
                  notesBloc.carpeta = data;
                  Navigator.push(
                      context,
                      navegarFadeIn(
                          context,
                          SubCarpetas(
                            nombre: data.nombre,
                            tipo: data.sub,
                          ))).then((value) async {
                    notesBloc.add(SetLoadingFolders(true));
                    notesBloc.carpeta = data;
                    await notesBloc.getFolders(widget.tipo);
                    notesBloc.add(SetLoadingFolders(false));
                  });
                  break;
                case 1:
                  notesBloc.add(ChargeData(data.nombre, true));
                  Navigator.push(
                      context,
                      navegarFadeIn(
                          context,
                          NotesPage(
                            tipo: widget.tipo,
                            folderModel: data,
                          )));
                  break;
                case 2:
                  final image = base64Decode(data.imagen);
                  Navigator.pushNamed(context, 'imageshow', arguments: image);
                  break;
                case 3:
                  final decode = jsonDecode(data.cuerpo);
                  final decodeText = List<MsgModel>.from(
                      decode.map((x) => MsgModel.fromJson(x)));

                  Navigator.push(
                      context,
                      navegarFadeIn(context,
                          Conversaciones(msg: decodeText, title: data.nombre)));
                  break;
                case 4:
                  /*
                  final file = File(data.imagen);
                  Navigator.push(context,
                      navegarFadeIn(context, VideoPlayer(file: file, url: '')));
                      */

                  break;

                default:
              }
            },
    );
  }
}
