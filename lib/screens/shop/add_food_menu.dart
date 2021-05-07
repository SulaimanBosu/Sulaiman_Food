import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sulaimanfood/utility/myConstant.dart';
import 'package:sulaimanfood/utility/my_style.dart';
import 'package:sulaimanfood/utility/normal_dialog.dart';

class AddFoodMenu extends StatefulWidget {
  @override
  _AddFoodMenuState createState() => _AddFoodMenuState();
}

class _AddFoodMenuState extends State<AddFoodMenu> {
  File file;
  final picker = ImagePicker();
  String foodname, detail, price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เมนูอาหาร'),
      ),
      body: Container(
        color: Colors.lightBlueAccent,
        child: SingleChildScrollView(
          child: Column(children: [
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: showTitle('เพิ่มเมนูอาหาร')),
              ],
            ),
            showImage(),
            addImageButton(),
            MyStyle().mySizebox(),
            showTitle('รายละเอียดอาหาร'),
            nameForm(),
            MyStyle().mySizebox(),
            priceForm(),
            MyStyle().mySizebox(),
            detailForm(),
            MyStyle().mySizebox(),
            groupButton(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
          ]),
        ),
      ),
    );
  }

  Widget showTitle(String string) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Container(child: MyStyle().showTitleH2(string)),
        ],
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
              margin: EdgeInsets.all(16.0),
              width: 300.0,
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
                    )),
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
          print('No image selected.');
        }
      });
    } catch (e) {}
  }

//เพิ่มลิ้งรูปภาพและรายละเอียดอื่นๆไปยัง SQL
  Future<Null> addDetailFoodmenu() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userid = preferences.getString('User_id');
    Random random = Random();
    int i = random.nextInt(1000000);
    String nameImage = 'Foodmenu$i.jpg';
    String urlImage = '/Sulaiman_food/Shop/imageFood/$nameImage';

    String urladdData =
        '${MyConstant().domain}/Sulaiman_food/add_foodmenu.php?isAdd=true&foodname=$foodname&fooddetail=$detail&price=$price&urlImage=$urlImage&userid=$userid';

    await Dio().get(urladdData).then(
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
        } else if (value.toString() == 'noShop') {
          errorDialog('กรุณาเพิ่มรายละเอียดร้านค้าด้วยคะ');
          Navigator.pop(context);
        } else {
          normalDialog(context, 'อัพโหลดล้มเหลว กรุณาลองใหม่อีกครั้งคะ');
        }
      },
    );
  }

  Widget nameForm() => Container(
        width: 300.0,
        child: TextField(
          cursorColor: Colors.white,
       //   style: TextStyle(color: Colors.white),
          onChanged: (value) => foodname = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.fastfood,
              color: Colors.white,
            ),
            labelText: 'ชื่ออาหาร',
         //   labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget priceForm() => Container(
        width: 300.0,
        child: TextField(
          cursorColor: Colors.white,
     //     style: TextStyle(color: Colors.white),
          keyboardType: TextInputType.number,
          onChanged: (value) => price = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.attach_money,
              color: Colors.white,
            ),
            labelText: 'ราคา',
           // labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget detailForm() => Container(
        width: 300.0,
        child: TextField(
          cursorColor: Colors.white,
        //  style: TextStyle(color: Colors.white),
          onChanged: (value) => detail = value.trim(),
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.details_outlined,
              color: Colors.white,
            ),
            labelText: 'รายละเอียด',
        //    labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(),
          ),
        ),
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
              if (foodname == null || foodname.isEmpty) {
                normalDialog(context, 'กรุณากรอกชื่อเมนูอาหารด้วยคะ');
              } else if (detail == null || detail.isEmpty) {
                normalDialog(context, 'กรุณากรอกรายละเอียดของอาหารด้วยคะ');
              } else if (price == null || price.isEmpty) {
                normalDialog(context, 'กรุณากรอกราคาของอาหารด้วยคะ');
              } else if (file == null) {
                normalDialog(context, 'กรุณาเพิ่มรูปภาพของอาหารด้วยคะ');
              } else {
                addDetailFoodmenu();
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

  errorDialog(String text) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlertDialog(
              title: Row(
                children: [
                  Text('ไม่พบร้านค้า'),
                ],
              ),
              content: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          text,
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
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
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
