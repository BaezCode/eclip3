import 'package:animate_do/animate_do.dart';
import 'package:eclips_3/bloc/grupos/grupos_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/models/usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdicionarIntegrantes extends StatefulWidget {
  final List<Usuario> usuarios;
  const AdicionarIntegrantes({super.key, required this.usuarios});

  @override
  State<AdicionarIntegrantes> createState() => _AdicionarIntegrantesState();
}

class _AdicionarIntegrantesState extends State<AdicionarIntegrantes> {
  late UsuariosBloc usuariosBloc;
  late GruposBloc gruposBloc;
  late LoginBloc loginBloc;
  List<Usuario> usuarios = [];
  List<Usuario> contactosAdicionados = [];

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    gruposBloc = BlocProvider.of<GruposBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    init();
  }

  void init() async {
    gruposBloc.add(SetLoadingGrupos(true));
    await usuariosBloc.getUsuarios();
    usuarios.addAll(usuariosBloc.state.usuarios);
    contactosAdicionados.addAll(widget.usuarios);

    contactosAdicionados
        .removeWhere((element) => element.uid == loginBloc.usuario!.uid);
    gruposBloc.add(SetLoadingGrupos(false));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.90,
      child: BlocBuilder<GruposBloc, GruposState>(
        builder: (context, state) {
          return state.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    _header(),
                    _search(usuarios),
                    if (contactosAdicionados.isNotEmpty) _adicionadosList(),
                    Expanded(
                        child: ListView.separated(
                            itemBuilder: (_, i) {
                              return _contactos(usuarios[i]);
                            },
                            separatorBuilder: (_, i) => const Divider(),
                            itemCount: usuarios.length))
                  ],
                );
        },
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar")),
        TextButton(
            onPressed: contactosAdicionados.isEmpty
                ? null
                : () async {
                    CustomWIdgets.loading(context);
                    contactosAdicionados.insert(0, loginBloc.usuario!);
                    final list = List.generate(contactosAdicionados.length,
                        (index) => contactosAdicionados[index].uid);
                    gruposBloc.state.grupo!.integrantes = list;
                    final resp = await gruposBloc.updateGroup();
                    if (resp) {
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                      gruposBloc
                          .add(SetListUsuariosGroup(contactosAdicionados));
                    } else {
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                          gravity: ToastGravity.CENTER,
                          msg: "Error Intente de Nuevo");
                    }
                  },
            child: const Text("Confirmar"))
      ],
    );
  }

  Widget _search(List<Usuario> contactos) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 40,
        child: CupertinoTextField(
          controller: controller,
          onChanged: (value) {
            if (value.isEmpty) {
              setState(() {
                usuarios = usuariosBloc.state.usuarios;
              });
            } else {
              final list = contactos
                  .where((user) => user.nombre!
                      .toLowerCase()
                      .contains(value.trim().toLowerCase()))
                  .toList();
              setState(() {
                usuarios = list;
              });
            }
          },
          autofocus: false,
          suffix: controller.text.isEmpty
              ? null
              : IconButton(
                  splashColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      controller.clear();
                      usuarios = usuariosBloc.state.usuarios;
                    });
                  },
                  icon: const Icon(Icons.cancel)),
          prefix: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Icon(CupertinoIcons.search),
          ),
        ),
      ),
    );
  }

  Widget _contactos(Usuario contacts) {
    return ListTile(
      onTap: () {
        final index = contactosAdicionados
            .indexWhere((element) => element.uid == contacts.uid);
        if (index == -1) {
          contactosAdicionados.add(contacts);
        } else {
          contactosAdicionados.removeAt(index);
        }
        setState(() {});
      },
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: const Color(0xfff20262e),
            child: Text(
              contacts.nombre![0].toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Positioned(
            bottom: 1,
            child: CircleAvatar(
              radius: 5,
              backgroundColor:
                  contacts.online! ? Colors.green[700] : Colors.red[700],
            ),
          )
        ],
      ),
      title: Text(
        contacts.nombre!,
        style: const TextStyle(color: Colors.black, fontSize: 14),
      ),
      trailing: Icon(
        contactosAdicionados.contains(contacts)
            ? Icons.circle_rounded
            : Icons.circle_outlined,
      ),
    );
  }

  Widget _adicionadosList() {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.11,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: contactosAdicionados.length,
          itemBuilder: (ctx, i) {
            final contacts = contactosAdicionados[i];
            return FadeIn(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: const Color(0xfff20262e),
                          child: Text(
                            contacts.nombre![0].toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                        ),
                        Positioned(
                            top: 1,
                            right: 1,
                            child: GestureDetector(
                                onTap: () {
                                  contactosAdicionados.remove(contacts);
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.cancel,
                                  size: 18,
                                  color: Colors.grey[400],
                                )))
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 50,
                      child: Text(
                        contacts.nombre!,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
