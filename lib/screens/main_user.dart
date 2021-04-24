import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sulaimanfood/screens/home.dart';
import 'package:sulaimanfood/screens/signin.dart';
import 'package:sulaimanfood/utility/my_style.dart';
import 'package:sulaimanfood/utility/signout_process.dart';

class MainUser extends StatefulWidget {
  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  String nameUser;
  String userid;

  @override
  void initState() {
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('Name');
      userid = preferences.getString('User_id');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(nameUser == null ? 'Main User' : 'ยินดีต้อนรับคุณ$userid'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                signOutProcess(context);
                routeToHome();
              })
        ],
      ),
      drawer: showDrawer(),
    );
  }

  void routeToHome() {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => Home(),
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHeadDrawer(),
            signOutMenu(),
          ],
        ),
      );

  ListTile signOutMenu() {
    return ListTile(
      leading: Icon(Icons.logout),
      title: Text('Sign Out'),
      onTap: () {
        signOutProcess(context);
        // Navigator.pop(context);
        // MaterialPageRoute route = MaterialPageRoute(builder: (value) => Home());
        // Navigator.pushAndRemoveUntil(context, route, (route) => false);
      },
    );
  }

  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
        decoration: MyStyle().myBoxDecoration('food_user.jpg'),
        currentAccountPicture: MyStyle().showlogo(),
        accountName: Text(
          'Name',
          style: TextStyle(
              color: MyStyle().darkColor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        accountEmail: Text(
          'Login',
          style: TextStyle(color: Colors.black54),
        ));
  }
}
