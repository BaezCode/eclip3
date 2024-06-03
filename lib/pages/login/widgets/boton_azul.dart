import 'package:flutter/material.dart';

class BotomAzul extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const BotomAzul({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      highlightElevation: 5,
      onPressed: onPressed,
      child: SizedBox(
        width: size.width * 0.18,
        height: size.height * 0.060,
        child: Center(
          child: Text(text,
              style: const TextStyle(color: Colors.white, fontSize: 15)),
        ),
      ),
    );
  }
}
