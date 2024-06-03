import 'package:device_information/device_information.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/socket/socket_bloc.dart';
import 'package:eclips_3/pages/login/widgets/boton_azul.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FormularioLogin extends StatefulWidget {
  const FormularioLogin({Key? key}) : super(key: key);

  @override
  State<FormularioLogin> createState() => _FormularioLoginState();
}

class _FormularioLoginState extends State<FormularioLogin> {
  final _formKey = GlobalKey<FormState>();
  final prefs = PreferenciasUsuario();

  late LoginBloc loginBloc;
  late SocketBloc socketBloc;

  String _user = '';
  String _senha = '';

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
    socketBloc = BlocProvider.of<SocketBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Center(
          child: SizedBox(
            width: size.width * 0.80,
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _formularioUser(),
                    const SizedBox(height: 20),
                    _formularioSenha(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: state.loading
                              ? const CircularProgressIndicator()
                              : BotomAzul(text: 'Login', onPressed: _submit),
                        ),
                      ],
                    )
                  ],
                )),
          ),
        );
      },
    );
  }

  Widget _formularioUser() {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      key: const ValueKey('id'),
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Colors.white),
        fillColor: Colors.white,
        prefixIconColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: 'Id',
        suffixIcon: const Icon(
          Icons.accessibility_new_rounded,
          size: 20,
          color: Colors.white,
        ),
      ),
      onChanged: (value) => _user = value,
      validator: (value) {
        if (value == null || value.trim().length < 4) {
          return 'ID deve Contener @ejemplo.id';
        }
        return null;
      },
    );
  }

  Widget _formularioSenha() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      key: const ValueKey('senha'),
      obscureText: true,
      decoration: InputDecoration(
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
      onChanged: (value) => _senha = value,
      validator: (value) {
        if (value == null || value.trim().length < 3) {
          return 'Password deve Contener almenos 3 Caracteres';
        }
        return null;
      },
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      FocusScope.of(context).unfocus();
      final String imeiNo = await DeviceInformation.deviceIMEINumber;

      final loginOK = await loginBloc.login(_user, _senha, imeiNo);

      if (loginOK) {
        socketBloc.connect();
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);

          Navigator.pushReplacementNamed(context, 'firts0', arguments: imeiNo);
        }
      } else {
        Fluttertoast.showToast(
            textColor: Colors.black,
            backgroundColor: Colors.white,
            msg: prefs.msgError);
      }
    } on PlatformException catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Id o Senha Incorrectos'),
        content: Text(
          msg,
          textAlign: TextAlign.center,
        ),
        actions: [
          Container(
              padding: const EdgeInsets.only(bottom: 35),
              child: const Icon(
                Icons.perm_device_information_sharp,
                size: 30,
              )),
          const SizedBox(
            width: 40,
          ),
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
            textColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
