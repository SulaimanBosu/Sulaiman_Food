import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sulaimanfood/model/foodMenu_Model.dart';
import 'package:sulaimanfood/model/user_model.dart';
import 'package:sulaimanfood/screens/shop/add_food_menu.dart';
import 'package:sulaimanfood/screens/shop/edit_food_menu.dart';
import 'package:sulaimanfood/utility/myConstant.dart';
import 'package:sulaimanfood/utility/my_style.dart';

import 'package:toast/toast.dart';

class ListMenuShop extends StatefulWidget {
  @override
  _ListMenuShopState createState() => _ListMenuShopState();
}

class _ListMenuShopState extends State<ListMenuShop> {
  UserModel userModel;
  bool status = true;
  bool loadStatus = true;
  // ignore: deprecated_member_use
  List<FoodMenuModel> foodMenuModels = List();
  double time = 0.0;
  @override
  void initState() {
    super.initState();
    readFoodMenu();
  }

  Future<Null> readFoodMenu() async {
    if (foodMenuModels.length != 0) {
      foodMenuModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userid = preferences.getString('User_id');
    print('User id ==> $userid');

    String url =
        '${MyConstant().domain}/Sulaiman_food/get_FoodMenu.php?isAdd=true&id=$userid';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      var result = json.decode(value.data);
      //  print('Result ==> $result');
      if (result.toString() != 'null') {
        for (var map in result) {
          FoodMenuModel foodMenuModel = FoodMenuModel.fromJson(map);
          setState(() {
            foodMenuModels.add(foodMenuModel);
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent,
      child: Stack(
        children: [
          loadStatus
              ? MyStyle().showProgress2('กรุณารอสักครู่...')
              : showContent(),
          addMenuButton(),
        ],
      ),
    );
  }

  Widget showContent() {
    return status
        ? //showListFoodMenu()
        showListFoodMenu2()
        : Center(
            child: Text('ยังไม่มีรายการอาหาร'),
          );
  }

  Widget addMenuButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 16.0, right: 16.0),
              child: FloatingActionButton(
                onPressed: () {
                  routeAddInfomation();
                },
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> routeAddInfomation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String shopId = preferences.getString('Shop_id');
    print('Shopid ==> $shopId');
    if (shopId == null || shopId.isEmpty || shopId == 'null') {
      errorDialog('กรุณาเพิ่มร้านของคุณก่อนคะ');
    } else {
      MaterialPageRoute route = MaterialPageRoute(
        builder: (value) => AddFoodMenu(),
      );
      Navigator.push(context, route).then((value) => readFoodMenu());
    }
  }

  errorDialog(String text) async {
    showDialog(
      //    context: context,
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
      context: context,
    );
  }

  Widget showListFoodMenu() => ListView.separated(
        padding: EdgeInsetsDirectional.only(top: 20.0, bottom: 20.0),
        itemCount: foodMenuModels.length,
        itemBuilder: (context, index) => Container(
          child: Slidable(
            key: Key(foodMenuModels[index].foodName),
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Container(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsetsDirectional.only(
                      start: 10.0,
                      end: 10.0,
                    ),
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.3,
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.network(
                        '${MyConstant().domain}${foodMenuModels[index].imagePath}',
                        fit: BoxFit.cover,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                    ),
                  ),
                  Container(
                    padding: EdgeInsetsDirectional.only(start: 10.0, end: 5.0),
                    //   padding: EdgeInsets.all(5.0),
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.width * 0.3,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            //padding: EdgeInsetsDirectional.only(top: 0.0,bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    foodMenuModels[index].foodName,
                                    overflow: TextOverflow.ellipsis,
                                    style: MyStyle().mainTitle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'ราคา ${foodMenuModels[index].price} บาท',
                                  overflow: TextOverflow.ellipsis,
                                  style: MyStyle().mainH2Title,
                                ),
                              ),
                              // IconButton(
                              //     icon: Icon(
                              //       Icons.delete_sweep_outlined,
                              //       color: Colors.white,
                              //     ),
                              //     onPressed: null),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  foodMenuModels[index].foodDetail,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              IconSlideAction(
                caption: 'Archive',
                color: Colors.blue,
                icon: Icons.archive,
                onTap: () => Toast.show('Archive on $index', context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM),
              ),
              IconSlideAction(
                caption: 'Share',
                color: Colors.indigo,
                icon: Icons.share,
                onTap: () => Toast.show('Share on $index', context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM),
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Edit',
                color: Colors.black45,
                icon: Icons.edit,
                onTap: () => Toast.show('Edit on $index', context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM),
              ),
              IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    confirmDeleteDialog(foodMenuModels[index]);
                  }),
            ],
          ),
        ),
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.black54,
          );
        },
      );

  Widget showListFoodMenu2() => ListView.builder(
        padding: EdgeInsetsDirectional.only(top: 0.0, bottom: 20.0),
        itemCount: foodMenuModels.length,
        itemBuilder: (context, index) => Container(
          child: Slidable(
            key: Key(foodMenuModels[index].foodName),
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Container(
              decoration: index % 2 == 0
                  ? new BoxDecoration(color: Colors.lightBlueAccent)
                  : new BoxDecoration(color: Colors.lightBlue),
              child: Container(
                padding: EdgeInsetsDirectional.only(top: 0.0, bottom: 0.0),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.width * 0.3,
                      child: Container(
                        child: Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: CachedNetworkImage(
                            imageUrl:
                                '${MyConstant().domain}${foodMenuModels[index].imagePath}',
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    MyStyle().showProgress(),
                            // CircularProgressIndicator(
                            //     ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 5,
                          margin: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                    Container(
                      //  padding: EdgeInsetsDirectional.only(start: 5.0, end: 5.0),
                      //   padding: EdgeInsets.all(5.0),
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width * 0.3,
                      child: SingleChildScrollView(
                        padding:
                            EdgeInsets.only(right: 5.0, top: 15.0, bottom: 5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              //padding: EdgeInsetsDirectional.only(top: 0.0,bottom: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      foodMenuModels[index].foodName,
                                      overflow: TextOverflow.ellipsis,
                                      style: MyStyle().mainTitle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    'ราคา ${foodMenuModels[index].price} บาท',
                                    overflow: TextOverflow.ellipsis,
                                    style: MyStyle().mainH2Title,
                                  ),
                                ),
                                // IconButton(
                                //     icon: Icon(
                                //       Icons.delete_sweep_outlined,
                                //       color: Colors.white,size: 20,
                                //     ),
                                //     onPressed: null),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    foodMenuModels[index].foodDetail,
                                    //overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14.0,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                                // IconButton(
                                //     icon: Icon(
                                //       Icons.delete_sweep_outlined,
                                //       color: Colors.white,size: 20,
                                //     ),
                                //     onPressed: null),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    '7.0 km(27 min) | 50B',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 10.0,
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //   actions: <Widget>[
            //   IconSlideAction(
            //     caption: 'Archive',
            //     color: Colors.blue,
            //     icon: Icons.archive,
            //     onTap: () => Toast.show('Archive on $index', context,
            //         duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM),
            //   ),
            //   IconSlideAction(
            //     caption: 'Share',
            //     color: Colors.indigo,
            //     icon: Icons.share,
            //     onTap: () => Toast.show('Share on $index', context,
            //         duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM),
            //   ),
            // ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'แก้ไข',
                color: Colors.black45,
                icon: Icons.edit,
                onTap: () {
                  MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) => EditFoodMenu(
                      foodModel: foodMenuModels[index],
                    ),
                  );
                  Navigator.push(context, route).then(
                    (value) => readFoodMenu(),
                  );
                },
              ),
              IconSlideAction(
                  caption: 'ลบ',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    confirmDeleteDialog(foodMenuModels[index]);
                  }),
            ],
          ),
        ),
      );

  Future<Null> confirmDeleteDialog(
    FoodMenuModel foodMenuModel,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [Text('Delete Confirm')]),
          content: Text('คุณต้องการลบเมนู ${foodMenuModel.foodName}'),
          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              // ignore: deprecated_member_use
              FlatButton(
                child: Text("ตกลง"),
                onPressed: () async {
                  //  Navigator.pop(context);
                  //  deleteDialog(context);
                  String url =
                      '${MyConstant().domain}/Sulaiman_food/delete_foodmenu.php?isAdd=true&Food_id=${foodMenuModel.foodId}';
                  Response response =
                      // ignore: missing_return
                      await Dio().get(url).then((value) {
                    foodMenuModels.clear();

                    // ignore: unused_element
                    readFoodMenu();
                    if (value.toString() == 'true') {
                      Navigator.pop(context);
                    } else {}
                  });
                  print('response == $response');
                },
                // ignore: deprecated_member_use
              ),
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  // readFoodMenu();
                },
                child: Text('ยกเลิก'),
              ),
            ]
                // ignore: deprecated_member_use
                )
            // ignore: deprecated_member_use
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
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
          title: Row(children: [Text('Delete Confirm')]),
          content: Text('ลบเรียบร้อย'),
          actions: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
              child: Text("ตกลง"),
              onPressed: () {
                print('ลบเรียบร้อย');
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

  Widget showListFoodMenu3() => ListView.separated(
        padding: EdgeInsetsDirectional.only(top: 20.0, bottom: 20.0),
        itemCount: foodMenuModels.length,
        itemBuilder: (context, index) => Column(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsetsDirectional.only(
                    start: 10.0,
                    end: 10.0,
                  ),
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.width * 0.6,
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: CachedNetworkImage(
                      imageUrl:
                          '${MyConstant().domain}${foodMenuModels[index].imagePath}',
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
                    margin: EdgeInsets.all(10),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsetsDirectional.only(start: 10.0, end: 5.0),
              //   padding: EdgeInsets.all(5.0),
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.width * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    //padding: EdgeInsetsDirectional.only(top: 0.0,bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.star_outline_rounded),
                        Expanded(
                          child: Text(
                            foodMenuModels[index].foodName,
                            overflow: TextOverflow.ellipsis,
                            style: MyStyle().mainTitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.attach_money_outlined),
                      Expanded(
                        child: Text(
                          'ราคา ${foodMenuModels[index].price} บาท',
                          overflow: TextOverflow.ellipsis,
                          style: MyStyle().mainH2Title,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.details),
                      Expanded(
                        child: Text(
                          foodMenuModels[index].foodDetail,
                          overflow: TextOverflow.ellipsis,
                          style: MyStyle().mainH2Title,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.black54,
          );
        },
      );
}
