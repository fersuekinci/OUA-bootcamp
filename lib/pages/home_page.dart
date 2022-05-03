import 'package:flutter/material.dart';
import 'package:oua_bootcamp/widgets/bootomNavigation.dart';
import 'package:oua_bootcamp/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String _appbarTitle = 'Kategoriler';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        _appbarTitle,
      )),
      extendBody: true,
      //Yan menü - drawer eklentisi (Widget klasöüründe)
      drawer: const DrawerWidget(),
      body: const Center(child: Text('Kategoriler Sayfası')),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
