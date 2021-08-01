import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:sulaimanfood/model/infomationShop_model.dart';
import 'package:sulaimanfood/utility/myConstant.dart';
import 'package:sulaimanfood/utility/my_api.dart';
import 'package:sulaimanfood/utility/my_style.dart';

class AboutShop extends StatefulWidget {
  final InfomationShopModel shopModel;
  AboutShop({Key key, this.shopModel}) : super(key: key);
  @override
  _AboutShopState createState() => _AboutShopState();
}

class _AboutShopState extends State<AboutShop> {
  InfomationShopModel shopModels;
  double lat1, lng1, lat2, lng2, distance;
  String distanceString;
  int transport;
  CameraPosition position;
  // Location _location = Location();

  @override
  void initState() {
    super.initState();
    findLatLng();
    shopModels = widget.shopModel;

    // _location.onLocationChanged.listen((event) {
    //   setState(() {
    //     lat1 = event.latitude;
    //     lon1 = event.longitude;
    //     print('lat1 == $lat1,  lon1 == $lon1');
    //   });
    // });
  }

//ดึงตำ่แหน่งที่ตั้งปัจจุบัน
  Future<Null> findLatLng() async {
    Location location = Location();
    LocationData locationData = await location.getLocation();
    setState(() {
      lat1 = locationData.latitude;
      lng1 = locationData.longitude;
      lat2 = double.parse(shopModels.latitude);
      lng2 = double.parse(shopModels.longitude);
    });
    print('Lat = $lat1,  Lng = $lng1, Lat2 == $lat2 , Lon2 == $lng2');
    distance = MyApi().calculateDistance(lat1, lng1, lat2, lng2);

    var myFormat = NumberFormat('#0.00', 'en_US');
    distanceString = myFormat.format(distance);
    transport = MyApi().calculateTransport(distance);
    print('TranSport == $transport');

    print('Distance ==> $distance');
  }

//โฟกัสตำแหน่งที่ตั้งปัจบันเสมอ
  // Future<LocationData> findLocationData() async {
  //   Location location = Location();

  //   try {
  //     return location.getLocation;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return distanceString == null ? progress(context) : buildContent();
  }

  Widget buildContent() {
    return Container(
      //color: Colors.lightBlueAccent,
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyStyle().mySizebox(),
              MyStyle().mySizebox(),
              showImage(),
              ListTile(
                leading: Icon(Icons.home),
                title: Text(
                  shopModels.addressShop,
                  style: MyStyle().text2,
                ),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text(
                  shopModels.phoneShop,
                  style: MyStyle().text2,
                ),
              ),
              ListTile(
                leading: Icon(Icons.directions_bike),
                title: Text(
                  distance == null ? '' : '$distanceString กิโลเมตร',
                  style: MyStyle().text2,
                ),
              ),
              ListTile(
                leading: Icon(Icons.transfer_within_a_station),
                title: Text(
                  transport == null ? '0 บาท' : '$transport บาท',
                  style: MyStyle().text2,
                ),
              ),
              showMap(),
            ],
          ),
        ),
      ),
    );
  }

  Container showImage() {
    return Container(
      padding: EdgeInsetsDirectional.only(start: 0.0, end: 0.0, bottom: 10),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.width * 0.6,
      child: Container(
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: CachedNetworkImage(
            imageUrl: '${MyConstant().domain}${shopModels.urlImage}',
            progressIndicatorBuilder: (context, url, downloadProgress) =>
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
          margin: EdgeInsets.all(0),
        ),
      ),
    );
  }

  Marker userMarker() {
    return Marker(
      markerId: MarkerId('userMarker'),
      position: LatLng(
        lat1,
        lng1,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(60),
      infoWindow: InfoWindow(
        title: 'ตำแหน่งของคุณ',
      ),
    );
  }

  Marker shopMarker() {
    return Marker(
      markerId: MarkerId('shopMarker'),
      position: LatLng(
        lat2,
        lng2,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(60),
      infoWindow: InfoWindow(
        title: shopModels.nameShop,
      ),
    );
  }

  Set<Marker> mySet() {
    return <Marker>[userMarker(), shopMarker()].toSet();
  }

  Widget showMap() {
    if (lat1 != null) {
      LatLng latLng = LatLng(lat2, lng2);
      position = CameraPosition(
        target: latLng,
        zoom: 16.0,
      );
    }
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 32),
      height: 300.0,
      child: lat1 == null
          ? MyStyle().showProgress()
          : Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: GoogleMap(
                initialCameraPosition: position,
                mapType: MapType.normal,
                onMapCreated: (controller) {},
                markers: mySet(),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(5.0),
            ),
    );
  }

  Widget progress(BuildContext context) {
    return Container(
        child: new Stack(
      children: <Widget>[
        buildContent(),
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
}

// Container(
//   margin: EdgeInsets.only(left: 10, right: 10),
//   child: Row(
//     children: [
//       Expanded(
//         child: Text(
//           shopModels.addressShop,
//         ),
//       ),
//     ],
//   ),
// ),
