import 'package:eclips_3/bloc/conversaciones/conversaciones_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class SwitcherTittle extends StatelessWidget {
  const SwitcherTittle({super.key});

  @override
  Widget build(BuildContext context) {
    final conversacionesBloc = BlocProvider.of<ConversacionesBloc>(context);
    final sr = AppLocalizations.of(context)!;

    return BlocBuilder<ConversacionesBloc, ConversacionesState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minWidth: 60,
                color: state.selectedGroup == 0
                    ? Colors.blue[800]
                    : Colors.transparent,
                onPressed: () {
                  if (state.selectedGroup != 0) {
                    conversacionesBloc.add(SetListConv([]));
                    conversacionesBloc.add(SelectedGroup(0));
                  }
                },
                child: Text(
                  sr.tab30,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minWidth: 60,
                color: state.selectedGroup == 1
                    ? Colors.blue[800]
                    : Colors.transparent,
                onPressed: () {
                  if (state.selectedGroup != 1) {
                    conversacionesBloc.add(SetListGrupos([]));
                    conversacionesBloc.add(SelectedGroup(1));
                  }
                },
                child: Text(
                  sr.tab31,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
