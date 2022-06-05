import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:oua_bootcamp/cloud_firestore/all_business_ref.dart';
import 'package:oua_bootcamp/model/CategoryModal.dart';
import 'package:oua_bootcamp/pages/businesses_page.dart';
import 'package:oua_bootcamp/repositories/repo_categories.dart';
import 'package:oua_bootcamp/sercices/auth.dart';
import 'package:oua_bootcamp/utils/utils.dart';
import 'package:oua_bootcamp/constants.dart';
import 'package:oua_bootcamp/widgets/CategoryItems.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oua_bootcamp/state/state_management.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// ignore: must_be_immutable
class CategoryPage extends ConsumerWidget {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String appbarTitle = 'U S T A S I N I   B U L';

    return Scaffold(
        backgroundColor: kSecondaryColor,
        key: scaffoldState,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/logo.svg',
                  width: 75,
                  height: 75,
                ),
                const Text(
                  appbarTitle,
                  style: TextStyle(
                      fontFamily: fontFamiyKanadaka,
                      fontWeight: FontWeight.bold),
                )
              ],
            )),
        body: getBody(context, ref));
  }

  Widget getBody(context, WidgetRef ref) {
    final categoryRepoProvider = ref.read(categoriesPageProvider);
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(kDefaultPadding),
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kDefaultPadding / 4,
            ),
            decoration: BoxDecoration(
              color: kThirdColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text(
                  'Kategori Seç',
                  style: TextStyle(
                      color: kSecondaryColor,
                      fontSize: 20,
                      fontFamily: fontFamiyKanadaka),
                ),
                Text(
                  'İşletmeleri Listele',
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 20,
                      fontFamily: fontFamiyKanadaka),
                ),
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.all(kDefaultPadding),
              padding: const EdgeInsets.only(
                  left: kDefaultPadding, right: kDefaultPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      //FirebaseAuth.instance.signOut();
                      //print(FirebaseAuth.instance.currentUser!.email.toString());
                    },
                    child: const Text(
                      'Giriş Yap / Kayıt Ol',
                      style: TextStyle(color: kThirdColor, fontSize: 18),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      AuthMethods().signInWithGoogle(context);
                    },
                    icon: SvgPicture.asset(
                      'assets/svg/icons8-google.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/svg/icons8-microsoft-outlook.svg',
                        width: 24,
                        height: 24,
                      ))
                ],
              )),
          Expanded(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 70),
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
                FutureBuilder(
                    future: getCategory(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitThreeInOut(
                            color: kThirdColor,
                          ),
                        );
                      } else {
                        var categories = snapshot.data as List<CategoryModal>;
                        if (categories.isEmpty) {
                          return const Center(
                            child: Text('Kategori bulunamadı'),
                          );
                        } else {
                          return GridView.builder(
                              padding: const EdgeInsets.all(24),
                              scrollDirection: Axis.vertical,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1.3,
                                mainAxisSpacing: 0.0,
                                crossAxisSpacing: 0.0,
                              ),
                              itemCount: 8,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    categoryRepoProvider.category =
                                        categories[index].category.toString();
                                    categoryRepoProvider.image =
                                        categories[index].image.toString();

                                    categoryRepoProvider.notifyAll();

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Businesses()));
                                  },
                                  child: CategoryItems(
                                    height: 150.0,
                                    width: MediaQuery.of(context).size.width,
                                    paddingHorizontal: 0.0,
                                    paddingVertical: 0.0,
                                    align: Alignment.center,
                                    radius: kLessPadding,
                                    blendMode: BlendMode.difference,
                                    color: kDarkColor,
                                    image: categories[index].image!,
                                    title: categories[index].category!,
                                    titleSize: 18.0,
                                    amount: "",
                                    amountSize: 0.0,
                                  ),
                                );
                              });
                        }
                      }
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  processLogin(BuildContext context, WidgetRef ref) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      FlutterAuthUi.startUi(
              items: [AuthUiProvider.email],
              tosAndPrivacyPolicy: const TosAndPrivacyPolicy(
                  tosUrl: 'https://google.com',
                  privacyPolicyUrl: 'https://google.com'),
              androidOption: const AndroidOption(
                  enableSmartLock: false, showLogo: true, overrideTheme: true))
          .then((value) async {
        ref.read(userLogged.state).state = FirebaseAuth.instance.currentUser;
        await checkLoginState(context, ref, true, scaffoldState);
      }).catchError((e) {
        ScaffoldMessenger.of(scaffoldState.currentContext!)
            .showSnackBar(SnackBar(content: Text('${e.toString()}')));
      });
    } else {}
  }

  Future<LOGIN_STATE> checkLoginState(BuildContext context, WidgetRef ref,
      bool fromLogin, GlobalKey<ScaffoldState> scaffoldState) async {
    if (!ref.read(forceReload.state).state) {
      await Future.delayed(Duration(seconds: fromLogin == true ? 0 : 3))
          .then((value) => {
                FirebaseAuth.instance.currentUser
                    ?.getIdToken()
                    .then((token) async {
                  ref.read(userToken.state).state = token;

//Kullanıcı var mı
                  CollectionReference userRef =
                      FirebaseFirestore.instance.collection('User');
                  DocumentSnapshot snapshotUser = await userRef
                      .doc(FirebaseAuth.instance.currentUser!.email)
                      .get();

                  ref.read(forceReload.state).state = true;
                  if (snapshotUser.exists) {
                  } else {
                    var fullNameController = TextEditingController();
                    var mailController = TextEditingController();
                    var phoneNumberController = TextEditingController();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Profili Kaydet'),
                            content: Column(
                              children: [
                                TextField(
                                  decoration: const InputDecoration(
                                      icon: Icon(Icons.account_circle),
                                      labelText: 'Tam Adınız'),
                                  controller: fullNameController,
                                ),
                                TextField(
                                  decoration: const InputDecoration(
                                      icon: Icon(Icons.account_circle),
                                      labelText: 'Mail Adresiniz'),
                                  controller: mailController,
                                ),
                                TextField(
                                  decoration: const InputDecoration(
                                      icon: Icon(Icons.account_circle),
                                      labelText: 'Telefon Numaranız'),
                                  controller: phoneNumberController,
                                ),
                              ],
                            ),
                            actions: [
                              DialogButton(
                                  child: Text('İptal'),
                                  onPressed: () => Navigator.pop(context)),
                              DialogButton(
                                  child: Text('Kaydet'),
                                  onPressed: () {
                                    //Kullanıcı Güncelleme
                                    userRef
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.email)
                                        .set({
                                      'fullName': fullNameController.text,
                                      'mail': mailController.text,
                                      'phoneNumber': phoneNumberController.text
                                    }).then((value) async {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                              scaffoldState.currentContext!)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text('Profil Güncellendi')));
                                      await Future.delayed(
                                          Duration(seconds: 1));
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          '/homePage', (route) => false);
                                    }).catchError((e) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                              scaffoldState.currentContext!)
                                          .showSnackBar(
                                              SnackBar(content: Text('$e')));
                                    });
                                  })
                            ],
                          );
                        });
                  }
                })
              });
    }
    return FirebaseAuth.instance.currentUser != null
        ? LOGIN_STATE.LOGGED
        : LOGIN_STATE.NOT_LOGIN;
  }
}
