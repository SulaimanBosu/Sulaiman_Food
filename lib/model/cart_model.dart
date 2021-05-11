class CartModel {
  int orderId;
  String shopId;
  String nameShop;
  String foodId;
  String foodName;
  String price;
  String amount;
  String sum;
  String distance;
  String transport;

  CartModel(
      {this.orderId,
      this.shopId,
      this.nameShop,
      this.foodId,
      this.foodName,
      this.price,
      this.amount,
      this.sum,
      this.distance,
      this.transport});

  CartModel.fromJson(Map<String, dynamic> json) {
    orderId = json['Order_id'];
    shopId = json['Shop_id'];
    nameShop = json['Name_shop'];
    foodId = json['Food_id'];
    foodName = json['Food_Name'];
    price = json['Price'];
    amount = json['Amount'];
    sum = json['Sum'];
    distance = json['Distance'];
    transport = json['Transport'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Order_id'] = this.orderId;
    data['Shop_id'] = this.shopId;
    data['Name_shop'] = this.nameShop;
    data['Food_id'] = this.foodId;
    data['Food_Name'] = this.foodName;
    data['Price'] = this.price;
    data['Amount'] = this.amount;
    data['Sum'] = this.sum;
    data['Distance'] = this.distance;
    data['Transport'] = this.transport;
    return data;
  }
}
