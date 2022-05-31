import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatPageRepository extends ChangeNotifier{
  String anlikMesaj = "";
  String userName = "";
  String companyName = "";


  void notifyAnlikMesaj(String mesaj){
    anlikMesaj = mesaj;
    notifyListeners();
  }

  void notifyUserName(String uName){
    userName = uName;
    notifyListeners();
  }

  void notifyCompanyName(String cName){
    companyName = cName;
    notifyListeners();
  }


}



final chatPageProvider = ChangeNotifierProvider((ref){
  return ChatPageRepository();
});