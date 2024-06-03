import 'package:eclips_3/bloc/notes/notes_bloc.dart';
import 'package:eclips_3/helpers/customFolder.dart';
import 'package:eclips_3/models/folder_2model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnviarFol extends StatefulWidget {
  const EnviarFol({super.key});

  @override
  State<EnviarFol> createState() => _EnviarFolState();
}

class _EnviarFolState extends State<EnviarFol> {
  late NotesBloc notesBloc;

  @override
  void initState() {
    super.initState();
    notesBloc = BlocProvider.of<NotesBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        return SizedBox(
          height: size.height * 0.90,
          child: Column(
            children: [
              _header(state),
              const Divider(),
              Expanded(
                  child: ListView.separated(
                      itemBuilder: (_, i) => _body(state.compartirFolders[i]),
                      separatorBuilder: (_, i) => const Divider(),
                      itemCount: state.compartirFolders.length)),
            ],
          ),
        );
      },
    );
  }

  Widget _header(NotesState state) {
    final size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          subtitle: Row(
            children: [
              Text(
                "Compartir",
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(
                width: 5,
              ),
              Icon(
                CupertinoIcons.arrowshape_turn_up_right,
                color: Colors.grey[600],
                size: 15,
              )
            ],
          ),
          leading: const Icon(
            CupertinoIcons.folder,
            color: Colors.black,
          ),
          title: Text(
            state.nombreCompartir,
            style: const TextStyle(color: Colors.black),
          ),
          trailing: SizedBox(
            width: size.width * 0.25,
            child: Row(
              children: [
                if (state.compartirFolders.isNotEmpty)
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, 'compartirFolder');
                      },
                      icon: const Icon(Icons.check)),
                const Spacer(),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.black,
                    ))
              ],
            ),
          ),
        ));
  }

  Widget _body(Folder2Model data) {
    return ListTile(
      title: Text(
        data.nombre,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black),
      ),
      leading: Icon(
        CustomFolder.crearArchivos(data),
        color: Colors.black,
      ),
      trailing: IconButton(
          onPressed: () {
            notesBloc.removeArchive(data);
          },
          icon: const Icon(
            CupertinoIcons.delete,
            size: 18,
          )),
    );
  }
}
