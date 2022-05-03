import 'package:flutter/material.dart';
import 'package:oua_bootcamp/constants.dart';
import 'package:oua_bootcamp/pages/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debug logosunu kaldırmak için kullanıldı.
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      theme: ThemeData.light().copyWith(
        //appBarTheme : proje kapsamında appbar teması özellikleri
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: appbarColor,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),

      home: const HomePage(),
    );
  }
}
