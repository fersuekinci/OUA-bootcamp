import 'package:flutter/material.dart';
import 'package:oua_bootcamp/model/menu_item.dart';

//ZoomDrawer menü elemanlarının oluşturulması ve özelliklerinin verilmesi
class MenuItems {
  //Menü elemanları ekleniyor.
  static const category = MenuItemK('Ana Sayfa', Icons.category);
  static const businessDetail = MenuItemK('İşletme Detayları', Icons.details);
  static const businesses = MenuItemK('İşletmeler', Icons.list_alt);
  static const register = MenuItemK('Kayıt ol sayfası', Icons.list_alt);
  static const businessAppointment =
      MenuItemK('Randevu Al', Icons.calendar_month);

  static const all = <MenuItemK>[
    category,
    businessDetail,
    businesses,
    register,
    businessAppointment
  ];
}

class MenuPage extends StatelessWidget {
  final MenuItemK currentItem;
  final ValueChanged<MenuItemK> onSelectedItem;
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
            Container(
              child: Text('deneme'),
            ),
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

  Widget buildMenuItem(MenuItemK item) => ListTileTheme(
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
