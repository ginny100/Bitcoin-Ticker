import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'price_screen.dart';

Future main() async {
  // To load the .env file contents into dotenv,
  // Ensure that the filename corresponds to the path defined in the .env and pubspec.yaml files
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          primaryColor: Colors.lightBlue,
          scaffoldBackgroundColor: Colors.white),
      home: PriceScreen(),
    );
  }
}
