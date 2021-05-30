import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:sulaimanfood/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';

// void main() {
//   runApp(MyApp());
// }

Future main() async {
  await ThemeManager.initialise();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebaseCloudMessaging();

  runApp(MyApp());
}

Future<dynamic> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.reload();

  if (message.data != null) {
    message.data.forEach((key, value) async {
    //  print("bg storing key=$key, value=$value");
      await prefs.setString(key, value);
    });
    await prefs.reload();
  
  }
}

Future<void> initFirebaseCloudMessaging() async {
  await Firebase.initializeApp();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.white, accentColor: Colors.lightBlueAccent),
      title: 'Sulaiman Food',
      home: Home(),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
