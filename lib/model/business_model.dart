class BusinessModal {
  String? name;
  String? content;
  String? address;
  String? phone;
  String? subtitle;

  BusinessModal(
      {this.name, this.content, this.address, this.phone, this.subtitle});

  BusinessModal.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    content = json['content'];
    address = json['address'];
    phone = json['phone'];
    subtitle = json['subtitle'];
  }

  set docId(String docId) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['content'] = content;
    data['address'] = address;
    data['phone'] = phone;
    data['subtitle'] = subtitle;
    return data;
  }
}
