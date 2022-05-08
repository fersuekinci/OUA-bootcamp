import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:oua_bootcamp/model/mesaj_model.dart';


// mesajlar kaydırıldığında mesajın gönderildiği tarih eklenecek
// mesajların üstünde işletme/kullanıcı görselleri eklenecek
// flood durumunda görseller sadece bir defa olacak

// mesaj gönderenin tespiti için riverpod kullanıldığı zaman isim oradan çekilecek

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String anlikMesaj = "";
  List<Mesaj> mesajlar = [
    Mesaj("Merhaba, size nasıl yardımcı olabilirim?", "İşletme 1", DateTime.now()),
  ];
  final _controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("İşletme Adı")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: mesajlar.length,
              itemBuilder: (context, index) {
                return MesajGorunumu(mesajlar[mesajlar.length - index - 1]);
              },
            ),
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
                              setState(() {
                              anlikMesaj = value;
                              });
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
                            setState(() {
                              mesajlar.add(Mesaj(anlikMesaj, "Yasin", DateTime.now()));
                              _controller.clear();
                              anlikMesaj = "";
                            });
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

class MesajGorunumu extends StatelessWidget {
  final Mesaj mesaj;
  MesajGorunumu(
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
                mesaj.yazi,
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

