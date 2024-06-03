import 'dart:convert';

import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/notes/notes_bloc.dart';
import 'package:eclips_3/helpers/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class PopMenuImage extends StatefulWidget {
  final dynamic datos;
  const PopMenuImage({
    Key? key,
    required this.datos,
  }) : super(key: key);

  @override
  State<PopMenuImage> createState() => _PopMenuImageState();
}

class _PopMenuImageState extends State<PopMenuImage> {
  late NotesBloc notesBloc;
  late LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    notesBloc = BlocProvider.of<NotesBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
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
          Navigator.pushNamed(context, 'imageEditor', arguments: widget.datos);
        }
        if (selectedValue == 1) {
          final action =
              await Dialogs.yesAbortDialog(context, sr.tab23, sr.tab24);
          if (action == DialogAction.yes) {
            final image = base64Encode(widget.datos);
            await notesBloc.nuevoFolderDB(
                1, ' Nueva Imagen', 2, '', image, '', loginBloc.usuario!.uid);
            Fluttertoast.showToast(
                backgroundColor: Colors.white,
                textColor: Colors.black,
                msg: sr.tab25);
          } else {}
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text(sr.tab26),
        ),
      ],
    );
  }
}
