import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:oua_bootcamp/constants.dart';

import 'package:oua_bootcamp/pages/businesses_page.dart';
import 'package:oua_bootcamp/pages/category_page.dart';
import 'package:oua_bootcamp/pages/menu_page.dart';
import 'package:oua_bootcamp/model/menu_item.dart';
import 'package:oua_bootcamp/pages/splashh.dart';
import 'package:oua_bootcamp/pages/user_history_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'signup_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();



}

class _HomePageState extends State<HomePage> {
  MenuItemK currentItem = MenuItems.category;

  loadUsername() async {
    await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      style: DrawerStyle.style1,
      borderRadius: 40,
      angle: -10,
      slideWidth: MediaQuery.of(context).size.width * 0.7,
      showShadow: true,
      menuBackgroundColor: kThirdColor,
      menuScreen: Builder(builder: (context) {
        return MenuPage(
          currentItem: currentItem,
          onSelectedItem: (item) {
            setState(() => currentItem = item);
            ZoomDrawer.of(context)!.close();
          },
        );
      }),
      mainScreen: getScreen(),
    );
  }

//Menüde tıklanan başlığa göre sayfalara yönlendirme yapılması
  Widget getScreen() {
    switch (currentItem) {
      case MenuItems.category:
        return Splash();

      case MenuItems.businesses:
        return Businesses();
      case MenuItems.register:
        return const SignUp();

      case MenuItems.userHistory:
        return UserHistoryPage();
      default:
        return CategoryPage();
    }
  }

}
