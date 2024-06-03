import 'package:eclips_3/models/usuario.dart';
import 'package:eclips_3/search/master_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopMenuMaster extends StatelessWidget {
  final List<Usuario> usuarios;
  const PopMenuMaster({super.key, required this.usuarios});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        icon: const Icon(
          CupertinoIcons.search,
          color: Colors.white,
          size: 20,
        ),
        onSelected: (int selectedValue) async {
          if (selectedValue == 0) {
            showSearch(
                context: context,
                delegate: MasterSearchDelegate(usuarios, false));
          }
          if (selectedValue == 1) {
            showSearch(
                context: context,
                delegate: MasterSearchDelegate(usuarios, true));
          }
        },
        itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Text('Buscar por Nombre'),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text('Buscar por ID'),
              ),
            ]);
  }
}
