import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:oua_bootcamp/state/state_management.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CategoryPage extends ConsumerWidget {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String _appbarTitle = 'Kategoriler';
    bool isList = false;

    return Scaffold(
        key: scaffoldState,
        appBar: AppBar(
            //ZoomDraer eklentisi
            leading: const MenuWidget(),
            actions: [
              FutureBuilder(
                future: checkLoginState(context, false, scaffoldState),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var userState = snapshot.data as LOGIN_STATE;
                    if (userState == LOGIN_STATE.LOGGED) {
                      return Container();
                    } else {
                      IconButton(
                        icon: const Icon(Icons.login),
                        onPressed: () => processLogin,
                      );
                    }
                  }
                  return Container();
                },
              )
            ],
            title: const Text(
              _appbarTitle,
            )),
        extendBody: true,
        //Yan menü - drawer eklentisi (Widget klasöüründe)
        //drawer: const DrawerWidget(),
        body: Categoryview(
            direction: Axis.vertical,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: kWhiteColor,
            column: isList ? 1 : 2,
            ratio: isList ? 2.6 : 1.3,
            items: categoryList.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                  future: getCategory(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      var categories = snapshot.data as List<CategoryModal>;
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
                            titleSize: 20.0,
                            amount: "",
                            amountSize: 0.0,
                          ),
                        );
                      }
                    }
                  });
            }));
  }

  processLogin(BuildContext context) async {
    var user = FirebaseAuth.instance.currentUser;
    // if (user == null) {
    //   FirebaseAuthUi.instance()
    //       .launchAuth([AuthProvider.email()]).then((firebaseUser) async {
    //     context.read().state = FirebaseAuth.instance.currentUser;
    //     // ScaffoldMessenger.of(scaffoldState.currentContext!).showSnackBar(SnackBar(
    //     //     content: Text(
    //     //         'Giriş Başarılı ${FirebaseAuth.instance.currentUser!.email}')));
    //     await checkLoginState(context, true, scaffoldState);
    //   }).catchError((e) {
    //     if (e is PlatformException) if (e.code ==
    //         FirebaseAuthUi.kUserCancelledError)
    //       ScaffoldMessenger.of(scaffoldState.currentContext!)
    //           .showSnackBar(SnackBar(content: Text('${e.message}')));
    //     else
    //       ScaffoldMessenger.of(scaffoldState.currentContext!)
    //           .showSnackBar(SnackBar(content: Text('Error')));
    //   });
    // } else {}
  }

  Future<LOGIN_STATE> checkLoginState(BuildContext context, bool fromLogin,
      GlobalKey<ScaffoldState> scaffoldState) async {
    await Future.delayed(Duration(seconds: fromLogin == true ? 0 : 3))
        .then((value) => {
              FirebaseAuth.instance.currentUser
                  ?.getIdToken()
                  .then((token) async {
                print(token);
                context.read().state = token;
                // Navigator.pushNamedAndRemoveUntil(
                //     context, '/businessDetail', (route) => false);

//Kullanıcı var mı
                CollectionReference userRef =
                    FirebaseFirestore.instance.collection('User');
                DocumentSnapshot snapshotUser = await userRef
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .get();

                context.read().state = true;
                if (snapshotUser.exists) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/businessDetail', (route) => false);
                } else {
                  var fullNameController = TextEditingController();
                  var mailController = TextEditingController();
                  var phoneNumberController = TextEditingController();
                  Alert(
                    context: context,
                    title: 'Profili Güncelle',
                    content: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                              icon: Icon(Icons.account_circle),
                              labelText: 'Tam Adınız'),
                          controller: fullNameController,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              icon: Icon(Icons.account_circle),
                              labelText: 'Mail Adresiniz'),
                          controller: mailController,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              icon: Icon(Icons.account_circle),
                              labelText: 'Telefon Numaranız'),
                          controller: phoneNumberController,
                        ),
                      ],
                    ),
                    buttons: [
                      DialogButton(
                          child: Text('İptal'),
                          onPressed: () => Navigator.pop(context)),
                      DialogButton(
                          child: Text('Kaydet'),
                          onPressed: () {
                            //Kullanıcı Güncelleme
                            userRef
                                .doc(FirebaseAuth.instance.currentUser!.email)
                                .set({
                              'fullName': fullNameController.text,
                              'mail': mailController.text,
                              'phoneNumber': phoneNumberController.text
                            }).then((value) async {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(
                                      scaffoldState.currentContext!)
                                  .showSnackBar(SnackBar(
                                      content: Text('Profil Güncellendi')));
                              await Future.delayed(Duration(seconds: 1));
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/businessDetail', (route) => false);
                            }).catchError((e) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(
                                      scaffoldState.currentContext!)
                                  .showSnackBar(SnackBar(content: Text('$e')));
                            });
                          })
                    ],
                  );
                }
              })
            });

    return FirebaseAuth.instance.currentUser != null
        ? LOGIN_STATE.LOGGED
        : LOGIN_STATE.NOT_LOGIN;
  }
}
