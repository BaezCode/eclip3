import 'dart:convert';
import 'dart:io';

import 'package:eclips_3/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/notes/notes_bloc.dart';
import 'package:eclips_3/helpers/customFolder.dart';
import 'package:eclips_3/helpers/navegar_fadein.dart';
import 'package:eclips_3/pages/folders/widgets/notes_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:images_picker/images_picker.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class Floatingnotes extends StatelessWidget {
  final int tipo;
  const Floatingnotes({Key? key, required this.tipo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _floatingfolders(context);
  }

  SpeedDial _floatingfolders(BuildContext context) {
    final notesBloc = BlocProvider.of<NotesBloc>(context);
    final conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    final data = AppLocalizations.of(context)!;

    return SpeedDial(
      buttonSize: const Size(50, 50),
      overlayColor: Colors.black,
      backgroundColor: Color(0xfff20262e),
      animatedIcon: AnimatedIcons.menu_close,
      children: [
        SpeedDialChild(
            child: const Icon(
              CupertinoIcons.folder_badge_person_crop,
            ),
            label: 'Carpeta Compartida',
            onTap: () {
              CustomFolder.customCarpetaCompartida(context);
            }),
        SpeedDialChild(
            child: const Icon(
              CupertinoIcons.folder_badge_plus,
            ),
            label: data.tab101,
            onTap: () {
              CustomFolder.customFolder(context, tipo);
            }),
        SpeedDialChild(
            child: const Icon(Icons.text_fields_outlined),
            label: data.tab102,
            onTap: () => Navigator.push(
                context,
                navegarFadeIn(
                    context,
                    NotesPage(
                      tipo: tipo,
                      folderModel: null,
                    )))),
        SpeedDialChild(
            child: const Icon(Icons.image),
            label: data.tab103,
            onTap: () async {
              conversacionesBloc.noPin = true;

              List<Media>? res = await ImagesPicker.openCamera(
                maxSize: 500,
                quality: 0.6,
                language: Language.System,
                pickType: PickType.image,
              );
              if (res == null) {
                conversacionesBloc.noPin = false;
              } else {
                for (var element in res) {
                  File file = File(element.path);

                  String img64 = base64Encode(file.readAsBytesSync());
                  await notesBloc.nuevoFolderDB(
                      tipo, 'Imagen', 2, '', img64, '', loginBloc.usuario!.uid);
                }
                conversacionesBloc.noPin = false;
              }
            }),
        /*
        SpeedDialChild(
            child: const Icon(
              CupertinoIcons.video_camera,
            ),
            label: data.tab104,
            onTap: () async {
              conversacionesBloc.noPin = true;

              final resp = await ImagesPicker.openCamera(
                pickType: PickType.video,
                maxSize: 500,
                quality: 0.1,
                maxTime: 7, // record video max time
              );
              if (resp == null) {
                conversacionesBloc.noPin = false;

                return;
              } else {
                File file = File(resp[0].path);
                final info = await VideoCompress.compressVideo(
                  file.path,
                  quality: VideoQuality.MediumQuality,
                  deleteOrigin: false,
                  includeAudio: true,
                );
                await notesBloc.nuevoFolderDB(1, ' Nuevo Video', 4, '',
                    info!.path!, '', loginBloc.usuario!.uid);
                Fluttertoast.showToast(
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    msg: data.tab91);
                conversacionesBloc.noPin = false;
              
            }),
            */
      ],
    );
  }
}
