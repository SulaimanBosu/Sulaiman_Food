import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sulaimanfood/model/infomationShop_model.dart';
import 'package:sulaimanfood/screens/shop_info.dart';
import 'package:sulaimanfood/utility/myConstant.dart';
import 'package:sulaimanfood/utility/my_style.dart';

class ShowListShopAll extends StatefulWidget {
  @override
  _ShowListShopAllState createState() => _ShowListShopAllState();
}

class _ShowListShopAllState extends State<ShowListShopAll> {
  String nameUser;
  String userid;
  // ignore: deprecated_member_use
  List<InfomationShopModel> infomationShopModels = List();
  // ignore: deprecated_member_use
  List<Widget> shopCards = List();

  @override
  void initState() {
    super.initState();
    findUser();
    readshop();
  }

  Future<Null> readshop() async {
    String url =
        '${MyConstant().domain}/Sulaiman_food/get_Shop_forUser.php?isAdd=true';
    await Dio().get(url).then((value) {
      print('Value == $value');
      var result = json.decode(value.data);
      int index = 0;
      print('Value == $result');
      for (var map in result) {
        InfomationShopModel model = InfomationShopModel.fromJson(map);
        print('NameShop == ${model.shopId}');
        setState(() {
          infomationShopModels.add(model);
          shopCards.add(createCard(model, index));
          index++;
        });
      }
    });
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
    return Container(
      color: Colors.lightBlueAccent,
      child: shopCards.length == 0
          ? MyStyle().showProgress2('กรุณารอสักครู่...')
          : GridView.extent(
              maxCrossAxisExtent: 240,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: shopCards,
            ),
    );
  }

  Widget createCard(InfomationShopModel infomationShopModel, int index) {
    String imageURL = infomationShopModel.urlImage;
    return GestureDetector(
      onTap: () {
        print('you click index $index');
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ShopInfo(
            shopModel: infomationShopModels[index],
          ),
        );
        Navigator.push(context, route);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            showImage(imageURL),
            Container(
              margin: EdgeInsets.only(left: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        infomationShopModel.nameShop,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container showImage(String imageURL) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
      // width: 380.00,
      // height: 300.00,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: CachedNetworkImage(
          imageUrl: MyConstant().domain + imageURL,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              MyStyle().showProgress(),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: EdgeInsets.all(0),
      ),
    );
  }
}
