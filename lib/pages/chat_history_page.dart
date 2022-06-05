import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helperfun/sharedpref_helper.dart';
import '../sercices/database.dart';
import 'chat_screen.dart';

class ChatHistoryPage extends StatefulWidget {
  const ChatHistoryPage({Key? key}) : super(key: key);

  @override
  State<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {

  String? myName, myProfilePic, myUserName, myEmail;
  Stream<QuerySnapshot>? chatRoomsStream;
  QuerySnapshot? usersStream;

  getMyInfoFromSharedPreference() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  getChatRooms() async {
    chatRoomsStream = await DatabaseMethods().getChatRooms();
    setState(() {});
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  Widget chatRoomsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRoomsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data?.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data?.docs[index] as DocumentSnapshot<Object?>;
              Timestamp tsdate = ds["lastMessageSendTs"];
              DateTime d = tsdate.toDate();
              String date = DateFormat('yyyy-MM-dd').format(d);
              String time = DateFormat('kk:mm').format(d);
              return ChatRoomListTile(ds["lastMessage"], ds.id, myUserName!, date, time);
            })
            : const Center(child: const CircularProgressIndicator());
      },
    );
  }



  @override
  void initState() {
    print("init çalıştı");
    getMyInfoFromSharedPreference();
    getChatRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mesaj Kutusu"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: chatRoomsList(),
      ),

    );
  }
}




class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myUsername, dtDate, dtTime;
  ChatRoomListTile(this.lastMessage, this.chatRoomId, this.myUsername, this.dtDate, this.dtTime);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "", name = "", username = "";

  getThisUserInfo() async {
    username =
        widget.chatRoomId.replaceAll(widget.myUsername, "").replaceAll("_", "");
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo(username);
    name = "${querySnapshot.docs[0]["name"]}";
    profilePicUrl = "${querySnapshot.docs[0]["imgUrl"]}";
    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(username, name)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                profilePicUrl,
                errorBuilder:(context, error, stackTrace) {
                  return const CircularProgressIndicator();
                },
                height: 40,
                width: 40,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 3),
                  Text(widget.lastMessage)
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(widget.dtDate),
                Text(widget.dtTime),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
