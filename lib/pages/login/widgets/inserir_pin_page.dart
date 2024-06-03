import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class InserirPIN extends StatefulWidget {
  const InserirPIN({super.key});

  @override
  State<InserirPIN> createState() => _InserirPINState();
}

class _InserirPINState extends State<InserirPIN> {
  final _formKey = GlobalKey<FormState>();
  final prefs = PreferenciasUsuario();
  String value = '';

  @override
  Widget build(BuildContext context) {
    final data = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            Image.asset(
              'images/logo.png',
              height: 150,
            ),
            Text(
              data.tab116,
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 5,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${data.tab117} ${prefs.getIntentos} ${data.tab118}",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 25,
            ),
            Form(key: _formKey, child: _adicionarContrasenha()),
            const SizedBox(
              height: 25,
            ),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: const Color(0xfff20262e),
                onPressed: _submit,
                child: Text(
                  data.tab119,
                  style: TextStyle(color: Colors.white),
                )),
            const SizedBox(
              height: 25,
            ),
            Text(
              data.tab120,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _adicionarContrasenha() {
    final size = MediaQuery.of(context).size;
    final data = AppLocalizations.of(context)!;

    return SizedBox(
      width: size.width * 0.7,
      child: TextFormField(
        autofocus: false,
        obscureText: true,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.black),
        key: const ValueKey('pin'),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            labelText: data.tab121,
            labelStyle: TextStyle(color: Colors.white)),
        onSaved: (newvalue) => value = newvalue!,
        validator: (value) {
          if (value == null || value.trim().length < 6) {
            return "Pin Deve contener 6 Numeros";
          }
          return null;
        },
      ),
    );
  }

  void _submit() async {
    final data = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      prefs.activarPin = true;
      prefs.pinUsuario = value;
    });
    Fluttertoast.showToast(msg: data.tab122);
    Navigator.pushReplacementNamed(context, 'loading');
  }
}
