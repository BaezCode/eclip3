import 'package:eclips_3/helpers/customPins.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/eclips_3.dart';

class CofrePin extends StatelessWidget {
  const CofrePin({super.key});

  @override
  Widget build(BuildContext context) {
    final data = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.lock,
            size: 40,
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            data.tab92,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 25,
          ),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.blue[700],
              child: Text(
                data.tab93,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => CustomPins.customCarpetasPin(
                    context,
                  ))
        ],
      ),
    );
  }
}
