class FoodMenuModel {
  String foodId;
  String foodName;
  String foodDetail;
  String price;
  String imagePath;
  String shopId;
  String userId;

  FoodMenuModel(
      {this.foodId,
      this.foodName,
      this.foodDetail,
      this.price,
      this.imagePath,
      this.shopId,
      this.userId});

  FoodMenuModel.fromJson(Map<String, dynamic> json) {
    foodId = json['Food_id'];
    foodName = json['Food_Name'];
    foodDetail = json['Food_Detail'];
    price = json['Price'];
    imagePath = json['Image_Path'];
    shopId = json['Shop_id'];
    userId = json['User_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Food_id'] = this.foodId;
    data['Food_Name'] = this.foodName;
    data['Food_Detail'] = this.foodDetail;
    data['Price'] = this.price;
    data['Image_Path'] = this.imagePath;
    data['Shop_id'] = this.shopId;
    data['User_id'] = this.userId;
    return data;
  }
}
