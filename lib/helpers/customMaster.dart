import 'package:eclips_3/bloc/master/master_bloc.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomMaster {
  CustomMaster._();
  static updateValido(BuildContext context, int valido, String idUser) {
    final masterBloc = BlocProvider.of<MasterBloc>(context);
    String content = valido.toString();
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            actions: [
              TextButton(
                  onPressed: () async {
                    if (content.isNotEmpty) {
                      final resp = await masterBloc.updateUsuario(
                          content.trim(), idUser);
                      if (resp) {
                      } else {
                        Navigator.pop(context);

                        Fluttertoast.showToast(msg: "Modificado Correctamente");
                      }
                      // ignore: use_build_context_synchronously
                    } else {
                      Fluttertoast.showToast(msg: "No puede Estar Vacio");
                    }
                  },
                  child: const Text(
                    "Confirmar",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: TextFormField(
              initialValue: content,
              style: const TextStyle(color: Colors.white),
              autofocus: true,
              keyboardType: TextInputType.number,
              key: const ValueKey('contenido'),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Titulo',
                  hintStyle: TextStyle(color: Colors.white)),
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

  static updateContrasenha(BuildContext context, String userID) {
    final masterBloc = BlocProvider.of<MasterBloc>(context);
    String content = '';
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            actions: [
              TextButton(
                  onPressed: () async {
                    if (content.isNotEmpty) {
                      CustomWIdgets.loading(context);
                      final resp =
                          await masterBloc.updateSenha(content.trim(), userID);
                      if (resp) {
                        Navigator.of(context)
                          ..pop()
                          ..pop();
                        Fluttertoast.showToast(msg: "Modificado Correctamente");
                      } else {
                        Navigator.of(context)
                          ..pop()
                          ..pop();
                        Fluttertoast.showToast(msg: "Error Itente de Nuevo");
                      }
                      // ignore: use_build_context_synchronously
                    } else {
                      Fluttertoast.showToast(msg: "No puede Estar Vacio");
                    }
                  },
                  child: const Text(
                    "Confirmar",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: TextFormField(
              initialValue: content,
              style: const TextStyle(color: Colors.white),
              autofocus: true,
              keyboardType: TextInputType.number,
              key: const ValueKey('contenido'),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Nueva contraseña',
                  hintStyle: TextStyle(color: Colors.white)),
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

  static updateNombre(BuildContext context, String userID) {
    final masterBloc = BlocProvider.of<MasterBloc>(context);
    String content = '';
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            actions: [
              TextButton(
                  onPressed: () async {
                    if (content.isNotEmpty) {
                      CustomWIdgets.loading(context);
                      final resp =
                          await masterBloc.updateSenha(content.trim(), userID);
                      if (resp) {
                        Navigator.of(context)
                          ..pop()
                          ..pop();
                        Fluttertoast.showToast(msg: "Modificado Correctamente");
                      } else {
                        Navigator.of(context)
                          ..pop()
                          ..pop();
                        Fluttertoast.showToast(msg: "Error Itente de Nuevo");
                      }
                      // ignore: use_build_context_synchronously
                    } else {
                      Fluttertoast.showToast(msg: "No puede Estar Vacio");
                    }
                  },
                  child: const Text(
                    "Confirmar",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: TextFormField(
              initialValue: content,
              style: const TextStyle(color: Colors.white),
              autofocus: true,
              keyboardType: TextInputType.number,
              key: const ValueKey('contenido'),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Nueva contraseña',
                  hintStyle: TextStyle(color: Colors.white)),
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
