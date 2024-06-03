import 'dart:convert';
import 'dart:io';

import 'package:eclips_3/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:eclips_3/bloc/grupos/grupos_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/helpers/customGroup.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/helpers/delete_dialog.dart';
import 'package:eclips_3/models/grupo_model.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:eclips_3/widgets/pop_menu_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:images_picker/images_picker.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class OptionsGroup extends StatefulWidget {
  const OptionsGroup({
    super.key,
  });

  @override
  State<OptionsGroup> createState() => _OptionsGroupState();
}

class _OptionsGroupState extends State<OptionsGroup> {
  late GruposBloc gruposBloc;
  late LoginBloc loginBloc;
  late ConversacionesBloc conversacionesBloc;

  @override
  void initState() {
    super.initState();
    gruposBloc = BlocProvider.of<GruposBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final data = AppLocalizations.of(context)!;

    return BlocBuilder<GruposBloc, GruposState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xfff20262e),
          appBar: AppBar(
            centerTitle: false,
            actions: [
              GroupPopMenu(
                grupo: state.grupo!,
              )
            ],
            title: Text(
              data.tab111,
              style: TextStyle(fontSize: 18),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                )),
          ),
          body: Center(
            child: state.loading
                ? const CircularProgressIndicator()
                : SafeArea(
                    child: Column(
                      children: [
                        _Header(
                          grupo: state.grupo!,
                          conversacionesBloc: conversacionesBloc,
                          gruposBloc: gruposBloc,
                        ),
                        ListTile(
                          onTap: () {
                            CustomGroup.addUserGroup(context, state.usuarios);
                          },
                          title: Text(
                            data.tab112,
                            style: TextStyle(color: Colors.white),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue[700],
                            child: const Icon(
                              Icons.group_add_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.usuarios.length,
                            itemBuilder: (ctx, i) =>
                                _bodyUsuarios(state.usuarios[i], state.grupo!),
                          ),
                        ),
                        ListTile(
                          onTap: () async {
                            final action = await Dialogs.yesAbortDialog(
                                context, data.tab113, data.tab114);
                            if (action == DialogAction.yes) {
                              CustomWIdgets.loading(context);
                              state.grupo!.integrantes
                                  .remove(loginBloc.usuario!.uid);
                              final respuesta = state.grupo!.admins
                                  .contains(loginBloc.usuario!.uid);
                              if (respuesta) {
                                state.grupo!.admins
                                    .remove(loginBloc.usuario!.uid);
                              }
                              if (state.grupo!.admins.isEmpty) {
                                for (var element in state.grupo!.integrantes) {
                                  if (element != loginBloc.usuario!.uid &&
                                      state.grupo!.admins.isEmpty) {
                                    state.grupo!.admins.add(element);
                                  }
                                }
                              }
                              final resp = await gruposBloc.updateGroup();
                              if (resp) {
                                await conversacionesBloc.getGrupos();
                                Navigator.of(context)
                                  ..pop()
                                  ..pop()
                                  ..pop();
                              } else {
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                    gravity: ToastGravity.CENTER,
                                    msg: data.tab115);
                              }
                            } else {}
                          },
                          title: Text(
                            data.tab113,
                            style: TextStyle(color: Colors.white),
                          ),
                          leading: Icon(
                            Icons.exit_to_app,
                            color: Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _bodyUsuarios(Usuario contacts, Grupo grupo) {
    return ListTile(
      onLongPress: () {
        CustomGroup.buildGroupOption(context, grupo, contacts);
      },
      trailing: grupo.admins.contains(contacts.uid)
          ? Text(
              "Admin.",
              style: TextStyle(
                color: Colors.blue[700],
              ),
            )
          : null,
      title: Text(
        contacts.nombre!,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.black,
        child: Text(
          contacts.nombre![0].toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Grupo grupo;
  final GruposBloc gruposBloc;
  final ConversacionesBloc conversacionesBloc;

  const _Header({
    required this.grupo,
    required this.gruposBloc,
    required this.conversacionesBloc,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: grupo.img.isEmpty
          ? GestureDetector(
              onTap: () => _submit(context),
              child: CircleAvatar(
                backgroundColor: Colors.grey[700],
                child: Text(
                  grupo.nombre[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            )
          : GestureDetector(
              onTap: () => _submit(context),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: MemoryImage(base64Decode(grupo.img)),
              ),
            ),
      title: Text(
        grupo.nombre,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        'Grupo ${grupo.integrantes.length} Participantes',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  void _submit(BuildContext context) async {
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
        final imageCrop = await ImageCropper()
            .cropImage(sourcePath: element.path, cropStyle: CropStyle.circle);
        if (imageCrop == null) {
          return;
        }
        final finalFile = File(imageCrop.path);
        final nImage = base64Encode(finalFile.readAsBytesSync());
        gruposBloc.state.grupo!.img = nImage;
        final index = conversacionesBloc.state.grupos
            .indexWhere((element) => element.uid == grupo.uid);
        conversacionesBloc.state.grupos[index].img = nImage;

        CustomWIdgets.loading(context);
        await gruposBloc.updateGroup();
        gruposBloc.add(SetGrupo(gruposBloc.state.grupo));
        conversacionesBloc.add(SetListGrupos(conversacionesBloc.state.grupos));
        conversacionesBloc.noPin = false;

        Navigator.pop(context);
      }
    }
  }
}
