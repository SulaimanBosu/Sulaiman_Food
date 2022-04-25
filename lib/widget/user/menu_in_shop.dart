import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:sulaimanfood/model/cart_model.dart';
import 'package:sulaimanfood/model/foodMenu_Model.dart';
import 'package:sulaimanfood/model/infomationShop_model.dart';
import 'package:sulaimanfood/utility/myConstant.dart';
import 'package:sulaimanfood/utility/my_api.dart';
import 'package:sulaimanfood/utility/my_style.dart';
import 'package:sulaimanfood/utility/normal_dialog.dart';
import 'package:sulaimanfood/utility/sqlite_helper.dart';
import 'package:toast/toast.dart';

class MenuInShop extends StatefulWidget {
  final InfomationShopModel shopModel;
  MenuInShop({Key key, this.shopModel}) : super(key: key);
  @override
  _MenuInShopState createState() => _MenuInShopState();
}

class _MenuInShopState extends State<MenuInShop> {
  InfomationShopModel shopModels;
  String shopid;
  // ignore: deprecated_member_use
  List<FoodMenuModel> foodModels = List();
  // ignore: deprecated_member_use
  List<CartModel> cartModels = List();
  int amount = 1;
  int transport = 0;
  double lat1, lng1, lat2, lng2, distance;
  String distanceString;
  Location location = Location();
  int total;
  String sum;
  int _sum;
  int time;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shopModels = widget.shopModel;
    readFoodmenu();
    //findLocation();
    findLatLng();
  }

//ดึงตำ่แหน่งที่ตั้งปัจจุบัน
  // Future<Null> findLocation() async {
  //   location.onLocationChanged.listen((event) {
  //     lat1 = event.latitude;
  //     lng1 = event.longitude;
  //     print('Latitude = $lat1, Longitude = $lng1');
  //   });
  // }

  Future<Null> readFoodmenu() async {
    shopid = shopModels.shopId;
    String url =
        '${MyConstant().domain}/Sulaiman_food/get_Menu_in_Shop_forUser.php?isAdd=true&Shop_id=$shopid';
    Response response = await Dio().get(url);
    //print('Response == $response');

    var result = json.decode(response.data);
    //print('Result == $result');
    for (var map in result) {
      FoodMenuModel foodModel = FoodMenuModel.fromJson(map);
      setState(() {
        foodModels.add(foodModel);
      });
    }
  }

  //ดึงตำ่แหน่งที่ตั้งปัจจุบัน
  // Future<Null> findLatLng() async {
  //   Location location = Location();
  //   LocationData locationData = await location.getLocation();
  //   setState(() {
  //     lat1 = locationData.latitude;
  //     lng1 = locationData.longitude;
  //     lat2 = double.parse(shopModels.latitude);
  //     lng2 = double.parse(shopModels.longitude);
  //   });
  //   print('Lat = $lat1,  Lng = $lng1, Lat2 == $lat2 , Lon2 == $lng2');
  //   distance = MyApi().calculateDistance(lat1, lng1, lat2, lng2);
  // }

    Future<Null> findLatLng() async {
    Location location = Location();
    LocationData locationData = await location.getLocation();
    setState(() {
      lat1 = locationData.latitude;
      lng1 = locationData.longitude;
      lat2 = double.parse(shopModels.latitude);
      lng2 = double.parse(shopModels.longitude);
    });
    print('Lat = $lat1,  Lng = $lng1, Lat2 == $lat2 , Lon2 == $lng2');
    //  distance = MyApi().calculateDistance(lat1, lng1, lat2, lng2);
    double distance = MyApi().calculateDistance(lat1, lng1, lat2, lng2);
    var myFormat = NumberFormat('#0.00', 'en_US');
    distanceString = myFormat.format(distance);
    transport = MyApi().calculateTransport(distance);
    time = MyApi().calculateTime(distance);
  }

//โฟกัสตำแหน่งที่ตั้งปัจบันเสมอ
  // Future<LocationData> findLocationData() async {
  //   Location location = Location();
  //   try {
  //     return location.getLocation;
  //   } catch (e) {
  //     return e;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.lightBlueAccent,
      child: foodModels.length == 0
          ? progress(context)
          //MyStyle().showProgress2('ดาวน์โหลด...')
          : showContent(),
    );
  }

  Widget showContent() {
    return
    //  foodModels.length != 0
    //     ? showListFoodMenu1()
    //     : 
        Center(
            child: Text('ยังไม่มีรายการอาหาร'),
          );
  }

  // Widget showListFoodMenu1() => ListView.builder(
  //       padding: EdgeInsetsDirectional.only(top: 0.0, bottom: 20.0),
  //       itemCount: foodModels.length,
  //       itemBuilder: (context, index) => Container(
  //         child: Slidable(
  //           key: Key(foodModels[index].foodName),
  //           actionPane: SlidableDrawerActionPane(),
  //           actionExtentRatio: 0.25,
  //           child: Container(
  //             decoration: index % 2 == 0
  //                 ? new BoxDecoration(color: Colors.white10)
  //                 : new BoxDecoration(color: Colors.grey.shade300),
  //             child: Container(
  //               padding: EdgeInsetsDirectional.only(top: 0.0, bottom: 0.0),
  //               child: GestureDetector(
  //                 onTap: () {
  //                   // print('คุณคลิก index = $index');
  //                   amount = 1;
  //                   userOrder(index);
  //                 },
  //                 child: Row(
  //                   children: [
  //                     Container(
  //                       padding:
  //                           EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
  //                       width: MediaQuery.of(context).size.width * 0.4,
  //                       height: MediaQuery.of(context).size.width * 0.3,
  //                       child: Container(
  //                         child: Card(
  //                           semanticContainer: true,
  //                           clipBehavior: Clip.antiAliasWithSaveLayer,
  //                           child: CachedNetworkImage(
  //                             imageUrl:
  //                                 '${MyConstant().domain}${foodModels[index].imagePath}',
  //                             progressIndicatorBuilder:
  //                                 (context, url, downloadProgress) =>
  //                                     MyStyle().showProgress(),
  //                             // CircularProgressIndicator(
  //                             //     ),
  //                             errorWidget: (context, url, error) =>
  //                                 Icon(Icons.error),
  //                             fit: BoxFit.cover,
  //                           ),
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(20.0),
  //                           ),
  //                           elevation: 5,
  //                           margin: EdgeInsets.all(10),
  //                         ),
  //                       ),
  //                     ),
  //                     Container(
  //                       //  padding: EdgeInsetsDirectional.only(start: 5.0, end: 5.0),
  //                       //   padding: EdgeInsets.all(5.0),
  //                       width: MediaQuery.of(context).size.width * 0.488,
  //                       height: MediaQuery.of(context).size.width * 0.3,
  //                       child: SingleChildScrollView(
  //                         padding: EdgeInsets.only(
  //                             right: 5.0, top: 15.0, bottom: 5.0),
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Container(
  //                               //padding: EdgeInsetsDirectional.only(top: 0.0,bottom: 10.0),
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                 children: [
  //                                   Expanded(
  //                                     child: Text(
  //                                       foodModels[index].foodName,
  //                                       overflow: TextOverflow.ellipsis,
  //                                       style: MyStyle().mainTitle,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               children: [
  //                                 Expanded(
  //                                   child: Text(
  //                                     'ราคา ${foodModels[index].price} บาท',
  //                                     overflow: TextOverflow.ellipsis,
  //                                     style: MyStyle().mainH2Title,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               children: [
  //                                 Expanded(
  //                                   child: Text(
  //                                     foodModels[index].foodDetail,
  //                                     //overflow: TextOverflow.ellipsis,
  //                                     style: TextStyle(
  //                                         color: Colors.black45,
  //                                         fontSize: 14.0,
  //                                         fontFamily: 'FC-Minimal-Regular',
  //                                         fontStyle: FontStyle.italic),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               children: [
  //                                 Expanded(
  //                                   child: MyStyle().textdetail_1(
  //                                       '${distanceString.toString()} Km. | (${time}min) | ${transport}B'),
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: IconButton(
  //                         icon: Icon(
  //                           Icons.edit_outlined,
  //                           color: Colors.black45,
  //                           size: 30,
  //                         ),
  //                         // ignore: unnecessary_statements
  //                         onPressed: () {},
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //           actions: <Widget>[
  //             IconSlideAction(
  //               caption: 'เมนูโปรด',
  //               color: Colors.grey.shade400,
  //               icon: Icons.favorite_outline_rounded,
  //               onTap: () => Toast.show('Archive on $index', context,
  //                   duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM),
  //             ),
  //             IconSlideAction(
  //               caption: 'ดูรีวิว',
  //               color: Colors.red.shade300,
  //               icon: Icons.rate_review,
  //               onTap: () => Toast.show('Share on $index', context,
  //                   duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM),
  //             ),
  //           ],
  //           secondaryActions: <Widget>[
  //             IconSlideAction(
  //               caption: 'เขียนรีวิว',
  //               color: Colors.black45,
  //               icon: Icons.edit,
  //               onTap: () {
  //                 Text('เขียนรีวิว');
  //               },
  //             ),
  //             IconSlideAction(
  //                 caption: 'ให้คะแนน',
  //                 color: Colors.lightBlue.shade100,
  //                 icon: Icons.stars_rounded,
  //                 foregroundColor: Colors.amberAccent.shade700,
  //                 onTap: () {
  //                   Text('ให้คะแนน');
  //                 }),
  //           ],
  //         ),
  //       ),
  //     );

  // Widget showListFoodMenu3() => ListView.builder(
  //       padding: EdgeInsetsDirectional.only(top: 0.0, bottom: 20.0),
  //       itemCount: foodModels.length,
  //       itemBuilder: (context, index) => Container(
  //         child: Slidable(
  //           key: Key(foodModels[index].foodName),
  //           actionPane: SlidableDrawerActionPane(),
  //           actionExtentRatio: 0.25,
  //           child: Container(
  //             decoration: index % 2 == 0
  //                 ? new BoxDecoration(color: Colors.lightBlueAccent)
  //                 : new BoxDecoration(color: Colors.lightBlue),
  //             child: Container(
  //               padding: EdgeInsetsDirectional.only(top: 0.0, bottom: 0.0),
  //               child: GestureDetector(
  //                 onTap: () {
  //                   // print('คุณคลิก index = $index');
  //                   amount = 1;
  //                   userOrder(index);
  //                 },
  //                 child: Row(
  //                   children: [
  //                     Container(
  //                       padding:
  //                           EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
  //                       width: MediaQuery.of(context).size.width * 0.4,
  //                       height: MediaQuery.of(context).size.width * 0.3,
  //                       child: Container(
  //                         child: Card(
  //                           semanticContainer: true,
  //                           clipBehavior: Clip.antiAliasWithSaveLayer,
  //                           child: CachedNetworkImage(
  //                             imageUrl:
  //                                 '${MyConstant().domain}${foodModels[index].imagePath}',
  //                             progressIndicatorBuilder:
  //                                 (context, url, downloadProgress) =>
  //                                     //       MyStyle().showProgress(),
  //                                     Center(
  //                               child: CircularProgressIndicator(
  //                                 value: downloadProgress.progress,
  //                                 backgroundColor: Colors.white,
  //                                 valueColor:
  //                                     AlwaysStoppedAnimation<Color>(Colors.red),
  //                               ),
  //                             ),
  //                             errorWidget: (context, url, error) =>
  //                                 Icon(Icons.error),
  //                             fit: BoxFit.cover,
  //                           ),
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(20.0),
  //                           ),
  //                           elevation: 5,
  //                           margin: EdgeInsets.all(10),
  //                         ),
  //                       ),
  //                     ),
  //                     Container(
  //                       //  padding: EdgeInsetsDirectional.only(start: 5.0, end: 5.0),
  //                       //   padding: EdgeInsets.all(5.0),
  //                       width: MediaQuery.of(context).size.width * 0.6,
  //                       height: MediaQuery.of(context).size.width * 0.3,
  //                       child: SingleChildScrollView(
  //                         padding: EdgeInsets.only(
  //                             right: 5.0, top: 15.0, bottom: 5.0),
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Container(
  //                               //padding: EdgeInsetsDirectional.only(top: 0.0,bottom: 10.0),
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                 children: [
  //                                   Expanded(
  //                                     child: Text(
  //                                       foodModels[index].foodName,
  //                                       overflow: TextOverflow.ellipsis,
  //                                       style: MyStyle().mainTitle,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               children: [
  //                                 Expanded(
  //                                   child: Text(
  //                                     'ราคา ${foodModels[index].price} บาท',
  //                                     overflow: TextOverflow.ellipsis,
  //                                     style: MyStyle().mainH2Title,
  //                                   ),
  //                                 ),
  //                                 // IconButton(
  //                                 //     icon: Icon(
  //                                 //       Icons.delete_sweep_outlined,
  //                                 //       color: Colors.white,size: 20,
  //                                 //     ),
  //                                 //     onPressed: null),
  //                               ],
  //                             ),
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               children: [
  //                                 Expanded(
  //                                   child: Text(
  //                                     foodModels[index].foodDetail,
  //                                     //overflow: TextOverflow.ellipsis,
  //                                     style: TextStyle(
  //                                         color: Colors.white70,
  //                                         fontSize: 14.0,
  //                                         fontStyle: FontStyle.italic),
  //                                   ),
  //                                 ),
  //                                 // IconButton(
  //                                 //     icon: Icon(
  //                                 //       Icons.delete_sweep_outlined,
  //                                 //       color: Colors.white,size: 20,
  //                                 //     ),
  //                                 //     onPressed: null),
  //                               ],
  //                             ),
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               children: [
  //                                 Expanded(
  //                                   child: Text(
  //                                     '7.0 km(27 min) | 50B',
  //                                     overflow: TextOverflow.ellipsis,
  //                                     style: TextStyle(
  //                                         color: Colors.white70,
  //                                         fontSize: 10.0,
  //                                         fontStyle: FontStyle.normal),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //           //   actions: <Widget>[
  //           //   IconSlideAction(
  //           //     caption: 'Archive',
  //           //     color: Colors.blue,
  //           //     icon: Icons.archive,
  //           //     onTap: () => Toast.show('Archive on $index', context,
  //           //         duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM),
  //           //   ),
  //           //   IconSlideAction(
  //           //     caption: 'Share',
  //           //     color: Colors.indigo,
  //           //     icon: Icons.share,
  //           //     onTap: () => Toast.show('Share on $index', context,
  //           //         duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM),
  //           //   ),
  //           // ],
  //           secondaryActions: <Widget>[
  //             IconSlideAction(
  //               caption: 'แก้ไข',
  //               color: Colors.black45,
  //               icon: Icons.edit,
  //               onTap: () {
  //                 // MaterialPageRoute route = MaterialPageRoute(
  //                 //   builder: (context) => EditFoodMenu(
  //                 //     foodModel: foodMenuModels[index],
  //                 //   ),
  //                 // );
  //                 // Navigator.push(context, route).then(
  //                 //   (value) => readFoodMenu(),
  //                 // );
  //               },
  //             ),
  //             IconSlideAction(
  //                 caption: 'ลบ',
  //                 color: Colors.red,
  //                 icon: Icons.delete,
  //                 onTap: () {
  //                   // confirmDeleteDialog(foodMenuModels[index]);
  //                 }),
  //           ],
  //         ),
  //       ),
  //     );

  Future<Null> userOrder(int index) async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => SimpleDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.fastfood,
                color: Colors.black45,
                size: 18,
              ),
              MyStyle().mySizebox(),
              MyStyle().showtext_2(foodModels[index].foodName),
            ],
          ),
          children: [
            Container(
              padding: EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
              //     width: 200,height: 180,
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.5,
              child: Container(
                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: CachedNetworkImage(
                    imageUrl:
                        '${MyConstant().domain}${foodModels[index].imagePath}',
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            //       MyStyle().showProgress(),
                            Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.remove_circle_outline,
                      size: 36,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      if (amount > 1) {
                        setState(() {
                          amount--;
                        });
                      }
                    }),
                MyStyle().mySizebox(),
                MyStyle().mySizebox(),
                Text(
                  amount.toString(),
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                MyStyle().mySizebox(),
                MyStyle().mySizebox(),
                IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      size: 36,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      setState(() {
                        amount++;
                      });
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // ignore: deprecated_member_use
                RaisedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                  ),
                  label: MyStyle().showtext_2('ยกเลิก'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ), // ignore: deprecated_member_use
                RaisedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    //  print('Amount == $amount');
                    addOrderToCart(index);
                  },
                  icon: Icon(
                    Icons.fastfood_outlined,
                    color: Colors.green,
                  ),
                  label: MyStyle().showtext_2('ใส่ตะกร้า'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ],
            )
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
    );
  }

  Future<Null> addOrderToCart(int index) async {
    String nameshop = shopModels.nameShop;
    String foodid = foodModels[index].foodId;
    String foodname = foodModels[index].foodName;
    String price = foodModels[index].price;

    int priceInt = int.parse(price);
    int sum = priceInt * amount;
    double distance = MyApi().calculateDistance(lat1, lng1, lat2, lng2);
    var myFormat = NumberFormat('#0.00', 'en_US');
    distanceString = myFormat.format(distance);
    int transport = MyApi().calculateTransport(distance);

    //print(
    //     'idshop = $shopid , Nameshop = $nameshop, Foodid = $foodid, Foodname = $foodname, Price = $price, Amount = $amount, Sum = $sum, Distance = $distanceString, transport = $transport');
    Map<String, dynamic> map = Map();

    map['Shop_id'] = shopid;
    map['Name_shop'] = nameshop;
    map['Food_id'] = foodid;
    map['Food_Name'] = foodname;
    map['Price'] = price;
    map['Amount'] = amount.toString();
    map['Sum'] = sum.toString();
    map['Distance'] = distanceString;
    map['Transport'] = transport.toString();

    //print('Map == ${map.toString()}');

    CartModel cartModel = CartModel.fromJson(map);

    var object = await SQLiteHelper().readDataFromSQLite();

    //  print('object == ${object.length}');

    if (object.length == 0) {
      await SQLiteHelper().insertDataToSQLite(cartModel).then((value) {
        print('Insert Length = 0 Success');
        showToast('เพิ่มลงตะกร้าเรียบร้อย');
      });
    } else {
      String shopidSQLite = object[0].shopId;
      //  print('shopidSQLite == $shopidSQLite');
      if (shopid == shopidSQLite) {
        //  apdateSQLite(cartModel, foodid, amount);
        await SQLiteHelper().insertDataToSQLite(cartModel).then(
          (value) {
            print('Insert Success');
            showToast('เพิ่มลงตะกร้าเรียบร้อย');
          },
        );
      } else {
        normalDialog(
            context, 'มีรายการอาหารของร้าน ${object[0].nameShop} อยู่แล้ว');
      }
    }
  }

  void showToast(String string) {
    Toast.show(
      string,
      context,
      duration: Toast.LENGTH_LONG,
    );
  }

  Future<Null> apdateSQLite(
      CartModel cartModel, String foodid, int amount) async {
    var object = await SQLiteHelper().readDataFromSQLite();

    cartModels = object;
    String foodID = cartModel.foodId;
    for (var model in object) {
      String foodidSQLite = model.foodId;
      for (int i = 1; i < cartModels.length; i++) {}

      String amountSQLite = model.amount;
      int amountInt = int.parse(amountSQLite);
      print('Count == $foodID');

      if (foodidSQLite == foodID) {
        int sumAmount = amountInt + amount;
        await SQLiteHelper()
            .apdateAmountToSQLite(foodid, sumAmount)
            .then((value) {
          print('Apdate Success');
          showToast('Apdate Success');
        });
      } else {
        await SQLiteHelper().insertDataToSQLite(cartModel).then((value) {
          print('Insert length != 0 Success');
          showToast('เพิ่มลงตะกร้าเรียบร้อย');
        });
      }
    }
  }

  Widget progress(BuildContext context) {
    return Container(
        child: new Stack(
      children: <Widget>[
        Container(
          alignment: AlignmentDirectional.center,
          decoration: new BoxDecoration(
            color: Colors.white,
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
                      'ดาวน์โหลด...',
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
