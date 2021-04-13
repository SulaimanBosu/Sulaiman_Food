import 'package:flutter/material.dart';
import 'package:sulaimanfood/screens/add_info_shop.dart';
import 'package:sulaimanfood/utility/my_style.dart';

class InfomationShop extends StatefulWidget {
  @override
  _InfomationShopState createState() => _InfomationShopState();
}

class _InfomationShopState extends State<InfomationShop> {
  void routeAddInfomation() {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (value) => AddInfoShop(),
    );
    Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MyStyle().titleCenter(
            context, 'ยังไม่มีข้อมูลร้านค้า กรุณาเพิ่มข้อมูลร้านค้า'),
        addAndEditButton()
      ],
    );
  }

  Row addAndEditButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: 25.0, bottom: 25.0),
              child: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: (){
                  routeAddInfomation();
                }
              ),
            ),
          ],
        ),
      ],
    );
  }
}
