import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';
import 'package:oua_bootcamp/cloud_firestore/user_ref.dart';
import 'package:oua_bootcamp/model/user_model.dart';
import 'package:oua_bootcamp/widgets/bottom_clipper.dart';
import 'package:oua_bootcamp/widgets/custom_heading.dart';
import 'package:oua_bootcamp/widgets/custom_search.dart';
import 'package:flutter/material.dart';
import 'package:oua_bootcamp/cloud_firestore/all_business_ref.dart';
import 'package:oua_bootcamp/model/CategoryModal.dart';
import 'package:oua_bootcamp/utils/utils.dart';
import 'package:oua_bootcamp/widgets/menu_widget.dart';
import 'package:oua_bootcamp/constants.dart';
import 'package:oua_bootcamp/widgets/CategoryItems.dart';
import 'package:oua_bootcamp/widgets/CategoryView.dart';

// ignore: import_of_legacy_library_into_null_safe

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:oua_bootcamp/state/state_management.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CategoryPage extends ConsumerWidget {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    bool isList = false;

    return Scaffold(
        key: scaffoldState,
        appBar: AppBar(
            //ZoomDraer eklentisi
            leading: MenuWidget(),
            actions: [
              FutureBuilder(
                future: checkLoginState(context, ref, false, scaffoldState),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var userState = snapshot.data as LOGIN_STATE;
                    if (userState == LOGIN_STATE.LOGGED) {
                      return IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                      );
                    } else {
                      return IconButton(
                        icon: const Icon(Icons.door_back_door),
                        onPressed: () => processLogin(context, ref),
                      );
                    }
                  }
                },
              )
            ],
            title: const Text(
              "Burası Neresi?",
            )),
        extendBody: true,
        //Yan menü - drawer eklentisi (Widget klasöüründe)
        //drawer: const DrawerWidget(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  ClipPath(
                    clipper: BottomClipper(),
                    child: Container(
                      //width: size.width,
                      height: 300,
                      decoration: const BoxDecoration(color: kSecondColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: appPadding, right: appPadding),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: spacer + 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FutureBuilder(
                              future: getUserProfiles(
                                  ref,
                                  FirebaseAuth.instance.currentUser?.email
                                      .toString()),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting)
                                  return Center(
                                      child: CircularProgressIndicator());
                                else {
                                  var userModel = snapshot.data as UserModel;
                                  return CustomHeading(
                                    title: userModel.fullName.toString() == null
                                        ? 'Anonim'
                                        : userModel.fullName.toString(),
                                    subTitle: userModel.mail.toString() == null
                                        ? ''
                                        : userModel.mail.toString(),
                                    color: textWhite,
                                  );
                                }
                              },
                            ),
                            SizedBox(
                              height: spacer,
                              width: spacer,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset('assets/images/avatar.png'),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: spacer,
                        ),
                        const CustomSearchField(
                          hintField: "Aramak için tıklayınız...",
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(height: spacer - 30.0),
                        //CustomCategoryCard(),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: smallSpacer,
              ),
              Categoryview(
                  direction: Axis.vertical,
                  height: MediaQuery.of(context).size.height - 350,
                  width: MediaQuery.of(context).size.width,
                  color: kWhiteColor,
                  column: isList ? 1 : 2,
                  ratio: isList ? 2.6 : 1.3,
                  items: categoryList.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: getCategory(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            var categories =
                                snapshot.data as List<CategoryModal>;
                            if (categories == null || categories.length == 0)
                              return Center(
                                child: Text('Kategori bulunamadı'),
                              );
                            else {
                              return GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, '/businessList',
                                    arguments: ref
                                            .read(selectedCategory.state)
                                            .state
                                            .category =
                                        categories[index].category.toString()),
                                child: CategoryItems(
                                  height: 150.0,
                                  width: MediaQuery.of(context).size.width,
                                  paddingHorizontal: 0.0,
                                  paddingVertical: 0.0,
                                  align: Alignment.center,
                                  radius: kLessPadding,
                                  blendMode: BlendMode.difference,
                                  color: kDarkColor,
                                  image: categories[index].image!,
                                  title: categories[index].category!,
                                  titleSize: 18.0,
                                  amount: "",
                                  amountSize: 0.0,
                                ),
                              );
                            }
                          }
                        });
                  })
            ],
          ),
        ));
    ;
  }

  deneme() {
    return Container();
  }

  processLogin(BuildContext context, WidgetRef ref) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      FlutterAuthUi.startUi(
              items: [AuthUiProvider.email],
              tosAndPrivacyPolicy: const TosAndPrivacyPolicy(
                  tosUrl: 'https://google.com',
                  privacyPolicyUrl: 'https://google.com'),
              androidOption: const AndroidOption(
                  enableSmartLock: false, showLogo: true, overrideTheme: true))
          .then((value) async {
        ref.read(userLogged.state).state = FirebaseAuth.instance.currentUser;
        await checkLoginState(context, ref, true, scaffoldState);
      }).catchError((e) {
        ScaffoldMessenger.of(scaffoldState.currentContext!)
            .showSnackBar(SnackBar(content: Text('${e.toString()}')));
      });
    } else {}
  }

  Future<LOGIN_STATE> checkLoginState(BuildContext context, WidgetRef ref,
      bool fromLogin, GlobalKey<ScaffoldState> scaffoldState) async {
    if (!ref.read(forceReload.state).state) {
      await Future.delayed(Duration(seconds: fromLogin == true ? 0 : 3))
          .then((value) => {
                FirebaseAuth.instance.currentUser
                    ?.getIdToken()
                    .then((token) async {
                  ref.read(userToken.state).state = token;

//Kullanıcı var mı
                  CollectionReference userRef =
                      FirebaseFirestore.instance.collection('User');
                  DocumentSnapshot snapshotUser = await userRef
                      .doc(FirebaseAuth.instance.currentUser!.email)
                      .get();

                  ref.read(forceReload.state).state = true;
                  if (snapshotUser.exists) {
                  } else {
                    var fullNameController = TextEditingController();
                    var mailController = TextEditingController();
                    var phoneNumberController = TextEditingController();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Profili Kaydet'),
                            content: Column(
                              children: [
                                TextField(
                                  decoration: const InputDecoration(
                                      icon: Icon(Icons.account_circle),
                                      labelText: 'Tam Adınız'),
                                  controller: fullNameController,
                                ),
                                TextField(
                                  decoration: const InputDecoration(
                                      icon: Icon(Icons.account_circle),
                                      labelText: 'Mail Adresiniz'),
                                  controller: mailController,
                                ),
                                TextField(
                                  decoration: const InputDecoration(
                                      icon: Icon(Icons.account_circle),
                                      labelText: 'Telefon Numaranız'),
                                  controller: phoneNumberController,
                                ),
                              ],
                            ),
                            actions: [
                              DialogButton(
                                  child: Text('İptal'),
                                  onPressed: () => Navigator.pop(context)),
                              DialogButton(
                                  child: Text('Kaydet'),
                                  onPressed: () {
                                    //Kullanıcı Güncelleme
                                    userRef
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.email)
                                        .set({
                                      'fullName': fullNameController.text,
                                      'mail': mailController.text,
                                      'phoneNumber': phoneNumberController.text
                                    }).then((value) async {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                              scaffoldState.currentContext!)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text('Profil Güncellendi')));
                                      await Future.delayed(
                                          Duration(seconds: 1));
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          '/homePage', (route) => false);
                                    }).catchError((e) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                              scaffoldState.currentContext!)
                                          .showSnackBar(
                                              SnackBar(content: Text('$e')));
                                    });
                                  })
                            ],
                          );
                        });
                  }
                })
              });
    }
    return FirebaseAuth.instance.currentUser != null
        ? LOGIN_STATE.LOGGED
        : LOGIN_STATE.NOT_LOGIN;
  }
}
