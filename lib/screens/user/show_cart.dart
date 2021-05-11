import 'package:flutter/material.dart';
import 'package:sulaimanfood/model/cart_model.dart';
import 'package:sulaimanfood/utility/my_style.dart';
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
        title: Text('ตะกร้าของฉัน'),
      ),
      body: status
          ? Center(
              child: Text('ไม่มีรายการอาหารในตะกร้า'),
            )
          : buildContent(),
    );
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            MyStyle().mySizebox(),
            buildNameShop(),
            MyStyle().mySizebox(),
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
          ],
        ),
      ),
    );
  }

  Widget buildClearCart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RaisedButton.icon(
          onPressed: () {
            confirmDeleteDialog();
          },
          icon: Icon(Icons.delete),
          label: Text('Clear ตะกร้า'),color: Colors.blue,
        ),
      ],
    );
  }

  Widget buildNameShop() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home_sharp),
          MyStyle().mySizebox(),
          Text(
            'ร้าน ${cartModels[0].nameShop}',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget buildTitle() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade400),
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
                MyStyle().showTitleCart('  ลบ'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListFood() => ListView.separated(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: cartModels.length,
        itemBuilder: (context, index) => Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(cartModels[index].foodName),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(cartModels[index].price),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(cartModels[index].amount),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(cartModels[index].sum),
                    ],
                  ),
                ),
                Expanded(
                    child: IconButton(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.delete_forever),
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
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.black54,
          );
        },
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
                Icon(Icons.location_on_outlined),
                MyStyle().mySizebox(),
                Text(
                  'ระยะทาง ',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${cartModels[0].distance}  กม.'),
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
                Text('ค่าส่ง  '),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${cartModels[0].transport}  บาท'),
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
                // MyStyle().mySizebox(),
                Text('ราคารวม  '),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${total.toString()}  บาท'),
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
            Text('Delete Confirm')
          ]),
          content: Text('คุณต้องการลบเมนูทั้งหมดหรือไม่'),
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
          title: Row(children: [
            Icon(Icons.delete_forever_rounded),
            Text('Delete Success')
          ]),
          content: Text('ลบรายอาหารทั้งหมดเรียบร้อย'),
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

  // Widget builddistance() => Row(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         Row(
  //           children: [
  //             Icon(Icons.location_on_outlined),
  //             MyStyle().mySizebox(),
  //             Text('ระยะทาง    ${cartModels[0].distance} กม.'),
  //           ],
  //         ),
  //       ],
  //     );

  // Widget buildtransport() => Row(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         Row(
  //           children: [
  //             Icon(Icons.location_on_outlined),
  //             MyStyle().mySizebox(),
  //             Text('ค่าส่ง    ${cartModels[0].transport} บาท'),
  //           ],
  //         ),
  //       ],
  //     );

  // Widget buildTotal() => Row(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         Row(
  //           children: [
  //             Text('ราคารวม    ${total.toString()} บาท'),
  //           ],
  //         ),
  //       ],
  //     );
}
