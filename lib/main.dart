import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tdl/pages/homepage.dart';

void main() async {
  // init hive
  await Hive.initFlutter();

  // open a box
  var box = await Hive.openBox('todoBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}

/*
This code:

Initializes Hive for local data storage.

Opens a Hive box called 'todoBox' to store to-do items.

Runs a Flutter app with a green-themed UI.

Loads a HomePage widget (where the to-do list logic/UI likely exists).
 */

