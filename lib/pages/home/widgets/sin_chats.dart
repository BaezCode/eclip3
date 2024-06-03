import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class SinChats extends StatelessWidget {
  const SinChats({super.key});

  @override
  Widget build(BuildContext context) {
    final resp = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.chat_bubble_2,
            size: 40,
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            resp.tab109,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
