import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

//ZoomDrawer menü eklentisi
class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => ZoomDrawer.of(context)?.toggle(),
        icon: const Icon(Icons.menu));
  }
}
