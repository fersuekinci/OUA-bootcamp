import 'package:flutter/material.dart';
import 'package:oua_bootcamp/widgets/menu_item.dart';

//ZoomDrawer menü elemanlarının oluşturulması ve özelliklerinin verilmesi
class MenuItems {
  //Menü elemanları ekleniyor.
  static const category = MenuItem('Ana Sayfa', Icons.category);
  static const businessDetail = MenuItem('İşletme Detayları', Icons.details);

  static const all = <MenuItem>[category, businessDetail];
}

class MenuPage extends StatelessWidget {
  final MenuItem currentItem;
  final ValueChanged<MenuItem> onSelectedItem;
  const MenuPage(
      {Key? key, required this.currentItem, required this.onSelectedItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: Colors.indigo,
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            ...MenuItems.all.map(buildMenuItem).toList(),
            const Spacer(
              flex: 2,
            )
          ],
        )),
      ),
    );
  }

  Widget buildMenuItem(MenuItem item) => ListTileTheme(
        selectedColor: Colors.white,
        child: ListTile(
          selectedTileColor: Colors.black26,
          selected: currentItem == item,
          minLeadingWidth: 20,
          leading: Icon(item.icon),
          title: Text(item.title),
          onTap: () {
            return onSelectedItem(item);
          },
        ),
      );
}
