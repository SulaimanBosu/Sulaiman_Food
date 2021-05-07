import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sulaimanfood/model/foodMenu_Model.dart';
import 'package:sulaimanfood/screens/home.dart';
import 'package:sulaimanfood/utility/my_style.dart';
import 'package:sulaimanfood/utility/signout_process.dart';
import 'package:sulaimanfood/widget/user/show_list_menu_all.dart';
import 'package:sulaimanfood/widget/user/show_list_order_all.dart';
import 'package:sulaimanfood/widget/user/show_list_shop_all.dart';

class MainUser extends StatefulWidget {
  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  String nameUser;
  String userid;
  // ignore: deprecated_member_use
  List<FoodMenuModel> foodMenuModels = List();
  // ignore: deprecated_member_use
  List<Widget> foodCards = List();
  Widget currentWidget;

  @override
  void initState() {
    super.initState();
    currentWidget = ShowListMenuAll();
    findUser();
    // readfood();
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
        title: Text(nameUser == null ? 'Main User' : ''),
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
      body: Container(
        color: Colors.lightBlueAccent,
        child: currentWidget,
      ),
    );
  }

  void routeToHome() {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => Home(),
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Drawer showDrawer() => Drawer(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showHeadDrawer(),
                list_menu(),
                list_shop(),
                list_order(),
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

  // ignore: non_constant_identifier_names
  ListTile list_menu() {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          currentWidget = ShowListMenuAll();
        });
      },
      leading: Icon(Icons.fastfood),
      title: Text(
        'เมนูอาหาร',
        style: TextStyle(fontSize: 18.0),
      ),
      subtitle: Text('เมนูทั้งหมด'),
    );
  }

// ignore: non_constant_identifier_names
  ListTile list_shop() {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          currentWidget = ShowListShopAll();
        });
      },
      leading: Icon(Icons.home),
      title: Text(
        'ร้านค้าใกล้คุณ',
        style: TextStyle(fontSize: 18.0),
      ),
      subtitle: Text('รายละเอียดร้านค้า'),
    );
  }

// ignore: non_constant_identifier_names
  ListTile list_order() {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          currentWidget = ShowListOrderAll();
        });
      },
      leading: Icon(Icons.shopping_basket_rounded),
      title: Text(
        'รายการอาหารที่สั่ง',
        style: TextStyle(fontSize: 18.0),
      ),
      subtitle: Text('รายการสั่งซื้อ'),
    );
  }

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
      decoration: MyStyle().myBoxDecoration('food_user.jpg'),
      currentAccountPicture: MyStyle().showlogo(),
      accountName: Text(
        nameUser,
        style: TextStyle(
            color: MyStyle().darkColor,
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
      // accountEmail: ListTile(
      //   title: Text('Sign Out'),
      //   onTap: () {
      //     signOutProcess(context);
      //   },
      // ),
      accountEmail: Text(
        'LogOut',
        style: TextStyle(color: Colors.black54),
      ),
    );
  }
}
