import 'dart:convert';
import 'dart:io';

import 'package:eclips_3/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:eclips_3/bloc/grupos/grupos_bloc.dart';
import 'package:eclips_3/helpers/customGroup.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/models/grupo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:images_picker/images_picker.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class GroupPopMenu extends StatelessWidget {
  final Grupo grupo;
  const GroupPopMenu({super.key, required this.grupo});

  @override
  Widget build(BuildContext context) {
    final gruposBloc = BlocProvider.of<GruposBloc>(context);
    final conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
    final sr = AppLocalizations.of(context)!;

    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon: const Icon(
        Icons.more_vert_rounded,
        color: Colors.white,
        size: 20,
      ),
      onSelected: (int selectedValue) async {
        if (selectedValue == 0) {
          CustomGroup.editName(context, grupo);
        }
        if (selectedValue == 1) {
          conversacionesBloc.noPin = true;

          List<Media>? res = await ImagesPicker.pick(
            cropOpt: CropOption(),
            maxSize: 500,
            quality: 0.6,
            language: Language.System,
            count: 1,
            pickType: PickType.image,
          );

          if (res == null) {
            conversacionesBloc.noPin = false;

            return;
          } else {
            for (var element in res) {
              final imageCrop = await ImageCropper().cropImage(
                  sourcePath: element.path, cropStyle: CropStyle.circle);
              if (imageCrop == null) {
                return;
              }
              final finalFile = File(imageCrop.path);
              final nImage = base64Encode(finalFile.readAsBytesSync());
              gruposBloc.state.grupo!.img = nImage;
              final index = conversacionesBloc.state.grupos
                  .indexWhere((element) => element.uid == grupo.uid);
              conversacionesBloc.state.grupos[index].img = nImage;

              // ignore: use_build_context_synchronously
              CustomWIdgets.loading(context);
              await gruposBloc.updateGroup();
              gruposBloc.add(SetGrupo(gruposBloc.state.grupo));
              conversacionesBloc
                  .add(SetListGrupos(conversacionesBloc.state.grupos));
              conversacionesBloc.noPin = false;

              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            }
          }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Text(
            sr.tab21,
            style: TextStyle(fontSize: 15),
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Text(
            sr.tab22,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}
