import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sulaimanfood/model/user_model.dart';
import 'package:sulaimanfood/screens/main_rider.dart';
import 'package:sulaimanfood/screens/shop/main_shop.dart';
import 'package:sulaimanfood/screens/user/main_user.dart';
import 'package:sulaimanfood/utility/myConstant.dart';
import 'package:sulaimanfood/utility/my_style.dart';
import 'package:sulaimanfood/utility/normal_dialog.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String user, password;
  bool loginStatus = false;
  double screen;
  bool statusRedEye = true;
  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().appbarColor,
        title: Text('Sign In'),
      ),
      body: loginStatus == true ? progress(context) : buildContent(),
    );
  }

  Container buildContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: <Color>[Colors.white, MyStyle().redColor],
          // center: Alignment(0, -0.3),
          radius: 1.0,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MyStyle().showlogo(),
              MyStyle().mySizebox(),
              MyStyle().showTitle('Sulaiman Food'),
              MyStyle().mySizebox(),
              userForm(),
              MyStyle().mySizebox(),
              passwordForm(),
              MyStyle().mySizebox(),
              loginButton(),
              MyStyle().mySizebox(),
              MyStyle().mySizebox(),
              MyStyle().mySizebox(),
            ],
          ),
        ),
      ),
    );
  }

  void _onLoading() {
    Timer(
      Duration(seconds: 20),
      () {
        if (loginStatus == true) {
          setState(() {
            loginStatus = false;
            normalDialog(context, 'การเชื่อมต่อล้มเหลว');
          });
        } else {}
      },
    );
  }

  Widget progress(BuildContext context) {
    return Container(
        child: new Stack(
      children: <Widget>[
        buildContent(),
        Container(
          alignment: AlignmentDirectional.center,
          decoration: new BoxDecoration(
            color: Colors.white24,
          ),
          child: new Container(
            decoration: new BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: new BorderRadius.circular(10.0)),
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.3,
            alignment: AlignmentDirectional.center,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Center(
                  child: new SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: new CircularProgressIndicator(
                      value: null,
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      strokeWidth: 7.0,
                    ),
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 25.0),
                  child: new Center(
                    child: new Text(
                      'เข้าสู่ระบบ...',
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.black45,
                        fontFamily: 'FC-Minimal-Regular',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget loginButton() => Container(
        width: 300.0,
        child: RaisedButton(
          color: Colors.black26,
          onPressed: () {
            MyStyle().showProgress2('กรุณารอสักครู่...');
            if (user == null ||
                user.isEmpty ||
                password == null ||
                password.isEmpty) {
              normalDialog(context, 'กรุณากรอกข้อมูลให้ครบค่ะ');
            } else {
              setState(() {
                loginStatus = true;
              });
              _onLoading();
              checkAuthen();
            }
          },
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  Future<Null> checkAuthen() async {
    String url =
        '${MyConstant().domain}/Sulaiman_food/getUserWhereUser.php?isAdd=true&user=$user';
    try {
      Response response = await Dio().get(url);
      print('res = $response');
      if (response.toString() != 'null') {
        var result = json.decode(response.data);
        print('result = $result');
        for (var map in result) {
          UserModel userModel = UserModel.fromJson(map);
          if (password == userModel.password) {
            String chooseType = userModel.chooseType;
            if (chooseType == 'User') {
              routeToService(MainUser(), userModel);
            } else if (chooseType == 'Shop') {
              routeToService(MainShop(), userModel);
            } else if (chooseType == 'Rider') {
              routeToService(MainRider(), userModel);
            } else {
              setState(() {
                loginStatus = false;
              });
              normalDialog(context, 'ไม่พบประเภพของสมาชิก กรุณาลองอีกครั้งค่ะ');
            }
          } else {
            setState(() {
              loginStatus = false;
            });
            normalDialog(context, 'รหัสผ่านผิด กรุณาลองใหม่');
          }
        }
      } else {
        setState(() {
          loginStatus = false;
        });
        normalDialog(context, 'ชื่อเข้าใช้ไม่ถูกต้องคะ');
      }
    } catch (e) {
      setState(() {
        loginStatus = false;
      });
      normalDialog(context, 'เชื่อมต่อเซอร์เวอร์ล้มเหลว');
    }
  }

  Future<void> routeToService(Widget myWidget, UserModel userModel) async {
    FirebaseMessaging _messaging = FirebaseMessaging.instance;
    String token = await _messaging.getToken();
    print('token >>>>>>>>>>>> $token');

    //REGISTER REQUIRED FOR IOS
    if (Platform.isIOS) {
      _messaging.requestPermission();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('User_id', userModel.userId);
    preferences.setString('ChooseType', userModel.chooseType);
    preferences.setString('User', userModel.user);
    preferences.setString('Name', userModel.name);
    if (userModel.userId != null && userModel.userId.isNotEmpty) {
      String url =
          '${MyConstant().domain}/Sulaiman_food/edit_token.php?isAdd=true&Token=$token&userid=${userModel.userId}';
      await Dio().get(url).then((value) {
        print('อัพเดท Token เรียบร้อย');
        setState(() {
          loginStatus = false;
        });
      });
    }

    if (userModel.shopId == null || userModel.shopId.isEmpty) {
      MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => myWidget,
      );
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    } else {
      preferences.setString('Shop_id', userModel.shopId);
      MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => myWidget,
      );
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    }
  }

  Widget userForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300.0,
            child: TextField(
              onChanged: (value) => user = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.account_box,
                  color: Colors.black54,
                ),
                labelStyle: TextStyle(
                  fontSize: 22.0,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  // fontStyle: FontStyle.italic,
                  fontFamily: 'FC-Minimal-Regular',
                ),
                labelText: 'User : ',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
              ),
            ),
          ),
        ],
      );

  Widget passwordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300.0,
            child: TextField(
              obscureText: statusRedEye,
              onChanged: (value) => password = value.trim(),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: statusRedEye ? Icon(Icons.remove_red_eye,color: Colors.black54,) : Icon(Icons.remove_red_eye_outlined,color: Colors.black54,),
                    onPressed: () {
                      setState(() {
                        statusRedEye = !statusRedEye;
                      });
                    }),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black54,
                ),
                labelStyle: TextStyle(
                  fontSize: 22.0,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  // fontStyle: FontStyle.italic,
                  fontFamily: 'FC-Minimal-Regular',
                ),
                labelText: 'Password : ',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
              ),
            ),
          ),
        ],
      );
}
