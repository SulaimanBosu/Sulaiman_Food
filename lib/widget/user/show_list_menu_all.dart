import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:sulaimanfood/model/foodMenu_Model.dart';
import 'package:sulaimanfood/model/infomationShop_model.dart';
import 'package:sulaimanfood/screens/user/food_menu.dart';
import 'package:sulaimanfood/screens/user/shop_info.dart';
import 'package:sulaimanfood/utility/myConstant.dart';
import 'package:sulaimanfood/utility/my_api.dart';
import 'package:sulaimanfood/utility/my_style.dart';

class ShowListMenuAll extends StatefulWidget {
  @override
  _ShowListMenuAllState createState() => _ShowListMenuAllState();
}

class _ShowListMenuAllState extends State<ShowListMenuAll> {
  String nameUser;
  String userid;
  double lat1, lng1, lat2, lng2, distance;
  String distanceString;
  int transport;
  String imageURL;
  // ignore: deprecated_member_use
  List<FoodMenuModel> foodModels = List();
  // ignore: deprecated_member_use
  List<Widget> foodCards = List();
  FoodMenuModel foodmodel;

  // ignore: deprecated_member_use
  List<InfomationShopModel> infomationShopModels = List();
  // ignore: deprecated_member_use
  List<Widget> shopinfo = List();
  InfomationShopModel shopModel;

  List<String> distanceModels = List();
  List<String> transportModels = List();
  List<String> list = List();

  @override
  void initState() {
    super.initState();
    readfood();
    readshop();
  }

  Future<Null> readfood() async {
    LocationData locationData = await findLocationData();
    //readshop();
    String url =
        '${MyConstant().domain}/Sulaiman_food/get_Menu_forUser.php?isAdd=true';
    await Dio().get(url).then((value) {
      // print('Value == $value');
      var result = json.decode(value.data);
      int index = 0;
      print('Value == $result');
      for (var map in result) {
        FoodMenuModel modelFood = FoodMenuModel.fromJson(map);
        setState(() {
          lat1 = locationData.latitude;
          lng1 = locationData.longitude;
          lat2 = double.parse(modelFood.latitude);
          lng2 = double.parse(modelFood.longitude);
          distance = MyApi().calculateDistance(lat1, lng1, lat2, lng2);
          print('lat1 = $lat1, lng1 = $lng1, lat2 = $lat2, lng2 = $lng2');
          var myFormat = NumberFormat('#0.00', 'en_US');

          distanceString = myFormat.format(distance);
          distanceModels.add(distanceString);

          transport = MyApi().calculateTransport(distance);
          transportModels.add(transport.toString());
          print('TranSport == $transport');

          print('Distance ==> $distance');

          foodModels.add(modelFood);

          index++;
        });
      }
    });
  }

  List<String> changeArrey(String distance) {
    int index = 0;
    for (var distance in list) {
      list[index] = distance;
      index++;
    }
    return list;
  }

  Future<Null> readshop() async {
    String url =
        '${MyConstant().domain}/Sulaiman_food/get_Shop_forUser.php?isAdd=true';
    await Dio().get(url).then((value) {
      //  print('Value == $value');
      var result = json.decode(value.data);
      int indexShop = 0;
      //  print('Value == $result');
      for (var map in result) {
        InfomationShopModel modelshop = InfomationShopModel.fromJson(map);
        setState(() {
          infomationShopModels.add(modelshop);
          indexShop++;
        });
      }
    });
  }

//โฟกัสตำแหน่งที่ตั้งปัจบันเสมอ
  Future<LocationData> findLocationData() async {
    Location location = Location();

    try {
      return location.getLocation;
    } catch (e) {
      return null;
    }
  }

  //   @override
  // Widget build(BuildContext context) {
  //   return
  //     showContent();
  //}

  @override
  Widget build(BuildContext context) {
    return foodModels.length == 0 ? progress(context) : buildListView();
  }

  Widget progress(BuildContext context) {
    return Container(
        child: new Stack(
      children: <Widget>[
        buildListView(),
        Container(
          alignment: AlignmentDirectional.center,
          decoration: new BoxDecoration(
            color: Colors.white70,
          ),
          child: new Container(
            decoration: new BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: new BorderRadius.circular(10.0)),
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.3,
            alignment: AlignmentDirectional.center,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Center(
                  child: new SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: new CircularProgressIndicator(
                      value: null,
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      strokeWidth: 7.0,
                    ),
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 25.0),
                  child: new Center(
                    child: new Text(
                      'ดาวน์โหลด...',
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.black45,
                        fontFamily: 'FC-Minimal-Regular',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget buildListView() {
    return ListView(
      children: [
        MyStyle().mySizebox(),
        Container(
          padding: EdgeInsetsDirectional.only(start: 10, end: 10),
          child: Row(
            children: [
              Icon(
                Icons.restaurant,
                color: Colors.black45,
                size: 16,
              ),
              MyStyle().mySizebox(),
              Text(
                'ร้านที่คุณน่าจะชอบ',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
        MyStyle().mySizebox(),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.4,
          //width: 250,
          child: showListshop(),
        ),
        Container(
          padding: EdgeInsetsDirectional.only(start: 10, end: 10),
          child: Row(
            children: [
              Icon(
                Icons.restaurant_menu,
                color: Colors.black45,
                size: 16,
              ),
              MyStyle().mySizebox(),
              Text(
                'ร้านฮิตติดเทรน',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
        MyStyle().mySizebox(),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.35,
          child: showListshoppopular(),
        ),
        Container(
          padding: EdgeInsetsDirectional.only(start: 20, end: 10),
          child: Row(
            children: [
              Icon(
                Icons.fastfood,
                color: Colors.black45,
                size: 16,
              ),
              MyStyle().mySizebox(),
              Text(
                'เมนูอาหารแนะนำ',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
        MyStyle().mySizebox(),
        SizedBox(
        // height: MediaQuery.of(context).size.height * 0.8,
          height: MediaQuery.of(context).size.width * 0.7,
          // height: 150.0,
          child: showListFoodMenu2(),
        ),
      ],
    );
  }

  Widget showListshop() => ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.only(start: 10.0, end: 10.0),
        itemCount: infomationShopModels.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            print('you click index $index');
            MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => ShopInfo(
                shopModel: infomationShopModels[index],
              ),
            );
            Navigator.push(context, route);
          },
          child: Container(
            child: Container(
              padding: EdgeInsetsDirectional.only(start: 1.0, end: 10.0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsetsDirectional.only(
                        start: 0.0, end: 0.0, bottom: 10),
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.3,
                    child: Container(
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: CachedNetworkImage(
                          imageUrl:
                              '${MyConstant().domain}${infomationShopModels[index].urlImage}',
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  MyStyle().showProgress(),
                          // CircularProgressIndicator(
                          //     ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.all(0),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(infomationShopModels[index].nameShop,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget showListshoppopular() => ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.only(start: 10.0, end: 10.0),
        itemCount: infomationShopModels.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            print('you click index $index');
            MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => ShopInfo(
                shopModel: infomationShopModels[index],
              ),
            );
            Navigator.push(context, route);
          },
          child: Container(
            child: Container(
              padding: EdgeInsetsDirectional.only(start: 1.0, end: 10.0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsetsDirectional.only(
                        start: 0.0, end: 0.0, bottom: 10),
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.width * 0.25,
                    child: Container(
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: CachedNetworkImage(
                          imageUrl:
                              '${MyConstant().domain}${infomationShopModels[index].urlImage}',
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  MyStyle().showProgress(),
                          // CircularProgressIndicator(
                          //     ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.all(0),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(infomationShopModels[index].nameShop,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.0,
                          // fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget showListFoodMenu() {
    return ListView.builder(
      padding: EdgeInsets.all(15.0),
      itemCount: foodModels.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          //           print('you click index $index');
          // MaterialPageRoute route = MaterialPageRoute(
          //   builder: (context) => ShopInfo(
          //     shopModel: infomationShopModels[index],
          //   ),
          // );
          // Navigator.push(context, route);

          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => FoodMenu(
              foodMenuModel: foodModels[index],
            ),
          );
          Navigator.push(context, route);
        },
        child: Card(
          shadowColor: Colors.black,
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.5,
                child: Card(
                  shadowColor: Colors.grey,
                  //semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: CachedNetworkImage(
                    imageUrl:
                        '${MyConstant().domain}${foodModels[index].imagePath}',
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            MyStyle().showProgress(),
                    // CircularProgressIndicator(
                    //     ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.only(bottom: 0),
                ),
              ),
              Container(
                // padding: EdgeInsetsDirectional.only(start: 10.0, end: 5.0, top: 10),
                padding: EdgeInsets.all(5.0),
                //  width: MediaQuery.of(context).size.width * 1,
                // height: MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      //padding: EdgeInsetsDirectional.only(top: 0.0,bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.star_outline_rounded,
                            color: Colors.black45,
                            size: 16,
                          ),
                          MyStyle().mySizebox(),
                          Expanded(
                            child: Text(
                              foodModels[index].foodName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.attach_money_outlined,
                          size: 10,
                          color: Colors.black45,
                        ),
                        MyStyle().mySizebox(),
                        Expanded(
                          child: Text(
                            'ราคา ${foodModels[index].price} บาท',
                            overflow: TextOverflow.ellipsis,
                            style: MyStyle().mainH2Title,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.restaurant,
                          color: Colors.black45,
                          size: 10,
                        ),
                        MyStyle().mySizebox(),
                        Expanded(
                          child: Text(
                            foodModels[index].shopName,
                            overflow: TextOverflow.ellipsis,
                            style: MyStyle().mainH2Title,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.motorcycle_outlined,
                          color: Colors.black45,
                          size: 10,
                        ),
                        MyStyle().mySizebox(),
                        Expanded(
                          child: Text(
                            'ค่าส่ง ${transportModels[index]}B. | ${distanceModels[index]} km.',
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
        ),
      ),
    );
  }

  Widget showListFoodMenu2() => ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(15.0),
        itemCount: foodModels.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            // MaterialPageRoute route = MaterialPageRoute(
            //   builder: (context) => FoodMenu(
            //     foodMenuModel: foodModels[index],
            //   ),
            // );
            // Navigator.push(context, route);

            print('you click index $index');
            MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => ShopInfo(
                shopModel: infomationShopModels[index],
              ),
            );
            Navigator.push(context, route);
          },
          child: Card(
            shadowColor: Colors.black,
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.width * 0.40,
                  child: Card(
                    shadowColor: Colors.grey,
                    //semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: CachedNetworkImage(
                      imageUrl:
                          '${MyConstant().domain}${foodModels[index].imagePath}',
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              MyStyle().showProgress(),
                      // CircularProgressIndicator(
                      //     ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.only(bottom: 0),
                  ),
                ),
                MyStyle().mySizebox(),
                Container(
                  //             padding: EdgeInsetsDirectional.only(
                  // start: 0.0, end: 0.0, bottom: 2),
                  //  padding: EdgeInsets.all(5.0),
                  width: MediaQuery.of(context).size.width * 0.55,
                  // height: MediaQuery.of(context).size.width * 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        //padding: EdgeInsetsDirectional.only(top: 0.0,bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.star_outline_rounded,
                              color: Colors.black45,
                              size: 16,
                            ),
                            MyStyle().mySizebox(),
                            Expanded(
                              child: Text(
                                foodModels[index].foodName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.attach_money_outlined,
                            size: 10,
                            color: Colors.black45,
                          ),
                          MyStyle().mySizebox(),
                          Expanded(
                            child: Text(
                              'ราคา ${foodModels[index].price} บาท',
                              overflow: TextOverflow.ellipsis,
                              style: MyStyle().mainH2Title,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.restaurant,
                            color: Colors.black45,
                            size: 10,
                          ),
                          MyStyle().mySizebox(),
                          Expanded(
                            child: Text(
                              foodModels[index].shopName,
                              overflow: TextOverflow.ellipsis,
                              style: MyStyle().mainH2Title,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.motorcycle_outlined,
                            color: Colors.black45,
                            size: 10,
                          ),
                          MyStyle().mySizebox(),
                          Expanded(
                            child: Text(
                              'ค่าส่ง ${transportModels[index]}B. | ${distanceModels[index]} km.',
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
          ),
        ),
      );
}
