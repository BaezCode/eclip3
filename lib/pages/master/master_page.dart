import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/bloc/master/master_bloc.dart';
import 'package:eclips_3/pages/master/widgets/body_master.dart';
import 'package:eclips_3/pages/master/widgets/crear_usuario.dart';
import 'package:eclips_3/pages/master/widgets/pop_menu_master.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MasterPage extends StatefulWidget {
  const MasterPage({super.key});

  @override
  State<MasterPage> createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  late MasterBloc masterBloc;
  late LoginBloc loginBloc;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    masterBloc = BlocProvider.of<MasterBloc>(context);
    loginBloc = BlocProvider.of<LoginBloc>(context);
    init();
  }

  void init() async {
    await masterBloc.getUsuarios(loginBloc.usuario!.uid);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MasterBloc, MasterState>(
      builder: (context, state) {
        return Scaffold(
            floatingActionButton: const CreaUser(),
            appBar: AppBar(
              centerTitle: false,
              actions: [
                PopMenuMaster(usuarios: state.usuarios),
              ],
              title: const Text(
                "Opciones de Master",
                style: TextStyle(fontSize: 18),
              ),
              backgroundColor: const Color(0xfff20262e),
            ),
            body: loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _listviewUsuarios(state));
      },
    );
  }

  ListView _listviewUsuarios(MasterState state) {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, i) => BodyMaster(contacts: state.usuarios[i]),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: state.usuarios.length);
  }
}
