import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oua_bootcamp/pages/register_page.dart';
import 'package:oua_bootcamp/sercices/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helperfun/sharedpref_helper.dart';
import '../pages/home_page.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  getCurrentUser() async {
    return await _auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication?.idToken,
        accessToken: googleSignInAuthentication?.accessToken);

    UserCredential result = await _auth.signInWithCredential(credential);

    User userDetails = result.user!;

    Map<String, dynamic>? kayitOl = await Navigator.of(context).push<Map<String, dynamic>>(MaterialPageRoute(builder: (context) {
      return const RegisterPage();
    },));
    print("Kayıt ol sayfasından gelen map = ${kayitOl.toString()}");


    SharedPreferenceHelper().saveUserEmail(userDetails.email);
    SharedPreferenceHelper().saveUserId(userDetails.uid);
    SharedPreferenceHelper()
        .saveUserName(userDetails.email!.replaceAll("@gmail.com", ""));
    SharedPreferenceHelper().saveDisplayName(userDetails.displayName);
    SharedPreferenceHelper().saveUserProfileUrl(userDetails.photoURL);

    Map<String, dynamic> userInfoMap = {
      "email": userDetails.email,
      "username": userDetails.email?.replaceAll("@gmail.com", ""),
      "name": userDetails.displayName,
      "imgUrl": userDetails.photoURL
    };

    if(kayitOl != null){

      userInfoMap.addAll(kayitOl);
      //kayıt olan işletme olarak kayıt olduysa
      if(kayitOl["isBusiness"]){
        // Veritabanında AllBusiness ekleyelim
        DatabaseMethods().addBusiness(kayitOl["category"], userDetails.uid, userInfoMap);
        print("İşletme olarak kayıt edildi");

      }else{
        // Bişe yapmaya gerek yok. Zaten altta "users" içerisine kayıt ediyor.
        print("Bireysel kullanıcı olarak kayıt edildi.");
      }
    }



    DatabaseMethods()
        .addUserInfoToDB(userDetails.uid, userInfoMap)
        .then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  Future signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}

