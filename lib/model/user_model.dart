class UserModel {
  String? fullName;
  String? phoneNumber;
  String? mail;

  UserModel({this.fullName, this.phoneNumber, this.mail});

  UserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
    mail = json['mail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['phoneNumber'] = this.phoneNumber;
    data['mail'] = this.mail;
    return data;
  }
}
