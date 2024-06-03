import 'package:flutter/material.dart';

class BotonTrasero extends StatelessWidget {
  final Function()? ontap;

  const BotonTrasero({
    Key? key,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.black,
      onPressed: ontap,
      icon: const Icon(Icons.keyboard_arrow_left_rounded),
    );
  }
}
