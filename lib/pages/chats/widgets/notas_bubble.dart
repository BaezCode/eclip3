import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/helpers/customNote.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class NotesBubble extends StatelessWidget {
  final String uid;
  final DateTime dateTime;
  final String texto;
  final int leido;

  const NotesBubble({
    Key? key,
    required this.uid,
    required this.dateTime,
    required this.texto,
    required this.leido,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    return Container(
      child: uid == loginBloc.usuario!.uid
          ? _myMessage(context)
          : _notMyMessage(context),
    );
  }

  Widget _myMessage(BuildContext context) {
    final dateLocal = dateTime.toLocal();
    final data = AppLocalizations.of(context)!;

    String formattedDate = DateFormat('kk:mm').format(dateLocal);
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => CustomNote.notesView(context, texto),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          margin: const EdgeInsets.only(right: 5, bottom: 5, left: 50),
          decoration: BoxDecoration(
              color: const Color(0xfff20262e),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ListTile(
                trailing: const Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Colors.white,
                ),
                subtitle: Text(
                  data.tab82,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                title: const Text(
                  "Notes",
                  style: TextStyle(color: Colors.white),
                ),
                leading: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.black,
                  child: Icon(
                    FontAwesomeIcons.noteSticky,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formattedDate,
                    textAlign: TextAlign.end,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Icon(
                    _icons(leido),
                    color: Colors.white,
                    size: 12,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _notMyMessage(BuildContext context) {
    final dateLocal = dateTime.toLocal();
    String formattedDate = DateFormat('kk:mm').format(dateLocal);
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => CustomNote.notesView(context, texto),
        child: Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.only(left: 5, bottom: 5, right: 50),
            decoration: BoxDecoration(
                color: const Color(0xffE4E5E8),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const ListTile(
                  trailing: Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: Colors.black,
                  ),
                  subtitle: Text(
                    'Nota encryptada',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  title: Text(
                    'Archivo de Nota',
                    style: TextStyle(color: Colors.black),
                  ),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black,
                    child: Icon(
                      FontAwesomeIcons.noteSticky,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formattedDate,
                      textAlign: TextAlign.end,
                      style: const TextStyle(color: Colors.black, fontSize: 10),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }

  IconData _icons(int leido) {
    switch (leido) {
      case 0:
        return Icons.access_time_outlined;
      case 2:
        return Icons.remove_red_eye_sharp;
      case 1:
        return Icons.panorama_fish_eye_sharp;
      default:
        return Icons.abc;
    }
  }
}
