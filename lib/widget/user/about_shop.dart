import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:sulaimanfood/model/infomationShop_model.dart';
import 'package:sulaimanfood/utility/myConstant.dart';
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
    LocationData locationData = await findLocationData();
    setState(() {
      lat1 = locationData.latitude;
      lng1 = locationData.longitude;
      lat2 = double.parse(shopModels.latitude);
      lng2 = double.parse(shopModels.longitude);
    });
    print('Lat = $lat1,  Lng = $lng1, Lat2 == $lat2 , Lon2 == $lng2');
    distance = calculateDistance(lat1, lng1, lat2, lng2);

    var myFormat = NumberFormat('#0.00', 'en_US');
    distanceString = myFormat.format(distance);
    transport = calculateTransport(distance);
    print('TranSport == $transport');

    print('Distance ==> $distance');
  }

  // ignore: missing_return
  int calculateTransport(double distance) {
    int transport;
    if (distance <= 1) {
      transport = 35;
    } else {
      transport = 35 + ((distance - 1).round() * 10);
    }
    return transport;
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));

    return distance;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent,
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Column(
            children: [
              showImage(),
              ListTile(
                leading: Icon(Icons.home),
                title: Text(shopModels.addressShop),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text(shopModels.phoneShop),
              ),
              ListTile(
                leading: Icon(Icons.directions_bike),
                title: Text(distance == null ? '' : '$distanceString กิโลเมตร'),
              ),
              ListTile(
                leading: Icon(Icons.transfer_within_a_station),
                title: Text(transport == null ? '0 บาท' : '$transport บาท'),
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
      margin: EdgeInsetsDirectional.only(start: 10.0, end: 10),
      // width: 380.00,
      // height: 300.00,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: CachedNetworkImage(
          imageUrl: '${MyConstant().domain}${shopModels.urlImage}',
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              MyStyle().showProgress(),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5,
        margin: EdgeInsets.all(5),
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
