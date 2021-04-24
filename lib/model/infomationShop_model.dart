class InfomationShopModel {
  String shopId;
  String nameShop;
  String addressShop;
  String phoneShop;
  String urlImage;
  String latitude;
  String longitude;
  String userId;

  InfomationShopModel(
      {this.shopId,
      this.nameShop,
      this.addressShop,
      this.phoneShop,
      this.urlImage,
      this.latitude,
      this.longitude,
      this.userId});

  InfomationShopModel.fromJson(Map<String, dynamic> json) {
    shopId = json['Shop_id'];
    nameShop = json['Name_shop'];
    addressShop = json['Address_shop'];
    phoneShop = json['Phone_shop'];
    urlImage = json['Url_image'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    userId = json['User_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Shop_id'] = this.shopId;
    data['Name_shop'] = this.nameShop;
    data['Address_shop'] = this.addressShop;
    data['Phone_shop'] = this.phoneShop;
    data['Url_image'] = this.urlImage;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['User_id'] = this.userId;
    return data;
  }
}
