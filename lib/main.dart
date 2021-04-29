import 'package:flutter/material.dart';
import 'package:sulaimanfood/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      title: 'Sulaiman Food',
      home: Home(),
    );
  }
}
