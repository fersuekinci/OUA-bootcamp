import 'package:flutter/material.dart';
import 'package:oua_bootcamp/widgets/menu_widget.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final String _appbarTitle = 'Kategoriler';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //ZoomDraer eklentisi
          leading: const MenuWidget(),
          title: Text(
            _appbarTitle,
          )),
      extendBody: true,
      //Yan menü - drawer eklentisi (Widget klasöüründe)
      //drawer: const DrawerWidget(),
      body: const Center(child: Text('Kategoriler Sayfası')),

      //Alt menü
      //bottomNavigationBar: const BottomNavigation(),
    );
  }
}
