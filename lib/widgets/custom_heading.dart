import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  // Giriş yapılmamışsa deaktif olacak yerleri alttaki koddan kontrol edebiliriz.
  final bool isAnonymous = FirebaseAuth.instance.currentUser!.isAnonymous;

  @override
  Widget build(BuildContext context) {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isAnonymous
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
          isAnonymous
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
