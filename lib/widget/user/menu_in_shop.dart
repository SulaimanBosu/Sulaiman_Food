import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sulaimanfood/model/foodMenu_Model.dart';
import 'package:sulaimanfood/model/infomationShop_model.dart';
import 'package:sulaimanfood/utility/myConstant.dart';
import 'package:sulaimanfood/utility/my_style.dart';

class MenuInShop extends StatefulWidget {
  final InfomationShopModel shopModel;
  MenuInShop({Key key, this.shopModel}) : super(key: key);
  @override
  _MenuInShopState createState() => _MenuInShopState();
}

class _MenuInShopState extends State<MenuInShop> {
  InfomationShopModel shopModels;
  String shopid;
  List<FoodMenuModel> foodModels = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shopModels = widget.shopModel;
    readFoodmenu();
  }

  Future<Null> readFoodmenu() async {
    shopid = shopModels.shopId;
    String url =
        '${MyConstant().domain}/Sulaiman_food/get_Menu_in_Shop_forUser.php?isAdd=true&Shop_id=$shopid';
    Response response = await Dio().get(url);
    //print('Response == $response');

    var result = json.decode(response.data);
    print('Result == $result');
    for (var map in result) {
      FoodMenuModel foodModel = FoodMenuModel.fromJson(map);
      setState(() {
        foodModels.add(foodModel);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent,
      child: foodModels.length == 0 ? MyStyle().showProgress() : showContent(),
    );
  }

  Widget showContent() {
    return foodModels.length != 0
        ? showListFoodMenu2()
        : Center(
            child: Text('ยังไม่มีรายการอาหาร'),
          );
  }

  Widget showListFoodMenu2() => ListView.builder(
        padding: EdgeInsetsDirectional.only(top: 0.0, bottom: 20.0),
        itemCount: foodModels.length,
        itemBuilder: (context, index) => Container(
          child: Slidable(
            key: Key(foodModels[index].foodName),
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
                                '${MyConstant().domain}${foodModels[index].imagePath}',
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
                                      foodModels[index].foodName,
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
                                    'ราคา ${foodModels[index].price} บาท',
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
                                    foodModels[index].foodDetail,
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
                  // MaterialPageRoute route = MaterialPageRoute(
                  //   builder: (context) => EditFoodMenu(
                  //     foodModel: foodMenuModels[index],
                  //   ),
                  // );
                  // Navigator.push(context, route).then(
                  //   (value) => readFoodMenu(),
                  // );
                },
              ),
              IconSlideAction(
                  caption: 'ลบ',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    // confirmDeleteDialog(foodMenuModels[index]);
                  }),
            ],
          ),
        ),
      );
}
