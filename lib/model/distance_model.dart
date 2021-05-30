class DistanceModel {

  String distance;
  String transport;

  DistanceModel(
      {
      this.distance,
      this.transport});

  DistanceModel.fromJson(Map<String, dynamic> json) {

    distance = json['Distance'];
    transport = json['Transport'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Distance'] = this.distance;
    data['Transport'] = this.transport;
    return data;
  }
}
