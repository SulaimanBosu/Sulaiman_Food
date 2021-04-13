import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sulaimanfood/utility/my_style.dart';

class AddInfoShop extends StatefulWidget {
  @override
  _AddInfoShopState createState() => _AddInfoShopState();
}

class _AddInfoShopState extends State<AddInfoShop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Infomation Shop'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            showTitle('รายละเอียดร้านค้า'),
            MyStyle().mySizebox(),
            nameShopform(),
            MyStyle().mySizebox(),
            addressShopform(),
            MyStyle().mySizebox(),
            phoneShopform(),
            MyStyle().mySizebox(),
            groupImage(),
            MyStyle().mySizebox(),
            showMap(),
            MyStyle().mySizebox(),
            saveButton(),
            MyStyle().mySizebox(),
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
        color: MyStyle().primaryColor,
        onPressed: () {},
        icon: Icon(Icons.save,color: Colors.white,),
        label: Text('Save Infomation',style: TextStyle(color: Colors.white),),
      ),
    );
  }

  Container showMap() {
    LatLng latLng = LatLng(13.601704, 100.626396);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );

    return Container(
      height: 300,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
      ),
    );
  }

  Text showTitle(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 28.0,
          color: Colors.black54,
          fontWeight: FontWeight.bold,
        ),
      );

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            margin: EdgeInsets.only(left: 8.0, right: 10.0),
            child: IconButton(
                icon: Icon(
                  Icons.add_a_photo,
                  size: 40.0,
                ),
                onPressed: () {})),
        Container(
          width: 240.0,
          child: Image.asset('images/icon_image.png'),
        ),
        Container(
          margin: EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              size: 40.0,
            ),
            onPressed: () {},
          ),
        )
      ],
    );
  }

  Widget nameShopform() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300.0,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'ชื่อร้านค้า',
                prefixIcon: Icon(Icons.account_box),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget addressShopform() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300.0,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'ที่อยู่ร้านค้า',
                prefixIcon: Icon(Icons.house),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget phoneShopform() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300.0,
            child: TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'เบอร์โทรร้านค้า',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
}
