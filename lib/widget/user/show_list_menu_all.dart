import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sulaimanfood/model/foodMenu_Model.dart';
import 'package:sulaimanfood/screens/user/food_menu.dart';
import 'package:sulaimanfood/utility/myConstant.dart';
import 'package:sulaimanfood/utility/my_style.dart';

class ShowListMenuAll extends StatefulWidget {
  @override
  _ShowListMenuAllState createState() => _ShowListMenuAllState();
}

class _ShowListMenuAllState extends State<ShowListMenuAll> {
  String nameUser;
  String userid;
  // ignore: deprecated_member_use
  List<FoodMenuModel> foodMenuModels = List();
  // ignore: deprecated_member_use
  List<Widget> foodCards = List();

  @override
  void initState() {
    super.initState();
    readfood();
  }

  Future<Null> readfood() async {
    String url =
        '${MyConstant().domain}/Sulaiman_food/get_Menu_forUser.php?isAdd=true';
    await Dio().get(url).then((value) {
      print('Value == $value');
      var result = json.decode(value.data);
      int index = 0;
      print('Value == $result');
      for (var map in result) {
        FoodMenuModel model = FoodMenuModel.fromJson(map);
        print('NameShop == ${model.foodId}');
        setState(() {
          foodMenuModels.add(model);
          foodCards.add(createCard(model, index));
          index++;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return foodCards.length == 0
        ? MyStyle().showProgress()
        : GridView.extent(
            maxCrossAxisExtent: 240,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: foodCards,
          );
  }

  Widget createCard(FoodMenuModel foodMenuModel, int index) {
    String imageURL = foodMenuModel.imagePath;
    return GestureDetector(
      onTap: () {
        print('you click index $index');
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => FoodMenu(
            foodMenuModel: foodMenuModels[index],
          ),
        );
        Navigator.push(context, route);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            showImage(imageURL),
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(foodMenuModel.foodName,style: TextStyle(fontSize: 12),),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Text('ร้าน ${foodMenuModel.shopName}'),
                  //   ],
                  // ),
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
      width: 120.00,
      height: 120.00,
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
        margin: EdgeInsets.all(5),
      ),
    );
  }
}
