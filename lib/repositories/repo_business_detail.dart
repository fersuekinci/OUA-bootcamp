import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessDetailRepository extends ChangeNotifier{
  String companyName = "";
  String address = "";
  String content = "";
  String phone = "";
  String subtitle = "";
  String email = "";

  String getEmailForChatPage(){
    String emailForChat = email.replaceAll("@gmail.com", "");
    print("mail = $email");
    return emailForChat;
  }

  String getCompanyName(){
    print("company name = $companyName");
    return companyName;
  }


  void notifyAll(){
    notifyListeners();
  }
}

final businessDetailPageProvider = ChangeNotifierProvider((ref){
  return BusinessDetailRepository();
});