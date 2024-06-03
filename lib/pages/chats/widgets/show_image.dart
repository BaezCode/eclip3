import 'dart:convert';

import 'package:eclips_3/bloc/notes/notes_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/navegar_fadein.dart';
import 'package:eclips_3/pages/contactos/widgets/compartir_archivos.dart';
import 'package:eclips_3/widgets/pop_menu_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ShowImagePage extends StatefulWidget {
  const ShowImagePage({
    Key? key,
  }) : super(key: key);

  @override
  State<ShowImagePage> createState() => _ShowImagePageState();
}

class _ShowImagePageState extends State<ShowImagePage> {
  late NotesBloc notesBloc;
  late UsuariosBloc usuariosBloc;
  var datos;

  @override
  void initState() {
    super.initState();
    notesBloc = BlocProvider.of<NotesBloc>(context);
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    datos = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    navegarFadeIn(
                        context,
                        CompartirArchivos(
                          archivo: base64Encode(datos),
                          type: 'image',
                          usuarios: usuariosBloc.state.usuarios,
                        )));
              },
              icon: const Icon(
                CupertinoIcons.arrowshape_turn_up_right_fill,
                color: Colors.white,
              )),
          PopMenuImage(
            datos: datos,
          )
        ],
        backgroundColor: const Color(0xfff20262e),
        title: const Text(
          'Image View',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Center(
        child:
            PinchZoom(maxScale: 2.5, child: Image(image: MemoryImage(datos))),
      ),
    );
  }
}
