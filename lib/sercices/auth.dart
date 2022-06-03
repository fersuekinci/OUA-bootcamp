import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

    UserCredential result =
    await _auth.signInWithCredential(credential);

    User userDetails = result.user!;

    if (result != null) {
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

      DatabaseMethods()
          .addUserInfoToDB(userDetails.uid, userInfoMap)
          .then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      });
    }
  }

  Future signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await _auth.signOut();
    await _googleSignIn.signOut();

  }
}