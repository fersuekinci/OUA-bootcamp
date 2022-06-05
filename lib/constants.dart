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

//İşletmenin yüklediği resimler yer alacak.
final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];
