import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class First1 extends StatefulWidget {
  const First1({super.key});

  @override
  State<First1> createState() => _First1State();
}

class _First1State extends State<First1> {
  final prefs = PreferenciasUsuario();
  TextEditingController? _textController;
  final _formKey = GlobalKey<FormState>();
  String confirmar = '';

  @override
  Widget build(BuildContext context) {
    final resp = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: AppBar(
          title: Text(resp.tab7, style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: const Color(0xfff20262e),
        ),
        body: _crearBody());
  }

  Widget _crearBody() {
    final resp = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              resp.tab8,
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _adicionarContrasenha(),
          const SizedBox(
            height: 20,
          ),
          _confirmarPin(),
          const SizedBox(
            height: 25,
          ),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: const Color(0xfff20262e),
              onPressed: _submit,
              child: Text(
                resp.tab9,
                style: const TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }

  Widget _adicionarContrasenha() {
    final size = MediaQuery.of(context).size;
    final resp = AppLocalizations.of(context)!;

    return SizedBox(
      width: size.width * 0.7,
      child: TextFormField(
        autofocus: false,
        obscureText: true,
        controller: _textController,
        style: const TextStyle(color: Colors.black),
        key: const ValueKey('pin'),
        decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            labelText: resp.tab10,
            labelStyle: const TextStyle(color: Colors.black)),
        onSaved: (value) => prefs.pinUsuario = value!,
        validator: (value) {
          if (value == null || value.trim().length < 6) {
            return resp.tab11;
          }
          return null;
        },
      ),
    );
  }

  Widget _confirmarPin() {
    final size = MediaQuery.of(context).size;
    final resp = AppLocalizations.of(context)!;

    return SizedBox(
      width: size.width * 0.7,
      child: TextFormField(
        autofocus: false,
        obscureText: true,
        controller: _textController,
        style: const TextStyle(color: Colors.black),
        key: const ValueKey('pinconfirm'),
        decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            labelText: 'Confirm Pin',
            labelStyle: TextStyle(color: Colors.black)),
        onSaved: (value) => confirmar = value!,
        validator: (value) {
          if (value == null || value.trim().length < 6) {
            return resp.tab11;
          }
          return null;
        },
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (prefs.pinUsuario == confirmar) {
      setState(() {
        prefs.activarPin = true;
        prefs.intentados = 3;
        prefs.pinCarpetas = '';
        prefs.pinCarpetasActivado = false;
      });
      Navigator.of(context).popUntil((route) => route.isFirst);

      Fluttertoast.showToast(msg: "Bienvenido");
      Navigator.pushReplacementNamed(context, 'loading');
    } else {
      Fluttertoast.showToast(msg: "Pin Diferentes");
    }
  }
}
