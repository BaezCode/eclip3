import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:eclips_3/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:eclips_3/bloc/grupos/grupos_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:images_picker/images_picker.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class ConfirmGroup extends StatefulWidget {
  final List<Usuario> usuarios;
  const ConfirmGroup({super.key, required this.usuarios});

  @override
  State<ConfirmGroup> createState() => _ConfirmGroupState();
}

class _ConfirmGroupState extends State<ConfirmGroup> {
  late UsuariosBloc usuariosBloc;
  late ConversacionesBloc conversacionesBloc;
  late GruposBloc gruposBloc;
  late LoginBloc loginBloc;
  TextEditingController controller = TextEditingController();
  List<Usuario> contactosAdicionados = [];
  File? finalFile;

  @override
  void initState() {
    super.initState();
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
    gruposBloc = BlocProvider.of<GruposBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    contactosAdicionados.addAll(widget.usuarios);
    controller.text = 'Nuevo Grupo';
  }

  @override
  Widget build(BuildContext context) {
    final data = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          _nombreGrupo(),
          const Divider(),
          Text("    ${data.tab87}: ${widget.usuarios.length}"),
          const Divider(),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
              ),
              itemCount: contactosAdicionados.length,
              itemBuilder: (ctx, i) => _contactos(contactosAdicionados[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nombreGrupo() {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30,
          child: finalFile != null
              ? GestureDetector(
                  onTap: _seleccionargaleria,
                  child: ClipOval(child: Image.file(finalFile!)))
              : IconButton(
                  onPressed: _seleccionargaleria,
                  icon: const Icon(Icons.camera_alt_outlined)),
        ),
        const SizedBox(
          width: 15,
        ),
        SizedBox(
          height: 40,
          width: size.width * 0.70,
          child: CupertinoTextField(
            controller: controller,
            autofocus: false,
            suffix: controller.text.isEmpty
                ? null
                : IconButton(
                    splashColor: Colors.transparent,
                    onPressed: () {
                      setState(() {
                        controller.clear();
                      });
                    },
                    icon: const Icon(Icons.cancel)),
          ),
        ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    final data = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text(data.tab38)),
        Text(data.tab88),
        TextButton(
            onPressed: () async {
              contactosAdicionados.insert(0, loginBloc.usuario!);
              final list = List.generate(contactosAdicionados.length,
                  (index) => contactosAdicionados[index].uid);
              final listAdmins =
                  List.generate(1, (index) => loginBloc.usuario!.uid);
              CustomWIdgets.loading(context);
              final resp = await gruposBloc.createGroup(
                  controller.text,
                  finalFile != null
                      ? base64Encode(finalFile!.readAsBytesSync())
                      : '',
                  list,
                  listAdmins,
                  loginBloc.usuario!.uid);
              if (resp && mounted) {
                Navigator.of(context)
                  ..pop()
                  ..pop();
                Fluttertoast.showToast(
                    gravity: ToastGravity.CENTER, msg: "Grupo Creado");
              } else {
                Navigator.of(context)
                  ..pop()
                  ..pop();
                Fluttertoast.showToast(
                    gravity: ToastGravity.CENTER, msg: "Error");
              }
            },
            child: const Text("Crear"))
      ],
    );
  }

  Widget _contactos(Usuario contacts) {
    return FadeIn(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xfff20262e),
                  child: Text(
                    contacts.newName != null
                        ? contacts.newName![0].toUpperCase()
                        : contacts.nombre![0].toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                Positioned(
                    top: 1,
                    right: 1,
                    child: GestureDetector(
                        onTap: () {
                          contactosAdicionados.remove(contacts);
                          setState(() {});
                        },
                        child: Icon(
                          Icons.cancel,
                          size: 18,
                          color: Colors.grey[400],
                        )))
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              width: 50,
              child: Text(
                contacts.newName != null ? contacts.newName! : contacts.nombre!,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _seleccionargaleria() async {
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
    } else if (mounted) {
      for (var element in res) {
        final imageCrop = await ImageCropper()
            .cropImage(sourcePath: element.path, cropStyle: CropStyle.circle);
        if (imageCrop == null) {
          return;
        }
        finalFile = File(imageCrop.path);

        setState(() {});
      }
    }
  }
}
