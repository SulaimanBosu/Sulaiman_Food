import 'package:flutter/material.dart';
import 'package:sulaimanfood/utility/my_style.dart';

Future<void> normalDialog(BuildContext context, String message) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          children: [
            Row(children: [
              Icon(
                Icons.notifications_active,
                color: Colors.black54,
              ),
              MyStyle().mySizebox(),
              MyStyle().showTitle_2('การแจ้งเตือน'),
            ]),
            Divider(
              color: Colors.black54,
            ),
          ],
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: MyStyle().text2,
            ),
          ],
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
          borderRadius: BorderRadius.circular(20.0),
        ),
      );
    },
  );
}
