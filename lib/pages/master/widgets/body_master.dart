import 'package:eclips_3/bloc/master/master_bloc.dart';
import 'package:eclips_3/helpers/navegar_fadein.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:eclips_3/pages/master/widgets/profile_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BodyMaster extends StatelessWidget {
  final Usuario contacts;
  const BodyMaster({super.key, required this.contacts});

  @override
  Widget build(BuildContext context) {
    final masterBloc = BlocProvider.of<MasterBloc>(context);
    return ListTile(
        subtitle: Text(contacts.email),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
          color: Colors.black,
        ),
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xfff20262e),
              child: Text(
                contacts.nombre![0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Positioned(
              bottom: 1,
              child: CircleAvatar(
                radius: 7,
                backgroundColor:
                    contacts.online! ? Colors.green[700] : Colors.red[700],
              ),
            )
          ],
        ),
        title: Text(
          contacts.nombre!,
          style: const TextStyle(color: Colors.black),
        ),
        onTap: () {
          masterBloc.add(SetContacto(contacts));
          Navigator.push(context, navegarFadeIn(context, const ProfileEdit()));
        });
  }
}
