import 'package:flutter/material.dart';
import 'package:oua_bootcamp/model/CategoryModal.dart';

// Giriş yapılmamışsa deaktif olacak yerleri alttaki koddan kontrol edebiliriz.
// final bool isAnonymous = FirebaseAuth.instance.currentUser!.isAnonymous;

//Renk ve font tanımlamaları için kullanılacaktır.
const Color appbarColor = kPrimaryColor;

const String exampleString =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In dictum blandit mauris a auctor. Pellentesque enim diam, ultrices elementum metus at, scelerisque congue enim. Nunc malesuada sollicitudin purus eu molestie. Proin diam orci, condimentum eu aliquam id, bibendum quis tortor. Aliquam sed magna et risus consequat interdum at mattis nunc. Phasellus suscipit justo a libero lacinia, nec suscipit nibh accumsan. Cras pretium feugiat nibh, ut laoreet neque. Maecenas orci purus, interdum id ligula rutrum, suscipit vestibulum leo. Quisque varius maximus arcu, sed feugiat lorem blandit eget. Quisque bibendum iaculis enim non malesuada. Etiam metus mauris, pellentesque ac sem quis, faucibus aliquam velit. Vivamus ac tincidunt neque. Pellentesque vitae leo quis sem euismod congue sit amet ut nunc.';

const kSecondColor = Color.fromRGBO(136, 48, 78, 1);

const kAccentColor = Color(0xFFF1F1F1);
const kWhiteColor = Color(0xFFFFFFFF);
const kLightColor = Color(0xFF808080);
const kDarkColor = Color(0xFF303030);
const kTransparent = Colors.transparent;

const double appPadding = 25.0;
const double spacer = 50.0;
const double smallSpacer = 30.0;
const double miniSpacer = 10.0;
const Color textWhite = Color(0xFFFFFFFF);
const Color textBlack = Color(0xFF000000);

const String fontFamiy = "Ubuntu";
const String fontFamiyBrittany = "Brittany";
const String fontFamiyKanadaka = "Kanadaka";
const kLessPadding = 10.0;
const kFixPadding = 16.0;
const kLess = 4.0;

const kShape = 30.0;

const kRadius = 0.0;
const kAppBarHeight = 56.0;

const kHeadTextStyle = TextStyle(
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
);

const kSubTextStyle = TextStyle(
  fontSize: 18.0,
  color: kLightColor,
);

const kTextStyle = TextStyle(
  fontSize: 15.0,
  color: kLightColor,
);

const kTitleTextStyle = TextStyle(
  fontSize: 20.0,
  color: kPrimaryColor,
);

const kDarkTextStyle = TextStyle(
  fontSize: 20.0,
  color: kDarkColor,
);

const kDivider = Divider(
  color: kAccentColor,
  thickness: kLessPadding,
);

const kSmallDivider = Divider(
  color: kAccentColor,
  thickness: 5.0,
);

String myName = "";

const kBackgroundColor = Color.fromRGBO(18, 115, 105, 1);

const kPrimaryColor = Color.fromRGBO(18, 115, 105, 1);
const kSecondaryColor = Color.fromRGBO(16, 64, 59, 1);
const kThirdColor = Color.fromRGBO(138, 166, 163, 1);
const kFourthColor = Color.fromRGBO(76, 89, 88, 1);
const kFifthColor = Color.fromRGBO(191, 191, 191, 1);
const kTextColor = Color(0xFF000839);
const kTextLightColor = Color(0xFF747474);
const kBlueColor = Color(0xFF40BAD5);

const kDefaultPadding = 20.0;

// our default Shadow
const kDefaultShadow = BoxShadow(
  offset: Offset(0, 15),
  blurRadius: 27,
  color: Colors.black12, // Black color with 12% opacity
);
