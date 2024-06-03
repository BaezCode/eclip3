import 'package:eclips_3/bloc/master/master_bloc.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class CreaUser extends StatefulWidget {
  const CreaUser({super.key});

  @override
  State<CreaUser> createState() => _CreaUserState();
}

class _CreaUserState extends State<CreaUser> {
  late MasterBloc masterBloc;
  final _formKey = GlobalKey<FormState>();
  final prefs = PreferenciasUsuario();
  String nombre = '';
  String senha = '';
  String valido = '180';
  var uid = const Uuid();
  String id = '';

  @override
  void initState() {
    super.initState();
    masterBloc = BlocProvider.of<MasterBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: Color(0xfff20262e),
        child: const Icon(Icons.add),
        onPressed: _showDialog);
  }

  void _showDialog() {
    final size = MediaQuery.of(context).size;
    id = const Uuid().v4().characters.take(6).toString();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text("ID Generado:  $id",
            style: const TextStyle(color: Colors.white, fontSize: 18)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                  color: Colors.blue,
                  child: const Text(
                    "Confirmar",
                  ),
                  textColor: Colors.white,
                  onPressed: submit),
              MaterialButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancelar",
                ),
                textColor: Colors.white,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Nombre De Login Usuario",
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                const SizedBox(height: 15),
                _ingresarUser(),
                const SizedBox(height: 25),
                _formularioSenha(),
                const SizedBox(height: 25),
                _valido(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    CustomWIdgets.loading(context);
    final resp = await masterBloc.register(nombre, senha, id, valido);
    if (resp && mounted) {
      Navigator.of(context)
        ..pop()
        ..pop();
      Fluttertoast.showToast(msg: "Usuario Creado Correctamente");
    } else {
      Navigator.of(context)
        ..pop()
        ..pop();
      Fluttertoast.showToast(msg: prefs.msgError);
    }
  }

  Widget _ingresarUser() {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.7,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        key: const ValueKey('nombre'),
        decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
            labelText: ' Ingrese su User',
            labelStyle: TextStyle(color: Colors.blue)),
        onChanged: (value) => nombre = value,
        validator: (value) {
          if (value == null || value.trim().length < 2) {
            return "User Deve contener almenos 2 Numeros";
          }
          return null;
        },
      ),
    );
  }

  Widget _formularioSenha() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      key: const ValueKey('senha'),
      obscureText: true,
      decoration: InputDecoration(
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
            borderRadius: BorderRadius.circular(10)),
        labelText: 'Password',
        suffixIcon: const Icon(
          Icons.lock,
          size: 20,
          color: Colors.white,
        ),
      ),
      onChanged: (value) => senha = value,
      validator: (value) {
        if (value == null || value.trim().length < 3) {
          return 'Password deve Contener almenos 3 Caracteres';
        }
        return null;
      },
    );
  }

  Widget _valido() {
    return TextFormField(
      initialValue: valido,
      style: const TextStyle(color: Colors.white),
      key: const ValueKey('valido'),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue)),
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
            borderRadius: BorderRadius.circular(10)),
        labelText: 'Dias Validos',
      ),
      onChanged: (value) => valido = value,
      validator: (value) {
        if (value == null || value.trim().length < 2) {
          return 'Password deve Contener almenos 3 Caracteres';
        }
        return null;
      },
    );
  }
}
