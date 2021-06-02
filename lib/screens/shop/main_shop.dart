import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sulaimanfood/utility/myConstant.dart';
import 'package:sulaimanfood/utility/my_style.dart';

import 'package:sulaimanfood/utility/signout_process.dart';
import 'package:sulaimanfood/widget/shop/infomation_shop.dart';
import 'package:sulaimanfood/widget/shop/list_menu_shop.dart';
import 'package:sulaimanfood/widget/shop/order_list_shop.dart';

class MainShop extends StatefulWidget {
  @override
  _MainShopState createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
  String nameUser;
  Widget currentWidget = ListMenuShop();
  Widget infoShop = InfomationShop();
  Widget orderListShop = OrderListShop();

  @override
  initState() {
    super.initState();
    findUser();
    aboutNotification();
  }

  Future<Null> aboutNotification() async {
    try {
      FirebaseMessaging _messaging = FirebaseMessaging.instance;
      String token = await _messaging.getToken();
      print('token >>>>>>>>>>>> $token');
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String userid = preferences.getString('User_id');
      print('User id ==== $userid');

      if (userid != null && userid.isNotEmpty) {
        String url =
            '${MyConstant().domain}/Sulaiman_food/edit_token.php?isAdd=true&Token=$token&userid=$userid';
        await Dio().get(url).then((value) => print('อัพเดท Token เรียบร้อย'));
      }
    } catch (e) {}

    if (Platform.isAndroid) {
      print('Notiwork Android');
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('ผู้ใช้ ได้อนุญาต');
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
          String title = message.data['title'];
          String notiMessage = message.data['body'];
          print('Message data: ${message.data}');

          if (message.notification != null) {
            print('title ==== ${notiMessage.toString()}');
            orderDialog(title, notiMessage);
          }
        });

        FirebaseMessaging.onMessageOpenedApp
            .listen((RemoteMessage message) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.reload();
          String title = prefs.getString('title');
          String notiMessage = prefs.getString('body');
          if (notiMessage != null && notiMessage.isNotEmpty) {
            // orderDialog(title, notiMessage);
            setState(() {
              currentWidget = OrderListShop();
            });
          }
          await prefs.remove('body');
          print('send $notiMessage');
        });
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('ผู้ใช้ ได้อนุญาตชั่วคราว');
      } else {
        print('ผู้ใช้ปฏิเสธหรือไม่ยอมรับการอนุญาต');
      }
    } else if (Platform.isIOS) {
      print('Notiwork IOS');
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    } else {}
  }

  Future<Null> removenoti() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    await prefs.remove('title');
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('Name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title:
        //      Text(nameUser == null ? 'Main Shop' : 'ยินดีต้อนรับคุณ$nameUser'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                signOutProcess(context);
              })
        ],
      ),
      drawer: showDrawer(),
      body: currentWidget,

      //   body: refresh(),
    );
  }

  orderDialog(String title, String body) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlertDialog(
              title: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.notifications_active,color: Colors.black54,),
                      MyStyle().mySizebox(),
                      MyStyle().showtext_2(title),
                    ],
                  ),
                  Divider(
                    color: Colors.black54,
                  ),
                ],
              ),
              content: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: MyStyle().showtext_2(body),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text("เปิดดู"),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      if (currentWidget == OrderListShop()) {
                        setState(() {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      OrderListShop()));
                          // currentWidget = OrderListShop();
                          // removenoti();
                        });
                      } else {
                        currentWidget = OrderListShop();
                        removenoti();
                      }
                    });
                  },
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text("ยกเลิก"),
                  onPressed: () {
                    // ใส่เงื่อนไขการกดยกเลิก
                    setState(() {
                      removenoti();
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ],
        );
      },
    );
  }

  // Center refresh() {
  //   return Center(
  //      child: RefreshIndicator(
  //        onRefresh:()async{
  //            //my refresh method
  //        },
  //      child:CustomScrollView(
  //        slivers:[
  //          SliverFillRemaining (child:infoShop)
  //        ]
  //        )
  //      ),
  //    );
  // }

  Drawer showDrawer() => Drawer(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showHeadDrawer(),
                homeMenu(),
                foodMenu(),
                infomationMenu(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                signOutMenu(),
              ],
            ),
          ],
        ),
      );

  ListTile homeMenu() => ListTile(
        leading: Icon(Icons.home),
        title: Text(
          'รายการอาหารที่ลูกค้าสั่ง',
          style: TextStyle(fontSize: 16.0),
        ),
        subtitle: Text('รายการอาหารที่รอส่ง'),
        onTap: () {
          setState(() {
            currentWidget = OrderListShop();
          });
          Navigator.pop(context);
        },
      );

  ListTile foodMenu() => ListTile(
        leading: Icon(Icons.fastfood),
        title: Text(
          'เมนูอาหาร',
          style: TextStyle(fontSize: 16.0),
        ),
        subtitle: Text('เพิ่ม แก้ไขเมนูอาหาร'),
        onTap: () {
          setState(() {
            currentWidget = ListMenuShop();
            // currentWidget = PercentIndicatorDemo();
          });
          Navigator.pop(context);
        },
      );

  ListTile infomationMenu() => ListTile(
        leading: Icon(Icons.info),
        title: Text(
          'รายละเอียดร้านอาหาร',
          style: TextStyle(fontSize: 16.0),
        ),
        subtitle: Text('เพิ่ม แก้ไขรายละเอียดร้าน'),
        onTap: () {
          setState(() {
            currentWidget = InfomationShop();
          });
          Navigator.pop(context);
        },
      );

  Widget signOutMenu() {
    return Container(
      decoration: BoxDecoration(color: Colors.red.shade600),
      child: ListTile(
        leading: Icon(
          Icons.logout,
          color: Colors.white,
        ),
        title: Text(
          'Sign Out',
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        subtitle: Text(
          'ออกจากระบบ',
          style: TextStyle(color: Colors.white),
        ),
        onTap: () {
          signOutProcess(context);
        },
      ),
    );
  }

  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/food_shop.jpg'), fit: BoxFit.contain),
        ),
        currentAccountPicture: MyStyle().showlogo(),
        accountName: Text(
          nameUser,
          style: TextStyle(
              color: MyStyle().darkColor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        accountEmail: Text(
          '  LogOut',
          style: TextStyle(color: Colors.black54),
        ));
  }
}
