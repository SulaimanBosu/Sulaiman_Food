import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sulaimanfood/utility/ProgressIndicator.dart';
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

  @override
  void initState() {
    super.initState();
    findUser();
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
          style: TextStyle(fontSize: 18.0),
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
          style: TextStyle(fontSize: 18.0),
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
          style: TextStyle(fontSize: 18.0),
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
