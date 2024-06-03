import 'package:eclips_3/helpers/customFolder.dart';
import 'package:eclips_3/pages/account/widgets/cambiar_pin_carpeta.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PinCarpetas extends StatefulWidget {
  const PinCarpetas({Key? key}) : super(key: key);

  @override
  State<PinCarpetas> createState() => _PinCarpetasState();
}

class _PinCarpetasState extends State<PinCarpetas> {
  final _formKey = GlobalKey<FormState>();
  final _prefs = PreferenciasUsuario();
  String pingCarpeta = '';
  String confirmarPin = '';

  @override
  Widget build(BuildContext context) {
    final data = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            data.tab51,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xfff20262e),
        ),
        body: ListView(
          children: [
            ListTile(
                leading: const Icon(
                  Icons.folder,
                  color: Colors.black,
                ),
                title: Text(
                  data.tab52,
                  style: const TextStyle(color: Colors.black),
                ),
                onTap: () {
                  if (_prefs.pinCarpetasActivado) {
                    _showSnackbar(data.tab53, Icons.info);
                  } else {
                    _showDialog();
                  }
                }),
            const CambiarPinCarpetas(),
            SwitchListTile(
                title: Text(
                  data.tab54,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                value: _prefs.pinCarpetasActivado,
                onChanged: (value) {
                  if (_prefs.pinCarpetas.isEmpty) {
                    _showSnackbar(data.tab55, Icons.lock);
                  } else {
                    CustomFolder.customPIM(
                      context,
                    );
                    setState(() {
                      _prefs.pinCarpetasActivado = value;
                    });
                  }
                }),
          ],
        ));
  }

  void _showDialog() {
    final size = MediaQuery.of(context).size;
    final data = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(data.tab56,
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
              const SizedBox(
                width: 10,
              ),
              MaterialButton(
                color: Colors.white,
                onPressed: () => Navigator.pop(context),
                textColor: Colors.black,
                child: Text(
                  data.tab38,
                ),
              ),
            ],
          )
        ],
        backgroundColor: Colors.grey[900],
        content: SizedBox(
          height: size.height * 0.4,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                    "Atencion este Pin es necesario para ingresar a la Carpeta Segura",
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                const SizedBox(height: 15),
                _ingresarPinGaleria(),
                const SizedBox(height: 20),
                _confirmarPin()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _ingresarPinGaleria() {
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
            labelText: data.tab41,
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

  Widget _confirmarPin() {
    final size = MediaQuery.of(context).size;
    final data = AppLocalizations.of(context)!;

    return SizedBox(
      width: size.width * 0.7,
      child: TextFormField(
        obscureText: true,
        style: const TextStyle(color: Colors.white),
        key: const ValueKey('pinCarpetasConfirmar'),
        decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
            labelText: 'Confirm Pin',
            labelStyle: TextStyle(color: Colors.blue)),
        onChanged: (value) => confirmarPin = value,
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

    if (pingCarpeta == confirmarPin) {
      setState(() {
        _prefs.pinCarpetasActivado = true;
        _prefs.pinCarpetas = pingCarpeta;
      });
      _showSnackbar(data.tab58, Icons.check);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: "Error Pin Diferentes", gravity: ToastGravity.BOTTOM);
    }
  }

  void _showSnackbar(String msg, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 2000),
        content: Row(children: [
          Text(msg),
          const Spacer(),
          Icon(
            icon,
            color: Colors.white,
          )
        ])));
  }
}
