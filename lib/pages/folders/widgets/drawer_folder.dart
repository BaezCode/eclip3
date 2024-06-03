import 'package:eclips_3/bloc/notes/notes_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class DrawerHome extends StatelessWidget {
  final int tipo;

  const DrawerHome({Key? key, required this.tipo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usuarioBloc = BlocProvider.of<UsuariosBloc>(context);
    final notesBloc = BlocProvider.of<NotesBloc>(context);
    final data = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
      child: Drawer(
          backgroundColor: const Color(0xfff20262e),
          child: BlocBuilder<UsuariosBloc, UsuariosState>(
            builder: (context, state) {
              return SafeArea(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              data.tab95,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.cancel,
                                  size: 20,
                                  color: Colors.white,
                                ))
                          ],
                        )),
                    Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.white),
                      child: RadioListTile<int>(
                          controlAffinity: ListTileControlAffinity.trailing,
                          title: Row(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Icon(
                                Icons.all_inbox_rounded,
                                color: Colors.white,
                              ),
                              Text(
                                data.tab96,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )
                            ],
                          ),
                          value: -1,
                          groupValue: state.groupValue,
                          onChanged: (value) async {
                            usuarioBloc.add(GroupValue(value!));
                            CustomWIdgets.loading(context);

                            await notesBloc.getFolders(tipo);
                            Navigator.of(context)
                              ..pop()
                              ..pop();
                          }),
                    ),
                    Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.white),
                      child: RadioListTile<int>(
                          controlAffinity: ListTileControlAffinity.trailing,
                          title: Row(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Icon(
                                CupertinoIcons.folder_fill,
                                color: Colors.white,
                              ),
                              Text(
                                data.tab97,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )
                            ],
                          ),
                          value: 0,
                          groupValue: state.groupValue,
                          onChanged: (value) async {
                            usuarioBloc.add(GroupValue(value!));
                            CustomWIdgets.loading(context);

                            await notesBloc.cargarScanPorClase(value, tipo);
                            Navigator.of(context)
                              ..pop()
                              ..pop();
                          }),
                    ),
                    Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.white),
                      child: RadioListTile<int>(
                          controlAffinity: ListTileControlAffinity.trailing,
                          title: Row(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Icon(
                                Icons.text_fields_rounded,
                                color: Colors.white,
                              ),
                              Text(
                                data.tab98,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )
                            ],
                          ),
                          value: 1,
                          groupValue: state.groupValue,
                          onChanged: (value) async {
                            usuarioBloc.add(GroupValue(value!));
                            CustomWIdgets.loading(context);
                            await notesBloc.cargarScanPorClase(value, tipo);
                            Navigator.of(context)
                              ..pop()
                              ..pop();
                          }),
                    ),
                    Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.white),
                      child: RadioListTile<int>(
                          controlAffinity: ListTileControlAffinity.trailing,
                          title: Row(
                            children: [
                              const Icon(
                                Icons.image,
                                color: Colors.white,
                              ),
                              Text(
                                data.tab99,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )
                            ],
                          ),
                          value: 2,
                          groupValue: state.groupValue,
                          onChanged: (value) async {
                            usuarioBloc.add(GroupValue(value!));
                            CustomWIdgets.loading(context);

                            await notesBloc.cargarScanPorClase(value, tipo);
                            Navigator.of(context)
                              ..pop()
                              ..pop();
                          }),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}
