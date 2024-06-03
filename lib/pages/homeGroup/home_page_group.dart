import 'package:eclips_3/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:eclips_3/pages/home/widgets/sin_chats.dart';
import 'package:eclips_3/pages/homeGroup/widgets/body_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageGroup extends StatefulWidget {
  const HomePageGroup({super.key});

  @override
  State<HomePageGroup> createState() => _HomePageGroupState();
}

class _HomePageGroupState extends State<HomePageGroup> {
  late ConversacionesBloc conversacionesBloc;

  @override
  void initState() {
    super.initState();
    conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
    inicial();
  }

  inicial() async {
    conversacionesBloc.add(LoadingConv(true));
    await conversacionesBloc.getGrupos();
    conversacionesBloc.add(LoadingConv(false));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversacionesBloc, ConversacionesState>(
      builder: (context, state) {
        return state.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : state.grupos.isEmpty
                ? const SinChats()
                : ListView.separated(
                    separatorBuilder: (_, i) => const Divider(),
                    itemCount: state.grupos.length,
                    itemBuilder: (ctx, i) {
                      final grupo = state.grupos[i];
                      try {
                        return BodyGroup(
                          grupo: grupo,
                        );
                      } catch (e) {
                        return Container();
                      }
                    },
                  );
      },
    );
  }
}
