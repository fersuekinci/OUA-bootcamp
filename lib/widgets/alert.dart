import 'package:oua_bootcamp/constants.dart';
import 'package:oua_bootcamp/pages/category_page.dart';
import 'package:oua_bootcamp/widgets/login_precess.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';

Alert getAlert(context, ref, String content, String title) {
  return Alert(
      style: const AlertStyle(
          titleStyle: TextStyle(fontFamily: fontFamiy, fontSize: 16),
          descStyle: TextStyle(fontFamily: fontFamiy, fontSize: 16),
          backgroundColor: Colors.white,
          alertElevation: 20),
      context: context,
      type: AlertType.warning,
      title: title,
      desc: content,
      buttons: [
        DialogButton(
            color: Colors.red,
            child: const Text(
              'Vazgeç',
              style: TextStyle(color: Colors.white, fontFamily: fontFamiy),
            ),
            onPressed: () => Navigator.of(context).pop()),
        DialogButton(
            color: kPrimaryColor,
            child: const Text('Giriş Yap',
                style: TextStyle(color: Colors.white, fontFamily: fontFamiy)),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => CategoryPage()));
            })
      ]);
}
