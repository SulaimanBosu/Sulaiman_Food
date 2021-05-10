import 'package:flutter/material.dart';
import 'package:sulaimanfood/model/infomationShop_model.dart';
import 'package:sulaimanfood/utility/my_style.dart';
import 'package:sulaimanfood/widget/user/about_shop.dart';
import 'package:sulaimanfood/widget/user/menu_in_shop.dart';

class ShopInfo extends StatefulWidget {
  final InfomationShopModel shopModel;
  ShopInfo({Key kay, this.shopModel}) : super(key: kay);
  @override
  _ShopInfoState createState() => _ShopInfoState();
}

class _ShopInfoState extends State<ShopInfo> {
  InfomationShopModel shopModels;
  List<Widget> listwidgets = List();
  int indexPage = 0;

  @override
  void initState() {
    super.initState();
    shopModels = widget.shopModel;
    listwidgets.add(
      AboutShop(
        shopModel: shopModels,
      ),
    );
    listwidgets.add(
      MenuInShop(
        shopModel: shopModels,
      ),
    );
  }

  BottomNavigationBarItem aboutShop() {
    return BottomNavigationBarItem(
      icon: Icon(
        Icons.home,
        size: 30,
      ),
      title: Text(
        'รายละเอียดร้าน',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  BottomNavigationBarItem menuinshop() {
    return BottomNavigationBarItem(
      icon: Icon(
        Icons.restaurant,
        size: 30,
      ),
      title: Text(
        'เมนูของร้าน',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shopModels.nameShop),
      ),
      body: listwidgets.length == 0
          ? MyStyle().showProgress2('กรุณารอสักครู่...')
          : listwidgets[indexPage],
      bottomNavigationBar: showBottomNavigationBar(),
    );
  }

  BottomNavigationBar showBottomNavigationBar() => BottomNavigationBar(
        backgroundColor: Colors.lightBlueAccent,
        selectedItemColor: Colors.redAccent, unselectedItemColor: Colors.white,
       // selectedFontSize: 16,
        // selectedFontSize: 24,
        currentIndex: indexPage,
        onTap: (value) {
          setState(() {
            indexPage = value;
          });
        },
        items: <BottomNavigationBarItem>[
          aboutShop(),
          menuinshop(),
        ],
      );
}
