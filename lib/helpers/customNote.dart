import 'dart:convert';

import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/notes/notes_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class CustomNote {
  CustomNote._();

  static notesView(BuildContext context, String data) {
    QuillController controller = QuillController.basic();
    var myJSON = jsonDecode(data);
    controller = QuillController(
        document: Document.fromJson(myJSON),
        selection: const TextSelection.collapsed(offset: 0));
    final FocusNode focusNode = FocusNode();

    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            actions: [
              IconButton(
                  onPressed: () {
                    setName(context, controller);
                  },
                  icon: const Icon(
                    Icons.save,
                    color: Colors.black,
                  ))
            ],
            content: QuillEditor(
                controller: controller,
                focusNode: focusNode,
                scrollController: ScrollController(),
                scrollable: true,
                padding: const EdgeInsets.all(8),
                autoFocus: false,
                readOnly: true,
                expands: false),
          );
        });
  }

  static setName(BuildContext context, QuillController controller) {
    final notesBloc = BlocProvider.of<NotesBloc>(context);
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    final data = AppLocalizations.of(context)!;

    String content = data.tab144;

    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            actions: [
              IconButton(
                  onPressed: () {
                    var json =
                        jsonEncode(controller.document.toDelta().toJson());

                    notesBloc.nuevoFolderDB(
                        1, content, 1, json, '', '', loginBloc.usuario!.uid);
                    Navigator.of(context)
                      ..pop()
                      ..pop();
                    Fluttertoast.showToast(
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        msg: data.tab145);
                  },
                  icon: const Icon(
                    Icons.save,
                    color: Colors.white,
                  ))
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: TextFormField(
              initialValue: data.tab146,
              style: const TextStyle(color: Colors.white),
              autofocus: true,
              keyboardType: TextInputType.multiline,
              key: const ValueKey('contenido'),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: data.tab125,
                  hintStyle: const TextStyle(color: Colors.white)),
              maxLines: null,
              onChanged: (value) => content = value,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return data.tab147;
                }
                return null;
              },
            ),
          );
        });
  }
}
