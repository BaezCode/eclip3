import 'package:eclips_3/helpers/customContact.dart';
import 'package:eclips_3/pages/login/widgets/formulario_login.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final prefs = PreferenciasUsuario();
  @override
  void initState() {
    super.initState();
    _sumbit();
    showEula();
  }

  void showEula() async {
    if (prefs.eula == false) {
      await Future.delayed(Duration.zero);
      // ignore: use_build_context_synchronously
      CustomContact.showEula(
        context,
      );
    }
  }

  void _sumbit() async {
    var status = await Permission.phone.status;
    if (status.isDenied) {
      await [
        Permission.storage,
        Permission.camera,
        Permission.phone,
        Permission.microphone
      ].request();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final resp = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xfff20262e),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SizedBox(
              height: size.height * 1.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _logo(context),
                  Center(
                    child: Text(
                      resp.tab1,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const FormularioLogin(),
                  const SizedBox(height: 70)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _logo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Column(
        children: [
          FadeInImage(
            placeholder: const AssetImage('images/logo.png'),
            image: const AssetImage('images/logo.png'),
            height: size.height * 0.17,
          ),
        ],
      ),
    );
  }
}
