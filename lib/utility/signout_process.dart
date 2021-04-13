
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sulaimanfood/screens/home.dart';

Future<Null> signOutProcess(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.clear();
  //  exit(0);

 MaterialPageRoute route = MaterialPageRoute(builder: (value) => Home());
  Navigator.pushAndRemoveUntil(context, route, (route) => false);
}
