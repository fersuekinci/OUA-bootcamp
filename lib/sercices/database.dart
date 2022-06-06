import 'package:cloud_firestore/cloud_firestore.dart';
import '../helperfun/sharedpref_helper.dart';

class DatabaseMethods {
  Future addUserInfoToDB(
      String userId, Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getUserByUserName(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .snapshots();
  }

  Future addMessage(
      String chatRoomId, String messageId, Map<String, dynamic> messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSend(String chatRoomId, Map<String, Object?> lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  createChatRoom(String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    String? myUsername = await SharedPreferenceHelper().getUserName();
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .orderBy("lastMessageSendTs", descending: true)
        .where("users", arrayContains: myUsername)
        .snapshots();
  }

  Future<QuerySnapshot> getUserInfo(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
  }

  Future<QuerySnapshot> getBusinessList() async {
    return await FirebaseFirestore.instance
        .collection("AllBusiness")
        .where("category")
        .get();
  }

  Future addBusiness(
      String isletmeTuru, String isletmeId, Map<String, dynamic> isletmeMap) async {
    return FirebaseFirestore.instance
        .collection("AllBusiness")
        .doc(isletmeTuru)
        .collection("BusinessList")
        .doc(isletmeId)
        .set(isletmeMap);
  }

  Future addAppointment(
      String isletmeUID, String randevuSaati, Map<String, dynamic> appointmentInfoMap) async {
    return FirebaseFirestore.instance
        .collection("Appointment")
        .doc(isletmeUID)
        .collection("randevular")
        .doc(randevuSaati)
        .set(appointmentInfoMap);
  }

  Future<Stream<QuerySnapshot>> getAppointment(isletmeUID) async {
    return FirebaseFirestore.instance
        .collection("Appointment")
        .doc(isletmeUID)
        .collection("randevular")
        .orderBy("timeStamp", descending: true)
        .snapshots();
  }

  Future<QuerySnapshot> getAllUsersList() async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email")
        .get();
  }




}