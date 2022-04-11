import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sulaimanfood/model/cart_model.dart';
import 'package:sulaimanfood/model/user_model.dart';
import 'package:sulaimanfood/utility/myConstant.dart';
import 'package:sulaimanfood/utility/my_style.dart';
import 'package:sulaimanfood/utility/normal_dialog.dart';
import 'package:sulaimanfood/utility/sqlite_helper.dart';

class ShowCart extends StatefulWidget {
  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  // ignore: deprecated_member_use
  List<CartModel> cartModels = List();
  int total;
  String sum;
  int _sum;
  bool status = true;
  bool orderStatus = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readSQLite();
  }

  Future<Null> readSQLite() async {
    var object = await SQLiteHelper().readDataFromSQLite();

    if (object.length != 0) {
      total = 0;
      for (var model in object) {
        sum = model.sum;
        _sum = int.parse(sum);
        setState(() {
          status = false;
          cartModels = object;
          total = total + _sum;
        });
      }
    } else {
      setState(() {
        status = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ตะกร้าของฉัน',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
                fontStyle: FontStyle.normal,
              ),
            ),
          ],
        ),
      ),
      body: status
          ? Center(
              child: Text(
                'ไม่มีรายการอาหารในตะกร้า',
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.black87,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          : orderStatus
              ? progress(context)
              : buildContent(),
    );
  }

  Widget buildContent() {
    return Card(
      margin: const EdgeInsets.all(20.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // MyStyle().mySizebox(),
              buildNameShop(),
              // MyStyle().mySizebox(),
              MyStyle().mySizebox(),
              buildTitle(),
              MyStyle().mySizebox(),
              buildListFood(),
              Divider(
                color: Colors.black54,
              ),
              builddistance(),
              buildtransport(),
              buildTotal(),
              buildClearCart(),
              buildOrderButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildClearCart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // ignore: deprecated_member_use
        RaisedButton.icon(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onPressed: () {
            confirmDeleteDialog();
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          label: MyStyle().showtext_2('Clear ตะกร้า'),
          //color: Colors.blue.shade200,
        ),
      ],
    );
  }

  Widget buildNameShop() {
    return Container(
      margin: EdgeInsets.only(top: 12, bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home_sharp,
            color: Colors.black54,
          ),
          MyStyle().mySizebox(),
          MyStyle().showTitle_2('ร้าน ${cartModels[0].nameShop}'),
        ],
      ),
    );
  }

  Widget buildTitle() {
    return Container(
      decoration: BoxDecoration(color: Colors.deepOrangeAccent),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: MyStyle().showTitleCart('รายการอาหาร'),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyStyle().showTitleCart('ราคา'),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyStyle().showTitleCart('จำนวน'),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyStyle().showTitleCart('รวม'),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyStyle().showTitleCart('ลบ'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListFood() => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: cartModels.length,
        itemBuilder: (context, index) => Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: MyStyle().showtext_2(cartModels[index].foodName),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyStyle().showtext_2(cartModels[index].price),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyStyle().showtext_2(cartModels[index].amount),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyStyle().showtext_2(cartModels[index].sum),
                    ],
                  ),
                ),
                Expanded(
                    child: IconButton(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                    ],
                  ),
                  onPressed: () async {
                    int orderid = cartModels[index].orderId;

                    await SQLiteHelper().deleteData(orderid).then((value) {
                      print('Delete Success == $orderid');
                      readSQLite();
                    });
                  },
                )),
              ],
            ),
          ],
        ),
      );

  Widget builddistance() {
    return Container(
      //  margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.red.shade400,
                ),
                MyStyle().mySizebox(),
                MyStyle().showtext_2('ระยะทาง '),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyStyle().showtext_2('${cartModels[0].distance}  กม.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildtransport() {
    return Container(
      // margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Icon(Icons.monetization_on),
                // MyStyle().mySizebox(),
                MyStyle().showtext_2('ค่าส่ง  '),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyStyle().showtext_2('${cartModels[0].transport}  บาท'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTotal() {
    return Container(
      // margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Icon(Icons.monetization_on),
                MyStyle().showtext_2('ราคารวม  '),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyStyle().showtext_2('${total.toString()}  บาท'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> confirmDeleteDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [
            Icon(Icons.delete_forever_rounded),
            SizedBox(
              width: 10,
            ),
            Text(
              'Delete Confirm',
              style: TextStyle(
                fontSize: 26.0,
                color: Colors.black,
                fontFamily: 'FC-Minimal-Regular',
              ),
            )
          ]),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'คุณต้องการลบเมนูทั้งหมดหรือไม่',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black45,
                  fontFamily: 'FC-Minimal-Regular',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text("ลบ"),
                  onPressed: () {
                    SQLiteHelper().deleteAllData().then((value) {
                      readSQLite();
                    });
                    Navigator.pop(context);
                    deleteDialog(context);
                  },
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // readFoodMenu();
                  },
                  child: Text('ยกเลิก'),
                ),
              ],
            ),
            // ignore: deprecated_member_use
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        );
      },
    );
  }

  Future<Null> deleteDialog(
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [
            Icon(Icons.delete_forever_rounded),
            Text('Delete Success')
          ]),
          content: Text(
            'ลบรายอาหารทั้งหมดเรียบร้อย',
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.black87,
              fontStyle: FontStyle.italic,
            ),
          ),
          actions: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
              child: Text("ตกลง"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            // ignore: deprecated_member_use
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        );
      },
    );
  }

  Future<Null> orderThread() async {
    DateTime dateTimenow = DateTime.now();
    String datetime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTimenow);
    String shopid = cartModels[0].shopId;
    String nameshop = cartModels[0].nameShop;
    String distance = cartModels[0].distance;
    String transport = cartModels[0].transport;

    List<String> foodids = List();
    List<String> namefoods = List();
    List<String> prices = List();
    List<String> amounts = List();
    List<String> sums = List();
    for (var model in cartModels) {
      foodids.add(model.foodId);
      namefoods.add(model.foodName);
      prices.add(model.price);
      amounts.add(model.amount);
      sums.add(model.sum);
    }

    String foodid = foodids.toString();
    String namefood = namefoods.toString();
    String price = prices.toString();
    String amount = amounts.toString();
    String sum = sums.toString();

    print('วันที่ = $datetime');
    print('Food id == $foodid');
    print('namefood == $namefood');
    print('price == $price');
    print('amount == $amount');
    print('sum == $sum');

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userid = preferences.getString('User_id');
    String username = preferences.getString('Name');

    String url =
        '${MyConstant().domain}/Sulaiman_food/add_order.php?isAdd=true&Order_datetime=$datetime&Shop_id=$shopid&Name_shop=$nameshop&Distance=$distance&Transport=$transport&Food_id=$foodid&Food_Name=$namefood&Price=$price&Amount=$amount&Sum=$sum&Rider_id=none&Status=Userorder&User_id=$userid&User_name=$username';
    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        notificationToShop(shopid);
      } else {
        normalDialog(context, 'สั่งอาหารล้มเหลว กรุณาลองใหม่อีกครั้ง');
      }
    });
  }

  Future<Null> clearAllmenuIncart() async {
    await SQLiteHelper().deleteAllData().then((value) {
      readSQLite();
    });
  }

  Future<Null> notificationToShop(String shopid) async {
    String urlFindToken =
        '${MyConstant().domain}/Sulaiman_food/get_shoptoken.php?isAdd=true&Shop_id=$shopid';
    await Dio().get(urlFindToken).then((value) {
      var result = jsonDecode(value.data);
      // print('Result ======>> $result');
      for (var map in result) {
        UserModel model = UserModel.fromJson(map);
        String tokenShop = model.token;
        print('Token ===>><<===== $tokenShop');
        sendNotificationToShop(tokenShop);
      }
    });
  }

  Future<Null> sendNotificationToShop(String tokenShop) async {
    String title = 'มีลูกค้าสั่งอาหาร';
    String body = 'กรุณากดรับออร์เดอร์ด้วยคะ';
    String urlsendToken =
        '${MyConstant().domain}/Sulaiman_food/apiNotification.php?isAdd=true&token=$tokenShop&title=$title&body=$body';
    await Dio().get(urlsendToken).then((value) {
      // MyStyle().showToast(context, 'แจ้งเตือนไปยังร้านค้าเรียบร้อย');
      // print('Value ===========>>> $value');
      if (value.toString() == '\n\nsuccess') {
        MyStyle().showToast(context, 'สั่งอาหารเรียบร้อย');
        setState(() {
          orderStatus = false;
        });
        clearAllmenuIncart();
      }
    });
  }

  void _onLoading() {
    Timer(
      Duration(seconds: 20),
      () {
        if (orderStatus == true) {
          setState(() {
            orderStatus = false;
            normalDialog(context, 'สั่งอาหาร ล้มเหลว');
          });
        } else {}
      },
    );
  }

  Widget buildOrderButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // ignore: deprecated_member_use
        RaisedButton.icon(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onPressed: () {
            orderThread();
            _onLoading();
            setState(() {
              orderStatus = true;
            });
          },
          icon: Icon(
            Icons.fastfood,
            color: Colors.green,
          ),
          label: MyStyle().showtext_2('สั่งอาหาร'),
          //color: Colors.blue.shade200,
        ),
      ],
    );
  }

  // ignore: unused_element
  // void _onLoading() {
  //   setState(() {
  //     orderStatus = true;
  //     new Future.delayed(new Duration(seconds: 3), orderThread);
  //   });
  // }

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
                      'กำลังสั่งอาหาร...',
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
