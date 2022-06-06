import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessDetailRepository extends ChangeNotifier {
  String companyName = "";
  String address = "";
  String content = "";
  String phone = "";
  String subtitle = "";
  String email = "";
  late double latitude;
  late double longitude;

  String getEmailForChatPage() {
    String emailForChat = email.replaceAll("@gmail.com", "");

    return emailForChat;
  }

  String getCompanyName() {
    return companyName;
  }

  void notifyAll() {
    notifyListeners();
  }
}

final businessDetailPageProvider = ChangeNotifierProvider((ref) {
  return BusinessDetailRepository();
});
