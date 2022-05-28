import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oua_bootcamp/constants.dart';
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
  static const userHistory = MenuItemK('Kullanıcı Geçmişi', Icons.history);

  static const all = <MenuItemK>[
    category,
    businessDetail,
    businesses,
    register,
    businessAppointment,
    userHistory
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
        backgroundColor: kSecondColor,
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Container(
              height: 200,
              child: DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      padding: const EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: const DecoratedBox(
                        decoration: ShapeDecoration(
                            shape: CircleBorder(),
                            color: Colors.white,
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: NetworkImage(
                                  "https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes.png"),
                            )),
                      ),
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser?.email == null
                          ? 'Giriş Yapılması'
                          : FirebaseAuth.instance.currentUser!.email.toString(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Çıkış Yap",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        print("Profilimi Düzenle");
                      },
                      child: const Text(
                        "Profilimi Düzenle",
                        style: TextStyle(fontSize: 14, color: kFourthColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
