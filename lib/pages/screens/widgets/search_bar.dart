import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBar extends StatelessWidget {
  final int indexHome;
  const SearchBar({super.key, required this.indexHome});

  @override
  Widget build(BuildContext context) {
    final usuariosBloc = BlocProvider.of<UsuariosBloc>(context);

    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Search..',
              hintStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.white, width: 1.0, style: BorderStyle.none),
              ),
              suffixIcon: Icon(
                Icons.person_search_sharp,
                size: 20,
                color: Colors.white,
              ),
            ),
            onSubmitted: (data) async {
              final list = usuariosBloc.state.usuarios
                  .where((user) =>
                      user.nombre!.toLowerCase().contains(data.toLowerCase()))
                  .toList();

              usuariosBloc.add(GetUsuarios(list));
            }),
      ),
    );
  }
}
