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
import 'package:sulaimanfood/utility/normal_dialog.dart';

class ListMenuShop extends StatefulWidget {
  @override
  _ListMenuShopState createState() => _ListMenuShopState();
}

class _ListMenuShopState extends State<ListMenuShop> {
  UserModel userModel;
  bool status = true;
  bool loadStatus = true;
  bool deleteStatus = false;
  // ignore: deprecated_member_use
  List<FoodMenuModel> foodMenuModels = List();

  @override
  void initState() {
    super.initState();
    readFoodMenu();
  }

  void _onDelete() {
    Timer(Duration(seconds: 20), () {
      if (deleteStatus == true) {
        setState(() {
          deleteStatus = false;
          deleteFailDialog(context);
        });
      }
    });
  }

  void _onLoading() {
    Timer(
      Duration(seconds: 20),
      () {
        if (loadStatus == true) {
          setState(() {
            loadStatus = false;
            normalDialog(context, 'การเชื่อมต่อล้มเหลว');
          });
        } else {}
      },
    );
  }

  Future<Null> readFoodMenu() async {
    _onLoading();
    if (foodMenuModels.length != 0) {
      foodMenuModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userid = preferences.getString('User_id');
   // print('User id ==> $userid');

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
            deleteStatus = false;
            status = false;
          });
        }
      } else {
        setState(() {
          status = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.lightBlueAccent,
      child: Stack(
        children: [
          loadStatus
              ? MyStyle().progress(context)
              : status
                  ? noDATA()
                  : showContent(),
          addMenuButton()
        ],
      ),
    );
  }

  Widget showContent() {
    return null;
    // deleteStatus ? progress2(context) : showListFoodMenu2();
  }

  Center noDATA() {
    return Center(
      child: MyStyle().showtext_2('ยังไม่มีรายการอาหาร'),
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
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlertDialog(
              title: Column(
                children: [
                  Row(
                    children: [
                      Text('ไม่พบร้านค้า'),
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
                  ? new BoxDecoration(color: Colors.white10)
                  : new BoxDecoration(color: Colors.grey.shade300),
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
                      width: MediaQuery.of(context).size.width * 0.488,
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
                                        color: Colors.black45,
                                        fontSize: 14.0,
                                        fontFamily: 'FC-Minimal-Regular',
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: Icon(
                          Icons.delete_sweep_outlined,
                          color: Colors.black45,
                          size: 30,
                        ),
                        // ignore: unnecessary_statements
                        onPressed: () {},
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
                      foodID: foodMenuModels[index].foodId,
                      foodNAME: foodMenuModels[index].foodName,
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

  Future<Null> confirmDeleteDialog(FoodMenuModel foodMenuModel) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Row(
                children: [
                  Text('Delete Confirm'),
                ],
              ),
              Divider(
                color: Colors.black54,
              ),
            ],
          ),
          content: Text('คุณต้องการลบเมนู ${foodMenuModel.foodName}'),
          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              // ignore: deprecated_member_use
              FlatButton(
                child: Text("ลบ"),
                onPressed: () async {
                  Navigator.pop(context);
                  //  deleteDialog(context);
                  detelefood(foodMenuModel.foodId);
                  setState(() {
                    deleteStatus = true;
                  });
                },
                // ignore: deprecated_member_use
              ),
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('ยกเลิก'),
              ),
            ]
                // ignore: deprecated_member_use
                )
            // ignore: deprecated_member_use
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        );
      },
    );
  }

  Future<Null> deleteFailDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Row(children: [Text('Delete Menu')]),
              Divider(
                color: Colors.black54,
              ),
            ],
          ),
          content: Text('ลบไม่สำเร็จ ลองใหม่อีกครั้ง'),
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
            borderRadius: BorderRadius.circular(20.0),
          ),
        );
      },
    );
  }

  Future<Null> detelefood(String foodId) async {
    deleteStatus = true;
    _onDelete();
    String url =
        '${MyConstant().domain}/Sulaiman_food/delete_foodmenu.php?isAdd=true&Food_id=${foodId.toString()}';
    Response response =
        // ignore: missing_return
        await Dio().get(url).then((value) {
      foodMenuModels.clear();

      // ignore: unused_element
      readFoodMenu();
      if (value.toString() == 'true') {
      } else {
        _onDelete();
      }
    });
    print('response == $response');
  }

  Widget progress(BuildContext context) {
    return Container(
        child: new Stack(
      children: <Widget>[
        showListFoodMenu2(),
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

  Widget progress2(BuildContext context) {
    return Container(
        child: new Stack(
      children: <Widget>[
      //  showListFoodMenu2(),
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
                      'กำลังลบ...',
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
