import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/notes/notes_bloc.dart';
import 'package:eclips_3/helpers/customFolder.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/helpers/delete_dialog.dart';
import 'package:eclips_3/models/folder_2model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class BuildBodyMover extends StatelessWidget {
  final Folder2Model seleccionado;

  const BuildBodyMover({
    super.key,
    required this.seleccionado,
  });

  @override
  Widget build(BuildContext context) {
    final notesBloc = BlocProvider.of<NotesBloc>(context);
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    final resp = AppLocalizations.of(context)!;
    return ListTile(
      subtitle: Row(
        children: [
          Text(
            "Mover",
            style: TextStyle(color: Colors.grey[400], fontSize: 13),
          ),
          const SizedBox(
            width: 5,
          ),
          Icon(
            Icons.move_up_rounded,
            color: Colors.grey[400],
            size: 15,
          )
        ],
      ),
      leading: Icon(
        CustomFolder.crearArchivos(seleccionado),
        color: Colors.white,
      ),
      title: Text(
        seleccionado.nombre,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () async {
                  final action = await Dialogs.yesAbortDialog(
                      context,
                      resp.tab105,
                      notesBloc.carpeta == null
                          ? '${resp.tab106} ${seleccionado.nombre} ${resp.tab107}'
                          : '${resp.tab106} ${seleccionado.nombre} a ${notesBloc.carpeta!.nombre}?');
                  if (action == DialogAction.yes) {
                    CustomWIdgets.loading(context);
                    final resultado = await notesBloc.moverScan(
                        seleccionado, loginBloc.usuario!.uid);
                    if (resultado) {
                      notesBloc.add(SetSeleccionado(null, false));
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: resp.tab108);
                    } else {
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: 'Error Intente de Nuevo');
                    }
                  } else {}
                },
                icon: const Icon(
                  Icons.check,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  notesBloc.add(SetSeleccionado(null, false));
                },
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }
}
