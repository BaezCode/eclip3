import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class EmptyFolder extends StatelessWidget {
  const EmptyFolder({super.key});

  @override
  Widget build(BuildContext context) {
    final data = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.doc,
            size: 40,
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            data.tab100,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
