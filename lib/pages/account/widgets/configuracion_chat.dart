import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class ConfiguracionChat extends StatefulWidget {
  const ConfiguracionChat({super.key});

  @override
  State<ConfiguracionChat> createState() => _ConfiguracionChatState();
}

class _ConfiguracionChatState extends State<ConfiguracionChat> {
  final _prefs = PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Config"),
        backgroundColor: const Color(0xfff20262e),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(
              Icons.pin,
              color: Colors.black,
            ),
            title: const Text(
              'Tamaño de texto',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onTap: _showCupertino,
            trailing: Text(
              _prefs.letra.toString(),
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCupertino() {
    final data = AppLocalizations.of(context)!;

    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: const Text(
              'Tamaño de texto',
            ),
            actions: [
              CupertinoActionSheetAction(
                  onPressed: () {
                    setState(() {
                      _prefs.letra = 15;
                    });
                    Navigator.pop(context);
                  },
                  child: Text('15')),
              CupertinoActionSheetAction(
                  onPressed: () {
                    setState(() {
                      _prefs.letra = 18;
                    });
                    Navigator.pop(context);
                  },
                  child: Text('18')),
              CupertinoActionSheetAction(
                  onPressed: () {
                    setState(() {
                      _prefs.letra = 20;
                    });
                    Navigator.pop(context);
                  },
                  child: Text('20')),
              CupertinoActionSheetAction(
                  onPressed: () {
                    setState(() {
                      _prefs.letra = 22;
                    });
                    Navigator.pop(context);
                  },
                  child: Text('22'))
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(data.tab38),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }
}
