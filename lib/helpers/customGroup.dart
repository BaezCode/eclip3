import 'package:eclips_3/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:eclips_3/bloc/grupos/grupos_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/models/grupo_model.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:eclips_3/pages/homeGroup/widgets/adicionar_integrantes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class CustomGroup {
  CustomGroup._();

  static buildGroupOption(BuildContext context, Grupo grupo, Usuario usuario) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    final gruposBloc = BlocProvider.of<GruposBloc>(context);
    final data = AppLocalizations.of(context)!;

    showCupertinoDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
              title: Text(
                grupo.nombre,
                style: const TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: const Color(0xfff20262e),
              children: [
                if (grupo.admins.contains(loginBloc.usuario!.uid))
                  ListTile(
                    onTap: () async {
                      CustomWIdgets.loading(context);
                      gruposBloc.state.usuarios
                          .removeWhere((element) => element.uid == usuario.uid);
                      gruposBloc.state.grupo!.integrantes.remove(usuario.uid);
                      final resp = await gruposBloc.updateGroup();
                      if (resp) {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context)
                          ..pop()
                          ..pop();
                        gruposBloc.add(SetGrupo(gruposBloc.state.grupo));
                      } else {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context)
                          ..pop()
                          ..pop();
                        Fluttertoast.showToast(
                            gravity: ToastGravity.CENTER, msg: data.tab127);
                      }
                    },
                    leading: const Icon(
                      CupertinoIcons.delete,
                      color: Colors.white,
                    ),
                    title: Text(
                      data.tab138,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                if (usuario.uid == loginBloc.usuario!.uid)
                  ListTile(
                    onTap: () => Navigator.pop(context),
                    leading: const Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    title: Text(
                      data.tab139,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                if (usuario.uid != loginBloc.usuario!.uid &&
                    grupo.admins.contains(usuario.uid) == false)
                  ListTile(
                    onTap: () async {
                      CustomWIdgets.loading(context);
                      gruposBloc.state.grupo!.admins.add(usuario.uid);
                      final resp = await gruposBloc.updateGroup();
                      if (resp) {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context)
                          ..pop()
                          ..pop();
                        gruposBloc.add(SetGrupo(gruposBloc.state.grupo));
                      } else {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context)
                          ..pop()
                          ..pop();
                        Fluttertoast.showToast(
                            gravity: ToastGravity.CENTER, msg: data.tab127);
                      }
                    },
                    leading: const Icon(
                      Icons.account_circle,
                      color: Colors.white,
                    ),
                    title: const Text(
                      "Adicionar Admin",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ListTile(
                  onTap: () => Navigator.pop(context),
                  leading: const Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                  title: Text(
                    data.tab140,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ));
  }

  static buildGroupDialog(BuildContext context, Grupo grupo) {
    final gruposBloc = BlocProvider.of<GruposBloc>(context);
    final conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
    final data = AppLocalizations.of(context)!;

    showCupertinoDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
              title: Text(
                grupo.nombre,
                style: const TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: const Color(0xfff20262e),
              children: [
                ListTile(
                  onTap: () async {
                    CustomWIdgets.loading(context);
                    final resp = await gruposBloc.deleteGroup(grupo);
                    if (resp) {
                      conversacionesBloc.state.grupos.remove(grupo);
                      conversacionesBloc
                          .add(SetListGrupos(conversacionesBloc.state.grupos));
                      // ignore: use_build_context_synchronously
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                      Fluttertoast.showToast(msg: data.tab141);
                    } else {
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: data.tab115);
                    }
                  },
                  leading: const Icon(
                    CupertinoIcons.delete,
                    color: Colors.white,
                  ),
                  title: Text(
                    data.tab142,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  onTap: () => Navigator.pop(context),
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  title: Text(
                    data.tab139,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  onTap: () => Navigator.pop(context),
                  leading: const Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                  title: Text(
                    data.tab140,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ));
  }

  static editName(BuildContext context, Grupo grupo) {
    final gruposBloc = BlocProvider.of<GruposBloc>(context);
    final conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
    final size = MediaQuery.of(context).size;
    String nombre = '';
    final data = AppLocalizations.of(context)!;

    return showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          actions: [
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  data.tab3,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                onPressed: () async {
                  if (nombre.isNotEmpty) {
                    CustomWIdgets.loading(context);
                    gruposBloc.state.grupo!.nombre = nombre;
                    gruposBloc.add(SetGrupo(gruposBloc.state.grupo));
                    final index = conversacionesBloc.state.grupos.indexWhere(
                        (element) =>
                            element.uid == gruposBloc.state.grupo!.uid);
                    conversacionesBloc.state.grupos[index] =
                        gruposBloc.state.grupo!;
                    conversacionesBloc
                        .add(SetListGrupos(conversacionesBloc.state.grupos));
                    await gruposBloc.updateGroup();
                    Navigator.of(context)
                      ..pop()
                      ..pop();
                  }
                })
          ],
          title: Text(
            data.tab143,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          backgroundColor: const Color(0xfff20262e),
          content: SizedBox(
            width: size.width * 0.7,
            child: CupertinoTextField(
              autofocus: true,
              style: const TextStyle(color: Colors.black),
              key: const ValueKey('nombre'),
              onChanged: (value) => nombre = value,
            ),
          )),
    );
  }

  static addUserGroup(BuildContext context, List<Usuario> usuarios) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return AdicionarIntegrantes(
            usuarios: usuarios,
          );
        });
  }
}
