import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oua_bootcamp/constants.dart';
import 'package:oua_bootcamp/model/menu_item.dart';
import 'package:oua_bootcamp/state/state_management.dart';
import '../sercices/auth.dart';

//ZoomDrawer menü elemanlarının oluşturulması ve özelliklerinin verilmesi
class MenuItems {
  //Menü elemanları ekleniyor.
  static const category = MenuItemK('Ana Sayfa', Icons.category);

  static const userHistory = MenuItemK('Kullanıcı Geçmişi', Icons.history);

  static const all = <MenuItemK>[category, userHistory];
}

class MenuPage extends ConsumerWidget {
  final MenuItemK currentItem;
  final ValueChanged<MenuItemK> onSelectedItem;
  const MenuPage(
      {Key? key, required this.currentItem, required this.onSelectedItem})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userWatch = ref.watch(userInformation);
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: kFourthColor,
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Container(
              height: 250,
              child: DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 70,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                            shape: CircleBorder(),
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.contain,
                                //image: AssetImage('assets/images/avatar.png'),
                                image:
                                    FirebaseAuth.instance.currentUser?.email ==
                                            null
                                        ? const AssetImage(
                                            'assets/images/avatar.png')
                                        : NetworkImage(FirebaseAuth
                                            .instance.currentUser!.photoURL
                                            .toString()) as ImageProvider)),
                      ),
                    ),
                    FirebaseAuth.instance.currentUser?.email == null
                        ? InkWell(
                            onTap: () {
                              AuthMethods().signInWithGoogle(context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text('Giriş Yap'),
                            ))
                        : Column(
                            children: [
                              Text(FirebaseAuth
                                  .instance.currentUser!.displayName
                                  .toString()),
                              const SizedBox(height: 10),
                              Text(FirebaseAuth.instance.currentUser!.email
                                  .toString()),
                              InkWell(
                                onTap: () {
                                  AuthMethods().signOut().then((s) {
                                    //         AuthMethods().signInAnon(context);
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    "Çıkış Yap",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    userWatch.isBusiness == true
                        ? IconButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed('/businessManagement');
                            },
                            icon: Icon(Icons.admin_panel_settings))
                        : InkWell(
                            onTap: () {
                              print("Profilimi Düzenle");
                            },
                            child: const Text(
                              "Profilimi Düzenle",
                              style:
                                  TextStyle(fontSize: 14, color: kFourthColor),
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
