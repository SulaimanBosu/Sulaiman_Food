import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sulaimanfood/utility/ProgressIndicator.dart';
import 'package:sulaimanfood/utility/my_style.dart';
import 'package:sulaimanfood/utility/signout_process.dart';
import 'package:sulaimanfood/widget/infomation_shop.dart';
import 'package:sulaimanfood/widget/list_menu_shop.dart';
import 'package:sulaimanfood/widget/order_list_shop.dart';

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
        title:
            Text(nameUser == null ? 'Main Shop' : 'ยินดีต้อนรับคุณ$nameUser'),
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
        child: ListView(
          children: <Widget>[
            showHeadDrawer(),
            homeMenu(),
            foodMenu(),
            infomationMenu(),
            signOutMenu(),
          ],
        ),
      );

  ListTile homeMenu() => ListTile(
        leading: Icon(Icons.home),
        title: Text(
          'รายการอาหารที่ลูกค้าสั่ง',
          style: TextStyle(fontSize: 22.0),
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
          style: TextStyle(fontSize: 22.0),
        ),
        subtitle: Text('เมนูอาหารของร้าน'),
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
          style: TextStyle(fontSize: 22.0),
        ),
        subtitle: Text('รายละเอียดร้าน Edit...'),
        onTap: () {
          setState(() {
            currentWidget = InfomationShop();
          });
          Navigator.pop(context);
        },
      );

  ListTile signOutMenu() {
    return ListTile(
      leading: Icon(Icons.logout),
      title: Text(
        'Sign Out',
        style: TextStyle(fontSize: 22.0),
      ),
      subtitle: Text('ออกจากระบบ'),
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
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/food_shop.jpg'), fit: BoxFit.contain),
        ),
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
