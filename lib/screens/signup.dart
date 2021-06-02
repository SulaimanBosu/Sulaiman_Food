import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sulaimanfood/screens/signin.dart';
import 'package:sulaimanfood/utility/myConstant.dart';
import 'package:sulaimanfood/utility/my_style.dart';
import 'package:sulaimanfood/utility/normal_dialog.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String chooseType, name, user, password;
  bool registerStatus = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().appbarColor,
        title: Text('Sign Up'),
      ),
      body: registerStatus == true ? progress(context) : buildContent(),
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
      child: ListView(
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          myLogo(),
          MyStyle().mySizebox(),
          showAppName(),
          MyStyle().mySizebox(),
          nameForm(),
          MyStyle().mySizebox(),
          userForm(),
          MyStyle().mySizebox(),
          passwordForm(),
          MyStyle().mySizebox(),
          Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: MyStyle().showTitleH2('ประเภทสมาชิก : ')),
          MyStyle().mySizebox(),
          userRadio(),
          shopRadio(),
          riderRadio(),
          MyStyle().mySizebox(),
          registerButton(),
          MyStyle().mySizebox(),
        ],
      ),
    );
  }

  Widget registerButton() => Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        width: 300.0,
        child: RaisedButton(
          color: Colors.black26,
          onPressed: () {
            // print('name = $name, user = $user, password = $password, chooseType = $chooseType');
            if (name == null ||
                name.isEmpty ||
                user == null ||
                user.isEmpty ||
                password == null ||
                password.isEmpty) {
              print('Have Space');
              normalDialog(context, 'กรุณากรอกข้อมูลให้ครบค่ะ');
            } else if (chooseType == null) {
              normalDialog(context, 'โปรดเลือกประเภทสมาชิก');
            } else {
              setState(() {
                registerStatus = true;
              });
              _onLoading();
              checkUser();
              //registerThread();
            }
          },
          child: Text(
            'Register',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  Future<void> registerlDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          children: [
            Row(children: [
              Icon(
                Icons.notifications_active,
                color: Colors.black54,
              ),
              MyStyle().mySizebox(),
              MyStyle().showTitle_2('Register'),
            ]),
            Divider(
              color: Colors.black54,
            ),
          ],
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyStyle().showtext_2('สมัครสมาชิกเรียบร้อย'),
          ],
        ),
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
            child: Text("ตกลง"),
            onPressed: () {
              
              Navigator.pop(context);
              routeToSignIn(SignIn());
            },
          ),
          // ignore: deprecated_member_use
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      );
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
                      'กำลังสมัครสมาชิก...',
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

  void _onLoading() {
    Timer(
      Duration(seconds: 20),
      () {
        if (registerStatus == true) {
          setState(() {
            registerStatus = false;
            normalDialog(context, 'การเชื่อมต่อล้มเหลว');
          });
        } else {}
      },
    );
  }

  Future<Null> checkUser() async {
    String url =
        '${MyConstant().domain}/Sulaiman_food/getUserWhereUser.php?isAdd=true&user=$user';

    try {
      Response response = await Dio().get(url);
      print('res = $response');

      if (response.toString() == 'null') {
        registerThread();
      } else {
        setState(() {
          registerStatus = false;
        });
        normalDialog(context, '$user มีอยู่ในระบบแล้วคะ');
      }
    } catch (e) {
      normalDialog(context, e);
    }
  }

  Future<Null> registerThread() async {
    String url =
        '${MyConstant().domain}/Sulaiman_food/addUser.php?isAdd=true&name=$name&user=$user&password=$password&chooseType=$chooseType';

    try {
      Response response = await Dio().get(url);
      print('res = $response');

      if (response.toString() == 'true') {
        // Navigator.pop(context);
        setState(() {
          registerStatus = false;
        });
        registerlDialog(context);
        
      } else {
        normalDialog(context, 'ล้มเหลว กรุณาลองใหม่อีกครั้งค่ะ');
      }
    } catch (e) {
      normalDialog(context, e);
    }
  }

  void routeToSignIn(Widget myWidget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Widget userRadio() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            width: MediaQuery.of(context).size.width * 0.7,
            child: Row(
              children: <Widget>[
                Radio(
                  value: 'User',
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(() {
                      chooseType = value;
                    });
                  },
                ),
                Text(
                  'ผู้สั่งอาหาร',
                  style: TextStyle(
                    fontSize: 20.0,
                    // fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    // fontStyle: FontStyle.italic,
                    fontFamily: 'FC-Minimal-Regular',
                  ),
                )
              ],
            ),
          ),
        ],
      );

  Widget shopRadio() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            width: MediaQuery.of(context).size.width * 0.7,
            child: Row(
              children: <Widget>[
                Radio(
                  value: 'Shop',
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(() {
                      chooseType = value;
                    });
                  },
                ),
                Text(
                  'เจ้าของร้านอาหาร',
                  style: TextStyle(
                    fontSize: 20.0,
                    // fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    // fontStyle: FontStyle.italic,
                    fontFamily: 'FC-Minimal-Regular',
                  ),
                )
              ],
            ),
          ),
        ],
      );

  Widget riderRadio() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            width: MediaQuery.of(context).size.width * 0.7,
            child: Row(
              children: <Widget>[
                Radio(
                  value: 'Rider',
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(() {
                      chooseType = value;
                    });
                  },
                ),
                Text(
                  'ผู้ส่งอาหาร',
                  style: TextStyle(
                    fontSize: 20.0,
                    // fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    // fontStyle: FontStyle.italic,
                    fontFamily: 'FC-Minimal-Regular',
                  ),
                )
              ],
            ),
          ),
        ],
      );

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300.0,
            child: TextField(
              onChanged: (value) => name = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.face,
                  color: Colors.black54,
                ),
                labelStyle: TextStyle(
                  fontSize: 22.0,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  // fontStyle: FontStyle.italic,
                  fontFamily: 'FC-Minimal-Regular',
                ),
                labelText: 'Name : ',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
              ),
            ),
          ),
        ],
      );

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
              onChanged: (value) => password = value.trim(),
              decoration: InputDecoration(
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

  Row showAppName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MyStyle().showTitle('Sulaiman Food'),
      ],
    );
  }

  Widget myLogo() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MyStyle().showlogo(),
        ],
      );
}
