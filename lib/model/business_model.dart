import 'package:cloud_firestore/cloud_firestore.dart';

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

  set reference(DocumentReference<Map<String, dynamic>> reference) {}

  set docId(String docId) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['content'] = this.content;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['subtitle'] = this.subtitle;
    return data;
  }
}
