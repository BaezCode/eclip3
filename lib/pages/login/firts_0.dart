import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class First0 extends StatefulWidget {
  const First0({Key? key}) : super(key: key);

  @override
  State<First0> createState() => _First0State();
}

class _First0State extends State<First0> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _prefs = PreferenciasUsuario();
  late LoginBloc loginBloc;
  DateTime now = DateTime.now();
  String nombre = '';
  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final resp = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(resp.tab2, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xfff20262e),
      ),
      key: _scaffoldKey,
      body: Form(key: _formKey, child: _crearBody()),
    );
  }

  Widget _crearBody() {
    final size = MediaQuery.of(context).size;
    final resp = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.090,
          ),
          const Center(
              child: Icon(
            Icons.account_box_rounded,
            size: 120,
          )),
          SizedBox(
            height: size.height * 0.040,
          ),
          _crearNombre(),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.black,
                      onPressed: _submit,
                      child: Text(
                        resp.tab3,
                        style: const TextStyle(color: Colors.white),
                      ))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _crearNombre() {
    final size = MediaQuery.of(context).size;
    final resp = AppLocalizations.of(context)!;

    return SizedBox(
      width: size.width * 0.7,
      child: TextFormField(
        style: const TextStyle(color: Colors.black),
        key: const ValueKey('nombreUsuario'),
        decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)),
            labelText: resp.tab4,
            labelStyle: const TextStyle(color: Colors.black)),
        onChanged: (value) => nombre = value,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return resp.tab6;
          }
          return null;
        },
      ),
    );
  }

  Future<void> _submit() async {
    // ignore: use_build_context_synchronously

    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final usuairosBloc = BlocProvider.of<UsuariosBloc>(context);
    final resp = AppLocalizations.of(context)!;

    CustomWIdgets.loading(context);

    try {
      _prefs.nombreUsuario = nombre;
      final response =
          await usuairosBloc.updateUsuario(nombre, loginBloc.usuario!.palabra);

      if (response && mounted) {
        Navigator.pushReplacementNamed(context, 'first1');
      } else {
        Fluttertoast.showToast(
            textColor: Colors.black,
            backgroundColor: Colors.white,
            msg: resp.tab5);
      }
      // ignore: deprecated_member_use
      return;
    } catch (e) {
      return;
    }
  }
}
