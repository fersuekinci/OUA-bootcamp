import 'package:flutter/material.dart';
import '../sercices/auth.dart';
import 'home_page.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OUA-BOOTCAMP-48"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                AuthMethods().signInWithGoogle(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color(0xffDB4437),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Text(
                  "Google ile Giriş Yap",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => const HomePage()));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color(0xffDB4437),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Text(
                  "Misafir Olarak Devam Et",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}