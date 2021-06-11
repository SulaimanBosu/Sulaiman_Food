import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
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
  final double lat;
  final double lng;
  EditInfoShop({Key key, this.lat, this.lng}) : super(key: key);
  @override
  _EditInfoShopState createState() => _EditInfoShopState();
}

class _EditInfoShopState extends State<EditInfoShop> {
  InfomationShopModel infomationShop;
  double lat;
  double lng;
  String nameShop, address, phone, urlImage, newUrlImage;
  final picker = ImagePicker();
  File file;
  bool editStatus = false;
  bool loadingStatus = true;
  //Location location = Location();

  @override
  void initState() {
    super.initState();
    readCurrentData();
    lat = widget.lat;
    lng = widget.lng;
    findLatLng();
    onLoading();

    // location.onLocationChanged.listen((event) {
    //   lat = event.latitude;
    //   lng = event.longitude;
    //  });
  }

    void onLoading() {
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
        loadingStatus = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loadingStatus == true
          ? Container(
              // color: Colors.lightBlueAccent,
              child: MyStyle().progress(context)
            )
          : editStatus
              ? progress2(context)
              : Container(
                  // color: Colors.lightBlueAccent,
                  child: showContent(),
                ),
      appBar: AppBar(
        title: Text(
          'แก้ไขรายละเอียด',
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.black45,
            fontFamily: 'FC-Minimal-Regular',
          ),
        ),
      ),
    );
  }

  Widget progress2(BuildContext context) {
    return Container(
        child: new Stack(
      children: <Widget>[
        showContent(),
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
                      'อัพเดต...',
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

  Widget showContent() => SingleChildScrollView(
        child: Column(
          children: [
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'รายละเอียดร้านค้า',
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
            addImageButton(),
            nameShopform(),
            addressShopform(),
            phoneShopform(),
            MyStyle().mySizebox(),
            lat == null ? MyStyle().showProgress() : showMap(),
            MyStyle().mySizebox(),
            groupButton(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
          ],
        ),
      );

  Container showImage() {
    return Container(
      padding: EdgeInsetsDirectional.only(start: 10.0, end: 10.0, bottom: 10),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.width * 0.6,
      child: Container(
        child: file == null
            ? Card(
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
    );
  }

  Widget addImageButton() {
    return Container(
      width: 200.0,
      // ignore: deprecated_member_use
      child: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        onPressed: () {
          _showPicker(context);
          ;
        },
        icon: Icon(
          Icons.add_photo_alternate,
          color: Colors.black54,
        ),
        label: Text(
          'เปลี่ยนรูปภาพ',
          style: TextStyle(color: Colors.black54),
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
        maxHeight: 600.0,
        maxWidth: 600.0,
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
    String shopid = preferences.getString('Shop_id');
    String userid = preferences.getString('User_id');
    String url =
        '${MyConstant().domain}/Sulaiman_food/edit_infomation.php?isAdd=true&nameShop=$nameShop&addressShop=$address&phoneShop=$phone&urlImage=$urlImage&latitude=$lat&longitude=$lng&shopid=$shopid&userid=$userid';
    print(urlImage);

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        setState(() {
          editStatus = false;
        });
        Navigator.pop(context);
      } else {
        setState(() {
          editStatus = false;
        });
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
              cursorColor: Colors.black54,
              initialValue: nameShop,
              style: MyStyle().text2,
              onChanged: (value) => nameShop = value,
              decoration: InputDecoration(
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
                labelText: 'ชื่อร้านค้า',
                labelStyle: TextStyle(color: Colors.black54),
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
              cursorColor: Colors.black54,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              initialValue: address,
              style: MyStyle().text2,
              onChanged: (value) => address = value,
              decoration: InputDecoration(
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
                labelText: 'ที่อยู่ร้านค้า',
                labelStyle: TextStyle(color: Colors.black54),
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
              cursorColor: Colors.black54,
              initialValue: phone,
              style: MyStyle().text2,
              onChanged: (value) => phone = value,
              decoration: InputDecoration(
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
                labelText: 'เบอร์ติดต่อร้านค้า',
                labelStyle: TextStyle(color: Colors.black54),
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
      padding: EdgeInsets.all(10.0),
      height: 300.0,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: GoogleMap(
          initialCameraPosition: cameraPosition,
          mapType: MapType.normal,
          onMapCreated: (controller) {},
          markers: myMarker(),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5,
        margin: EdgeInsets.all(5.0),
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
            backgroundColor: Colors.white,
            onPressed: () => saveEdit(),
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
              //   builder: (value) => InfomationShop(),
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

      void _onEdit() {
    Timer(Duration(seconds: 20), () {
      setState(() {
        editStatus = false;
        normalDialog(context, 'อัพโหลดล้มเหลว กรุณาลองใหม่อีกครั้งคะ');
      });
    });
  }

  // Future<Null> confirmDialog() async {
  //   showDialog(
  //     context: context,
  //     builder: (context) => Container(
  //       child: SimpleDialog(
  //         backgroundColor: Color.fromARGB(255, 255, 255, 255),
  //         title: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Expanded(
  //               child: Center(
  //                 child: Text(
  //                   'ยืนยันการแก้ไขรายละเอียด',
  //                   style: TextStyle(
  //                     fontSize: 16.0,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         children: [
  //           MyStyle().mySizebox(),
  //           MyStyle().mySizebox(),
  //           dialogButton(),
  //         ],
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(30.0),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Row dialogButton() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Container(
  //         margin: EdgeInsets.only(left: 2.0, right: 5.0),
  //         child: FloatingActionButton.extended(
  //           onPressed: () {
  //             Navigator.pop(context);
  //             if (file == null) {
  //               addInfomationShop(urlImage);
  //             } else {
  //               uploadImage();
  //             }
  //           },
  //           icon: Icon(
  //             Icons.save_alt_rounded,
  //             color: Colors.black54,
  //           ),
  //           label: Text(
  //             'ยืนยัน',
  //             style: TextStyle(color: Colors.black54),
  //           ),
  //           backgroundColor: Color.fromARGB(105, 105, 105, 105),
  //         ),
  //       ),
  //       Container(
  //         margin: EdgeInsets.only(left: 5.0, right: 2.0),
  //         child: FloatingActionButton.extended(
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           icon: Icon(
  //             Icons.cancel,
  //             color: Colors.black54,
  //           ),
  //           label: Text(
  //             'ยกเลิก',
  //             style: TextStyle(color: Colors.black54),
  //           ),
  //           backgroundColor: Color.fromARGB(105, 105, 105, 105),
  //         ),
  //       )
  //     ],
  //   );
  // }

  confirmDialog2() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlertDialog(
              title: Column(
                children: [
                  Row(
                    children: [Icon(Icons.notification_important),MyStyle().mySizebox(),
                      MyStyle().showtext_2('Confirm'),
                    ],
                  ),
                  Divider(
                    color: Colors.black54,
                  ),
                ],
              ),
              content: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: MyStyle().showtext_2('ยืนยันการแก้ไขรายละเอียด'),
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
                    setState(() {
                      editStatus = true;
                    });
                    _onEdit();
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ],
        );
      },
    );
  }
}
