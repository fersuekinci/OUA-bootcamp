import 'package:oua_bootcamp/constants.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: appbarColor,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.white.withOpacity(.90),
      elevation: 20,
      selectedFontSize: 14,
      unselectedFontSize: 14,
      onTap: (value) {},
      items: const [
        BottomNavigationBarItem(
          label: 'Ana Sayfa',
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: 'Profilim',
          icon: Icon(Icons.people),
        ),
        BottomNavigationBarItem(
          label: 'Randevularım',
          icon: Icon(Icons.calendar_month),
        ),
      ],
    );
  }
}
