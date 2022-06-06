class BusinessModal {
  String? name;
  String? content;
  String? address;
  String? phone;
  String? subtitle;
  dynamic? key;
  String? email;
  double? latitude;
  double? longitude;

  BusinessModal(
      {this.name,
      this.content,
      this.address,
      this.phone,
      this.subtitle,
      this.email,
      this.latitude,
      this.longitude});

  BusinessModal.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    content = json['content'];
    address = json['address'];
    phone = json['phone'];
    subtitle = json['subtitle'];
    email = json['email'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  set docId(String docId) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['content'] = content;
    data['address'] = address;
    data['phone'] = phone;
    data['subtitle'] = subtitle;
    data['email'] = email;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
