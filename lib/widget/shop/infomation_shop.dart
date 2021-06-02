import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sulaimanfood/model/infomationShop_model.dart';
import 'package:sulaimanfood/model/user_model.dart';
import 'package:sulaimanfood/screens/shop/add_info_shop.dart';
import 'package:sulaimanfood/screens/shop/edit_info_shop.dart';
import 'package:sulaimanfood/utility/myConstant.dart';
import 'package:sulaimanfood/utility/my_style.dart';
import 'package:sulaimanfood/utility/normal_dialog.dart';

class InfomationShop extends StatefulWidget {
  @override
  _InfomationShopState createState() => _InfomationShopState();
}

String nameShop, address, phone, urlImage, shopId;
double lat, lng;

class _InfomationShopState extends State<InfomationShop> {
  UserModel userModel;
  InfomationShopModel infomationShop;
  bool loadingStatus = true;
  bool statusData = true;
  @override
  void initState() {
    super.initState();
    readCurrentData();
    findLatLng();

    // readDataInfomation();
  }

  void _onLoading() {
    Timer(
      Duration(seconds: 20),
      () {
        if (loadingStatus == true) {
          setState(() {
            loadingStatus = false;
            normalDialog(context, 'การเชื่อมต่อล้มเหลว');
          });
        } else {}
      },
    );
  }

  //ดึงตำ่แหน่งที่ตั้งปัจจุบัน
  Future<Null> findLatLng() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
    });
    print('Lat = $lat,  Lng = $lng');
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

  Future<Null> readCurrentData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userid = preferences.getString('User_id');
    _onLoading();
    String url =
        '${MyConstant().domain}/Sulaiman_food/get_infomation.php?isAdd=true&id=$userid';
    Response response = await Dio().get(url);
    //  print('response ==> $response');
    if (response.data != null) {
      var result = json.decode(response.data);
      print('response ==> $result');

      for (var map in result) {
        setState(() {
          infomationShop = InfomationShopModel.fromJson(map);
          shopId = infomationShop.shopId;
          nameShop = infomationShop.nameShop;
          address = infomationShop.addressShop;
          phone = infomationShop.phoneShop;
          urlImage = infomationShop.urlImage;
          loadingStatus = false;
          if (nameShop != null) {
            statusData = false;
          } else {
            statusData = true;
          }
        });
        addSharedShopid();
      }
    } else {
      _onLoading();
    }
  }

  Future<Null> addSharedShopid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('Shop_id', infomationShop.shopId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.lightBlueAccent,
      child: Stack(
        children: [
          //   showdata(context),

          loadingStatus
              ? MyStyle().progress(context)
              : statusData
                  ? showNodata()
                  : showinfoShop(),
          //refresh(),
          addAndEditButton(),
        ],
      ),
    );
  }


  Widget showinfoShop() => ListView(
        children: [
          MyStyle().mySizebox(),
          MyStyle().mySizebox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'รายละเอียดร้าน',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.black45,
                  fontFamily: 'FC-Minimal-Regular',
                ),
              ),
            ],
          ),
          MyStyle().mySizebox(),
          showImage(),
          MyStyle().mySizebox(),
          Container(
            margin: EdgeInsetsDirectional.only(start: 30.0, end: 30.0),
            child: MyStyle().showTitle_2('ร้าน ${infomationShop.nameShop}'),
          ),
          Container(
            margin: EdgeInsetsDirectional.only(
              start: 30.0,
              end: 30.0,
            ),
            child: Row(
              children: [
                MyStyle().showTitle_2('โทร. '),
                Container(
                    //  margin: EdgeInsetsDirectional.only(top: 7.0),
                    child: Text(
                  phone,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black45,
                    fontFamily: 'FC-Minimal-Regular',
                  ),
                )),
              ],
            ),
          ),
          Container(
            margin: EdgeInsetsDirectional.only(start: 30.0, end: 30.0),
            child: Row(
              children: [
                MyStyle().showTitle_2('ที่อยู่ :'),
              ],
            ),
          ),
          Container(
            margin: EdgeInsetsDirectional.only(start: 30.0, end: 30.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    infomationShop.addressShop,
                    style: MyStyle().text2,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(''),
                ),
              ],
            ),
          ),
          MyStyle().mySizebox(),
          MyStyle().mySizebox(),
          showMap(),
          MyStyle().mySizebox(),
          MyStyle().mySizebox(),
          MyStyle().mySizebox(),
          MyStyle().mySizebox(),
          MyStyle().mySizebox(),
          MyStyle().mySizebox(),
        ],
      );

  Container showImage() {
    return Container(
      padding: EdgeInsetsDirectional.only(start: 30.0, end: 30.0, bottom: 10),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.width * 0.6,
      child: Container(
          child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: CachedNetworkImage(
          imageUrl: '${MyConstant().domain}$urlImage',
          progressIndicatorBuilder: (context, url, downloadProgress) =>
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
        margin: EdgeInsets.all(0),
      )),
    );
  }

  Set<Marker> shopMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('shopId'),
        position: LatLng(
          double.parse(infomationShop.latitude),
          double.parse(infomationShop.longitude),
        ),
        infoWindow: InfoWindow(
            title: 'ตำแหน่งร้านของคุณ',
            snippet:
                'ละติจูด = ${infomationShop.latitude}, ลองจิจูด = ${infomationShop.longitude}'),
      )
    ].toSet();
  }

  Widget showMap() {
    double latitude = double.parse(infomationShop.latitude);
    double longitude = double.parse(infomationShop.longitude);

    LatLng latLng = LatLng(latitude, longitude);
    CameraPosition position = CameraPosition(target: latLng, zoom: 16.0);

    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      height: 300.0,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: GoogleMap(
          initialCameraPosition: position,
          mapType: MapType.normal,
          onMapCreated: (controller) {},
          markers: shopMarker(),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5,
        margin: EdgeInsets.all(5.0),
      ),
    );
  }

  showNodata() => Center(
        child: MyStyle().showtext_2('ยังไม่มีข้อมูลร้านค้าของคุณ'),
      );

  Row addAndEditButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: 25.0, bottom: 25.0),
              child: FloatingActionButton(
                  child: Icon(Icons.edit),
                  onPressed: () {
                    routeAddInfomation();
                  }),
            ),
          ],
        ),
      ],
    );
  }

  void routeAddInfomation() {
    Widget widget = shopId == 'null'
        ? AddInfoShop()
        : EditInfoShop(
            lat: lat,
            lng: lng,
          );

    MaterialPageRoute route = MaterialPageRoute(
      builder: (value) => widget,
    );
    Navigator.push(context, route).then((value) => readCurrentData());
  }
}
