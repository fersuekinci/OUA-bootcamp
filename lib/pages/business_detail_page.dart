import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oua_bootcamp/pages/map_page.dart';
import 'package:oua_bootcamp/widgets/alert.dart';
import '../constants.dart';
import '../repositories/repo_business_detail.dart';
import 'comment.dart';

class BusinessDetail extends ConsumerWidget {
  BusinessDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final businessRepoProvider = ref.watch(businessDetailPageProvider);

    return DefaultTabController(
      length: 4,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
                elevation: 30,
                automaticallyImplyLeading: false,
                toolbarHeight: 100,
                title: getAppBar(businessRepoProvider)),
            body: TabBarView(
              children: [
                getBusinessData(businessRepoProvider),
                getServices(businessRepoProvider),
                Reviews(),
                getContanct(businessRepoProvider, context, ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getAppBar(businessRepoProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 13.0),
          child: Text(businessRepoProvider.companyName),
        ),
        const SizedBox(
          height: 8,
        ),
        const TabBar(
          indicatorSize: TabBarIndicatorSize.label,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white38,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
                child: Text(
              "Bilgiler",
            )),
            Tab(
                child: Text(
              "Hizmetler",
            )),
            Tab(
                child: Text(
              "Yorumlar",
            )),
            Tab(
                child: Text(
              "İletişim",
            ))
          ],
        ),
      ],
    );
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

  getBusinessData(BusinessDetailRepository businessRepoProvider) {
    return Container(
      color: kPrimaryColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Card(
            elevation: 30,
            color: kThirdColor,
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      //title: Text(businessRepoProvider.subtitle),
                      subtitle: Text(
                        businessRepoProvider.subtitle,
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  getContanct(BusinessDetailRepository businessRepoProvider, context, ref) {
    return Container(
      color: kPrimaryColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Card(
                elevation: 30,
                color: kThirdColor,
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.phone),
                          title: Text(businessRepoProvider.phone,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6))),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Card(
                elevation: 30,
                color: kThirdColor,
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.navigation),
                          title: Text(businessRepoProvider.address,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6))),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Card(
                elevation: 30,
                color: kThirdColor,
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.mail),
                          title: Text(businessRepoProvider.email,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6))),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Card(
                elevation: 30,
                color: kThirdColor,
                child: ToggleButtons(
                  color: Colors.black.withOpacity(0.60),
                  isSelected: [false, false, false],
                  onPressed: (index) {},
                  children: [
                    IconButton(
                      icon: const Icon(Icons.navigation),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GoogleMaps()));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: () {
                        FirebaseAuth.instance.currentUser?.email == null
                            ? getAlert(
                                    context,
                                    'Seçilen işletmeden randevu alabilmek için giriş yapmanız ya da kayıt olmanız gerekmektedir. ',
                                    'Giriş Yap')
                                .show()
                            : '';
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.message),
                      onPressed: () {
                        FirebaseAuth.instance.currentUser?.email == null
                            ? getAlert(
                                    context,
                                    'Seçilen işletmeyle mesajlaşabilmek için giriş yapmanız ya da kayıt olmanız gerekmektedir. ',
                                    'Giriş Yap')
                                .show()
                            : '';
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getServices(BusinessDetailRepository businessRepoProvider) {
    return Container(
      color: kPrimaryColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Card(
            elevation: 30,
            color: kThirdColor,
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CarouselSlider(
                      items: imageSlider(),
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                        viewportFraction: 1,
                      ),
                    ),
                    Container(
                      height: 300,
                      child: ListView(
                        children: [
                          for (int count
                              in List.generate(9, (index) => index + 1))
                            ListTile(
                              title: Text('List item $count'),
                              isThreeLine: true,
                              subtitle: Text('Secondary text\nTertiary text'),
                              leading: Icon(Icons.label),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}
