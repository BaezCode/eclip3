import 'package:animate_do/animate_do.dart';
import 'package:eclips_3/bloc/notes/notes_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/pages/folders/widgets/build_body_compartirFol.dart';
import 'package:eclips_3/pages/folders/widgets/build_body_mover.dart';
import 'package:eclips_3/pages/folders/widgets/empty_folder.dart';
import 'package:eclips_3/pages/folders/widgets/folder_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({super.key});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  late NotesBloc notesBloc;
  late UsuariosBloc usuariosBloc;

  @override
  void initState() {
    super.initState();
    notesBloc = BlocProvider.of<NotesBloc>(context);
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    notesBloc.add(SetAprovado(false));
    init();
  }

  void init() async {
    notesBloc.add(SetLoadingFolders(true));
    await notesBloc.getFolders(1);
    notesBloc.add(SetLoadingFolders(false));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        return state.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : state.folders.isEmpty
                ? const EmptyFolder()
                : Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: state.folders.length,
                            itemBuilder: (ctx, i) => FadeIn(
                                child: FolderBody(data: state.folders[i]))),
                      ),
                      if (state.mover)
                        FadeInUp(
                            child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xfff20262e),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5))),
                          child:
                              BuildBodyMover(seleccionado: state.seleccionado!),
                        )),
                      if (state.compartirFol)
                        FadeInUp(
                            child: Container(
                                decoration: const BoxDecoration(
                                    color: Color(0xfff20262e),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5))),
                                child: const BodyCompartirFold()))
                    ],
                  );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    usuariosBloc.add(SetCofreOpen(false));
  }
}
