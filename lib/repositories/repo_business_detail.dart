import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessDetailRepository extends ChangeNotifier{
  String companyName = "";
  String address = "";
  String content = "";
  String phone = "";
  String subtitle = "";

  void notifyAll(){
    notifyListeners();
  }
}

final businessDetailPageProvider = ChangeNotifierProvider((ref){
  return BusinessDetailRepository();
});