import 'package:eclips_3/helpers/customWidgets.dart';
import 'package:flutter/material.dart';

class AddUser extends StatelessWidget {
  const AddUser({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: FittedBox(
        child: FloatingActionButton(
            backgroundColor: Color(0xfff20262e),
            child: const Icon(
              Icons.group_add_rounded,
              size: 17,
            ),
            onPressed: () {
              CustomWIdgets.addContacto(context);
            }),
      ),
    );
  }
}
