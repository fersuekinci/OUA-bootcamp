import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oua_bootcamp/pages/category_page.dart';
import 'package:oua_bootcamp/pages/signup_page.dart';
import 'package:oua_bootcamp/state/state_management.dart';
import 'package:oua_bootcamp/utils/utils.dart';

processLogin(BuildContext context, WidgetRef ref, scaffoldState) async {
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
          .showSnackBar(SnackBar(content: Text(e.toString())));
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
                  // ignore: use_build_context_synchronously
                  return Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => CategoryPage()));
                } else {
                  // ignore: use_build_context_synchronously
                  return Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const SignUp()));
                }
              })
            });
  }
  return FirebaseAuth.instance.currentUser != null
      ? LOGIN_STATE.LOGGED
      : LOGIN_STATE.NOT_LOGIN;
}
