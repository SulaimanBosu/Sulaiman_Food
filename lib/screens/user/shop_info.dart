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
  int indexPage = 1;

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
          fontFamily: 'FC-Minimal-Regular',
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
      // ignore: deprecated_member_use
      title: Text(
        'เมนูของร้าน',
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'FC-Minimal-Regular',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: [
              MyStyle().iconShowCart(context),
            ],
            title: Center(
                child: Text(
              'ร้าน ' + shopModels.nameShop,
              style: MyStyle().text2,
            )),
            centerTitle: true,
            floating: true,
            snap: true,
            //pinned: true,
            forceElevated: innerBoxIsScrolled,
          )
        ],
        body: listwidgets.length == 0
            ? MyStyle().showProgress2('กรุณารอสักครู่...')
            : listwidgets[indexPage],
      ),
      bottomNavigationBar: showBottomNavigationBar(),
    );
  }

  BottomNavigationBar showBottomNavigationBar() => BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.black54,
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
