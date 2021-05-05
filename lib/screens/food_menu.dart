import 'package:flutter/material.dart';
import 'package:sulaimanfood/model/foodMenu_Model.dart';

class FoodMenu extends StatefulWidget {
  final FoodMenuModel foodMenuModel; 
  FoodMenu({Key kay,this.foodMenuModel}) : super(key: kay);
  @override
  _FoodMenuState createState() => _FoodMenuState();
}

class _FoodMenuState extends State<FoodMenu> {

  FoodMenuModel foodMenuModel; 
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foodMenuModel = widget.foodMenuModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(foodMenuModel.shopName),),
    );
  }
}