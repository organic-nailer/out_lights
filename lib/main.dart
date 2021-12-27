import 'package:flutter/material.dart';
import 'package:out_lights/front_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OutLights',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const FrontPage(),
    );
  }
}
