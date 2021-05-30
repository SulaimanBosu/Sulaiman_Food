import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:sulaimanfood/model/order_model.dart';
import 'package:sulaimanfood/utility/myConstant.dart';
import 'package:sulaimanfood/utility/my_style.dart';

class ShowListOrderAll extends StatefulWidget {
  @override
  _ShowListOrderAllState createState() => _ShowListOrderAllState();
}

class _ShowListOrderAllState extends State<ShowListOrderAll> {
  String userid;
  bool statusOrder = true;
  List<OrderModel> orderModels = List();
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
    finduser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.lightBlueAccent,
      child: userid == null
          ? MyStyle().showProgress()
          : statusOrder
              ? buildNullOrder()
              : SingleChildScrollView(
                  child: buildContent(),
                ),
    );
  }

  Widget buildContent() => ListView.builder(
        padding: EdgeInsets.all(16),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: orderModels.length,
        itemBuilder: (context, index) => Column(
          children: [
            MyStyle().mySizebox(),
            buildNameShop(index),
            MyStyle().mySizebox(),
            buildDateTime(index),
            buildDistance(index),
            buildTranSport(index),
            buildHead(),
            buildListViewMenuFood(index),
            MyStyle().mySizebox(),
            buildTotal(index),
            MyStyle().mySizebox(),
            MyStyle().mySizebox(),
            buildStepIndicator(statusInts[index]),
            MyStyle().mySizebox(),
            Divider(
              color: Colors.black54,
            ),
          ],
        ),
      );

  Widget buildStepIndicator(int index) => Column(
        children: [
          StepsIndicator(
            lineLength: MediaQuery.of(context).size.width * 0.21,
            selectedStep: index,
            nbSteps: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Order'),
              Text('Cooking'),
              Text('Delivery'),
              Text('Finish'),
            ],
          )
        ],
      );

  Widget buildTotal(int index) => Row(
        children: [
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'รวมราคาอาหาร ',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black87,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${totalints[index].toString()} บาท',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black87,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  ListView buildListViewMenuFood(int index) => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: listMenufoods[index].length,
        itemBuilder: (context, index2) => Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                listMenufoods[index][index2],
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.black87,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    listPrices[index][index2],
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black87,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    listAmounts[index][index2],
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black87,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${listSums[index][index2]} บ.',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black87,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Container buildHead() {
    return Container(
      padding: EdgeInsets.only(left: 8),
      decoration: BoxDecoration(color: Colors.deepOrangeAccent),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: MyStyle().showTitleH2white('รายการอาหาร'),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyStyle().showTitleH2white('ราคา'),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyStyle().showTitleH2white('จำนวน'),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyStyle().showTitleH2white('รวม'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row buildTranSport(int index) {
    return Row(
      children: [
        Text(
          'ค่าส่ง ${orderModels[index].transport} บาท',
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black87,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Row buildDistance(int index) {
    return Row(
      children: [
        Text(
          'ระยะทาง ${orderModels[index].distance} กม.',
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black87,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Row buildDateTime(int index) {
    return Row(
      children: [
        Text(
          'วันที่สั่ง ${orderModels[index].orderDatetime}',
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black87,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Row buildNameShop(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          orderModels[index].nameShop,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black87,
            fontStyle: FontStyle.normal,
          ),
        ),
      ],
    );
  }

  Center buildNullOrder() => Center(
        child: Text('ไม่มีรายการอาหารที่สั่ง'),
      );

  Future<Null> finduser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userid = preferences.getString('User_id');
    print('User id == $userid');
    readOrder();
  }

  Future<Null> readOrder() async {
    if (userid != null) {
      String url =
          '${MyConstant().domain}/Sulaiman_food/get_orderforuser.php?isAdd=true&User_id=$userid';

      Response response = await Dio().get(url);
      // print('Response == $response');

      if (response.toString() != 'null') {
        var resulr = json.decode(response.data);
        for (var map in resulr) {
          OrderModel model = OrderModel.fromJson(map);
          List<String> menuFoods = changeArrey(model.foodName);
          List<String> prices = changeArrey(model.price);
          List<String> amounts = changeArrey(model.amount);
          List<String> sums = changeArrey(model.sum);
          //  print('MenuFood ==>> $menuFoods');
          int status = 0;
          switch (model.status) {
            case 'Userorder':
              status = 0;
              break;
            case 'ShopCooking':
              status = 1;
              break;
            case 'RiderHandle':
              status = 2;
              break;
            case 'Finish':
              status = 3;
              break;
            default:
          }
          int total = 0;
          for (var string in sums) {
            total = total + int.parse(string.trim());
          }
          print('Total = $total');

          setState(() {
            statusOrder = false;
            orderModels.add(model);
            listMenufoods.add(menuFoods);
            listPrices.add(prices);
            listAmounts.add(amounts);
            listSums.add(sums);
            totalints.add(total);
            statusInts.add(status);
          });
        }
      } else {}
    } else {}
  }

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
}
