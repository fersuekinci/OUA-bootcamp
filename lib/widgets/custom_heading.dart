import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CustomHeading extends StatelessWidget {
  CustomHeading({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.color,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final Color color;
  bool isGuest = true;

  @override
  Widget build(BuildContext context) {

    if(FirebaseAuth.instance.currentUser != null){
      isGuest = false;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isGuest
          ? "Misafir"
          : "Hoşgeldin\n${FirebaseAuth.instance.currentUser!.displayName.toString()}" ,
          style: TextStyle(
            color: color,
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10.0),
        Text(
          isGuest
          ? "" : FirebaseAuth.instance.currentUser!.email.toString(),
          style: TextStyle(
            color: color,
            fontSize: 15.0,
          ),
        ),
      ],
    );
  }
}
