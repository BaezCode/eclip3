import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeFloatingButton extends StatelessWidget {
  const HomeFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Color(0xfff20262e),
              borderRadius: BorderRadius.circular(10)),
          child: IconButton(
              onPressed: () {},
              icon: const Icon(
                FontAwesomeIcons.folder,
                color: Colors.white,
              )),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.blue[800], borderRadius: BorderRadius.circular(10)),
          child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "contactos");
              },
              icon: const Icon(
                FontAwesomeIcons.comment,
                color: Colors.white,
              )),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
