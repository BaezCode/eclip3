import 'package:animate_do/animate_do.dart';
import 'package:eclips_3/bloc/notes/notes_bloc.dart';
import 'package:eclips_3/helpers/customFolder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BodyCompartirFold extends StatelessWidget {
  const BodyCompartirFold({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        return Column(
          children: [
            ListTile(
                subtitle: Row(
                  children: [
                    Text(
                      "Compartir",
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Icon(
                      CupertinoIcons.arrowshape_turn_up_right,
                      color: Colors.grey[400],
                      size: 15,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (state.compartirFolders.isNotEmpty)
                      FadeIn(
                        child: CircleAvatar(
                          radius: 8,
                          child: Text(
                            state.compartirFolders.length.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      )
                  ],
                ),
                leading: const Icon(
                  CupertinoIcons.folder,
                  color: Colors.white,
                ),
                title: Text(
                  state.nombreCompartir,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: TextButton(
                    onPressed: () {
                      CustomFolder.enviarCompartirFol(
                        context,
                      );
                    },
                    child: const Text("Ver")))
          ],
        );
      },
    );
  }
}
