import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eclips_3/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:eclips_3/bloc/llamadas/llamadas_bloc.dart';
import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/msg/msg_bloc.dart';
import 'package:eclips_3/bloc/notes/notes_bloc.dart';
import 'package:eclips_3/bloc/socket/socket_bloc.dart';
import 'package:eclips_3/bloc/usuarios/usuarios_bloc.dart';
import 'package:eclips_3/helpers/customContact.dart';
import 'package:eclips_3/helpers/customFolder.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/helpers/delete_dialog.dart';
import 'package:eclips_3/helpers/navegar_fadein.dart';
import 'package:eclips_3/models/conversaciones.dart';
import 'package:eclips_3/pages/account/account_page.dart';
import 'package:eclips_3/pages/calls/calls_page.dart';
import 'package:eclips_3/pages/chats/widgets/call_page.dart';
import 'package:eclips_3/pages/contactos/contactos_page.dart';
import 'package:eclips_3/pages/contactos/widgets/add_user.dart';
import 'package:eclips_3/pages/folders/folder_page.dart';
import 'package:eclips_3/pages/folders/widgets/cofre_pin.dart';
import 'package:eclips_3/pages/folders/widgets/drawer_folder.dart';
import 'package:eclips_3/pages/folders/widgets/floatin_notes.dart';
import 'package:eclips_3/pages/home/home_page.dart';
import 'package:eclips_3/pages/homeGroup/home_page_group.dart';
import 'package:eclips_3/pages/screens/widgets/custom_nav.dart';
import 'package:eclips_3/pages/screens/widgets/switcher_title.dart';
import 'package:eclips_3/search/cofre_search.dart';
import 'package:eclips_3/search/contactos_search.dart';
import 'package:eclips_3/shared/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> with WidgetsBindingObserver {
  late UsuariosBloc usuariosBloc;
  late SocketBloc socketBloc;
  late MsgBloc msgBloc;
  late ConversacionesBloc conversacionesBloc;
  late LoginBloc loginBloc;
  late LlamadasBloc llamadasBloc;
  late NotesBloc notesBloc;
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final prefs = PreferenciasUsuario();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    socketBloc = BlocProvider.of<SocketBloc>(context);
    msgBloc = BlocProvider.of<MsgBloc>(context);
    conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    notesBloc = BlocProvider.of<NotesBloc>(context);
    llamadasBloc = BlocProvider.of<LlamadasBloc>(context);
    socketBloc.socket.on('conversacion-personal', _escucharConv);
    socketBloc.socket.on('eliminar-conversacion', _eliminarConv);
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        final resultado = await InternetConnectionChecker().hasConnection;
        if (resultado) {
          await socketBloc.connect();
          usuariosBloc.add(SetConectado(true));
        } else {
          usuariosBloc.add(SetConectado(false));
        }
      } else {
        usuariosBloc.add(SetConectado(false));
      }
    });
    init();
    _getData();
  }

  void _eliminarConv(id) {
    conversacionesBloc.state.conversaciones
        .removeWhere((element) => element.uid == id);
    conversacionesBloc
        .add(SetListConv(conversacionesBloc.state.conversaciones));
  }

  void _escucharConv(payload) {
    final conver = Conversaciones.fromJson(payload);
    final index = conversacionesBloc.state.conversaciones.indexWhere(
      (element) => element.uid == conver.uid,
    );
    if (index != -1) {
      conversacionesBloc.state.conversaciones[index] = conver;
      conversacionesBloc
          .add(SetListConv(conversacionesBloc.state.conversaciones));
    } else {
      conversacionesBloc.state.conversaciones.add(conver);
      conversacionesBloc
          .add(SetListConv(conversacionesBloc.state.conversaciones));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
    } else if (state == AppLifecycleState.inactive) {
      if (conversacionesBloc.noPin == false &&
          conversacionesBloc.inPop == false) {
        init();
      }
    } else if (state == AppLifecycleState.detached) {
    } else if (state == AppLifecycleState.paused) {}
  }

  void init() async {
    await Future.delayed(Duration.zero);
    if (mounted) {
      CustomFolder.customPIM(
        context,
      );
    }
  }

  void _getData() async {
    await Future.delayed(Duration.zero);

    DateTime dateTime = DateTime.parse(loginBloc.usuario!.createdAt!).toUtc();
    final date = dateTime.add(Duration(days: loginBloc.usuario!.valido!));
    DateTime date1 = DateTime.now();
    final dias = date.difference(date1).inDays;

    if (mounted && dias <= 0) {
      CustomContact.dialogVerificado(context);
    } else if (dias <= 10) {
      final resp = AppLocalizations.of(context)!;

      final action = await Dialogs.yesAbortDialog(context, resp.tab14,
          '${resp.tab12} ${dias.toString()} ${resp.tab13}');
      if (action == DialogAction.yes) {
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    return BlocBuilder<UsuariosBloc, UsuariosState>(
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: const DrawerHome(tipo: 1),
          bottomNavigationBar: CustomNav(index: state.indexHome),
          floatingActionButton: BlocBuilder<NotesBloc, NotesState>(
            builder: (context, stateNotes) {
              return stateNotes.compartirFol
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.085),
                      child: FadeIn(
                          child: FloatingActionButton(
                              backgroundColor: const Color(0xfff20262e),
                              child: const Icon(
                                Icons.cancel_outlined,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                notesBloc.cancelar();
                              })))
                  : stateNotes.mover
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.085),
                          child: FadeIn(child: _FloatingButton(state: state)))
                      : FadeIn(child: _FloatingButton(state: state));
            },
          ),
          appBar: AppBar(
            bottom: state.enLlamada
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(15.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            navegarFadeIn(
                                context,
                                const CallPage(
                                  isCalling: true,
                                )));
                      },
                      child: Container(
                        width: double.infinity,
                        height: 30,
                        color: Colors.green[700],
                        child: Center(
                          child: Text(data.tab15,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white)),
                        ),
                      ),
                    ))
                : state.conectado
                    ? state.loading
                        ? PreferredSize(
                            preferredSize: const Size.fromHeight(4.0),
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.black,
                              color: Colors.green[300],
                            ))
                        : null
                    : PreferredSize(
                        preferredSize: const Size.fromHeight(4.0),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.red[700],
                          color: Colors.red[300],
                        )),
            leading: state.indexHome == 1 || state.indexHome == 4
                ? Container()
                : IconButton(
                    onPressed: () async {
                      switch (state.indexHome) {
                        case 0:
                          showSearch(
                              context: context,
                              delegate: ContactosSearchDelegate(
                                  contactos: state.usuarios));
                          break;
                        case 2:
                          showSearch(
                              context: context,
                              delegate: ContactosSearchDelegate(
                                  contactos: state.usuarios));
                          break;
                        case 3:
                          if (state.cofreOpen && prefs.pinCarpetasActivado) {
                            final lista = notesBloc.state.folders;
                            // ignore: use_build_context_synchronously
                            showSearch(
                                context: context,
                                delegate: CofreSearchDelegate(folders: lista));
                          } else {
                            final lista = notesBloc.state.folders;
                            // ignore: use_build_context_synchronously
                            showSearch(
                                context: context,
                                delegate: CofreSearchDelegate(folders: lista));
                          }

                          break;

                        default:
                      }
                    },
                    icon: const Icon(
                      CupertinoIcons.search,
                      color: Colors.white,
                      size: 20,
                    )),
            actions: [
              if (state.indexHome == 0)
                IconButton(
                    onPressed: () async {
                      CustomWIdgets.loading(context);
                      final resp = await conversacionesBloc.getConversaciones();
                      if (resp && mounted) {
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            gravity: ToastGravity.CENTER, msg: data.tab180);
                      } else {
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: data.tab5);
                      }
                    },
                    icon: const Icon(
                      Icons.replay_outlined,
                      color: Colors.white,
                    )),
              if (state.indexHome == 2)
                IconButton(
                    onPressed: () async {
                      CustomWIdgets.loading(context);
                      final resp = await usuariosBloc.getUsuarios();
                      if (resp && mounted) {
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: data.tab16);
                      } else {
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: data.tab5);
                      }
                    },
                    icon: const Icon(
                      Icons.replay_outlined,
                      color: Colors.white,
                    )),
              IconButton(
                  onPressed: () {
                    if (state.indexHome == 3) {
                      _scaffoldKey.currentState!.openDrawer();
                    } else {
                      CustomWIdgets.userInterface(context);
                    }
                  },
                  icon: Icon(
                    state.indexHome == 3
                        ? Icons.all_inbox_sharp
                        : Icons.account_circle,
                    size: 25,
                    color: Colors.white,
                  )),
            ],
            title: _TitleHome(state: state),
            backgroundColor: const Color(0xfff20262e),
          ),
          body: Center(
            child: _HomePageBody(
              state: state,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    connectivitySubscription.cancel();
    socketBloc.socket.off('conversacion-personal');
    socketBloc.socket.off('eliminar-conversacion');
  }
}

// ignore: unused_element
class _FloatingButton extends StatelessWidget {
  final UsuariosState state;

  const _FloatingButton({required this.state});

  @override
  Widget build(BuildContext context) {
    final prefs = PreferenciasUsuario();
    switch (state.indexHome) {
      case 2:
        return const AddUser();
      case 3:
        return state.cofreOpen == false && prefs.pinCarpetasActivado
            ? Container()
            : const Floatingnotes(
                tipo: 1,
              );
      default:
        return Container();
    }
  }
}

class _TitleHome extends StatelessWidget {
  final UsuariosState state;

  const _TitleHome({required this.state});

  @override
  Widget build(BuildContext context) {
    final notesBloc = BlocProvider.of<NotesBloc>(context);
    switch (state.indexHome) {
      case 0:
        notesBloc.clearALL();
        return const SwitcherTittle();
      case 1:
        notesBloc.clearALL();
        return const Text(
          "Calls",
          style: TextStyle(color: Colors.white, fontSize: 15),
        );
      case 2:
        notesBloc.clearALL();
        return const Text(
          "Contactos",
          style: TextStyle(color: Colors.white, fontSize: 15),
        );
      case 3:
        return const Text(
          "Folder",
          style: TextStyle(color: Colors.white, fontSize: 15),
        );
      case 4:
        notesBloc.clearALL();
        return const Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontSize: 15),
        );
      default:
        notesBloc.clearALL();
        return const Text(
          "Chats",
          style: TextStyle(color: Colors.white, fontSize: 15),
        );
    }
  }
}

class _HomePageBody extends StatelessWidget {
  final UsuariosState state;
  const _HomePageBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final prefs = PreferenciasUsuario();

    switch (state.indexHome) {
      case 0:
        return BlocBuilder<ConversacionesBloc, ConversacionesState>(
          builder: (context, state) {
            return state.selectedGroup == 0
                ? const Homepage()
                : const HomePageGroup();
          },
        );
      case 1:
        return const CallsPageHome();
      case 2:
        return const ContactosPage();
      case 3:
        return state.cofreOpen == false && prefs.pinCarpetasActivado
            ? const CofrePin()
            : const FolderPage();

      case 4:
        return const Accountpage();
      default:
        return const Homepage();
    }
  }
}
