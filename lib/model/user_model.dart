class UserModel {
  String userId;
  String chooseType;
  String name;
  String user;
  String password;
  String token;

  UserModel(
      {this.userId,
      this.chooseType,
      this.name,
      this.user,
      this.password,
      this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['User_id'];
    chooseType = json['ChooseType'];
    name = json['Name'];
    user = json['User'];
    password = json['Password'];
    token = json['Token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['User_id'] = this.userId;
    data['ChooseType'] = this.chooseType;
    data['Name'] = this.name;
    data['User'] = this.user;
    data['Password'] = this.password;
    data['Token'] = this.token;
    return data;
  }
}
