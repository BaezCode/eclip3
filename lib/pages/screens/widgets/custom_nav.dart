import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class CustomNav extends StatelessWidget {
  final int index;

  const CustomNav({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    final sr = AppLocalizations.of(context)!;

    return Theme(
      data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          canvasColor: const Color(0xfff20262e)),
      child: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(fontSize: 11),
        unselectedLabelStyle:
            const TextStyle(color: Colors.white, fontSize: 11),
        fixedColor: Colors.white,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        currentIndex: index,
        onTap: usuariosBloc.selectedIndex,
        items: [
          BottomNavigationBarItem(
            activeIcon: const Icon(
              CupertinoIcons.chat_bubble_text_fill,
              color: Colors.blue,
            ),
            icon: const Icon(
              CupertinoIcons.chat_bubble,
              color: Colors.white,
            ),
            label: sr.tab30,
          ),
          const BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.call,
              color: Colors.blue,
            ),
            icon: Icon(
              Icons.call_outlined,
              color: Colors.white,
            ),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            activeIcon: const Icon(
              Icons.contact_page_rounded,
              color: Colors.blue,
            ),
            icon: const Icon(
              Icons.contact_page_outlined,
              color: Colors.white,
            ),
            label: sr.tab33,
          ),
          BottomNavigationBarItem(
            activeIcon: const Icon(
              CupertinoIcons.doc_fill,
              color: Colors.blue,
            ),
            icon: const Icon(
              CupertinoIcons.doc,
              color: Colors.white,
            ),
            label: sr.tab34,
          ),
          BottomNavigationBarItem(
            activeIcon: const Icon(
              CupertinoIcons.settings,
              color: Colors.blue,
            ),
            icon: const Icon(
              CupertinoIcons.settings_solid,
              color: Colors.white,
            ),
            label: sr.tab35,
          ),
        ],
      ),
    );
  }
}
