class OrderModel {
  String orderId;
  String orderDatetime;
  String shopId;
  String nameShop;
  String distance;
  String transport;
  String foodId;
  String foodName;
  String price;
  String amount;
  String sum;
  String riderId;
  String status;
  String userId;
  String name;

  OrderModel(
      {this.orderId,
      this.orderDatetime,
      this.shopId,
      this.nameShop,
      this.distance,
      this.transport,
      this.foodId,
      this.foodName,
      this.price,
      this.amount,
      this.sum,
      this.riderId,
      this.status,
      this.userId,
      this.name});

  OrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json['Order_id'];
    orderDatetime = json['Order_datetime'];
    shopId = json['Shop_id'];
    nameShop = json['Name_shop'];
    distance = json['Distance'];
    transport = json['Transport'];
    foodId = json['Food_id'];
    foodName = json['Food_Name'];
    price = json['Price'];
    amount = json['Amount'];
    sum = json['Sum'];
    riderId = json['Rider_id'];
    status = json['Status'];
    userId = json['User_id'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Order_id'] = this.orderId;
    data['Order_datetime'] = this.orderDatetime;
    data['Shop_id'] = this.shopId;
    data['Name_shop'] = this.nameShop;
    data['Distance'] = this.distance;
    data['Transport'] = this.transport;
    data['Food_id'] = this.foodId;
    data['Food_Name'] = this.foodName;
    data['Price'] = this.price;
    data['Amount'] = this.amount;
    data['Sum'] = this.sum;
    data['Rider_id'] = this.riderId;
    data['Status'] = this.status;
    data['User_id'] = this.userId;
    data['Name'] = this.name;
    return data;
  }
}
