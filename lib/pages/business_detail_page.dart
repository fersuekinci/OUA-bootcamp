import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oua_bootcamp/cloud_firestore/user_ref.dart';
import 'package:oua_bootcamp/widgets/menu_widget.dart';
import '../helperfun/sharedpref_helper.dart';
import '../repositories/repo_business_detail.dart';
import '../repositories/repo_chatpage.dart';
import 'chat_page.dart';
import 'chat_screen.dart';

class BusinessDetail extends ConsumerWidget {
  BusinessDetail({Key? key}) : super(key: key);

  //İşletmenin yüklediği resimler yer alacak.
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  @override
  Widget build(BuildContext context, ref) {
    final businessRepoProvider = ref.watch(businessDetailPageProvider);
    final chatRepoProvider = ref.watch(chatPageProvider);

    final String email = businessRepoProvider.getEmailForChatPage();
    final String companyName = businessRepoProvider.getCompanyName();

    return Scaffold(
        appBar: AppBar(
          title: Text(businessRepoProvider.companyName),
          //Önceki erkana geçiş için
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back),
          //   onPressed: () => Navigator.of(context).pop(),
          // ),

          leading: const MenuWidget(),
        ),
        body: Scaffold(
          body: SingleChildScrollView(
              child: Column(children: [
            //Resimlerin slyat olarak görüntülenmesi
            CarouselSlider(
              items: imageSlider(),
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
                viewportFraction: 1,
              ),
            ),
            // Card(
            //   child: FutureBuilder(
            //     future: getUserProfiles(
            //         ref, FirebaseAuth.instance.currentUser?.email.toString()),
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting)
            //         return Center(child: CircularProgressIndicator());
            //       else {
            //         //var userModel = snapshot.data as UserModel;
            //         return Container(
            //           child: Text("Bu ekranın değişkenlerinin yerinin ayarlanması gerekiyor"),
            //           //child: Text('${userModel.mail}'),
            //         );
            //       }
            //     },
            //   ),
            // ),
            //İşletme bilgilerinin yazılması
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      businessRepoProvider.subtitle,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      businessRepoProvider.phone,
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      businessRepoProvider.address,
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      businessRepoProvider.content,
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ButtonBar(
                      alignment: MainAxisAlignment.center,
                      buttonPadding: const EdgeInsets.all(15),
                      children: [
                        FloatingActionButton(
                          heroTag: "startChat",
                          onPressed: () {
                            if (0 == 0) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChatScreen(email, companyName)));
                            } else {
                              Center(
                                  child: Text(
                                      "Giriş Yap uyarısı dialog popup hazırlanacak"));
                            }
                          },
                          elevation: 20,
                          child: const Icon(Icons.message),
                        ),
                        FloatingActionButton(
                          heroTag: "navigation",
                          onPressed: () {},
                          elevation: 20,
                          child: const Icon(Icons.navigation),
                        ),
                        FloatingActionButton(
                          heroTag: "calendar",
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: const Text('Randevu Oluştur'),
                                      content: const Text(
                                          'Randevu oluşturabilmek için uygulamaya giriş yapmış olmanız gerekmektedir.'),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextButton(
                                              onPressed: () {},
                                              child: const Text('Giriş Yap'),
                                            ),
                                            TextButton(
                                              onPressed: () {},
                                              child: const Text('Kayıt Ol'),
                                            ),
                                          ],
                                        )
                                      ],
                                    ));
                          },
                          elevation: 20,
                          child: const Icon(Icons.calendar_month),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ])),
          //bottomNavigationBar: const BottomNavigation(),
        ));
  }

  imageSlider() {
    return imgList
        .map((item) => Container(
              margin: const EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            'No. ${imgList.indexOf(item)} image',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ))
        .toList();
  }
}

String getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
