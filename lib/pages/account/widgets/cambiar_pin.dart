import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class Cambiarpin extends StatefulWidget {
  const Cambiarpin({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CambiarpinState createState() => _CambiarpinState();
}

class _CambiarpinState extends State<Cambiarpin> {
  final _formKey = GlobalKey<FormState>();
  final prefs = PreferenciasUsuario();
  String pinAntiguo = '';
  String pinNuevo = '';
  String confirmarNuevo = '';

  @override
  Widget build(BuildContext context) {
    final data = AppLocalizations.of(context)!;

    return ListTile(
        leading: const Icon(
          Icons.lock_clock,
          color: Colors.black,
        ),
        title: Text(
          data.tab47,
          style: const TextStyle(color: Colors.black),
        ),
        onTap: prefs.activarPin == false
            ? () {
                _showSnackbar(data.tab46, Icons.info);
              }
            : () {
                // ignore: unnecessary_null_comparison
                if (prefs.pinUsuario == null) {
                  _showSnackbar(data.tab49, Icons.info);
                } else {
                  _showDialog();
                }
              });
  }

  void _showDialog() {
    final size = MediaQuery.of(context).size;
    final data = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(data.tab47,
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
                child: Text(data.tab38),
                textColor: Colors.white,
              ),
            ],
          )
        ],
        backgroundColor: Colors.grey[900],
        content: Container(
          height: size.height * 0.38,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(data.tab48,
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                SizedBox(height: 15),
                _ingresarPinAntiguo(),
                SizedBox(height: 5),
                _ingresarPinNuevo(),
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
        style: TextStyle(color: Colors.white),
        key: ValueKey('pin'),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
            labelText: data.tab50,
            labelStyle: TextStyle(color: Colors.blue)),
        onChanged: (value) => pinAntiguo = value,
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
        style: TextStyle(color: Colors.white),
        key: ValueKey('pinNuevo'),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
            labelText: data.tab41,
            labelStyle: TextStyle(color: Colors.blue)),
        onChanged: (value) => pinNuevo = value,
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

    if (prefs.pinUsuario == pinAntiguo && confirmarNuevo == pinNuevo) {
      setState(() {
        prefs.pinUsuario = pinNuevo;
      });
      _showSnackbar(data.tab43, Icons.check);
      Navigator.pop(context);
    } else {
      _showErrorDialog(data.tab43);
    }
  }

  void _showErrorDialog(String msg) {
    final data = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Pin'),
        content: Text(
          msg,
          textAlign: TextAlign.center,
        ),
        actions: [
          Container(
              padding: EdgeInsets.only(bottom: 35),
              child: Icon(
                Icons.perm_device_information_sharp,
                size: 30,
              )),
          SizedBox(
            width: 40,
          ),
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: Text(data.tab45),
            textColor: Colors.red,
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String msg, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 2000),
        content: Row(children: [
          Text(msg),
          Spacer(),
          Icon(
            icon,
            color: Colors.white,
          )
        ])));
  }
}
