import 'package:eclips_3/bloc/login/login_bloc.dart';
import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:eclips_3/pages/account/widgets/option_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class Accountpage extends StatelessWidget {
  const Accountpage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    final data = AppLocalizations.of(context)!;

    return ListView(
      children: [
        OptionList(
            name: data.tab70,
            iconData: Icons.account_circle,
            onTap: () => CustomWIdgets.userInterface(context)),
        if (loginBloc.usuario!.rol == 'ADMIN_ROLE') ...[
          const Divider(),
          OptionList(
              name: data.tab71,
              iconData: CupertinoIcons.profile_circled,
              onTap: () => Navigator.pushNamed(context, 'Master')),
        ],
        const Divider(),
        OptionList(
            name: data.tab72,
            iconData: Icons.pin,
            onTap: () => Navigator.pushNamed(context, 'seguridad')),
        const Divider(),
        OptionList(
            name: data.tab73,
            iconData: CupertinoIcons.doc_fill,
            onTap: () => Navigator.pushNamed(context, 'pinCarpetas')),
        OptionList(
            name: data.tab175,
            iconData: CupertinoIcons.chat_bubble,
            onTap: () => Navigator.pushNamed(context, 'chatConfig'))
      ],
    );
  }
}
