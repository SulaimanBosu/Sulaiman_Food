import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sulaimanfood/model/infomationShop_model.dart';
import 'package:sulaimanfood/utility/myConstant.dart';
import 'package:sulaimanfood/utility/my_style.dart';
import 'package:sulaimanfood/utility/normal_dialog.dart';

class EditInfoShop extends StatefulWidget {
  @override
  _EditInfoShopState createState() => _EditInfoShopState();
}

class _EditInfoShopState extends State<EditInfoShop> {
  InfomationShopModel infomationShop;
  double lat, lng;
  String nameShop, address, phone, urlImage, newUrlImage;
  final picker = ImagePicker();
  File file;
  //Location location = Location();

  @override
  void initState() {
    super.initState();
    readCurrentData();
    findLatLng();

    // location.onLocationChanged.listen((event) {
    //   lat = event.latitude;
    //   lng = event.longitude;
    //  });
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
    String shopid = preferences.getString('Shop_id');
    print('Shop id  ===>  $shopid');

    String url =
        '${MyConstant().domain}/Sulaiman_food/getEdit_infomation.php?isAdd=true&id=$shopid';
    Response response = await Dio().get(url);
    //  print('response ==> $response');

    var result = json.decode(response.data);
    print('response ==> $result');

    for (var map in result) {
      setState(() {
        infomationShop = InfomationShopModel.fromJson(map);
        nameShop = infomationShop.nameShop;
        address = infomationShop.addressShop;
        phone = infomationShop.phoneShop;
        urlImage = infomationShop.urlImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: infomationShop == null ? MyStyle().showProgress() : showContent(),
      appBar: AppBar(
        title: Text('แก้ไขรายละเอียด'),
      ),
    );
  }

  Widget showContent() => SingleChildScrollView(
        child: Column(
          children: [
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyStyle().showTitle('รายละเอียดร้านค้า'),
              ],
            ),
            showImage(),
            addImageButton(),
            nameShopform(),
            addressShopform(),
            phoneShopform(),
            MyStyle().mySizebox(),
            lat == null ? MyStyle().showProgress() : showMap(),
            MyStyle().mySizebox(),
            lat == null ? MyStyle().showProgress() : groupButton(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
          ],
        ),
      );

  Widget showImage() => Container(
        margin: EdgeInsets.all(16.0),
        // width: 250.0,
        // height: 200.0,
        child: file == null
            ? Image.network('${MyConstant().domain}$urlImage')
            : Image.file(file),
      );

  Widget addImageButton() {
    return Container(
      width: 200.0,
      // ignore: deprecated_member_use
      child: FloatingActionButton.extended(
        onPressed: () {
          _showPicker(context);
          ;
        },
        icon: Icon(
          Icons.add_photo_alternate,
          color: Colors.white,
        ),
        label: Text(
          'เปลี่ยนรูปภาพ',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        getImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      getImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<Null> getImage(ImageSource imageSource) async {
    try {
      final pickedFile = await picker.getImage(
        source: imageSource,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );

      setState(() {
        if (pickedFile != null) {
          file = File(pickedFile.path);
        } else {
          // newUrlImage = urlImage;
          // print('No image selected.');
        }
      });
    } catch (e) {}
  }

  Future<Null> uploadImage() async {
    Random random = Random();
    int i = random.nextInt(1000000);
    String nameImage = 'Shop$i.jpg';
    String url = '${MyConstant().domain}/Sulaiman_food/saveImageFile.php';

    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file.path, filename: nameImage);

      FormData formData = FormData.fromMap(map);

      await Dio().post(url, data: formData).then((value) {
        print('Respone ==>> $value');

        newUrlImage = '/Sulaiman_food/Shop/$nameImage';
        print('Url Image = $urlImage');
        addInfomationShop(newUrlImage);
      });
    } catch (e) {}
  }

  Future<Null> addInfomationShop(String urlImage) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userid = preferences.getString('User_id');
    String url =
        '${MyConstant().domain}/Sulaiman_food/add_infomation.php?isAdd=true&nameShop=$nameShop&addressShop=$address&phoneShop=$phone&urlImage=$urlImage&latitude=$lat&longitude=$lng&id=$userid';
    print(urlImage);

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'อัพโหลดล้มเหลว กรุณาลองใหม่อีกครั้งคะ');
      }
    });
  }

  Widget nameShopform() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 300.0,
            child: TextFormField(
              initialValue: nameShop,
              onChanged: (value) => nameShop = value,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.account_box),
                border: OutlineInputBorder(),
                labelText: 'ชื่อร้านค้า',
              ),
            ),
          ),
        ],
      );

  Widget addressShopform() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 300.0,
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              initialValue: address,
              onChanged: (value) => address = value,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.house),
                border: OutlineInputBorder(),
                labelText: 'ที่อยู่ร้านค้า',
              ),
            ),
          ),
        ],
      );

  Widget phoneShopform() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 300.0,
            child: TextFormField(
              initialValue: phone,
              onChanged: (value) => phone = value,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
                labelText: 'เบอร์ติดต่อร้านค้า',
              ),
            ),
          ),
        ],
      );

  //โชว์แผนที่
  Container showMap() {
    LatLng latLng = LatLng(lat, lng);
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
        markers: myMarker(),
      ),
    );
  }

  //โชว์มาร์กเกอร์ของแผนที่
  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myShop'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: 'ตำแหน่งร้านของคุณ',
          snippet: 'ละติจูด = $lat, ลองจิจูด = $lng',
        ),
      )
    ].toSet();
  }

  //ปุ่มบันทึกและยกเลิก
  Row groupButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          child: FloatingActionButton.extended(
            onPressed: () => saveEdit(),
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            label: Text(
              'บันทึก',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          child: FloatingActionButton.extended(
            onPressed: () {
              // MaterialPageRoute route = MaterialPageRoute(
              //   builder: (value) => InfomationShop(),
              // );
              // Navigator.pushAndRemoveUntil(context, route, (route) => false);
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.cancel,
              color: Colors.white,
            ),
            label: Text(
              'ยกเลิก',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void saveEdit() {
    if (nameShop == null || nameShop.isEmpty) {
      normalDialog(context, 'กรุณากรอกชื่อร้านด้วยคะ');
    } else if (address == null || address.isEmpty) {
      normalDialog(context, 'กรุณากรอกที่อยู่ของร้านด้วยคะ');
    } else if (phone == null || phone.isEmpty) {
      normalDialog(context, 'กรุณากรอกเบอร์โทรศัพท์ของร้านด้วยคะ');
    } else if (urlImage == null) {
      normalDialog(context, 'กรุณาเพิ่มรูปภาพของร้านด้วยคะ');
    } else {
      // confirmDialog();
      confirmDialog2();
    }
  }

  Future<Null> confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => Container(
        child: SimpleDialog(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'ยืนยันการแก้ไขรายละเอียด',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          children: [
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            dialogButton(),
          ],
        ),
      ),
    );
  }

  Row dialogButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(left: 2.0, right: 5.0),
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pop(context);
              if (file == null) {
                addInfomationShop(urlImage);
              } else {
                uploadImage();
              }
            },
            icon: Icon(
              Icons.save_alt_rounded,
              color: Colors.black54,
            ),
            label: Text(
              'ยืนยัน',
              style: TextStyle(color: Colors.black54),
            ),
            backgroundColor: Color.fromARGB(105, 105, 105, 105),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 5.0, right: 2.0),
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.cancel,
              color: Colors.black54,
            ),
            label: Text(
              'ยกเลิก',
              style: TextStyle(color: Colors.black54),
            ),
            backgroundColor: Color.fromARGB(105, 105, 105, 105),
          ),
        )
      ],
    );
  }

  confirmDialog2() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlertDialog(
              title: Row(
                children: [
                  Text('Confirm'),
                ],
              ),
              content: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'ยืนยันการแก้ไขรายละเอียด',
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
                  child: Text("ยืนยัน"),
                  onPressed: () {
                    Navigator.pop(context);
                    if (file == null) {
                      addInfomationShop(urlImage);
                    } else {
                      uploadImage();
                    }
                  },
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text("ยกเลิก"),
                  onPressed: () {
                    // ใส่เงื่อนไขการกดยกเลิก
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
