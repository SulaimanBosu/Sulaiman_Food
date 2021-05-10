import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sulaimanfood/model/foodMenu_Model.dart';
import 'package:sulaimanfood/utility/myConstant.dart';
import 'package:sulaimanfood/utility/my_style.dart';
import 'package:sulaimanfood/utility/normal_dialog.dart';

class EditFoodMenu extends StatefulWidget {
  final FoodMenuModel foodModel;
  EditFoodMenu({Key key, this.foodModel}) : super(key: key);

  @override
  _EditFoodMenuState createState() => _EditFoodMenuState();
}

class _EditFoodMenuState extends State<EditFoodMenu> {
  FoodMenuModel foodModel;
  File file;
  final picker = ImagePicker();
  String foodid, foodName, price, foodDetial, imagePaht;

  @override
  void initState() {
    super.initState();

    foodModel = widget.foodModel;
    foodid = foodModel.foodId;
    foodName = foodModel.foodName;
    price = foodModel.price;
    foodDetial = foodModel.foodDetail;
    imagePaht = foodModel.imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขเมนู $foodName'),
      ),
      body: Container(
        color: Colors.lightBlueAccent,
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
      ),
    );
  }

  //โชว์ภาพตัวอย่างก่อนเลือกรูปและหลังเลือกรูป
  Column showImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            //width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(10.0),
            //width: 240.0,
            child: file == null
                ? Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: CachedNetworkImage(
                      imageUrl: '${MyConstant().domain}$imagePaht',
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
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
        ),
      ],
    );
  }

  //ปุ่มเพิ่มรูปภาพ
  Widget addImageButton() {
    return Container(
      width: 200.0,
      // ignore: deprecated_member_use
      child: FloatingActionButton.extended(
        onPressed: () {
          _showPicker(context);
        },
        icon: Icon(
          Icons.add_photo_alternate,
          color: Colors.white,
        ),
        label: Text(
          'เพิ่มรูปภาพ',
          style: TextStyle(color: Colors.white),
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
              print('ResponeUpimage ==>> $value');
              print('Url Image = $urlImage');
            });

            Navigator.pop(context);
          } else {
            normalDialog(context, 'อัพโหลดล้มเหลว กรุณาลองใหม่อีกครั้งคะ');
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
            Navigator.pop(context);
          } else {
            normalDialog(context, 'อัพโหลดล้มเหลว กรุณาลองใหม่อีกครั้งคะ');
          }
        },
      );
    }
  }

  Widget nameFoodForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 300.0,
            child: TextFormField(
              cursorColor: Colors.white,
              initialValue: foodModel.foodName,
              onChanged: (value) => foodName = value,
              // style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.fastfood,
                  color: Colors.white,
                ),
                labelText: 'ชื่อเมนู',
                //  labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
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
              cursorColor: Colors.white,
              keyboardType: TextInputType.number,
              initialValue: foodModel.price,
              onChanged: (value) => price = value,
              // style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.attach_money,
                  color: Colors.white,
                ),
                labelText: 'ราคา',
                //  labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
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
              cursorColor: Colors.white,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              initialValue: foodModel.foodDetail,
              onChanged: (value) => foodDetial = value,
              // style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.details_outlined,
                  color: Colors.white,
                ),
                labelText: 'รายละเอียด',
                //  labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
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
                    editDetailFoodmenu();
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
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ],
        );
      },
    );
  }
}
