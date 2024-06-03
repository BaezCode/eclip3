import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CambiarPinCarpetas extends StatefulWidget {
  const CambiarPinCarpetas({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CambiarPinCarpetasState createState() => _CambiarPinCarpetasState();
}

class _CambiarPinCarpetasState extends State<CambiarPinCarpetas> {
  final _formKey = GlobalKey<FormState>();
  final _prefs = PreferenciasUsuario();
  String pingCarpeta = '';
  String pingCarpetaNuevaConfim = '';
  String pingCarpetaNueva = '';

  @override
  Widget build(BuildContext context) {
    final data = AppLocalizations.of(context)!;

    return ListTile(
      leading: const Icon(
        Icons.rule_folder_rounded,
        color: Colors.black,
      ),
      title: Text(
        data.tab36,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
      onTap: () {
        if (_prefs.pinCarpetasActivado) {
          _showDialog();
        } else {
          Fluttertoast.showToast(msg: data.tab37);
        }
      },
    );
  }

  void _showDialog() {
    final size = MediaQuery.of(context).size;
    final data = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(data.tab36,
            style: const TextStyle(color: Colors.white, fontSize: 18)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: _submit,
                  child: Text(
                    data.tab3,
                  )),
              MaterialButton(
                onPressed: () => Navigator.pop(context),
                textColor: Colors.white,
                child: Text(
                  data.tab38,
                ),
              ),
            ],
          )
        ],
        backgroundColor: Colors.grey[900],
        content: SizedBox(
          height: size.height * 0.38,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(data.tab39,
                    style: const TextStyle(color: Colors.white, fontSize: 15)),
                const SizedBox(height: 20),
                _ingresarPinAntiguo(),
                const SizedBox(height: 20),
                _ingresarPinNuevo(),
                const SizedBox(height: 20),
                _confirmarPinNuevo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _ingresarPinAntiguo() {
    final size = MediaQuery.of(context).size;
    final data = AppLocalizations.of(context)!;

    return SizedBox(
      width: size.width * 0.7,
      child: TextFormField(
        obscureText: true,
        style: const TextStyle(color: Colors.white),
        key: const ValueKey('pinCarpetas'),
        decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)),
            labelText: data.tab40,
            labelStyle: const TextStyle(color: Colors.blue)),
        onChanged: (value) => pingCarpeta = value,
        validator: (value) {
          if (value == null || value.trim().length < 6) {
            return data.tab42;
          }
          return null;
        },
      ),
    );
  }

  Widget _confirmarPinNuevo() {
    final size = MediaQuery.of(context).size;
    final data = AppLocalizations.of(context)!;

    return SizedBox(
      width: size.width * 0.7,
      child: TextFormField(
        obscureText: true,
        style: const TextStyle(color: Colors.white),
        key: const ValueKey('nuevopinCarpetasConfirm'),
        decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)),
            labelText: data.tab177,
            labelStyle:
                const TextStyle(color: Color.fromARGB(255, 146, 166, 182))),
        onChanged: (value) => pingCarpetaNuevaConfim = value,
        validator: (value) {
          if (value == null || value.trim().length < 6) {
            return data.tab42;
          }
          return null;
        },
      ),
    );
  }

  Widget _ingresarPinNuevo() {
    final size = MediaQuery.of(context).size;
    final data = AppLocalizations.of(context)!;

    return SizedBox(
      width: size.width * 0.7,
      child: TextFormField(
        obscureText: true,
        style: const TextStyle(color: Colors.white),
        key: const ValueKey('nuevopinCarpetas'),
        decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)),
            labelText: data.tab41,
            labelStyle:
                const TextStyle(color: Color.fromARGB(255, 146, 166, 182))),
        onChanged: (value) => pingCarpetaNueva = value,
        validator: (value) {
          if (value == null || value.trim().length < 6) {
            return data.tab42;
          }
          return null;
        },
      ),
    );
  }

  void _submit() {
    final data = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_prefs.pinUsuario == pingCarpeta &&
        pingCarpetaNueva == pingCarpetaNuevaConfim) {
      setState(() {
        _prefs.pinCarpetas = pingCarpetaNueva;
      });
      Fluttertoast.showToast(msg: data.tab43);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: data.tab44);
    }
  }
}
