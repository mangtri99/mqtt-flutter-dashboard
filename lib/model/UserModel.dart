class UserModel {
  int id;
  String name;
  int noPasien;

  UserModel({this.id, this.name, this.noPasien});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    noPasien = json['no_pasien'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['no_pasien'] = this.noPasien;
    return data;
  }
}
