import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sulaimanfood/model/infomationShop_model.dart';
import 'package:sulaimanfood/screens/user/shop_info.dart';
import 'package:sulaimanfood/utility/myConstant.dart';
import 'package:sulaimanfood/utility/my_api.dart';
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

  double lat1, lng1, lat2, lng2, distance;
  String distanceString;
  int transport;
  List<String> distances = List();

  @override
  void initState() {
    super.initState();
    findUser();
    readshop();
    
  }

  Future<Null> readshop() async {
    LocationData locationData = await findLocationData();
    String url =
        '${MyConstant().domain}/Sulaiman_food/get_Shop_forUser.php?isAdd=true';
    await Dio().get(url).then((value) {
      //  print('Value == $value');
      var result = json.decode(value.data);
      int index = 0;
       print('Value == $result');
      for (var map in result) {
        InfomationShopModel model = InfomationShopModel.fromJson(map);
        print('NameShop == ${model.shopId}');
        setState(() {
          infomationShopModels.add(model);
          lat1 = locationData.latitude;
          lng1 = locationData.longitude;
          lat2 = double.parse(model.latitude);
          lng2 = double.parse(model.longitude);
          distance = MyApi().calculateDistance(lat1, lng1, lat2, lng2);

          var myFormat = NumberFormat('#0.00', 'en_US');
          distanceString = myFormat.format(distance);
          transport = MyApi().calculateTransport(distance);
          print('TranSport == $transport');

          print('Distance ==> $distance');

          shopCards.add(createCard(model, index, distanceString,transport));
          print('Distance ==> $distance');
          index++;
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
      // color: Colors.lightBlueAccent,
      child: shopCards.length == 0
          ? progress(context)
          : GridView.extent(
              maxCrossAxisExtent: 265,
              mainAxisSpacing: 20,
              crossAxisSpacing: 10,
              children: shopCards,
            ),
    );
  }

      Widget progress(BuildContext context) {
    return Container(
        child: new Stack(
      children: <Widget>[
        GridView.extent(
              maxCrossAxisExtent: 265,
              mainAxisSpacing: 20,
              crossAxisSpacing: 10,
              children: shopCards,
            ),
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

  Widget createCard(
      InfomationShopModel infomationShopModel, int index, String distance, int transports) {
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
      child: Container(
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
                    MyStyle().mySizebox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          infomationShopModel.nameShop,
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 14.0,
                              fontFamily: 'FC-Minimal-Regular',
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'ระยะทาง ${distance.toString()} กม.',
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 14.0,
                              fontFamily: 'FC-Minimal-Regular',
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'ค่าส่ง ${transports.toString()} บ.',
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 14.0,
                              fontFamily: 'FC-Minimal-Regular',
                              fontStyle: FontStyle.italic),
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

  Container showImage(String imageURL) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.width * 0.30,
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
