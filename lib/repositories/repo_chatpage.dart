import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helperfun/sharedpref_helper.dart';
import '../model/mesaj_model.dart';

class ChatPageRepository extends ChangeNotifier{
  

  String anlikMesaj = "";
  String userName = "";
  String companyName = "";


  String? myName;
  String? myProfilePic;
  String? myUserName;
  String? myEmail;

  Stream<QuerySnapshot>? chatsStream;

  getMyInfoFromSharedPreference() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    notifyListeners();
  }


  List<Mesaj> mesajlar = [
    Mesaj("Merhaba, size nasıl yardımcı olabilirim?", "İşletme 1", DateTime.now()),
  ];





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

  Stream<QuerySnapshot> getChatroom(String chatRoomId) {
    chatsStream = FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();

    print("${chatsStream!.length.toString()} şşşşşşşşşşşşşşşşşş");
    notifyListeners();
    return chatsStream!;
  }
}



final chatPageProvider = ChangeNotifierProvider((ref){
  return ChatPageRepository();
});