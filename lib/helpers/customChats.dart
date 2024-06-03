import 'dart:convert';

import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/notes/notes_bloc.dart';
import 'package:eclips_3/models/msg_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class CustomChats {
  CustomChats._();

  static setNameConversaciones(
    BuildContext context,
    List<MsgModel> chats,
  ) {
    final notesBloc = BlocProvider.of<NotesBloc>(context);
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    String content = 'Nombre de Chat';
    final data = AppLocalizations.of(context)!;

    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            actions: [
              TextButton(
                  onPressed: () async {
                    await notesBloc.nuevoFolderDB(1, content, 3,
                        jsonEncode(chats), '', '', loginBloc.usuario!.uid);
                    Navigator.pop(context);

                    Fluttertoast.showToast(msg: data.tab123);
                  },
                  child: Text(data.tab124))
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: TextFormField(
              initialValue: data.tab125,
              style: const TextStyle(color: Colors.white),
              autofocus: true,
              keyboardType: TextInputType.multiline,
              key: const ValueKey('contenido'),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: data.tab125,
                  hintStyle: TextStyle(color: Colors.white)),
              maxLines: null,
              onChanged: (value) => content = value,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Titulo no puede estar vacio';
                }
                return null;
              },
            ),
          );
        });
  }
}
