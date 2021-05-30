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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: <Color>[Colors.white, MyStyle().primaryColor],
            center: Alignment(0, -0.3),
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
      ),
    );
  }

  Widget registerButton() => Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        width: 300.0,
        child: RaisedButton(
          color: MyStyle().darkColor,
          onPressed: () {
            MyStyle().showProgress2('กรุณารอสักครู่...');
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

  Future<Null> checkUser() async {
    String url =
        '${MyConstant().domain}/Sulaiman_food/getUserWhereUser.php?isAdd=true&user=$user';

    try {
      Response response = await Dio().get(url);
      print('res = $response');

      if (response.toString() == 'null') {
        registerThread();
      } else {
        normalDialog(context, '$user มีอยู่ในระบบแล้วค่ะ');
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
        routeToSignIn(SignIn());
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
                  style: TextStyle(color: MyStyle().darkColor),
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
                  style: TextStyle(color: MyStyle().darkColor),
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
                  style: TextStyle(color: MyStyle().darkColor),
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
                  color: MyStyle().darkColor,
                ),
                labelStyle: TextStyle(color: MyStyle().darkColor),
                labelText: 'Name : ',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().darkColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().primaryColor)),
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
                  color: MyStyle().darkColor,
                ),
                labelStyle: TextStyle(color: MyStyle().darkColor),
                labelText: 'User : ',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().darkColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().primaryColor)),
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
                  color: MyStyle().darkColor,
                ),
                labelStyle: TextStyle(color: MyStyle().darkColor),
                labelText: 'Password : ',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().darkColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().primaryColor)),
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
