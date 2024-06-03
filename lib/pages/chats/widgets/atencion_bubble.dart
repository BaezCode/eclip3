import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AtencionBubble extends StatelessWidget {
  final String uid;
  final DateTime dateTime;
  final String texto;

  const AtencionBubble({
    Key? key,
    required this.uid,
    required this.dateTime,
    required this.texto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    return Container(
      child: uid == loginBloc.usuario!.uid ? _myMessage() : _notMyMessage(),
    );
  }

  Widget _myMessage() {
    final dateLocal = dateTime.toLocal();
    String formattedDate = DateFormat('kk:mm').format(dateLocal);

    return Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.only(right: 20, left: 50),
          decoration: BoxDecoration(
              color: Colors.blue[700], borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Llamada de Atencion hace $formattedDate",
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(
                width: 5,
              ),
              const Icon(
                Icons.notifications_active_outlined,
                color: Colors.white,
                size: 17,
              )
            ],
          ),
        ));
  }

  Widget _notMyMessage() {
    final dateLocal = dateTime.toLocal();
    String formattedDate = DateFormat('kk:mm').format(dateLocal);
    return Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.only(right: 20, bottom: 10, left: 50),
          decoration: BoxDecoration(
              color: const Color(0xffE4E5E8),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Llamada de Atencion hace $formattedDate",
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.notifications_active_outlined,
                color: Colors.black,
                size: 17,
              )
            ],
          ),
        ));
  }
}
