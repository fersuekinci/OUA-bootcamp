import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:oua_bootcamp/cloud_firestore/all_business_ref.dart';
import 'package:oua_bootcamp/cloud_firestore/user_ref.dart';
import 'package:oua_bootcamp/model/CategoryModal.dart';
import 'package:oua_bootcamp/model/user_model.dart';
import 'package:oua_bootcamp/pages/businesses_page.dart';
import 'package:oua_bootcamp/repositories/repo_categories.dart';
import 'package:oua_bootcamp/sercices/auth.dart';
import 'package:oua_bootcamp/constants.dart';
import 'package:oua_bootcamp/widgets/CategoryItems.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oua_bootcamp/widgets/login_precess.dart';
import 'package:oua_bootcamp/widgets/menu_widget.dart';

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
        appBar: getAppBar(appbarTitle, context),
        body: getBody(context, ref));
  }

  getAppBar(appbarTitle, context) {
    if (FirebaseAuth.instance.currentUser?.email == null) {
      return AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            appbarTitle,
            style: const TextStyle(
                fontFamily: fontFamiyKanadaka, fontWeight: FontWeight.bold),
          ));
    } else if (FirebaseAuth.instance.currentUser?.email != null) {
      return AppBar(
          leading: MenuWidget(),
          title: Text(
            appbarTitle,
            style: const TextStyle(
                fontFamily: fontFamiyKanadaka, fontWeight: FontWeight.bold),
          ));
    }
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
                      fontFamily: fontFamiy),
                ),
                Text(
                  'İşletmeleri Listele',
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 20,
                      fontFamily: fontFamiy),
                ),
              ],
            ),
          ),
          if (FirebaseAuth.instance.currentUser?.email == null)
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
                    if (FirebaseAuth.instance.currentUser == null)
                      GestureDetector(
                        onTap: () {
                          //FirebaseAuth.instance.signOut();
                          //print(FirebaseAuth.instance.currentUser!.email.toString());
                        },
                        child: const Text(
                          'Giriş Yap / Kayıt Ol',
                          style: TextStyle(
                              color: kThirdColor,
                              fontSize: 18,
                              fontFamily: fontFamiy),
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
                    // IconButton(
                    //     onPressed: () {
                    //       processLogin(context, ref, scaffoldState);
                    //     },
                    //     icon: Image.asset(
                    //       'assets/images/icons_mail.png',
                    //       width: 24,
                    //       height: 24,
                    //     )),
                  ],
                )),
          if (FirebaseAuth.instance.currentUser?.email != null)
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
                    FutureBuilder(
                      future: getUserProfiles(ref,
                          FirebaseAuth.instance.currentUser?.email.toString()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: SpinKitThreeInOut(
                              color: kThirdColor,
                            ),
                          );
                        } else {
                          var userModel = snapshot.data as UserModel;
                          return Text(
                            'Hoş geldin  ${FirebaseAuth.instance.currentUser!.displayName.toString()}',
                            style: const TextStyle(
                                color: kThirdColor,
                                fontSize: 18,
                                fontFamily: fontFamiy),
                          );
                        }
                      },
                    ),
                    // IconButton(
                    //     onPressed: () {
                    //       AuthMethods().signOut();
                    //       //FirebaseAuth.instance.signOut();
                    //       Navigator.pushReplacement(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => CategoryPage()));
                    //     },
                    //     icon: const Icon(Icons.exit_to_app))
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
}
