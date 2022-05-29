class UserModel {
  String? fullName;
  String? phoneNumber;
  String? mail;
  bool? isBusiness;

  UserModel({this.fullName, this.phoneNumber, this.mail, this.isBusiness});

  UserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
    mail = json['mail'];
    isBusiness =
        json['isBusiness'] == null ? false : json['isBusiness'] as bool;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['phoneNumber'] = this.phoneNumber;
    data['mail'] = this.mail;
    data['isBusiness'] = this.isBusiness;
    return data;
  }
}
