import 'dart:async';
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
  bool addStatus = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เมนูอาหาร',
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
      //color: Colors.lightBlueAccent,
      child: SingleChildScrollView(
        child: Column(children: [
          MyStyle().mySizebox(),
          MyStyle().mySizebox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Text(
                'เพิ่มเมนูอาหาร',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.black45,
                  fontFamily: 'FC-Minimal-Regular',
                ),
              )),
            ],
          ),
          MyStyle().mySizebox(),
          showImage(),
          MyStyle().mySizebox(),
          addImageButton(),
          MyStyle().mySizebox(),
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
  Container showImage() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      //  height: MediaQuery.of(context).size.width * 0.6,
      child: file == null
          ? Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset('images/add_image.png'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(0),
            )
          : Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.file(file),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(0),
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
        //  print('ResponeAddData ==>> $value');
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
                addStatus = false;
              });
            }
            //  print('ResponeUpimage ==>> $value');
            //   print('Url Image = $urlImage');
          });
          Navigator.pop(context);
        } else if (value.toString() == 'noShop') {
          errorDialog('กรุณาเพิ่มรายละเอียดร้านค้าด้วยคะ');
          Navigator.pop(context);
        } else {
          setState(() {
            addStatus = false;
          });
          normalDialog(context, 'อัพโหลดล้มเหลว กรุณาลองใหม่อีกครั้งคะ');
        }
      },
    );
  }

  Widget nameForm() => Container(
        width: 300.0,
        child: TextField(
          cursorColor: Colors.black54,
          style: MyStyle().text2,
          onChanged: (value) => foodname = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.fastfood,
              color: Colors.black54,
            ),
            labelText: 'ชื่ออาหาร',
            labelStyle: TextStyle(color: Colors.black54),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black54),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      );

  Widget priceForm() => Container(
        width: 300.0,
        child: TextField(
          cursorColor: Colors.black54,
          style: MyStyle().text2,
          keyboardType: TextInputType.number,
          onChanged: (value) => price = value.trim(),
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
      );

  Widget detailForm() => Container(
        width: 300.0,
        child: TextField(
          cursorColor: Colors.black54,
          style: MyStyle().text2,
          onChanged: (value) => detail = value.trim(),
          keyboardType: TextInputType.multiline,
          maxLines: 5,
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
                setState(() {
                  addStatus = true;
                });
                _onLoading();
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

  void _onLoading() {
    Timer(Duration(seconds: 20), () {
      setState(() {
        addStatus = false;
        normalDialog(context, 'อัพโหลดล้มเหลว กรุณาลองใหม่อีกครั้งคะ');
      });
    });
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
