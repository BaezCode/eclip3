import 'package:flutter/material.dart';

class OptionList extends StatelessWidget {
  final String name;
  final IconData iconData;
  final Function()? onTap;
  const OptionList(
      {super.key,
      required this.name,
      required this.iconData,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        iconData,
        color: Colors.black,
        size: 25,
      ),
      title: Text(
        name,
        style: const TextStyle(color: Colors.black, fontSize: 15),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_outlined,
        size: 15,
      ),
    );
  }
}
