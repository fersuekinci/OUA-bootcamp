import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:oua_bootcamp/constants.dart';
import 'package:oua_bootcamp/pages/business_detail_page.dart';
import 'package:oua_bootcamp/pages/business_home_page.dart';
import 'package:oua_bootcamp/pages/business_register_page.dart';
import 'package:oua_bootcamp/pages/businesses_page.dart';
import 'package:oua_bootcamp/pages/category_page.dart';
import 'package:oua_bootcamp/pages/home_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oua_bootcamp/pages/make_appointment.dart';
import 'package:page_transition/page_transition.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting()
      .then((_) => runApp(const ProviderScope(child: MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debug logosunu kaldırmak için kullanıldı.
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      // theme: ThemeData.light().copyWith(
      //   //appBarTheme : proje kapsamında appbar teması özellikleri
      //   appBarTheme: const AppBarTheme(
      //     centerTitle: true,
      //     backgroundColor: appbarColor,
      //     elevation: 15,
      //     iconTheme: IconThemeData(color: Colors.black),
      //     titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
      //   ),
      // ),

      theme: ThemeData(
        // We set Poppins as our default font
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        primaryColor: kSecondaryColor,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: kSecondaryColor,
          elevation: 0,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/homePage':
            return PageTransition(
                child: CategoryPage(), type: PageTransitionType.fade);
          case '/businessDetail':
            return PageTransition(
                child: BusinessDetail(), type: PageTransitionType.fade);
          case '/businessList':
            return PageTransition(
                child: Businesses(), type: PageTransitionType.fade);
          case '/makeAppointment':
            return PageTransition(
                child: MakeAppointment(), type: PageTransitionType.fade);
          case '/businessManagement':
            return PageTransition(
                child: BusinessHomePage(), type: PageTransitionType.fade);
          case '/businessRegister':
            return PageTransition(
                child: BusinessRegister(), type: PageTransitionType.fade);
          default:
            return null;
        }
      },

      home: HomePage(),
      // home: FutureBuilder(
      //   future: AuthMethods().getCurrentUser(),
      //   builder: (context, AsyncSnapshot<dynamic> snapshot) {
      //     if (snapshot.hasData) {
      //       return HomePage();
      //     } else {
      //       return SignIn();
      //     }
      //   },
      // ),
    );
  }
}
