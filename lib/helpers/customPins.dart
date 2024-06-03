import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class CustomPins {
  CustomPins._();

  static customCarpetasPin(
    BuildContext context,
  ) {
    final size = MediaQuery.of(context).size;
    final prefs = PreferenciasUsuario();
    final usuarioBloc = BlocProvider.of<UsuariosBloc>(context);
    String pin = '';
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
                child: const Text(
                  'Confirmar',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                onPressed: () {
                  if (prefs.pinCarpetas == pin) {
                    usuarioBloc.add(SetCofreOpen(true));
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    Fluttertoast.showToast(msg: data.tab130);
                  }
                })
          ],
          title: Text(
            data.tab147,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
          backgroundColor: const Color(0xfff20262e),
          content: SizedBox(
            width: size.width * 0.7,
            child: CupertinoTextField(
              obscureText: true,
              autofocus: true,
              style: const TextStyle(color: Colors.black),
              key: const ValueKey('nombre'),
              onChanged: (value) => pin = value,
            ),
          )),
    );
  }
}
