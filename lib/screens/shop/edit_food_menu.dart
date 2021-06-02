import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sulaimanfood/model/foodMenu_Model.dart';
import 'package:sulaimanfood/utility/myConstant.dart';
import 'package:sulaimanfood/utility/my_style.dart';
import 'package:sulaimanfood/utility/normal_dialog.dart';

class EditFoodMenu extends StatefulWidget {
  final String foodID, foodNAME;
  EditFoodMenu({Key key, this.foodID, this.foodNAME}) : super(key: key);

  @override
  _EditFoodMenuState createState() => _EditFoodMenuState();
}

class _EditFoodMenuState extends State<EditFoodMenu> {
  FoodMenuModel foodModel;
  File file;
  final picker = ImagePicker();
  String foodid, foodName, price, foodDetial, imagePaht;
  bool editStatus = false;
  bool loadingStatus = true;

  @override
  void initState() {
    super.initState();
    readCurrentData();
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

  Future<Null> readCurrentData() async {
    String url =
        '${MyConstant().domain}/Sulaiman_food/get_ForEdit_foodmenu.php?isAdd=true&id=${widget.foodID}';
    Response response = await Dio().get(url);
    print('response ==> $response');

    var result = json.decode(response.data);
    print('result ==> $result');

    for (var map in result) {
      setState(() {
        foodModel = FoodMenuModel.fromJson(map);
        foodid = foodModel.foodId;
        foodName = foodModel.foodName;
        price = foodModel.price;
        foodDetial = foodModel.foodDetail;
        imagePaht = foodModel.imagePath;
        loadingStatus = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แก้ไขเมนู ${widget.foodNAME}',
          style: TextStyle(
            fontSize: 22.0,
            color: Colors.black45,
            fontFamily: 'FC-Minimal-Regular',
          ),
        ),
      ),
      body: loadingStatus == true
          ? MyStyle().progress(context)
          : editStatus
              ? progress2(context)
              : buildContent(),
    );
  }

  Container buildContent() {
    return Container(
      //   color: Colors.lightBlueAccent,
      child: SingleChildScrollView(
        child: Column(
          children: [
            MyStyle().mySizebox(),
            showImage(),
            // MyStyle().mySizebox(),
            addImageButton(),
            MyStyle().mySizebox(),
            nameFoodForm(),
            priceForm(),
            detailFood(),
            MyStyle().mySizebox(),
            groupButton(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
          ],
        ),
      ),
    );
  }

  Widget progress2(BuildContext context) {
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

  //โชว์ภาพตัวอย่างก่อนเลือกรูปและหลังเลือกรูป
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
                  imageUrl: '${MyConstant().domain}$imagePaht',
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

  //ดึงรูปภาพจากมือถือมาใส่ในตัวแปร File
  Future<Null> getImage(ImageSource imageSource) async {
    try {
      final pickedFile = await picker.getImage(
        source: imageSource,
        maxHeight: 400.0,
        maxWidth: 600.0,
      );

      setState(() {
        if (pickedFile != null) {
          file = File(pickedFile.path);
        } else {
          // print('No image selected.');
        }
      });
    } catch (e) {}
  }

  //เพิ่มลิ้งรูปภาพและรายละเอียดอื่นๆไปยัง SQL
  Future<Null> editDetailFoodmenu() async {
    if (file != null) {
      Random random = Random();
      int i = random.nextInt(1000000);
      String nameImage = 'Foodmenu$i.jpg';
      String urlImage = '/Sulaiman_food/Shop/imageFood/$nameImage';

      String urlEditData =
          '${MyConstant().domain}/Sulaiman_food/edit_foodmenu.php?isAdd=true&foodname=$foodName&fooddetail=$foodDetial&price=$price&urlImage=$urlImage&Foodid=$foodid';

      await Dio().get(urlEditData).then(
        (value) async {
          print('ResponeAddData ==>> $value');
          if (value.toString() == 'true') {
            Navigator.pop(context);
            //เพิ่มรูปภาพไปยังโฟลเดอร์ที่เก็บรูป พร้อมเปลี่ยนชื่อรูป
            String urlpic =
                '${MyConstant().domain}/Sulaiman_food/saveImagemenu.php';
            Map<String, dynamic> map = Map();
            map['file'] =
                await MultipartFile.fromFile(file.path, filename: nameImage);
            FormData formData = FormData.fromMap(map);
            await Dio().post(urlpic, data: formData).then((value) {
              if (value.toString() == 'successfully') {
                setState(() {
                  editStatus = false;
                });
                // setState(() {
                //   _onLoading();
                //   new Future.delayed(new Duration(seconds: 3),);
                // });
              }
              print('ResponeUpimage ==>> $value');
              print('Url Image = $urlImage');
            });

            Navigator.pop(context);
          } else {
            normalDialog(context, 'อัพโหลดล้มเหลว กรุณาลองใหม่อีกครั้งคะ');
            setState(() {
              editStatus = false;
            });
          }
        },
      );
    } else {
      String urlEditData =
          '${MyConstant().domain}/Sulaiman_food/edit_foodmenu.php?isAdd=true&foodname=$foodName&fooddetail=$foodDetial&price=$price&urlImage=$imagePaht&Foodid=$foodid';
      await Dio().get(urlEditData).then(
        (value) {
          print('ResponeAddData ==>> $value');
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
        },
      );
    }
  }

  void _onEdit() {
    Timer(Duration(seconds: 20), () {
      if (editStatus == true) {
        setState(() {
          editStatus = false;
          normalDialog(context, 'อัพโหลดล้มเหลว กรุณาลองใหม่อีกครั้งคะ');
        });
      }
    });
  }

  Widget nameFoodForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 300.0,
            child: TextFormField(
              cursorColor: Colors.black54,
              initialValue: foodModel.foodName,
              onChanged: (value) => foodName = value,
              style: MyStyle().text2,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.fastfood,
                  color: Colors.black54,
                ),
                labelText: 'ชื่อเมนู',
                labelStyle: TextStyle(color: Colors.black54),
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

  Widget priceForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 300.0,
            child: TextFormField(
              cursorColor: Colors.black54,
              keyboardType: TextInputType.number,
              initialValue: foodModel.price,
              onChanged: (value) => price = value,
              style: MyStyle().text2,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.attach_money,
                  color: Colors.black54,
                ),
                labelText: 'ราคา',
                labelStyle: TextStyle(color: Colors.black54),
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

  Widget detailFood() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 300.0,
            child: TextFormField(
              cursorColor: Colors.black54,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              initialValue: foodModel.foodDetail,
              onChanged: (value) => foodDetial = value,
              style: MyStyle().text2,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.details_outlined,
                  color: Colors.black54,
                ),
                labelText: 'รายละเอียด',
                labelStyle: TextStyle(color: Colors.black54),
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
              if (foodName == null || foodName.isEmpty) {
                normalDialog(context, 'กรุณากรอกชื่อเมนูอาหารด้วยคะ');
              } else if (foodDetial == null || foodDetial.isEmpty) {
                normalDialog(context, 'กรุณากรอกรายละเอียดของอาหารด้วยคะ');
              } else if (price == null || price.isEmpty) {
                normalDialog(context, 'กรุณากรอกราคาของอาหารด้วยคะ');
              } else if (imagePaht == null) {
                normalDialog(context, 'กรุณาเพิ่มรูปภาพของอาหารด้วยคะ');
              } else {
                confirmDialog();
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

  confirmDialog() async {
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
                    children: [
                      Text('Confirm'),
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
                    editDetailFoodmenu();
                    _onEdit();
                    setState(() {
                      editStatus = true;
                    });
                    Navigator.pop(context);
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
