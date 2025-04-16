import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  VoidCallback onPressed;

  AppButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      // color: Theme.of(context).primaryColor,
      color: const Color.fromRGBO(44, 166, 164, 1),
      textColor: Colors.black,
      child: Text(text),
    );
  }
}

/*
Widget Type: StatelessWidget

Purpose: Custom reusable button

Parameters:

text: Label shown on the button

onPressed: Action callback when button is tapped

Style:

Uses MaterialButton

Background color: Teal (Color(0xFF2CA6A4))

Text color: Black

Use Case: Makes consistent buttons throughout the app
 */
