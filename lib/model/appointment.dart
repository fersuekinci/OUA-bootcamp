import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  String? businessName;
  String? category;
  String? userName;
  String? userMail;
  bool? done;
  String? businessAddress;
  String? interval;
  int? timeStamp;
  String? time;
  String? date;
  String? docId;

  AppointmentModel({
    this.businessName,
    this.category,
    this.userName,
    this.userMail,
    this.done,
    this.businessAddress,
    this.interval,
    this.timeStamp,
    this.time,
    this.date,
    this.docId,
  });

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    businessName = json['businessName'];
    category = json['category'];
    userName = json['userName'];
    userMail = json['userMail'];
    done = json['done'];
    businessAddress = json['businessAddress'];
    interval = json['interval'];
    timeStamp = json['timeStamp'];
    time = json['time'];
    date = json['date'];
    docId = json['docId'];
  }

  set reference(DocumentReference<Map<String, dynamic>> reference) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['businessName'] = this.businessName;
    data['category'] = this.category;
    data['userName'] = this.userName;
    data['userMail'] = this.userMail;
    data['done'] = this.done;
    data['businessAddress'] = this.businessAddress;
    data['interval'] = this.interval;
    data['timeStamp'] = this.timeStamp;
    data['time'] = this.time;
    data['date'] = this.date;
    data['docId'] = this.docId;

    return data;
  }
}
