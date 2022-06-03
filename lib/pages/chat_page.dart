import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oua_bootcamp/model/mesaj_model.dart';
import 'package:oua_bootcamp/repositories/repo_chatpage.dart';

import '../model/business_model.dart';
import '../repositories/repo_business_detail.dart';


// mesajlar kaydırıldığında mesajın gönderildiği tarih eklenecek
// mesajların üstünde işletme/kullanıcı görselleri eklenecek
// flood durumunda görseller sadece bir defa olacak

// mesaj gönderenin tespiti için riverpod kullanıldığı zaman isim oradan çekilecek

class ChatPage extends ConsumerWidget {
  final String chatRoomId;

  ChatPage({Key? key, required this.chatRoomId}) : super(key: key);

  final _controller = TextEditingController();
  final business = List<BusinessModal>;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessRepoProvider = ref.watch(businessDetailPageProvider);
    final chatRepoProvider = ref.watch(chatPageProvider);
    final anlikMesaj = chatRepoProvider.anlikMesaj;
    final Stream<QuerySnapshot> chatStream = chatRepoProvider.getChatroom("Yasin_myscod3r@gmail.com");

    return Scaffold(
      appBar: AppBar(title: Text(businessRepoProvider.companyName)),
      body: Column(
        children: [
          Expanded(
            child: chatMessages(chatStream: chatStream),
          ),
          DecoratedBox(
            decoration: BoxDecoration(border: Border.all()),
            child: Row(
              children: [
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border.all(), borderRadius: const BorderRadius.all(Radius.circular(25.0))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            controller: _controller,
                            onChanged: (value) {
                              chatRepoProvider.notifyAnlikMesaj(value);
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    )),
                anlikMesaj.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: ElevatedButton(
                          style:  ElevatedButton.styleFrom(
                            elevation: 16,
                            onPrimary: Colors.white,
                            primary: Colors.red,
                          ),
                          onPressed: () {
                              chatRepoProvider.mesajlar.add(Mesaj(anlikMesaj, "Yasin", DateTime.now()));

                              _controller.clear();
                              chatRepoProvider.getChatroom("Yasin_myscod3r@gmail.com");

                              },
                          child: const Text("Gönder"),
                        ),
                      )
                    : SizedBox(child: Row(
                      children: const [
                        Icon(Icons.emoji_emotions_outlined, size: 32.0, color: Colors.red),
                        SizedBox(width: 10.0),
                        Icon(Icons.add_box_outlined, size: 32.0, color: Colors.red),
                        SizedBox(width: 10.0),
                      ],
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class chatMessages extends StatelessWidget {
  const chatMessages({
    Key? key,
    required this.chatStream,
  }) : super(key: key);

  final Stream<QuerySnapshot<Object?>> chatStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chatStream,
      builder: (context, AsyncSnapshot<QuerySnapshot>  snapshot) {
        if (snapshot.hasError) {
          print("1");
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("2");
          return const Text("Loading");
        }
        print("3");
        return ListView(
          children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
            Map<String, dynamic> data =
            document.data()! as Map<String, dynamic>;
            return MesajGorunumu(Mesaj(data[0].toString(), "Yasin", DateTime.now()));
          })
              .toList()
              .cast(),
        );
      }
    );
  }
}



class MesajGorunumu extends StatelessWidget {
  final Mesaj mesaj;
  const MesajGorunumu(
      this.mesaj, {
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mesaj.gonderen == "Yasin" ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(
              color: mesaj.gonderen == "Yasin" ?  Colors.grey.withOpacity(0.3) : Colors.red.withOpacity(0.3) ,
              spreadRadius: 5,
              blurRadius: 8,
              offset: const Offset(2, 5),
            ),
          ],
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: mesaj.gonderen == "Yasin" ? Colors.white : Colors.red,
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text(
                mesaj.yazi!,
                style: TextStyle(
                  color: mesaj.gonderen == "Yasin" ? Colors.red : Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                )),
          ),
        ),
      ),
    );
  }
}


class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({required this.message, required this.sendByMe});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ]
                  : [
                const Color(0x1AFFFFFF),
                const Color(0x1AFFFFFF)
              ],
            )
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}