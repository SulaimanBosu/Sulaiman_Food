import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sulaimanfood/utility/myConstant.dart';
import 'package:sulaimanfood/utility/my_style.dart';
import 'package:sulaimanfood/utility/normal_dialog.dart';

class AddInfoShop extends StatefulWidget {
  @override
  _AddInfoShopState createState() => _AddInfoShopState();
}

class _AddInfoShopState extends State<AddInfoShop> {
  double lat, lng;
  File file;
  final picker = ImagePicker();
  String nameShop, address, phone, urlImage;
  bool addStatus = false;

  @override
  void initState() {
    super.initState();
    findLatLng();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รายละเอียดร้าน',
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.black45,
            fontFamily: 'FC-Minimal-Regular',
          ),
        ),
      ),
      body: addStatus ? progress(context) : buildContent(),
    );
  }

  Widget buildContent() {
    return Container(
      // color: Colors.lightBlueAccent,
      child: SingleChildScrollView(
        child: Column(
          children: [
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'เพิ่มร้านค้า',
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
            addImageButton(),
            MyStyle().mySizebox(),
            nameShopform(),
            MyStyle().mySizebox(),
            addressShopform(),
            MyStyle().mySizebox(),
            phoneShopform(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            lat == null ? MyStyle().showProgress() : showMap(),
            MyStyle().mySizebox(),
            lat == null ? MyStyle().showProgress() : groupButton(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
          ],
        ),
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
                      'อัพโหลด...',
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

//ปุ่มบันทึกและยกเลิก
  Row groupButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.white,
            onPressed: () {
              if (nameShop == null || nameShop.isEmpty) {
                normalDialog(context, 'กรุณากรอกชื่อร้านด้วยคะ');
              } else if (address == null || address.isEmpty) {
                normalDialog(context, 'กรุณากรอกที่อยู่ของร้านด้วยคะ');
              } else if (phone == null || phone.isEmpty) {
                normalDialog(context, 'กรุณากรอกเบอร์โทรศัพท์ของร้านด้วยคะ');
              } else if (file == null) {
                normalDialog(context, 'กรุณาเพิ่มรูปภาพของร้านด้วยคะ');
              } else {
                uploadImage();
                setState(() {
                  addStatus = true;
                });
                _onLoading();
                // addInfomationShop();
              }
            },
            icon: Icon(
              Icons.save,
              color: Colors.black54,
            ),
            label: Text(
              'บันทึก',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.white,
            onPressed: () {
              // MaterialPageRoute route = MaterialPageRoute(
              //   builder: (value) => MainShop(),
              // );
              // Navigator.pushAndRemoveUntil(context, route, (route) => false);
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
          ),
        )
      ],
    );
  }

//เพิ่มรูปภาพไปยังโฟลเดอร์ที่เก็บรูป พร้อมเปลี่ยนชื่อรูป
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

        urlImage = '/Sulaiman_food/Shop/$nameImage';
        print('Url Image = $urlImage');
        addInfomationShop();
      });
    } catch (e) {}
  }

//เพิ่มลิ้งรูปภาพและรายละเอียดอื่นๆไปยัง SQL
  Future<Null> addInfomationShop() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userid = preferences.getString('User_id');
    String url =
        '${MyConstant().domain}/Sulaiman_food/add_infomation.php?isAdd=true&nameShop=$nameShop&addressShop=$address&phoneShop=$phone&urlImage=$urlImage&latitude=$lat&longitude=$lng&id=$userid';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        setState(() {
          addStatus = false;
        });
        Navigator.pop(context);
      } else {
        setState(() {
          addStatus = false;
        });
        normalDialog(context, 'อัพโหลดล้มเหลว กรุณาลองใหม่อีกครั้งคะ');
      }
    });
  }

  void _onLoading() {
    Timer(Duration(seconds: 20), () {
      setState(() {
        addStatus = false;
        normalDialog(context, 'อัพโหลดล้มเหลว กรุณาลองใหม่อีกครั้งคะ');
      });
    });
  }

//ปุ่มเพิ่มรูปภาพ
  Widget addImageButton() {
    return Container(
      width: 200.0,
      // ignore: deprecated_member_use
      child: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        onPressed: () {
          _showPicker(context);
        },
        icon: Icon(
          Icons.add_photo_alternate,
          color: Colors.black54,
        ),
        label: Text(
          'เพิ่มรูปภาพ',
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }

//ดึงรูปภาพจากมือถือมาใส่ในตัวแปร File
  Future<Null> getImage(ImageSource imageSource) async {
    try {
      final pickedFile = await picker.getImage(
        source: imageSource,
        maxHeight: 600.0,
        maxWidth: 600.0,
      );

      setState(() {
        if (pickedFile != null) {
          file = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {}
  }

//โชว์ตัวเลือกสำหรับเข้าถึงรูปภาพจากกล้องหรือในLibrary
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

//โชว์แผนที่
  Container showMap() {
    LatLng latLng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );

    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      height: 300,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: myMarker(),
      ),
    );
  }

//โชว์ภาพตัวอย่างก่อนเลือกรูปและหลังเลือกรูป
  Column showImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding:
              EdgeInsetsDirectional.only(start: 10.0, end: 10.0, bottom: 10),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.width * 0.6,
          child: file == null
              ? Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.asset('images/add_image.png'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(0),
                )
              : Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.file(file),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(0),
                ),
        ),
      ],
    );
  }

  Widget nameShopform() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300.0,
            child: TextField(
              cursorColor: Colors.black54,
              style: MyStyle().text2,
              onChanged: (value) => nameShop = value.trim(),
              decoration: InputDecoration(
                labelText: 'ชื่อร้านค้า',
                labelStyle: TextStyle(color: Colors.black54),
                prefixIcon: Icon(
                  Icons.account_box,
                  color: Colors.black54,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                ),
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
              cursorColor: Colors.black54,
              style: MyStyle().text2,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              onChanged: (value) => address = value.trim(),
              decoration: InputDecoration(
                labelText: 'ที่อยู่ร้านค้า',
                labelStyle: TextStyle(color: Colors.black54),
                prefixIcon: Icon(
                  Icons.house,
                  color: Colors.black54,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                ),
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
              cursorColor: Colors.black54,
              style: MyStyle().text2,
              onChanged: (value) => phone = value.trim(),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'เบอร์โทรร้านค้า',
                labelStyle: TextStyle(color: Colors.black54),
                prefixIcon: Icon(
                  Icons.phone,
                  color: Colors.black54,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                ),
              ),
            ),
          ),
        ],
      );
}
