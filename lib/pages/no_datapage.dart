import 'package:flutter/material.dart';

class NoDataPage extends StatelessWidget {
  final String message;

  const NoDataPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(message),
      ),
    );
  }
}

/*
Purpose: Displays a simple message when there's no data available.

Stateless Widget: Doesn't manage any internal state.

Takes a Message: Requires a string message as input.

UI: Shows the message centered on the screen using Center and Text.

Use Case: Helpful for showing "no tasks", "no categories", or empty state screens.
 */