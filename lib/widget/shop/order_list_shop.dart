import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:toast/toast.dart';

class OrderListShop extends StatefulWidget {
  @override
  _OrderListShopState createState() => _OrderListShopState();
}

class _OrderListShopState extends State<OrderListShop> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [showListFoodMenu6()]);
  }

  Widget showListFoodMenu6() => ListView.builder(
        // padding: EdgeInsetsDirectional.only(top: 20.0, bottom: 20.0),
        itemCount: 10,
        itemBuilder: (context, index) => Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Container(
            color: Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.indigoAccent,
                child: Text('sulaiman'),
                foregroundColor: Colors.white,
              ),
              title: Text('Tile n°[Bosu'),
              subtitle: Text('SlidableDrawerDelegate'),
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
              caption: 'More',
              color: Colors.black45,
              icon: Icons.more_horiz,
              onTap: () => Toast.show('More on $index', context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM),
            ),
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => Toast.show('Delete on $index', context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM),
            ),
          ],
        ),
      );
}
