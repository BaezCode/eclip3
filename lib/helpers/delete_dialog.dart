import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

enum DialogAction { yes, abort }

class Dialogs {
  static Future<DialogAction> yesAbortDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    final data = AppLocalizations.of(context)!;

    final action = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            title,
            style: const TextStyle(color: Colors.black),
          ),
          content: Text(
            body,
            style: const TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.black,
              onPressed: () => Navigator.of(context).pop(DialogAction.yes),
              child: Text(
                data.tab3,
                style: TextStyle(color: Colors.white),
              ),
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 5,
              color: Colors.white,
              onPressed: () => Navigator.of(context).pop(DialogAction.abort),
              child: Text(
                data.tab45,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : DialogAction.abort;
  }
}
