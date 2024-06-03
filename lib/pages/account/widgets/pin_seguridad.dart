import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/helpers/customContact.dart';
import 'package:eclips_3/helpers/customFolder.dart';
import 'package:eclips_3/pages/account/widgets/cambiar_pin.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PinSeguridad extends StatefulWidget {
  const PinSeguridad({Key? key}) : super(key: key);

  @override
  State<PinSeguridad> createState() => _PinSeguridadState();
}

class _PinSeguridadState extends State<PinSeguridad> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _prefs = PreferenciasUsuario();
  TextEditingController? _textController;
  late LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final data = AppLocalizations.of(context)!;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: const Color(0xfff20262e),
          title: Text(
            data.tab59,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: _crearBody());
  }

  Widget _crearBody() {
    final data = AppLocalizations.of(context)!;

    return Column(
      children: [
        ListTile(
            leading: const Icon(
              Icons.lock,
              color: Colors.black,
            ),
            title: Text(
              data.tab60,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            onTap: () {
              if (_prefs.pinUsuario.isEmpty) {
                _showDialog();
              } else {
                _showSnackbar(data.tab61, Icons.info);
              }
            }),
        const Divider(),
        const Cambiarpin(),
        const Divider(),
        ListTile(
          leading: const Icon(
            Icons.pin,
            color: Colors.black,
          ),
          title: Text(
            data.tab62,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          onTap: _showCupertino,
          trailing: Text(
            _prefs.getIntentos.toString(),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        const Divider(),
        ListTile(
            leading: const Icon(
              FontAwesomeIcons.skullCrossbones,
              color: Colors.black,
            ),
            title: const Text(
              "Configurar Palabra",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onTap: () {
              if (loginBloc.usuario!.palabra!.isEmpty) {
                CustomContact.crearPalabra(context);
              } else {
                CustomContact.crearPalabra(context);

                CustomFolder.customPIM(
                  context,
                );
              }
            }),
      ],
    );
  }

  void _showDialog() {
    final size = MediaQuery.of(context).size;
    final data = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(data.tab63,
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
        backgroundColor: const Color(0xfff20262e),
        content: SizedBox(
          height: size.height * 0.27,
          child: Column(
            children: [
              Text(data.tab64,
                  style: const TextStyle(color: Colors.white, fontSize: 15)),
              const SizedBox(height: 15),
              Form(key: _formKey, child: _adicionarContrasenha())
            ],
          ),
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
        obscureText: true,
        maxLength: 6,
        controller: _textController,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white),
        key: const ValueKey('pin'),
        decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)),
            labelText: data.tab69,
            labelStyle: const TextStyle(color: Colors.blue)),
        onSaved: (value) => _prefs.pinUsuario = value!,
        validator: (value) {
          if (value == null || value.trim().length < 6) {
            return data.tab42;
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

    if (_prefs.pinUsuario.isNotEmpty) {
      setState(() {
        _prefs.activarPin = true;
      });
      _showSnackbar(data.tab43, Icons.check);
      Navigator.pop(context);
    }
  }

  void _showSnackbar(String msg, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: const Color(0xfff20262e),
        duration: const Duration(milliseconds: 2000),
        content: Row(children: [
          Text(msg),
          const Spacer(),
          Icon(icon, color: Colors.white)
        ])));
  }

  void _showCupertino() {
    final data = AppLocalizations.of(context)!;

    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text(
              data.tab62,
            ),
            message: Text(data.tab66),
            actions: [
              CupertinoActionSheetAction(
                  onPressed: () {
                    setState(() {
                      _prefs.getIntentos = 3;
                    });
                    Navigator.pop(context);
                  },
                  child: Text(data.tab66)),
              CupertinoActionSheetAction(
                  onPressed: () {
                    setState(() {
                      _prefs.getIntentos = 5;
                    });
                    Navigator.pop(context);
                  },
                  child: Text(data.tab67)),
              CupertinoActionSheetAction(
                  onPressed: () {
                    setState(() {
                      _prefs.getIntentos = 10;
                    });
                    Navigator.pop(context);
                  },
                  child: Text(data.tab68)),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(data.tab38),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }
}
