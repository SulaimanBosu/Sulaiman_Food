class FoodMenuModel {
  String foodId;
  String foodName;
  String foodDetail;
  String price;
  String imagePath;
  String shopId;
  String shopName;
  String userId;
  String latitude;
  String longitude;
  String urlImage;

  FoodMenuModel(
      {this.foodId,
      this.foodName,
      this.foodDetail,
      this.price,
      this.imagePath,
      this.shopId,
      this.shopName,
      this.userId,
      this.latitude,
      this.longitude,
      this.urlImage,
      });

  FoodMenuModel.fromJson(Map<String, dynamic> json) {
    foodId = json['Food_id'];
    foodName = json['Food_Name'];
    foodDetail = json['Food_Detail'];
    price = json['Price'];
    imagePath = json['Image_Path'];
    shopId = json['Shop_id'];
    shopName = json['Name_shop'];
    userId = json['User_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    urlImage = json['Url_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Food_id'] = this.foodId;
    data['Food_Name'] = this.foodName;
    data['Food_Detail'] = this.foodDetail;
    data['Price'] = this.price;
    data['Image_Path'] = this.imagePath;
    data['Shop_id'] = this.shopId;
    data['Name_shop'] = this.shopName;
    data['User_id'] = this.userId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['Url_image'] = this.urlImage;
    return data;
  }
}
