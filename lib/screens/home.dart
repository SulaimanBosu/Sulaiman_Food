import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sulaimanfood/screens/main_rider.dart';
import 'package:sulaimanfood/screens/main_shop.dart';
import 'package:sulaimanfood/screens/main_user.dart';
import 'package:sulaimanfood/screens/signin.dart';
import 'package:sulaimanfood/screens/signup.dart';
import 'package:sulaimanfood/utility/my_style.dart';
import 'package:sulaimanfood/utility/normal_dialog.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    checkPreferance();
  }

  Future<Null> checkPreferance() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String chooseType = preferences.getString('ChooseType');
      if (chooseType != null && chooseType.isNotEmpty) {
        if (chooseType == 'User') {
          routeToService(MainUser());
        } else if (chooseType == 'Shop') {
          routeToService(MainShop());
        } else if (chooseType == 'Rider') {
          routeToService(MainRider());
        } else {
          normalDialog(context, 'Error User Type');
        }
      }
    } catch (e) {}
  }

  void routeToService(Widget myWidget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: showDrawer(),
      body: Container(
        color: Colors.lightBlueAccent,
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyStyle().mySizebox(),
              MyStyle().mySizebox(),
              MyStyle().mySizebox(),
              MyStyle().mySizebox(),
              MyStyle().mySizebox(),
              // showMap(),
              MyStyle().mySizebox(),
              //  saveButton(),
              MyStyle().mySizebox(),
            ],
          ),
        ),
      ),
    ); //Scaffold
  }

  // Widget saveButton() {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     child: RaisedButton.icon(
  //       color: MyStyle().primaryColor,
  //       onPressed: () {},
  //       icon: Icon(Icons.save,color: Colors.white,),
  //       label: Text('Save Infomation',style: TextStyle(color: Colors.white),),
  //     ),
  //   );
  // }

  // Container showMap() {
  //   LatLng latLng = LatLng(13.601704, 100.626396);
  //   CameraPosition cameraPosition = CameraPosition(
  //     target: latLng,
  //     zoom: 16.0,
  //   );

  //   return Container(
  //     height: 300,
  //     child: GoogleMap(
  //       initialCameraPosition: cameraPosition,
  //       mapType: MapType.normal,
  //       onMapCreated: (controller) {},
  //     ),
  //   );
  // }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHeadDrawer(),
            signInMenu(),
            signUpMenu(),
          ],
        ),
      );

  ListTile signInMenu() {
    return ListTile(
      leading: Container(
        width: 30.0,
        height: 30.0,
        child: Image.asset('images/icon_touch-id.png'),
      ),
      title: Text(
        'Sign In',
        style: TextStyle(fontSize: 22.0),
      ),
      subtitle: Text('เข้าสู่ระบบ'),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => SignIn());
        Navigator.push(context, route);
      },
    );
  }

  ListTile signUpMenu() {
    return ListTile(
      leading: Container(
        width: 30.0,
        height: 30.0,
        child: Image.asset('images/icon_register.png'),
      ),
      title: Text(
        'Sign Up',
        style: TextStyle(fontSize: 22.0),
      ),
      subtitle: Text('สมัครสมาชิก'),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => SignUp());
        Navigator.push(context, route);
      },
    );
  }

  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
        decoration: MyStyle().myBoxDecoration('food.jpg'),
        currentAccountPicture: MyStyle().showlogo(),
        accountName: Text('Guest'),
        accountEmail: Text('Please Login'));
  }
}
