import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sulaimanfood/model/foodMenu_Model.dart';
import 'package:sulaimanfood/model/user_model.dart';
import 'package:sulaimanfood/screens/add_food_menu.dart';
import 'package:sulaimanfood/utility/myConstant.dart';
import 'package:sulaimanfood/utility/my_style.dart';

class ListMenuShop extends StatefulWidget {
  @override
  _ListMenuShopState createState() => _ListMenuShopState();
}

class _ListMenuShopState extends State<ListMenuShop> {
  UserModel userModel;
  bool status = true;
  bool loadStatus = true;
  // ignore: deprecated_member_use
  List<FoodMenuModel> foodMenuModels = List();

  final images = CachedNetworkImage(
    imageUrl: 'https://www.w3schools.com/w3css/img_lights.jpg',
    //   '${MyConstant().domain}${foodMenuModels[index].imagePath}',
    progressIndicatorBuilder: (context, url, downloadProgress) =>
        CircularProgressIndicator(value: downloadProgress.progress),
    errorWidget: (context, url, error) => Icon(Icons.error),
    fit: BoxFit.cover,
  );

  @override
  void initState() {
    super.initState();
    readFoodMenu();
  }

  Future<Null> readFoodMenu() async {
    if (foodMenuModels.length != 0) {
      foodMenuModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userid = preferences.getString('User_id');
    print('User id ==> $userid');

    String url =
        '${MyConstant().domain}/Sulaiman_food/get_FoodMenu.php?isAdd=true&id=$userid';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      var result = json.decode(value.data);
      print('Result ==> $result');
      if (result.toString() != 'null') {
        for (var map in result) {
          FoodMenuModel foodMenuModel = FoodMenuModel.fromJson(map);
          setState(() {
            foodMenuModels.add(foodMenuModel);
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent,
      child: Stack(
        children: [
          loadStatus ? MyStyle().showProgress() : showContent(),
          addMenuButton(),
        ],
      ),
    );
  }

  Widget showContent() {
    return status
        ? //showListFoodMenu()
        showListFoodMenu4()
        : Center(
            child: Text('ยังไม่มีรายการอาหาร'),
          );
  }

  Widget showListFoodMenu() => ListView.separated(
        padding: EdgeInsetsDirectional.only(top: 20.0, bottom: 20.0),
        itemCount: foodMenuModels.length,
        itemBuilder: (context, index) => Column(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsetsDirectional.only(
                    start: 10.0,
                    end: 10.0,
                  ),
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.width * 0.6,
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.network(
                      '${MyConstant().domain}${foodMenuModels[index].imagePath}',
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsetsDirectional.only(start: 10.0, end: 5.0),
              //   padding: EdgeInsets.all(5.0),
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.width * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    //padding: EdgeInsetsDirectional.only(top: 0.0,bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.star_outline_rounded),
                        Expanded(
                          child: Text(
                            foodMenuModels[index].foodName,
                            overflow: TextOverflow.ellipsis,
                            style: MyStyle().mainTitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.attach_money_outlined),
                      Expanded(
                        child: Text(
                          'ราคา ${foodMenuModels[index].price} บาท',
                          overflow: TextOverflow.ellipsis,
                          style: MyStyle().mainH2Title,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.details),
                      Expanded(
                        child: Text(
                          foodMenuModels[index].foodDetail,
                          overflow: TextOverflow.ellipsis,
                          style: MyStyle().mainH2Title,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.black54,
          );
        },
      );

  Widget showListFoodMenu2() => ListView.separated(
        padding: EdgeInsetsDirectional.only(top: 20.0, bottom: 20.0),
        itemCount: foodMenuModels.length,
        itemBuilder: (context, index) => Row(
          children: [
            Container(
              padding: EdgeInsetsDirectional.only(
                start: 10.0,
                end: 10.0,
              ),
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width * 0.3,
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.network(
                  '${MyConstant().domain}${foodMenuModels[index].imagePath}',
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 5,
                margin: EdgeInsets.all(10),
              ),
            ),
            Container(
              padding: EdgeInsetsDirectional.only(start: 10.0, end: 5.0),
              //   padding: EdgeInsets.all(5.0),
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    //padding: EdgeInsetsDirectional.only(top: 0.0,bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            foodMenuModels[index].foodName,
                            overflow: TextOverflow.ellipsis,
                            style: MyStyle().mainTitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'ราคา ${foodMenuModels[index].price} บาท',
                          overflow: TextOverflow.ellipsis,
                          style: MyStyle().mainH2Title,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          foodMenuModels[index].foodDetail,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.black54,
          );
        },
      );

  Widget addMenuButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 16.0, right: 16.0),
              child: FloatingActionButton(
                onPressed: () {
                  routeAddInfomation();
                },
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> routeAddInfomation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String shopId = preferences.getString('Shop_id');
    print('Shopid ==> $shopId');
    if (shopId == null || shopId.isEmpty || shopId == 'null') {
      errorDialog('กรุณาเพิ่มร้านของคุณก่อนคะ');
    } else {
      MaterialPageRoute route = MaterialPageRoute(
        builder: (value) => AddFoodMenu(),
      );
      Navigator.push(context, route).then((value) => readFoodMenu());
    }
  }

  errorDialog(String text) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlertDialog(
              title: Row(
                children: [
                  Text('ไม่พบร้านค้า'),
                ],
              ),
              content: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
   

  Widget showListFoodMenu4() => ListView.builder(
        padding: EdgeInsetsDirectional.only(top: 0.0, bottom: 20.0),
        itemCount: foodMenuModels.length,
        itemBuilder: (context, index) => Container(
          decoration: index % 2 == 0
              ? new BoxDecoration(color: Colors.lightBlueAccent)
              : new BoxDecoration(color: Colors.lightBlue),
          child: Row(
            children: [
              Container(
                padding: EdgeInsetsDirectional.only(
                  start: 10.0,
                  end: 10.0,
                ),
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.3,
                child: Container(
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: CachedNetworkImage(
                      imageUrl:
                          '${MyConstant().domain}${foodMenuModels[index].imagePath}',
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              MyStyle().showProgress(),
                      // CircularProgressIndicator(
                      //     ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsetsDirectional.only(start: 10.0, end: 5.0),
                //   padding: EdgeInsets.all(5.0),
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      //padding: EdgeInsetsDirectional.only(top: 0.0,bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              foodMenuModels[index].foodName,
                              overflow: TextOverflow.ellipsis,
                              style: MyStyle().mainTitle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'ราคา ${foodMenuModels[index].price} บาท',
                            overflow: TextOverflow.ellipsis,
                            style: MyStyle().mainH2Title,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            foodMenuModels[index].foodDetail,
                            //overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16.0,
                                fontStyle: FontStyle.italic),
                          ),
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
