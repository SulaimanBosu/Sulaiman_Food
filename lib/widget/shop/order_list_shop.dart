import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sulaimanfood/model/order_model.dart';
import 'package:sulaimanfood/utility/myConstant.dart';
import 'package:sulaimanfood/utility/my_style.dart';
import 'package:sulaimanfood/utility/normal_dialog.dart';
import 'package:toast/toast.dart';

class OrderListShop extends StatefulWidget {
  @override
  _OrderListShopState createState() => _OrderListShopState();
}

class _OrderListShopState extends State<OrderListShop> {
  String shopid;
  List<OrderModel> orderModels = List();
  OrderModel orderModel;
  bool statusOrder = true;
  bool loadingStatus = true;
  List<List<String>> listMenufoods = List();
  List<List<String>> listPrices = List();
  List<List<String>> listAmounts = List();
  List<List<String>> listSums = List();
  List<int> totalints = List();
  List<int> statusInts = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findShopidAndreadOrder();
  }

  Future<Null> findShopidAndreadOrder() async {
    _onLoading();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    shopid = preferences.getString('Shop_id');
    print('Shop id ==== $shopid');
    if (shopid != null) {
      String url =
          '${MyConstant().domain}/Sulaiman_food/get_order_forShop.php?isAdd=true&Shop_id=$shopid';

      Response response = await Dio().get(url);
      print('Response == $response');

      if (response.toString() != 'null') {
        var resulr = json.decode(response.data);
        for (var map in resulr) {
          OrderModel model = OrderModel.fromJson(map);
          List<String> menuFoods = changeArrey(model.foodName);
          List<String> prices = changeArrey(model.price);
          List<String> amounts = changeArrey(model.amount);
          List<String> sums = changeArrey(model.sum);
          //  print('MenuFood ==>> $menuFoods');
          // int status = 0;
          // switch (model.status) {
          //   case 'Userorder':
          //     status = 0;
          //     break;
          //   case 'ShopCooking':
          //     status = 1;
          //     break;
          //   case 'RiderHandle':
          //     status = 2;
          //     break;
          //   case 'Finish':
          //     status = 3;
          //     break;
          //   default:
          // }
          int total = 0;
          for (var string in sums) {
            total = total + int.parse(string.trim());
          }
          print('Total = $total');

          setState(() {
            statusOrder = false;
            loadingStatus = false;
            orderModels.add(model);
            listMenufoods.add(menuFoods);
            listPrices.add(prices);
            listAmounts.add(amounts);
            listSums.add(sums);
            totalints.add(total);
            // statusInts.add(status);
          });
        }
      } else {
        setState(() {
          statusOrder = true;
          loadingStatus = false;
        });

        _onLoading();
      }
    } else {
      setState(() {
        statusOrder = true;
        loadingStatus = false;
      });
      _onLoading();
    }
  }

  void _onLoading() {
    Timer(
      Duration(seconds: 20),
      () {
        if (loadingStatus == true) {
          setState(() {
            loadingStatus = false;
            statusOrder = true;
            normalDialog(context, 'เชื่อมต่อล้มเหลว');
          });
        } else {}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.lightBlueAccent,
      child: Stack(
        children: [
          loadingStatus
              ? MyStyle().progress(context)
              : statusOrder
                  ? buildNullOrder()
                  : SingleChildScrollView(
                      child: buildContent(),
                    ),
        ],
      ),
    );
  }

  Center buildNullOrder() => Center(
        child: MyStyle().showtext_2('ไม่มีรายการอาหารที่ลูกค้าสั่ง'),
      );

  Widget buildContent() => ListView.builder(
        padding: EdgeInsets.all(16),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: orderModels.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Card(color: index%2 == 0 ? Colors.grey.shade200 : Colors.white38,
                    child: Column(
              children: [
                MyStyle().mySizebox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyStyle().showTitle_2('รายการสั่งซื้อ'),
                  ],
                ),
                MyStyle().mySizebox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MyStyle().showtext_2('ชื่อลูกค้า : ${orderModels[index].name}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MyStyle().showtext_2(
                        'วันเวลา : ${orderModels[index].orderDatetime}'),
                  ],
                ),
                buildHead(),
                buildListViewMenuFood(index),
                MyStyle().mySizebox(),
                buildTotal(index),
                MyStyle().mySizebox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        // ignore: deprecated_member_use
                        child: RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      onPressed: () {},
                      icon: Icon(Icons.cancel_outlined,color: Colors.red,),
                      label: MyStyle().showtext_2('ปฏิเสธ'),
                    )),
                    MyStyle().mySizebox(),
                    Expanded(
                        // ignore: deprecated_member_use
                        child: RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      onPressed: () {},
                      icon: Icon(Icons.fastfood_outlined,color: Colors.green,),
                      label: MyStyle().showtext_2('รับออร์เดอร์'),
                    )),
                  ],
                ),
                //MyStyle().mySizebox(),
                // Divider(
                //   color: Colors.black54,
                // ),
              ],
            ),
          ),
        ),
      );

  Container buildHead() {
    return Container(
      padding: EdgeInsets.only(left: 8),
      decoration: BoxDecoration(color: Colors.deepOrangeAccent),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: MyStyle().showtext_2('รายการอาหาร'),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyStyle().showtext_2('ราคา'),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyStyle().showtext_2('จำนวน'),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyStyle().showtext_2('รวม '),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListView buildListViewMenuFood(int index) => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: listMenufoods[index].length,
        itemBuilder: (context, index2) => Row(
          children: [
            Expanded(
              flex: 3,
              child: MyStyle().showtext_1(listMenufoods[index][index2]),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyStyle().showtext_1(listPrices[index][index2]),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [MyStyle().showtext_1(listAmounts[index][index2])],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyStyle().showtext_1(
                    '${listSums[index][index2]} บ.',
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget buildTotal(int index) => Row(
        children: [
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyStyle().showtext_2('รวมราคาอาหาร '),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyStyle().showtext_2(
                  '${totalints[index].toString()} บ.',
                )
              ],
            ),
          ),
        ],
      );

  List<String> changeArrey(String string) {
    List<String> list = List();
    String myString = string.substring(1, string.length - 1);
    print('MyString == $myString');
    list = myString.split(',');
    int index = 0;
    for (var string in list) {
      list[index] = string.trim();
      index++;
    }
    return list;
  }

  // Widget showListFoodMenu6() => ListView.builder(
  //       // padding: EdgeInsetsDirectional.only(top: 20.0, bottom: 20.0),
  //       itemCount: 10,
  //       itemBuilder: (context, index) => Slidable(
  //         actionPane: SlidableDrawerActionPane(),
  //         actionExtentRatio: 0.25,
  //         child: Container(
  //           color: Colors.white,
  //           child: ListTile(
  //             leading: CircleAvatar(
  //               backgroundColor: Colors.indigoAccent,
  //               child: Text('sulaiman'),
  //               foregroundColor: Colors.white,
  //             ),
  //             title: Text('Tile n°[Bosu'),
  //             subtitle: Text('SlidableDrawerDelegate'),
  //           ),
  //         ),
  //         actions: <Widget>[
  //           IconSlideAction(
  //             caption: 'Archive',
  //             color: Colors.blue,
  //             icon: Icons.archive,
  //             onTap: () => Toast.show('Archive on $index', context,
  //                 duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM),
  //           ),
  //           IconSlideAction(
  //             caption: 'Share',
  //             color: Colors.indigo,
  //             icon: Icons.share,
  //             onTap: () => Toast.show('Share on $index', context,
  //                 duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM),
  //           ),
  //         ],
  //         secondaryActions: <Widget>[
  //           IconSlideAction(
  //             caption: 'More',
  //             color: Colors.black45,
  //             icon: Icons.more_horiz,
  //             onTap: () => Toast.show('More on $index', context,
  //                 duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM),
  //           ),
  //           IconSlideAction(
  //             caption: 'Delete',
  //             color: Colors.red,
  //             icon: Icons.delete,
  //             onTap: () => Toast.show('Delete on $index', context,
  //                 duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM),
  //           ),
  //         ],
  //       ),
  //     );
}
