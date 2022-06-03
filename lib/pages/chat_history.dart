import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oua_bootcamp/pages/signin.dart';

import '../helperfun/sharedpref_helper.dart';
import '../sercices/auth.dart';
import '../sercices/database.dart';
import 'chat_screen.dart';


class ChatHistory extends StatefulWidget {
  @override
  _ChatHistoryState createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  bool isSearching = false;
  String? myName, myProfilePic, myUserName, myEmail;
  Stream<QuerySnapshot>? chatRoomsStream, usersStream;

  TextEditingController searchUsernameEditingController =
  TextEditingController();

  getMyInfoFromSharedPreference() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  onSearchBtnClick() async {
    isSearching = true;
    setState(() {});
    usersStream = await DatabaseMethods()
        .getUserByUserName(searchUsernameEditingController.text);

    setState(() {});
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
              return ChatRoomListTile(ds["lastMessage"], ds.id, myUserName!);
            })
            : const Center(child: const CircularProgressIndicator());
      },
    );
  }

  Widget searchListUserTile({required String profileUrl, name, username, email}) {
    return GestureDetector(
      onTap: () {
        var chatRoomId = getChatRoomIdByUsernames(myUserName!, username);
        Map<String, dynamic> chatRoomInfoMap = {
          "users": [myUserName, username]
        };
        DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(username, name)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                profileUrl,
                height: 40,
                width: 40,
              ),
            ),
            const SizedBox(width: 12),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(name), Text(email)])
          ],
        ),
      ),
    );
  }

  Widget searchUsersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: usersStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          itemCount: snapshot.data?.docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data?.docs[index] as DocumentSnapshot<Object?>;
            return searchListUserTile(
                profileUrl: ds["imgUrl"],
                name: ds["name"],
                email: ds["email"],
                username: ds["username"]);
          },
        )
            : const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  getChatRooms() async {
    chatRoomsStream = await DatabaseMethods().getChatRooms();
    setState(() {});
  }

  onScreenLoaded() async {
    await getMyInfoFromSharedPreference();
    getChatRooms();
  }

  @override
  void initState() {
    onScreenLoaded();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messenger Clone"),
        actions: [
          InkWell(
            onTap: () {
              AuthMethods().signOut().then((s) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              });
            },
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                isSearching
                    ? GestureDetector(
                  onTap: () {
                    isSearching = false;
                    searchUsernameEditingController.text = "";
                    setState(() {});
                  },
                  child: const Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: const Icon(Icons.arrow_back)),
                )
                    : Container(),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                              controller: searchUsernameEditingController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none, hintText: "username"),
                            )),
                        GestureDetector(
                            onTap: () {
                              if (searchUsernameEditingController.text != "") {
                                onSearchBtnClick();
                              }
                            },
                            child: const Icon(Icons.search))
                      ],
                    ),
                  ),
                ),
              ],
            ),
            isSearching ? searchUsersList() : chatRoomsList()
          ],
        ),
      ),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myUsername;
  ChatRoomListTile(this.lastMessage, this.chatRoomId, this.myUsername);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "", name = "", username = "";

  getThisUserInfo() async {
    username =
        widget.chatRoomId.replaceAll(widget.myUsername, "").replaceAll("_", "");
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo(username);
    print(
        "something bla bla ${querySnapshot.docs[0].id} ${querySnapshot.docs[0]["name"]}  ${querySnapshot.docs[0]["imgUrl"]}");
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(username, name)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                profilePicUrl,
                height: 40,
                width: 40,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 3),
                Text(widget.lastMessage)
              ],
            )
          ],
        ),
      ),
    );
  }
}
