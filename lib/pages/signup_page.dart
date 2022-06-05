import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oua_bootcamp/constants.dart';
import 'package:oua_bootcamp/pages/category_page.dart';
import '../widgets/menu_widget.dart';

// Galeriden fotoğraf seçme işlemleri yapılacak

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              toolbarHeight: 97,
              automaticallyImplyLeading: false,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Padding(
                    padding: const EdgeInsets.only(top: 13.0),
                    child: Text('Kayıt Ol'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 3,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white38,
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(
                          child: Text(
                        "İşletme Kaydı",
                      )),
                      Tab(
                          child: Text(
                        "Kullanıcı Kaydı",
                      )),
                    ],
                  ),
                ],
              )),
          body: TabBarView(
            children: [
              getBusiness(context),
              getUser(context),
            ],
          )),
    );
  }

  getUser(BuildContext context) {
    var userFullNameController = TextEditingController();
    var userPhoneNumberController = TextEditingController();
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: kPrimaryColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: SizedBox(
                  height: 150,
                  child: Image(image: AssetImage("assets/images/useradd.png")),
                ),
              ),
              const SizedBox(height: 50),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Attributes(
                        title: 'Adınız ve Soyadınız',
                        controller: userFullNameController,
                        icon: Icons.person,
                        isPassword: false),
                    const SizedBox(height: 15),
                    Attributes(
                        title: "Telefon Numaranız",
                        controller: userPhoneNumberController,
                        icon: Icons.phone_android,
                        isPassword: false),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: kFourthColor,
                          minimumSize:
                              Size(MediaQuery.of(context).size.width - 75, 40)),
                      child: const Text("Kayıt Ol"),
                      onPressed: () {
                        CollectionReference userRef =
                            FirebaseFirestore.instance.collection('User');
                        userRef
                            .doc(FirebaseAuth.instance.currentUser!.email)
                            .set({
                          'fullName': userFullNameController.text,
                          'mail': FirebaseAuth.instance.currentUser?.email
                              .toString(),
                          'phoneNumber': userPhoneNumberController.text
                        }).then((value) async {
                          await Future.delayed(Duration(seconds: 1));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoryPage()));
                        }).catchError((e) {});
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
}

getBusiness(context) {
  var businessNameController = TextEditingController();
  var businessSubTitleController = TextEditingController();
  var businessPhoneNumberController = TextEditingController();
  var businessAddressController = TextEditingController();
  var businessDetailsController = TextEditingController();
  return SafeArea(
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: kPrimaryColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: SizedBox(
                height: 150,
                child: Image(image: AssetImage("assets/images/business.png")),
              ),
            ),
            const SizedBox(height: 50),
            SingleChildScrollView(
              child: Column(
                children: [
                  Attributes(
                      title: "İşletme Adı",
                      icon: Icons.factory,
                      controller: businessNameController,
                      isPassword: false),
                  const SizedBox(height: 15),
                  Attributes(
                      title: "Alt Başlık",
                      icon: Icons.subtitles,
                      controller: businessSubTitleController,
                      isPassword: false),
                  const SizedBox(height: 15),
                  Attributes(
                      title: "Telefon",
                      icon: Icons.phone_android,
                      controller: businessPhoneNumberController,
                      isPassword: false),
                  const SizedBox(height: 15),
                  Attributes(
                      title: "Adres",
                      icon: Icons.navigation,
                      controller: businessAddressController,
                      isPassword: false),
                  const SizedBox(height: 15),
                  Attributes(
                      title: "İşletme Detayları",
                      icon: Icons.details,
                      controller: businessDetailsController,
                      isPassword: false),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: kFourthColor,
                        minimumSize:
                            Size(MediaQuery.of(context).size.width - 75, 40)),
                    child: const Text("Kayıt Ol"),
                    onPressed: () {
                      CollectionReference userRef =
                          FirebaseFirestore.instance.collection('User');
                      userRef
                          .doc(FirebaseAuth.instance.currentUser!.email)
                          .set({
                        'fullName': businessNameController.text,
                        'mail':
                            FirebaseAuth.instance.currentUser?.email.toString(),
                        'isBusiness': true,
                        'phoneNumber': businessPhoneNumberController.text
                      }).then((value) async {
                        await Future.delayed(Duration(seconds: 1));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CategoryPage()));
                      }).catchError((e) {});
                      ;
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

class Attributes extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;

  const Attributes(
      {Key? key,
      required this.title,
      required this.icon,
      required this.isPassword,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0),
      alignment: Alignment.centerRight,
      color: kThirdColor,
      height: 50.0,
      width: MediaQuery.of(context).size.width - 75,
      child: TextField(
        obscureText: isPassword,
        controller: controller,
        style: const TextStyle(
          color: Colors.black,
          fontFamily: 'OpenSans',
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(top: 14.0),
          prefixIcon: Icon(
            icon,
            color: Colors.white,
          ),
          hintText: title,
        ),
      ),
    );
  }
}
